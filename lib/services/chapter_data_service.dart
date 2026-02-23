import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/story_models.dart';

/// Servicio que carga un capítulo narrativo desde JSON
/// y lo convierte en un [StoryChapter] compatible con el motor de historia.
///
/// Flujo: ignis_cap01.json → StoryChapter → StoryChapterScreen
class ChapterDataService {
  ChapterDataService._();
  static final instance = ChapterDataService._();

  /// Caché de capítulos ya cargados
  final Map<String, StoryChapter> _cache = {};

  /// Carga un capítulo narrativo desde assets/curriculum/{grade}/{chapterId}.json
  /// y lo convierte en un [StoryChapter] con grafo de nodos.
  Future<StoryChapter?> loadChapter({
    required String grade,
    required String chapterId,
  }) async {
    final cacheKey = '$grade/$chapterId';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey];

    try {
      final jsonStr = await rootBundle.loadString(
        'assets/curriculum/$grade/$chapterId.json',
      );
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final chapter = _buildStoryChapter(data);
      _cache[cacheKey] = chapter;
      return chapter;
    } catch (e) {
      return null;
    }
  }

  /// Convierte el JSON lineal en un grafo StoryChapter.
  ///
  /// El grafo sigue este flujo:
  ///   intro → orion_intro → transition → ex1 → ex2 → ... → closing → ending
  ///
  /// Cada ejercicio tiene nodos onCorrect/onIncorrect que muestran
  /// la reacción de Orión antes de pasar al siguiente.
  StoryChapter _buildStoryChapter(Map<String, dynamic> data) {
    final chapterMeta = data['chapter'] as Map<String, dynamic>;
    final narrativeList = data['narrative'] as List<dynamic>? ?? [];
    final exerciseList = data['exercises'] as List<dynamic>? ?? [];
    final closing = data['closing'] as Map<String, dynamic>?;
    final challenge = data['challenge'] as Map<String, dynamic>?;

    final nodes = <String, StoryNode>{};

    // ─── 1. Nodos narrativos ────────────────────
    for (int i = 0; i < narrativeList.length; i++) {
      final n = narrativeList[i] as Map<String, dynamic>;
      final nodeId = n['id'] as String? ?? 'narr_$i';
      final nextId = (i < narrativeList.length - 1)
          ? (narrativeList[i + 1] as Map<String, dynamic>)['id'] as String? ?? 'narr_${i + 1}'
          : (exerciseList.isNotEmpty
              ? 'ex_0'
              : 'closing');

      nodes[nodeId] = StoryNode(
        id: nodeId,
        type: StoryNodeType.narrative,
        text: n['text'] as String?,
        speaker: n['speaker'] as String?,
        emoji: n['emoji'] as String?,
        nextNode: nextId,
      );
    }

    // ─── 2. Nodos de ejercicios ─────────────────
    for (int i = 0; i < exerciseList.length; i++) {
      final ex = exerciseList[i] as Map<String, dynamic>;
      final exNodeId = 'ex_$i';
      final correctNodeId = 'ex_${i}_correct';
      final incorrectNodeId = 'ex_${i}_incorrect';

      // Siguiente destino después del feedback
      final nextDestination = (i < exerciseList.length - 1)
          ? 'ex_${i + 1}'
          : (challenge != null ? 'challenge_intro' : 'closing');

      // Adaptar ejercicio a multiple_choice para el motor actual
      final exerciseNode = _buildExerciseNode(
        id: exNodeId,
        exercise: ex,
        onCorrect: correctNodeId,
        onIncorrect: incorrectNodeId,
      );
      nodes[exNodeId] = exerciseNode;

      // Nodo de reacción correcta de Orión
      nodes[correctNodeId] = StoryNode(
        id: correctNodeId,
        type: StoryNodeType.narrative,
        text: ex['orion_correct'] as String? ?? '¡Bien hecho!',
        speaker: 'orion',
        emoji: '🦉',
        nextNode: nextDestination,
      );

      // Nodo de reacción incorrecta de Orión
      nodes[incorrectNodeId] = StoryNode(
        id: incorrectNodeId,
        type: StoryNodeType.narrative,
        text: ex['orion_wrong'] as String? ?? 'Inténtalo de nuevo.',
        speaker: 'orion',
        emoji: '🦉',
        nextNode: nextDestination,
      );
    }

    // ─── 3. Desafío extra (opcional) ────────────
    if (challenge != null) {
      // Intro al desafío
      nodes['challenge_intro'] = const StoryNode(
        id: 'challenge_intro',
        type: StoryNodeType.decision,
        text: '¡Has terminado los ejercicios principales! Pero queda un desafío extra para los más valientes...',
        emoji: '⭐',
        choiceA: '¡Acepto el desafío!',
        choiceB: 'Mejor paso al final',
        onChoiceA: 'challenge_ex',
        onChoiceB: 'closing',
      );

      // Ejercicio del desafío
      nodes['challenge_ex'] = _buildExerciseNode(
        id: 'challenge_ex',
        exercise: challenge,
        onCorrect: 'challenge_correct',
        onIncorrect: 'challenge_incorrect',
      );

      nodes['challenge_correct'] = StoryNode(
        id: 'challenge_correct',
        type: StoryNodeType.narrative,
        text: challenge['orion_correct'] as String? ?? '¡Increíble!',
        speaker: 'orion',
        emoji: '🦉',
        nextNode: 'closing',
      );

      nodes['challenge_incorrect'] = StoryNode(
        id: 'challenge_incorrect',
        type: StoryNodeType.narrative,
        text: challenge['orion_wrong'] as String? ?? 'No pasa nada, ¡volverás más fuerte!',
        speaker: 'orion',
        emoji: '🦉',
        nextNode: 'closing',
      );
    }

    // ─── 4. Cierre ──────────────────────────────
    nodes['closing'] = StoryNode(
      id: 'closing',
      type: StoryNodeType.narrative,
      text: closing?['text'] as String? ?? '¡Capítulo completado!',
      speaker: closing?['speaker'] as String? ?? 'orion',
      emoji: closing?['emoji'] as String? ?? '🎉',
      nextNode: 'ending',
    );

    // ─── 5. Ending ──────────────────────────────
    nodes['ending'] = const StoryNode(
      id: 'ending',
      type: StoryNodeType.ending,
      text: '¡Has completado el capítulo! Tu progreso ha sido guardado.',
      emoji: '🏆',
    );

    // Determinar nodo inicial
    final startNodeId = narrativeList.isNotEmpty
        ? (narrativeList[0] as Map<String, dynamic>)['id'] as String? ?? 'narr_0'
        : 'ex_0';

    return StoryChapter(
      id: chapterMeta['id'] as String? ?? 'unknown',
      number: chapterMeta['order'] as int? ?? 1,
      title: chapterMeta['title'] as String? ?? 'Capítulo',
      gemName: chapterMeta['kingdom'] as String? ?? 'ignis',
      subject: chapterMeta['subject'] as String? ?? 'mates',
      topic: chapterMeta['topic'] as String? ?? '',
      startNodeId: startNodeId,
      nodes: nodes,
    );
  }

  /// Convierte un ejercicio JSON en un StoryNode de tipo exercise.
  ///
  /// Para el motor actual (solo soporta multiple_choice con correctIndex),
  /// los tipos fill_blank, true_false, sort, open_problem se adaptan
  /// a múltiple opción con opciones generadas.
  StoryNode _buildExerciseNode({
    required String id,
    required Map<String, dynamic> exercise,
    required String onCorrect,
    required String onIncorrect,
  }) {
    final type = exercise['type'] as String? ?? 'multiple_choice';
    final question = exercise['question'] as String? ?? '';
    final hint = exercise['hint'] as String?;
    final answer = exercise['answer'];

    List<String> options;
    int correctIndex;

    switch (type) {
      case 'multiple_choice':
        options = (exercise['options'] as List<dynamic>?)
                ?.cast<String>() ??
            [];
        final answerStr = answer as String? ?? '';
        correctIndex = options.indexOf(answerStr);
        if (correctIndex < 0) correctIndex = 0;
        break;

      case 'true_false':
        options = ['Verdadero', 'Falso'];
        correctIndex = (answer == 'true' || answer == true) ? 0 : 1;
        break;

      case 'fill_blank':
      case 'open_problem':
        // Convertir a multiple_choice con la respuesta + 3 distractores
        final correctStr = answer.toString();
        final distractors = _generateDistractors(correctStr);
        options = [correctStr, ...distractors];
        options.shuffle();
        correctIndex = options.indexOf(correctStr);
        break;

      case 'sort':
        // Para sort, presentamos la primera posición como pregunta
        final answerList = (answer as List<dynamic>?)?.cast<String>() ?? [];
        if (answerList.length >= 2) {
          // Pregunta: ¿Cuál va primero?
          final items = (exercise['items'] as List<dynamic>?)?.cast<String>() ?? [];
          options = items;
          correctIndex = items.indexOf(answerList.first);
          if (correctIndex < 0) correctIndex = 0;
        } else {
          options = ['?'];
          correctIndex = 0;
        }
        break;

      default:
        options = (exercise['options'] as List<dynamic>?)
                ?.cast<String>() ??
            ['?'];
        correctIndex = 0;
    }

    return StoryNode(
      id: id,
      type: StoryNodeType.exercise,
      text: '⚔️ ¡Ejercicio!',
      question: question,
      options: options,
      correctIndex: correctIndex,
      hint: hint,
      onCorrect: onCorrect,
      onIncorrect: onIncorrect,
    );
  }

  /// Genera 3 distractores numéricos a partir de una respuesta correcta.
  List<String> _generateDistractors(String correct) {
    final num = int.tryParse(correct);
    if (num != null) {
      // Distractores numéricos cercanos
      return [
        '${num + 1}',
        '${num - 2}',
        '${num + 10}',
      ];
    }
    // Para respuestas no numéricas, distractores genéricos
    return ['No sé', 'Otra respuesta', 'Ninguna'];
  }
}
