import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/exercise_service.dart';

// ═══════════════════════════════════════════
// PROVIDER DE EJERCICIOS — Banco Curricular
// ═══════════════════════════════════════════

/// Provider singleton del ExerciseService
final exerciseServiceProvider = Provider<ExerciseService>((ref) {
  return ExerciseService();
});

/// Provider para cargar un trimestre completo
final trimesterDataProvider = FutureProvider.family<TrimesterData, ({String grade, String subject, int trimester})>(
  (ref, params) async {
    final service = ref.watch(exerciseServiceProvider);
    return service.loadTrimester(
      grade: params.grade,
      subject: params.subject,
      trimester: params.trimester,
    );
  },
);

/// Provider para obtener los temas de un trimestre
final topicsProvider = FutureProvider.family<List<CurriculumTopic>, ({String grade, String subject, int trimester})>(
  (ref, params) async {
    final service = ref.watch(exerciseServiceProvider);
    return service.getTopics(
      grade: params.grade,
      subject: params.subject,
      trimester: params.trimester,
    );
  },
);

/// Provider del trimestre actual
final currentTrimesterProvider = Provider<int>((ref) {
  return ExerciseService.currentTrimester();
});
