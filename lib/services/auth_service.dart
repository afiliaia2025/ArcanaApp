import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio de autenticación con código familiar
/// Padre crea cuenta (Google/email) → genera código → hijo lo usa
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ═══════════════════════════════════════════
  // PADRE: Registro y login
  // ═══════════════════════════════════════════

  /// Registrar padre con email y contraseña
  Future<User?> registerParent({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user == null) return null;

    // Crear perfil de padre en Firestore
    await _db.collection('users').doc(user.uid).set({
      'role': 'parent',
      'displayName': displayName,
      'email': email,
      'children': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  /// Login padre con email
  Future<User?> loginParent({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // ═══════════════════════════════════════════
  // CÓDIGO FAMILIAR (6 dígitos)
  // ═══════════════════════════════════════════

  /// Padre genera un código de 6 dígitos para un hijo
  Future<String> generateFamilyCode({
    required String parentUid,
    required String childName,
  }) async {
    // Código aleatorio de 6 dígitos
    final code = (Random().nextInt(900000) + 100000).toString();

    // Guardar en Firestore con TTL de 72 horas
    await _db.collection('family_codes').doc(code).set({
      'parentUid': parentUid,
      'childName': childName,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(
        DateTime.now().add(const Duration(hours: 72)),
      ),
      'used': false,
    });

    return code;
  }

  /// Hijo introduce el código → se crea cuenta anónima vinculada al padre
  Future<User?> redeemFamilyCode({
    required String code,
    required String nickname,
  }) async {
    // 1. Verificar código
    final codeDoc = await _db.collection('family_codes').doc(code).get();
    if (!codeDoc.exists) throw Exception('Código no válido');

    final data = codeDoc.data()!;
    if (data['used'] == true) throw Exception('Código ya usado');

    final expiresAt = (data['expiresAt'] as Timestamp).toDate();
    if (DateTime.now().isAfter(expiresAt)) throw Exception('Código expirado');

    // 2. Crear cuenta anónima para el hijo
    final cred = await _auth.signInAnonymously();
    final user = cred.user;
    if (user == null) throw Exception('Error al crear cuenta');

    final parentUid = data['parentUid'] as String;

    // 3. Crear perfil del hijo
    await _db.collection('users').doc(user.uid).set({
      'role': 'student',
      'displayName': data['childName'],
      'nickname': nickname,
      'parentUid': parentUid,
      'avatar': {},
      'level': 1,
      'xp': 0,
      'streak': 0,
      'lives': 5,
      'gems': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 4. Vincular hijo al padre
    await _db.collection('users').doc(parentUid).update({
      'children': FieldValue.arrayUnion([user.uid]),
    });

    // 5. Marcar código como usado
    await _db.collection('family_codes').doc(code).update({
      'used': true,
      'childUid': user.uid,
      'usedAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  // ═══════════════════════════════════════════
  // PROFE: Código de clase
  // ═══════════════════════════════════════════

  /// Profe genera código de clase
  Future<String> generateClassCode({
    required String teacherUid,
    required String className,
    required String subject,
  }) async {
    // Código tipo MATES-4B
    final subjectCode = subject.substring(0, 3).toUpperCase();
    final code = '$subjectCode-${className.replaceAll(' ', '')}';

    await _db.collection('class_codes').doc(code).set({
      'teacherUid': teacherUid,
      'className': className,
      'subject': subject,
      'students': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return code;
  }

  /// Logout
  Future<void> signOut() => _auth.signOut();
}
