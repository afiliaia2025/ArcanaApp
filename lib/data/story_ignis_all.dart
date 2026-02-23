/// ═══════════════════════════════════════════════════════════════
/// ÍNDICE DE TODOS LOS CAPÍTULOS DE LA GEMA IGNIS
/// Matemáticas · Edelvives Fanfest 2 · 13 capítulos + 3 bosses
/// ═══════════════════════════════════════════════════════════════
library;

import '../models/story_models.dart';

// — Capítulos 1-5 —
import 'story_chapter1_ignis.dart';
// — Boss 1 —
import 'story_ignis_boss1.dart';
// — Capítulos 6-9 —
import 'story_ignis_caps6_9.dart';
// — Boss 2 + Capítulos 10-13 —
import 'story_ignis_caps10_13.dart';
// — Boss Final —
import 'story_ignis_boss_final.dart';
// — Prólogo —
import 'story_prologue.dart';

/// Lista ordenada de TODOS los capítulos de Ignis (incluye bosses)
/// en el orden en que deben jugarse.
final List<StoryChapter> allIgnisChapters = [
  storyPrologue,        // 0: Prólogo
  chapter1Ignis,         // 1: La Puerta de la Torre
  chapter2Ignis,         // 2: Las Escaleras de Cristal
  chapter3Ignis,         // 3: El Coleccionista de Runas
  chapter4Ignis,         // 4: El Reloj de la Torre
  chapter5Ignis,         // 5: El Torneo de los Aprendices
  boss1Ignis,            // ⚔️ Boss 1: El Numerox Guardián
  chapter6Ignis,         // 6: La Ventisca de Noctus
  chapter7Ignis,         // 7: Las Cometas Mensajeras
  chapter8Ignis,         // 8: El Huerto Encantado
  chapter9Ignis,         // 9: La Fuente Seca
  boss2Ignis,            // ⚔️ Boss 2: El General de Piedra
  chapter10Ignis,        // 10: El Pergamino Cifrado
  chapter11Ignis,        // 11: El Mercado Oscuro
  chapter12Ignis,        // 12: La Sala de los Espejos
  chapter13Ignis,        // 13: El Banquete Final
  bossFinalIgnis,        // ⚔️ Boss Final: Noctus en la Torre
];

/// Obtener un capítulo por su ID
StoryChapter? getIgnisChapterById(String chapterId) {
  try {
    return allIgnisChapters.firstWhere((c) => c.id == chapterId);
  } catch (_) {
    return null;
  }
}

/// Obtener el siguiente capítulo en la secuencia
StoryChapter? getNextIgnisChapter(String currentChapterId) {
  final idx = allIgnisChapters.indexWhere((c) => c.id == currentChapterId);
  if (idx < 0 || idx >= allIgnisChapters.length - 1) return null;
  return allIgnisChapters[idx + 1];
}
