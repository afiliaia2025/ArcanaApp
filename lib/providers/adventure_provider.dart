import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';
import '../services/firestore_service.dart';
import '../services/gemini_service.dart';

/// Estado de la aventura del jugador (arco actual + progreso)
class AdventureState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? arcData;
  final List<MapNode> mapNodes;
  final List<MapPath> mapPaths;
  final Map<String, bool> completedChapters;
  final int currentAct;
  final String arcTitle;

  const AdventureState({
    this.isLoading = true,
    this.error,
    this.arcData,
    this.mapNodes = const [],
    this.mapPaths = const [],
    this.completedChapters = const {},
    this.currentAct = 1,
    this.arcTitle = '',
  });

  AdventureState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? arcData,
    List<MapNode>? mapNodes,
    List<MapPath>? mapPaths,
    Map<String, bool>? completedChapters,
    int? currentAct,
    String? arcTitle,
  }) {
    return AdventureState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      arcData: arcData ?? this.arcData,
      mapNodes: mapNodes ?? this.mapNodes,
      mapPaths: mapPaths ?? this.mapPaths,
      completedChapters: completedChapters ?? this.completedChapters,
      currentAct: currentAct ?? this.currentAct,
      arcTitle: arcTitle ?? this.arcTitle,
    );
  }
}

/// Carga el arco desde Firestore y genera nodos del mapa
class AdventureNotifier extends StateNotifier<AdventureState> {
  final FirestoreService _firestore;
  final GeminiService _gemini;

  AdventureNotifier(this._firestore, this._gemini)
      : super(const AdventureState()) {
    loadAdventure();
  }

  /// Carga el arco actual desde Firestore
  Future<void> loadAdventure() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = state.copyWith(isLoading: false, error: 'No autenticado');
        return;
      }

      final arcData = await _firestore.getArc(user.uid, state.currentAct);
      if (arcData == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Sin aventura. Completa el onboarding.',
        );
        return;
      }

      final chapters = (arcData['chapters'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [];

      final nodes = <MapNode>[];
      final paths = <MapPath>[];
      final completed = <String, bool>{};

      for (int i = 0; i < chapters.length; i++) {
        final ch = chapters[i];
        final chId = ch['id'] as String? ?? 'cap_${i + 1}';

        // Comprobar progreso en Firestore
        final progress = await _firestore.getChapterProgress(
            user.uid, state.currentAct, chId);
        final isCompleted = progress?['completed'] == true;
        completed[chId] = isCompleted;

        // Posición zigzag en el mapa
        final x = 0.2 + (i % 2 == 0 ? 0.0 : 0.35) + (i % 3) * 0.08;
        final y = 0.06 + (i * 0.088);

        // Estado del nodo
        MapNodeStatus status;
        if (isCompleted) {
          status = MapNodeStatus.completed;
        } else if (i == 0 ||
            completed[chapters[i - 1]['id'] ?? 'cap_$i'] == true) {
          status = MapNodeStatus.current;
        } else {
          status = MapNodeStatus.locked;
        }

        // Tipo según el arco
        final type = switch (ch['type'] as String? ?? 'normal') {
          'boss' => ChapterType.miniBoss,
          'gate' => ChapterType.gatePuzzle,
          _ => ChapterType.normal,
        };

        // Emoji según tipo e índice
        final emoji = switch (ch['type'] as String? ?? 'normal') {
          'boss' => '🐉',
          'gate' => '🚪',
          _ => _emojiForIndex(i),
        };

        nodes.add(MapNode(
          id: 'node_$i',
          chapterId: chId,
          kingdom: Kingdom.ignis, // TODO: determinar desde arcData
          x: x.clamp(0.08, 0.88),
          y: y.clamp(0.05, 0.92),
          status: status,
          type: type,
          label: ch['title'] as String? ?? 'Cap ${i + 1}',
          emoji: emoji,
        ));

        if (i > 0) {
          paths.add(MapPath(
            fromNodeId: 'node_${i - 1}',
            toNodeId: 'node_$i',
            isCompleted: completed[chapters[i - 1]['id'] ?? 'cap_$i'] == true,
          ));
        }
      }

      state = state.copyWith(
        isLoading: false,
        arcData: arcData,
        arcTitle: arcData['arc_title'] as String? ?? 'Aventura',
        mapNodes: nodes,
        mapPaths: paths,
        completedChapters: completed,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Marca capítulo como completado
  Future<void> completeChapter(String chapterId, int xpEarned) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore.saveChapterProgress(
      uid: user.uid,
      act: state.currentAct,
      chapterId: chapterId,
      progressData: {
        'completed': true,
        'completedAt': DateTime.now().toIso8601String(),
        'xpEarned': xpEarned,
      },
    );

    await _firestore.addXp(user.uid, xpEarned);
    await _firestore.updateStreak(user.uid);
    await loadAdventure();
  }

  /// Genera viñetas (lazy, cacheadas en Firestore)
  Future<List<Map<String, dynamic>>> loadChapterVignettes(
      String chapterId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    // Buscar caché
    final progress = await _firestore.getChapterProgress(
        user.uid, state.currentAct, chapterId);
    if (progress?['vignettes'] != null) {
      return (progress!['vignettes'] as List).cast<Map<String, dynamic>>();
    }

    // Generar con Gemini (coste: ~$0.002 por capítulo)
    final profile = await _firestore.getUserProfile(user.uid);
    if (profile == null) return [];

    final chapters = (state.arcData?['chapters'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final chapter = chapters.firstWhere(
      (ch) => ch['id'] == chapterId,
      orElse: () => <String, dynamic>{},
    );
    if (chapter.isEmpty) return [];

    final vignettes = await _gemini.generateVignettes(
      chapterTitle: chapter['title'] as String? ?? '',
      topic: chapter['topic'] as String? ?? '',
      childName: profile['displayName'] as String? ?? '',
      avatarDescription: profile['nickname'] as String? ?? '',
      interests: List<String>.from(profile['interests'] ?? []),
      ageGroup: profile['ageGroup'] as String? ?? 'aventureros',
    );

    // Cachear para no regenerar (ahorro de costes)
    await _firestore.saveChapterProgress(
      uid: user.uid,
      act: state.currentAct,
      chapterId: chapterId,
      progressData: {'vignettes': vignettes},
    );

    return vignettes;
  }

  String _emojiForIndex(int i) {
    const emojis = [
      '⚔️', '🌟', '🗝️', '📜', '🧩', '💎', '🔮', '🏆', '🌙', '⭐'
    ];
    return emojis[i % emojis.length];
  }
}

/// Provider
final adventureProvider =
    StateNotifierProvider<AdventureNotifier, AdventureState>((ref) {
  return AdventureNotifier(FirestoreService(), GeminiService.instance);
});
