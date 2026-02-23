/// Índice de la Gema Sylva (Science) — todos los capítulos en orden
///
/// Estructura:
///  1. Cap 1: El Jardín Viviente (living/non-living)
///  2. Cap 2: La Puerta del Clima (parts of a plant)
///  3. Cap 3: El Laberinto de Piedra (vertebrates/invertebrates)
///  4. Cap 4: El Laboratorio del Alquimista (materials)
///  5. Cap 5: La Cueva Sombría (states of water)
///  6. Cap 6: La Torre del Sol (human body)
///  7. Boss 1: El Guardián de las Enredaderas (repaso 1-3)
///  8. Boss Final: El Dragón de la Naturaleza (todo Science)
library;

import '../models/story_models.dart';
import 'story_sci_cap1_3.dart';
import 'story_sci_cap4_6.dart';
import 'story_sci_boss.dart';

/// Lista ordenada de todos los capítulos de Sylva
final List<StoryChapter> allSylvaChapters = [
  // Acto I — Naturaleza viva
  chapter1Sylva,    // 1: El Jardín Viviente
  chapter2Sylva,    // 2: La Puerta del Clima
  chapter3Sylva,    // 3: El Laberinto de Piedra

  // Acto II — Materia y cuerpo
  chapter4Sylva,    // 4: El Laboratorio del Alquimista
  chapter5Sylva,    // 5: La Cueva Sombría
  chapter6Sylva,    // 6: La Torre del Sol

  // Bosses
  boss1Sylva,       // 7: El Guardián de las Enredaderas
  bossFinalSylva,   // 8: El Dragón de la Naturaleza
];

/// Buscar un capítulo de Sylva por su ID
StoryChapter? getSylvaChapterById(String id) {
  try {
    return allSylvaChapters.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

/// Obtener el siguiente capítulo de Sylva tras el actual
StoryChapter? getNextSylvaChapter(String currentId) {
  final idx = allSylvaChapters.indexWhere((c) => c.id == currentId);
  if (idx == -1 || idx >= allSylvaChapters.length - 1) return null;
  return allSylvaChapters[idx + 1];
}
