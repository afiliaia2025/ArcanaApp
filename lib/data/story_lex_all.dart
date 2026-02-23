/// Índice de la Gema Lexis (Lengua) — todos los capítulos en orden
///
/// Estructura:
///  1. Cap 1: La Carta Misteriosa (abecedario)
///  2. Cap 2: La Biblioteca Revuelta (sílabas)
///  3. Cap 3: El Mensaje del Río (sustantivos)
///  4. Cap 4: La Receta Maldita (ortografía C/Q/Z)
///  5. Cap 5: Los Nombres Perdidos (adjetivos)
///  6. Boss 1: El Letrón (repaso U1-U5)
///  7. Cap 6: El Cuento Roto (puntuación)
///  8. Cap 7: Los Verbos del Tiempo (tiempos verbales)
///  9. Cap 8: El Poema de la Puerta (ortografía G/GU/GÜ)
/// 10. Cap 9: La Carta a Numeralia (comprensión lectora)
/// 11. Cap 10: El Mapa del Tesoro (mayúsculas)
/// 12. Boss 2: El Escriba Oscuro (repaso U6-U10)
/// 13. Boss Final: El Guardián de las Palabras (todo Lengua)
library;

import '../models/story_models.dart';
import 'story_lex_cap1_5.dart';
import 'story_lex_boss1.dart';
import 'story_lex_cap6_10.dart';
import 'story_lex_bosses.dart';

/// Lista ordenada de todos los capítulos de Lexis
final List<StoryChapter> allLexisChapters = [
  // Acto I — Primeros pasos en el Bosque Lexis
  chapter1Lexis,   // 1: La Carta Misteriosa
  chapter2Lexis,   // 2: La Biblioteca Revuelta
  chapter3Lexis,   // 3: El Mensaje del Río
  chapter4Lexis,   // 4: La Receta Maldita
  chapter5Lexis,   // 5: Los Nombres Perdidos
  boss1Lexis,      // 6: Boss 1 — El Letrón

  // Acto II — Avanzando por el bosque
  chapter6Lexis,   // 7: El Cuento Roto
  chapter7Lexis,   // 8: Los Verbos del Tiempo
  chapter8Lexis,   // 9: El Poema de la Puerta
  chapter9Lexis,   // 10: La Carta a Numeralia
  chapter10Lexis,  // 11: El Mapa del Tesoro
  boss2Lexis,      // 12: Boss 2 — El Escriba Oscuro

  // Acto III — Boss Final
  bossFinalLexis,  // 13: El Guardián de las Palabras
];

/// Buscar un capítulo de Lexis por su ID
StoryChapter? getLexisChapterById(String id) {
  try {
    return allLexisChapters.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

/// Obtener el siguiente capítulo de Lexis tras el actual
StoryChapter? getNextLexisChapter(String currentId) {
  final idx = allLexisChapters.indexWhere((c) => c.id == currentId);
  if (idx == -1 || idx >= allLexisChapters.length - 1) return null;
  return allLexisChapters[idx + 1];
}
