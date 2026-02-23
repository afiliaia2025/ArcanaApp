// Definición de los 25 logros de ArcanaApp
// Basado en el manual de diseño (sección Sistema de Logros)

import 'models.dart';

/// Los 25 logros del juego, organizados por categoría
final List<Achievement> allAchievements = [
  // ═══════════════════════════════════════════
  // 🔥 PRIMEROS PASOS (4)
  // ═══════════════════════════════════════════
  const Achievement(
    id: 'aprendiz',
    name: 'Aprendiz de Arcana',
    category: AchievementCategory.primerosPasos,
    description: 'Completar el primer capítulo',
    orionReaction: '¡Has dado tu primer paso, aprendiz! ¡Esto es solo el comienzo!',
    reward: 'Icono de perfil: estrella',
  ),
  const Achievement(
    id: 'cuatro_caminos',
    name: 'Cuatro Caminos',
    category: AchievementCategory.primerosPasos,
    description: 'Jugar al menos 1 capítulo de cada reino',
    orionReaction: '¡Has visitado los 4 reinos! Eres un explorador de verdad',
    reward: 'Marco de avatar: dorado',
  ),
  const Achievement(
    id: 'primera_runa',
    name: 'Primera Runa',
    category: AchievementCategory.primerosPasos,
    description: 'Encontrar tu primera runa',
    orionReaction: '¡Una RUNA! ¿Sabes lo raro que es encontrar una?',
    reward: 'Animación especial de runa',
  ),
  const Achievement(
    id: 'cien_xp',
    name: 'Primeras 100 XP',
    category: AchievementCategory.primerosPasos,
    description: 'Alcanzar 100 XP',
    orionReaction: '¡Cien puntos de experiencia! ¡Ya eres más mago que yo!',
    reward: 'Título: Mago Novato',
  ),

  // ═══════════════════════════════════════════
  // ⭐ MAESTRÍA (7)
  // ═══════════════════════════════════════════
  const Achievement(
    id: 'perfeccionista',
    name: 'Perfeccionista',
    category: AchievementCategory.maestria,
    description: '3 estrellas en un capítulo',
    orionReaction: '¡Tres estrellas! ¡Perfecto! ¡Estoy llorando de emoción!',
    reward: '+25 XP bonus',
  ),
  const Achievement(
    id: 'sin_fallos_5',
    name: 'Sin Fallos x5',
    category: AchievementCategory.maestria,
    description: '5 capítulos seguidos sin fallos',
    orionReaction: '¡CINCO seguidos sin fallar! ¿Eres humano o eres mago?',
    reward: 'Skin bastón: llamas',
  ),
  const Achievement(
    id: 'sin_fallos_10',
    name: 'Sin Fallos x10',
    category: AchievementCategory.maestria,
    description: '10 capítulos seguidos sin fallos',
    orionReaction: '¡DIEZ! Hasta Noctus tendría miedo de ti',
    reward: 'Título: Infalible',
  ),
  const Achievement(
    id: 'domador_ignis',
    name: 'Domador de Ignis',
    category: AchievementCategory.maestria,
    description: '3★ en TODOS los capítulos de Ignis',
    orionReaction: '¡Ignis está completamente dominado!',
    reward: 'Bastón rojo de fuego',
  ),
  const Achievement(
    id: 'domador_lexis',
    name: 'Domador de Lexis',
    category: AchievementCategory.maestria,
    description: '3★ en TODOS los capítulos de Lexis',
    orionReaction: '¡Las palabras no tienen secretos para ti!',
    reward: 'Bastón dorado',
  ),
  const Achievement(
    id: 'domador_sylva',
    name: 'Domador de Sylva',
    category: AchievementCategory.maestria,
    description: '3★ en TODOS los capítulos de Sylva',
    orionReaction: '¡La naturaleza te obedece!',
    reward: 'Bastón verde',
  ),
  const Achievement(
    id: 'domador_babel',
    name: 'Domador de Babel',
    category: AchievementCategory.maestria,
    description: '3★ en TODOS los capítulos de Babel',
    orionReaction: '¡Hablas todas las lenguas de Arcana!',
    reward: 'Bastón arcoíris',
  ),

  // ═══════════════════════════════════════════
  // 📚 CONOCIMIENTO (3)
  // ═══════════════════════════════════════════
  const Achievement(
    id: 'raton_biblioteca',
    name: 'Ratón de Biblioteca',
    category: AchievementCategory.conocimiento,
    description: 'Usar el diccionario 50 veces',
    orionReaction: '¡Te encanta aprender palabras nuevas!',
    reward: 'Pluma animada en perfil',
  ),
  const Achievement(
    id: 'poliglota',
    name: 'Políglota',
    category: AchievementCategory.conocimiento,
    description: 'Completar 6 capítulos de Babel',
    orionReaction: '¡Already speaking English! Amazing!',
    reward: 'Título: Políglota',
  ),
  const Achievement(
    id: 'cientifico_loco',
    name: 'Científico Loco',
    category: AchievementCategory.conocimiento,
    description: 'Completar 6 capítulos de Sylva',
    orionReaction: '¡Sabes más de la naturaleza que las propias plantas!',
    reward: 'Hoja animada en avatar',
  ),

  // ═══════════════════════════════════════════
  // 💪 CONSTANCIA (3)
  // ═══════════════════════════════════════════
  const Achievement(
    id: 'racha_7',
    name: 'Racha de 7',
    category: AchievementCategory.constancia,
    description: '7 días seguidos jugando',
    orionReaction: '¡Una SEMANA entera! ¡Eres imparable!',
    reward: '+50 XP bonus',
  ),
  const Achievement(
    id: 'racha_30',
    name: 'Racha de 30',
    category: AchievementCategory.constancia,
    description: '30 días seguidos jugando',
    orionReaction: '¡UN MES! *Orión llora* Nunca he estado tan orgulloso',
    reward: 'Título: Inquebrantable + marco especial',
  ),
  const Achievement(
    id: 'madrugador',
    name: 'Madrugador',
    category: AchievementCategory.constancia,
    description: 'Jugar antes de las 9:00 AM 10 veces',
    orionReaction: '¡Entrenar temprano es de sabios!',
    reward: 'Efecto amanecer en avatar',
  ),

  // ═══════════════════════════════════════════
  // ⚔️ COMBATE (4)
  // ═══════════════════════════════════════════
  const Achievement(
    id: 'primer_boss',
    name: 'Primer Boss',
    category: AchievementCategory.combate,
    description: 'Derrotar tu primer mini-boss',
    orionReaction: '¡Has derrotado a un GUARDIÁN! *tiembla de emoción*',
    reward: 'Medalla de bronce',
  ),
  const Achievement(
    id: 'cazador_6',
    name: 'Cazador de Guardianes',
    category: AchievementCategory.combate,
    description: 'Derrotar 6 mini-bosses',
    orionReaction: '¡Seis guardianes caídos! Eres una leyenda',
    reward: 'Medalla de plata',
  ),
  const Achievement(
    id: 'todos_guardianes',
    name: 'Todos los Guardianes',
    category: AchievementCategory.combate,
    description: 'Derrotar los 12 mini-bosses',
    orionReaction: '¡TODOS! Ya solo queda... él.',
    reward: 'Medalla de oro',
  ),
  const Achievement(
    id: 'destructor_noctus',
    name: 'Destructor de Noctus',
    category: AchievementCategory.combate,
    description: 'Derrotar al Boss Final',
    orionReaction: '¡NOCTUS HA CAÍDO! *Orión llora a moco tendido*',
    reward: 'Título: Salvador de Arcana + capa dorada',
  ),

  // ═══════════════════════════════════════════
  // 🧙 ARCHIMAGO — solo si hay profe (2)
  // ═══════════════════════════════════════════
  const Achievement(
    id: 'alumno_torre',
    name: 'Alumno de la Torre',
    category: AchievementCategory.archimago,
    description: 'Completar 1 reto del Archimago',
    orionReaction: '¡El Archimago está impresionado contigo!',
    reward: 'Insignia de la torre',
  ),
  const Achievement(
    id: 'entrenamiento_completo',
    name: 'Entrenamiento Completo',
    category: AchievementCategory.archimago,
    description: 'Completar 10 retos del Archimago',
    orionReaction: '¡Diez entrenamientos! El Archimago dice que eres su mejor alumno',
    reward: 'Título: Discípulo del Archimago',
  ),

  // ═══════════════════════════════════════════
  // 🌟 SECRETOS (2)
  // ═══════════════════════════════════════════
  const Achievement(
    id: 'cazador_secretos',
    name: 'Cazador de Secretos',
    category: AchievementCategory.secretos,
    description: 'Encontrar 5 puzzles ocultos',
    orionReaction: '¡Cinco secretos! ¡Tienes ojo de águila... digo, de búho!',
    reward: 'Lupa dorada en perfil',
  ),
  const Achievement(
    id: 'maestro_arcana',
    name: 'Maestro de Arcana',
    category: AchievementCategory.secretos,
    description: 'Desbloquear TODOS los logros anteriores',
    orionReaction: '¡LO HAS CONSEGUIDO TODO! Eres el mayor mago que Arcana ha conocido',
    reward: 'Título único: 🌟 Maestro de Arcana 🌟 + efecto de partículas permanente',
  ),
];
