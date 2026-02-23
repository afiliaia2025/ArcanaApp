import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/models.dart';

// ═══════════════════════════════════════════
// SERVICIO DE EJERCICIOS — Banco Curricular
// ═══════════════════════════════════════════
// Carga ejercicios desde los JSON estáticos en assets/curriculum/
// y los sirve a la app sin necesidad de llamadas a la IA.

/// Modelo de un tema curricular
class CurriculumTopic {
  final String id;
  final String name;
  final String icon;
  final int order;
  final List<Exercise> exercises;

  const CurriculumTopic({
    required this.id,
    required this.name,
    required this.icon,
    required this.order,
    required this.exercises,
  });

  factory CurriculumTopic.fromJson(Map<String, dynamic> json, List<Exercise> exercises) {
    return CurriculumTopic(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '📚',
      order: json['order'] as int? ?? 0,
      exercises: exercises,
    );
  }
}

/// Resultado de cargar un fichero de trimestre
class TrimesterData {
  final String grade;
  final String subject;
  final int trimester;
  final List<CurriculumTopic> topics;

  const TrimesterData({
    required this.grade,
    required this.subject,
    required this.trimester,
    required this.topics,
  });

  /// Total de ejercicios en este trimestre
  int get totalExercises => topics.fold(0, (sum, t) => sum + t.exercises.length);

  /// Todos los ejercicios aplanados
  List<Exercise> get allExercises =>
      topics.expand((t) => t.exercises).toList();
}

/// Servicio principal de ejercicios
class ExerciseService {
  // Caché en memoria para no re-parsear JSON en cada llamada
  final Map<String, TrimesterData> _cache = {};
  final Random _rng = Random();

  // ── Singleton ──
  static final ExerciseService _instance = ExerciseService._();
  factory ExerciseService() => _instance;
  ExerciseService._();

  // ═══════════════════════════════════════════
  // API PÚBLICA
  // ═══════════════════════════════════════════

  /// Carga un trimestre completo (con caché)
  Future<TrimesterData> loadTrimester({
    required String grade,     // "2_primaria" | "3_primaria"
    required String subject,   // "mates" | "lengua" | "ciencias"
    required int trimester,    // 1, 2, 3
  }) async {
    final key = '${grade}_${subject}_t$trimester';

    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final path = 'assets/curriculum/$grade/${subject}_t$trimester.json';
    final jsonStr = await rootBundle.loadString(path);
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    final topicsJson = data['topics'] as List;
    final topics = <CurriculumTopic>[];

    for (final topicJson in topicsJson) {
      final topicMap = topicJson as Map<String, dynamic>;
      final exercisesJson = topicMap['exercises'] as List? ?? [];
      final exercises = exercisesJson
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList();

      topics.add(CurriculumTopic.fromJson(topicMap, exercises));
    }

    final result = TrimesterData(
      grade: grade,
      subject: subject,
      trimester: trimester,
      topics: topics,
    );

    _cache[key] = result;
    return result;
  }

  /// Obtiene ejercicios de un tema específico, filtrados por dificultad
  Future<List<Exercise>> getExercisesByTopic({
    required String grade,
    required String subject,
    required int trimester,
    required String topicId,
    int? maxDifficulty,
    int? count,
  }) async {
    final data = await loadTrimester(
      grade: grade,
      subject: subject,
      trimester: trimester,
    );

    final topic = data.topics.where((t) => t.id == topicId).firstOrNull;
    if (topic == null) return [];

    var exercises = topic.exercises.toList();

    // Filtrar por dificultad máxima
    if (maxDifficulty != null) {
      exercises = exercises.where((e) => e.difficulty <= maxDifficulty).toList();
    }

    // Limitar cantidad y mezclar
    if (count != null && exercises.length > count) {
      exercises.shuffle(_rng);
      exercises = exercises.take(count).toList();
    }

    return exercises;
  }

  /// Obtiene un quiz aleatorio de un trimestre (mezcla de todos los temas)
  Future<List<Exercise>> getQuiz({
    required String grade,
    required String subject,
    required int trimester,
    int count = 10,
    int? maxDifficulty,
  }) async {
    final data = await loadTrimester(
      grade: grade,
      subject: subject,
      trimester: trimester,
    );

    var allExercises = data.allExercises.toList();

    if (maxDifficulty != null) {
      allExercises = allExercises.where((e) => e.difficulty <= maxDifficulty).toList();
    }

    allExercises.shuffle(_rng);
    return allExercises.take(count).toList();
  }

  /// Obtiene ejercicios de repaso (trimestres anteriores)
  Future<List<Exercise>> getReviewExercises({
    required String grade,
    required String subject,
    required int currentTrimester,
    int count = 5,
  }) async {
    final allExercises = <Exercise>[];

    // Cargar trimestres anteriores
    for (var t = 1; t < currentTrimester; t++) {
      try {
        final data = await loadTrimester(
          grade: grade,
          subject: subject,
          trimester: t,
        );
        allExercises.addAll(data.allExercises);
      } catch (_) {
        // Silenciar si no hay trimestre anterior
      }
    }

    allExercises.shuffle(_rng);
    return allExercises.take(count).toList();
  }

  /// Obtiene los temas de un trimestre (para el WorldMap)
  Future<List<CurriculumTopic>> getTopics({
    required String grade,
    required String subject,
    required int trimester,
  }) async {
    final data = await loadTrimester(
      grade: grade,
      subject: subject,
      trimester: trimester,
    );
    return data.topics;
  }

  /// Detecta el trimestre actual según la fecha
  static int currentTrimester([DateTime? now]) {
    final date = now ?? DateTime.now();
    final month = date.month;

    // Trimestre 1: Septiembre - Diciembre
    if (month >= 9 && month <= 12) return 1;
    // Trimestre 2: Enero - Marzo
    if (month >= 1 && month <= 3) return 2;
    // Trimestre 3: Abril - Junio
    if (month >= 4 && month <= 6) return 3;
    // Verano (julio-agosto): repaso del T3
    return 3;
  }

  /// Convierte el grado del perfil ("2º Primaria") al código de carpeta
  static String gradeToFolder(String profileGrade) {
    if (profileGrade.contains('2')) return '2_primaria';
    if (profileGrade.contains('3')) return '3_primaria';
    // Fallback
    return '2_primaria';
  }

  /// Verifica si la respuesta del usuario es correcta
  bool checkAnswer(Exercise exercise, String userAnswer) {
    final correct = exercise.correctAnswer.trim().toLowerCase();
    final answer = userAnswer.trim().toLowerCase();

    if (exercise.type == ExerciseType.trueFalse) {
      // Normalizar "verdadero"/"true" y "falso"/"false"
      final normalizedCorrect = _normalizeTrueFalse(correct);
      final normalizedAnswer = _normalizeTrueFalse(answer);
      return normalizedCorrect == normalizedAnswer;
    }

    return correct == answer;
  }

  String _normalizeTrueFalse(String value) {
    if (value == 'verdadero' || value == 'true' || value == 'v') return 'true';
    if (value == 'falso' || value == 'false' || value == 'f') return 'false';
    return value;
  }

  /// Limpia la caché (para tests o recarga)
  void clearCache() => _cache.clear();
}
