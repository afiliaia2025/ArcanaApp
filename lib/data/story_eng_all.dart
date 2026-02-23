/// Índice de la Gema Babel (English) — todos los capítulos en orden
///
/// Estructura:
///  1. Cap 1: El Portal se Abre (greetings, numbers, colours)
///  2. Cap 2: Un Día en Babel (daily routines, time)
///  3. Cap 3: El Mercado de Criaturas (have got / has got)
///  4. Cap 4: El Pueblo Perdido (prepositions of place)
///  5. Boss 1: El Guardián de Babel (repaso 1-4)
///  6. Cap 5: La Canción Perdida (food, some/any)
///  7. Cap 6: El Laberinto de Palabras (this/that/these/those)
///  8. Cap 7: El Misterio del Eco (present continuous, like + ing)
///  9. Cap 8: La Biblioteca Silenciosa (can / can't)
/// 10. Boss 2: El Maestro de las Rimas (repaso 5-8)
/// 11. Boss Final: Noctus Eterno (todo English + cierre aventura)
library;

import '../models/story_models.dart';
import 'story_eng_cap1_4.dart';
import 'story_eng_cap5_8.dart';
import 'story_eng_boss_final.dart';

/// Lista ordenada de todos los capítulos de Babel
final List<StoryChapter> allBabelChapters = [
  // Acto I — Primeras palabras
  chapter1Babel, // 1: El Portal se Abre
  chapter2Babel, // 2: Un Día en Babel
  chapter3Babel, // 3: El Mercado de Criaturas
  chapter4Babel, // 4: El Pueblo Perdido

  // Boss I
  boss1Babel, // 5: El Guardián de Babel

  // Acto II — Dominio del idioma
  chapter5Babel, // 6: La Canción Perdida
  chapter6Babel, // 7: El Laberinto de Palabras
  chapter7Babel, // 8: El Misterio del Eco
  chapter8Babel, // 9: La Biblioteca Silenciosa

  // Boss II + Final
  boss2Babel,      // 10: El Maestro de las Rimas
  bossFinalBabel,  // 11: Noctus Eterno
];

/// Buscar un capítulo de Babel por su ID
StoryChapter? getBabelChapterById(String id) {
  try {
    return allBabelChapters.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

/// Obtener el siguiente capítulo de Babel tras el actual
StoryChapter? getNextBabelChapter(String currentId) {
  final idx = allBabelChapters.indexWhere((c) => c.id == currentId);
  if (idx == -1 || idx >= allBabelChapters.length - 1) return null;
  return allBabelChapters[idx + 1];
}
