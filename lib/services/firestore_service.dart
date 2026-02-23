import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio de Firestore para Arcana
/// Gestiona perfiles, aventura, progreso, y currículo
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════
  // PERFIL DE USUARIO
  // ═══════════════════════════════════════════

  /// Obtener perfil de usuario
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  /// Stream del perfil (tiempo real)
  Stream<Map<String, dynamic>?> userProfileStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map(
          (snap) => snap.data(),
        );
  }

  /// Actualizar perfil
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  /// Guardar avatar del usuario
  Future<void> saveAvatar(String uid, Map<String, dynamic> avatarData) async {
    await _db.collection('users').doc(uid).update({
      'avatar': avatarData,
    });
  }

  // ═══════════════════════════════════════════
  // AVENTURA / PROGRESO
  // ═══════════════════════════════════════════

  /// Guardar arco narrativo de un acto
  Future<void> saveArc({
    required String uid,
    required int act,
    required Map<String, dynamic> arcData,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('adventure')
        .doc('act_$act')
        .set(arcData);
  }

  /// Obtener arco narrativo
  Future<Map<String, dynamic>?> getArc(String uid, int act) async {
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('adventure')
        .doc('act_$act')
        .get();
    return doc.data();
  }

  /// Guardar capítulo completado
  Future<void> saveChapterProgress({
    required String uid,
    required int act,
    required String chapterId,
    required Map<String, dynamic> progressData,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('adventure')
        .doc('act_$act')
        .collection('chapters')
        .doc(chapterId)
        .set(progressData, SetOptions(merge: true));
  }

  /// Obtener progreso de un capítulo
  Future<Map<String, dynamic>?> getChapterProgress(
      String uid, int act, String chapterId) async {
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('adventure')
        .doc('act_$act')
        .collection('chapters')
        .doc(chapterId)
        .get();
    return doc.data();
  }

  /// Actualizar XP, nivel, racha
  Future<void> addXp(String uid, int amount) async {
    final ref = _db.collection('users').doc(uid);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() ?? {};
      final currentXp = (data['xp'] as int?) ?? 0;
      final currentLevel = (data['level'] as int?) ?? 1;
      final newXp = currentXp + amount;

      // Nivel sube cada 200 XP
      final newLevel = (newXp ~/ 200) + 1;

      tx.update(ref, {
        'xp': newXp,
        'level': newLevel > currentLevel ? newLevel : currentLevel,
      });
    });
  }

  /// Actualizar racha diaria
  Future<void> updateStreak(String uid) async {
    final ref = _db.collection('users').doc(uid);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() ?? {};
      final lastActive = data['lastActiveDate'] as String?;
      final today = DateTime.now().toIso8601String().substring(0, 10);

      if (lastActive == today) return; // Ya activo hoy

      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .substring(0, 10);

      final currentStreak = (data['streak'] as int?) ?? 0;
      final newStreak = lastActive == yesterday ? currentStreak + 1 : 1;

      tx.update(ref, {
        'streak': newStreak,
        'lastActiveDate': today,
      });
    });
  }

  // ═══════════════════════════════════════════
  // MISIONES SECUNDARIAS
  // ═══════════════════════════════════════════

  /// Guardar misión secundaria
  Future<void> saveSideQuest({
    required String uid,
    required int act,
    required String questId,
    required Map<String, dynamic> questData,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('adventure')
        .doc('act_$act')
        .collection('side_quests')
        .doc(questId)
        .set(questData, SetOptions(merge: true));
  }

  // ═══════════════════════════════════════════
  // CURRÍCULO
  // ═══════════════════════════════════════════

  /// Obtener currículo por curso y asignatura
  Future<Map<String, dynamic>?> getCurriculum(
      String grade, String subject) async {
    final doc = await _db
        .collection('curriculum')
        .doc(grade)
        .collection('subjects')
        .doc(subject)
        .get();
    return doc.data();
  }

  // ═══════════════════════════════════════════
  // PANEL PADRE
  // ═══════════════════════════════════════════

  /// Stream del progreso de los hijos (para el padre)
  Stream<List<Map<String, dynamic>>> childrenProgressStream(
      List<String> childUids) {
    if (childUids.isEmpty) return Stream.value([]);
    return _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: childUids)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  // ═══════════════════════════════════════════
  // PANEL PROFE
  // ═══════════════════════════════════════════

  /// Obtener alumnos de una clase
  Future<List<Map<String, dynamic>>> getClassStudents(
      String classCode) async {
    final classDoc =
        await _db.collection('class_codes').doc(classCode).get();
    if (!classDoc.exists) return [];

    final students =
        List<String>.from(classDoc.data()?['students'] ?? []);
    if (students.isEmpty) return [];

    final snap = await _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: students)
        .get();
    return snap.docs.map((d) => {'uid': d.id, ...d.data()}).toList();
  }

  // ═══════════════════════════════════════════
  // ESCANEOS DE MATERIAL
  // ═══════════════════════════════════════════

  /// Guardar un escaneo de material
  Future<void> saveScan(String uid, Map<String, dynamic> scanData) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('scans')
        .add(scanData);
  }

  /// Obtener escaneos recientes (último 10)
  Future<List<Map<String, dynamic>>> getRecentScans(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('scans')
        .orderBy('scannedAt', descending: true)
        .limit(10)
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  // ═══════════════════════════════════════════
  // SISTEMA SOCIAL (AMIGOS + RANKING)
  // ═══════════════════════════════════════════

  /// Código de amigo del usuario (derivado del UID)
  String getFriendCode(String uid) => uid.substring(0, 8).toUpperCase();

  /// Enviar solicitud de amistad por código
  Future<bool> sendFriendRequest(String fromUid, String toCode) async {
    // Buscar usuario por código
    final snap = await _db.collection('users').get();
    final target = snap.docs.where((d) {
      return getFriendCode(d.id) == toCode.toUpperCase();
    }).firstOrNull;

    if (target == null || target.id == fromUid) return false;

    // Verificar que no sean ya amigos
    final existing = await _db
        .collection('users')
        .doc(target.id)
        .collection('friend_requests')
        .doc(fromUid)
        .get();
    if (existing.exists) return false;

    // Crear solicitud
    await _db
        .collection('users')
        .doc(target.id)
        .collection('friend_requests')
        .doc(fromUid)
        .set({
      'fromUid': fromUid,
      'status': 'pending',
      'sentAt': DateTime.now().toIso8601String(),
    });

    return true;
  }

  /// Aceptar solicitud de amistad
  Future<void> acceptFriendRequest(String uid, String fromUid) async {
    final batch = _db.batch();

    // Añadir como amigo mutuamente
    batch.set(
      _db.collection('users').doc(uid).collection('friends').doc(fromUid),
      {'addedAt': DateTime.now().toIso8601String()},
    );
    batch.set(
      _db.collection('users').doc(fromUid).collection('friends').doc(uid),
      {'addedAt': DateTime.now().toIso8601String()},
    );

    // Eliminar solicitud
    batch.delete(
      _db.collection('users').doc(uid).collection('friend_requests').doc(fromUid),
    );

    await batch.commit();
  }

  /// Rechazar solicitud
  Future<void> rejectFriendRequest(String uid, String fromUid) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('friend_requests')
        .doc(fromUid)
        .delete();
  }

  /// Stream de amigos
  Stream<List<Map<String, dynamic>>> friendsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('friends')
        .snapshots()
        .asyncMap((snap) async {
      if (snap.docs.isEmpty) return <Map<String, dynamic>>[];
      final uids = snap.docs.map((d) => d.id).toList();
      final profiles = await _db
          .collection('users')
          .where(FieldPath.documentId, whereIn: uids.take(10).toList())
          .get();
      return profiles.docs
          .map((d) => {'uid': d.id, ...d.data()})
          .toList();
    });
  }

  /// Stream de solicitudes pendientes
  Stream<List<Map<String, dynamic>>> friendRequestsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('friend_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .asyncMap((snap) async {
      if (snap.docs.isEmpty) return <Map<String, dynamic>>[];
      final fromUids = snap.docs.map((d) => d.id).toList();
      final profiles = await _db
          .collection('users')
          .where(FieldPath.documentId, whereIn: fromUids.take(10).toList())
          .get();
      return profiles.docs
          .map((d) => {'uid': d.id, ...d.data()})
          .toList();
    });
  }

  /// Eliminar amigo
  Future<void> removeFriend(String uid, String friendUid) async {
    final batch = _db.batch();
    batch.delete(
      _db.collection('users').doc(uid).collection('friends').doc(friendUid),
    );
    batch.delete(
      _db.collection('users').doc(friendUid).collection('friends').doc(uid),
    );
    await batch.commit();
  }

  // ═══════════════════════════════════════════
  // TIENDA DE GEMAS
  // ═══════════════════════════════════════════

  /// Comprar ítem con gemas (transacción atómica)
  Future<bool> purchaseItem(String uid, String itemId, int gemCost) async {
    final ref = _db.collection('users').doc(uid);
    return _db.runTransaction<bool>((tx) async {
      final snap = await tx.get(ref);
      final gems = (snap.data()?['gems'] as int?) ?? 0;
      if (gems < gemCost) return false;

      tx.update(ref, {'gems': gems - gemCost});
      tx.set(
        ref.collection('inventory').doc(itemId),
        {
          'purchasedAt': DateTime.now().toIso8601String(),
          'itemId': itemId,
        },
      );
      return true;
    });
  }

  /// Obtener inventario del usuario
  Future<List<String>> getInventory(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('inventory')
        .get();
    return snap.docs.map((d) => d.id).toList();
  }

  /// Añadir gemas al usuario
  Future<void> addGems(String uid, int amount) async {
    final ref = _db.collection('users').doc(uid);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = (snap.data()?['gems'] as int?) ?? 0;
      tx.update(ref, {'gems': current + amount});
    });
  }
}
