import '../models/models.dart';

/// Datos mock para el MVP visual
/// Simula lo que generaría la IA en producción
class MockData {
  MockData._();

  // ═══════════════════════════════════════════
  // USUARIO
  // ═══════════════════════════════════════════

  static const userProfile = UserProfile(
    id: 'mock-user-1',
    displayName: 'Pablo',
    nick: 'Pablo_Astro',
    avatar: '🧑‍🚀',
    role: UserRole.student,
    grade: '5_primaria',
    region: 'madrid',
    subjects: ['mates', 'lengua', 'ciencias', 'ingles'],
    hardestSubject: 'mates',
    interests: ['espacio', 'dinosaurios', 'videojuegos'],
    onboardingComplete: true,
    xp: 340,
    level: 4,
    streak: 3,
    lives: 4,
    maxLives: 5,
  );

  // ═══════════════════════════════════════════
  // EJERCICIOS
  // ═══════════════════════════════════════════

  static const sampleExercises = [
    Exercise(
      id: 'ex-1',
      type: ExerciseType.multipleChoice,
      question: '¿Cuánto es 3/4 + 1/2?',
      options: ['5/4', '4/6', '1', '5/6'],
      correctAnswer: '5/4',
      explanation: 'Para sumar fracciones con diferente denominador, buscamos el mínimo común múltiplo. MCM(4,2) = 4. Entonces: 3/4 + 2/4 = 5/4',
      xpReward: 10,
    ),
    Exercise(
      id: 'ex-2',
      type: ExerciseType.trueFalse,
      question: '2/3 es mayor que 3/4',
      options: ['Verdadero', 'Falso'],
      correctAnswer: 'Falso',
      explanation: '2/3 = 0.666... y 3/4 = 0.75, por lo que 3/4 es mayor',
      xpReward: 10,
    ),
    Exercise(
      id: 'ex-3',
      type: ExerciseType.fillInBlank,
      question: 'Si tienes 1/2 pizza y comes 1/4, te queda ___ de pizza',
      options: [],
      correctAnswer: '1/4',
      explanation: '1/2 - 1/4 = 2/4 - 1/4 = 1/4',
      xpReward: 15,
    ),
    Exercise(
      id: 'ex-4',
      type: ExerciseType.multipleChoice,
      question: '¿Cuál es la fracción equivalente a 2/4?',
      options: ['1/2', '3/6', '4/8', 'Todas son correctas'],
      correctAnswer: 'Todas son correctas',
      explanation: '2/4 = 1/2 = 3/6 = 4/8 — todas representan la misma cantidad',
      xpReward: 10,
    ),
    Exercise(
      id: 'ex-5',
      type: ExerciseType.multipleChoice,
      question: '¿Cuánto es 5/6 - 1/3?',
      options: ['4/3', '1/2', '2/3', '1/6'],
      correctAnswer: '1/2',
      explanation: 'Convertimos 1/3 a 2/6. Entonces: 5/6 - 2/6 = 3/6 = 1/2',
      xpReward: 10,
    ),
  ];

  // ═══════════════════════════════════════════
  // CAPÍTULOS
  // ═══════════════════════════════════════════

  static final chapters = [
    // Cap 0 — Pregenerado (primera vez)
    Chapter(
      id: 'ch-0',
      title: 'Los Primeros Arcanos',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 0,
      subject: 'mates',
      topic: 'Introducción',
      isCompleted: true,
      isUnlocked: true,
      totalXP: 50,
      panels: const [
        StoryPanel(
          id: 'p-0-1',
          text: 'Despiertas en una isla misteriosa. El cielo brilla con constelaciones que forman... ¿números?',
          backgroundTheme: 'numbers',
          isUnlocked: true,
        ),
        StoryPanel(
          id: 'p-0-2',
          text: '"Bienvenido, joven explorador", dice una voz. "Soy el Guardián de los Arcanos. Esta isla guarda secretos que solo los más sabios pueden descifrar."',
          backgroundTheme: 'numbers',
          isUnlocked: true,
        ),
      ],
      exercises: const [],
    ),

    // Cap 1 — Fracciones básicas
    Chapter(
      id: 'ch-1',
      title: 'El Puente Fraccionado',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 1,
      subject: 'mates',
      topic: 'Fracciones',
      isCompleted: true,
      isUnlocked: true,
      totalXP: 50,
      panels: const [
        StoryPanel(
          id: 'p-1-1',
          text: 'Un puente enorme cruza el río, pero sus tablas están rotas. Cada una tiene una fracción grabada.',
          backgroundTheme: 'numbers',
          isUnlocked: true,
        ),
        StoryPanel(
          id: 'p-1-2',
          text: '"Solo colocando las fracciones correctas podrás reconstruir el paso", dice el Guardián.',
          backgroundTheme: 'numbers',
          isUnlocked: true,
        ),
      ],
      exercises: sampleExercises.sublist(0, 3),
    ),

    // Cap 2 — Equivalencias
    Chapter(
      id: 'ch-2',
      title: 'La Cueva de los Espejos',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 2,
      subject: 'mates',
      topic: 'Fracciones equivalentes',
      isCompleted: true,
      isUnlocked: true,
      totalXP: 60,
      panels: const [
        StoryPanel(
          id: 'p-2-1',
          text: 'Dentro de la cueva, cada espejo refleja una fracción diferente. Pero todas representan lo mismo...',
          backgroundTheme: 'numbers',
          isUnlocked: true,
        ),
      ],
      exercises: sampleExercises.sublist(3, 5),
    ),

    // Cap 3 — Prueba-puerta 🚪
    Chapter(
      id: 'ch-3',
      title: 'La Puerta del Guardián',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 3,
      subject: 'mates',
      topic: 'Fracciones mixtas',
      type: ChapterType.gatePuzzle,
      isCompleted: false,
      isUnlocked: true,
      totalXP: 80,
      panels: const [
        StoryPanel(
          id: 'p-3-1',
          text: 'Una puerta gigante bloquea el camino. Inscripciones con números brillan en su superficie. "Demuestra lo que has aprendido", retumba la voz del Guardián.',
          backgroundTheme: 'numbers',
          isUnlocked: true,
        ),
      ],
      exercises: sampleExercises,
    ),

    // Cap 4A — Camino acierto
    Chapter(
      id: 'ch-4a',
      title: 'El Jardín de los Decimales',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 4,
      subject: 'mates',
      topic: 'Decimales',
      isCompleted: false,
      isUnlocked: false,
      totalXP: 60,
      panels: const [
        StoryPanel(
          id: 'p-4a-1',
          text: 'La puerta se abre. Un jardín lleno de flores numéricas te da la bienvenida. Cada pétalo es un decimal...',
          backgroundTheme: 'numbers',
        ),
      ],
      exercises: sampleExercises.sublist(0, 3),
    ),

    // Cap 4B — Camino fallo (bifurcación)
    Chapter(
      id: 'ch-4b',
      title: 'El Laberinto Oscuro',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 4,
      subject: 'mates',
      topic: 'Fracciones (repaso)',
      isCompleted: false,
      isUnlocked: false,
      totalXP: 60,
      panels: const [
        StoryPanel(
          id: 'p-4b-1',
          text: 'La puerta se cierra de golpe. El suelo cede y caes a un laberinto subterráneo. "No te rindas", susurra el Guardián. "Hay otra salida..."',
          backgroundTheme: 'numbers',
        ),
      ],
      exercises: sampleExercises.sublist(0, 4),
    ),

    // Cap 5 — Se unen los caminos
    Chapter(
      id: 'ch-5',
      title: 'La Torre del Cálculo',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 5,
      subject: 'mates',
      topic: 'Operaciones mixtas',
      isCompleted: false,
      isUnlocked: false,
      totalXP: 70,
      panels: const [
        StoryPanel(
          id: 'p-5-1',
          text: 'Los dos caminos se encuentran al pie de una torre altísima. Sus escalones tienen operaciones grabadas...',
          backgroundTheme: 'numbers',
        ),
      ],
      exercises: sampleExercises,
    ),

    // BOSS 🐉
    Chapter(
      id: 'ch-boss',
      title: 'El Dragón del Puente',
      kingdom: Kingdom.ignis,
      trimester: 1,
      orderInKingdom: 6,
      subject: 'mates',
      topic: 'Examen final fracciones',
      type: ChapterType.miniBoss,
      isCompleted: false,
      isUnlocked: false,
      totalXP: 150,
      panels: const [
        StoryPanel(
          id: 'p-boss-1',
          text: 'En la cima de la torre, un dragón de fuego azul custodia el primer Arcano. "¡Demuestra tu dominio de los números!"',
          backgroundTheme: 'numbers',
        ),
      ],
      exercises: sampleExercises,
    ),
  ];

  // ═══════════════════════════════════════════
  // WORLD MAP
  // ═══════════════════════════════════════════

  static const mapNodes = [
    MapNode(id: 'n-0', chapterId: 'ch-0', kingdom: Kingdom.ignis, x: 0.5, y: 0.92,
      status: MapNodeStatus.completed, label: 'Inicio', emoji: '🏠'),
    MapNode(id: 'n-1', chapterId: 'ch-1', kingdom: Kingdom.ignis, x: 0.3, y: 0.78,
      status: MapNodeStatus.completed, label: 'El Puente', emoji: '🌉'),
    MapNode(id: 'n-2', chapterId: 'ch-2', kingdom: Kingdom.ignis, x: 0.7, y: 0.65,
      status: MapNodeStatus.completed, label: 'La Cueva', emoji: '🪞'),
    MapNode(id: 'n-3', chapterId: 'ch-3', kingdom: Kingdom.ignis, x: 0.5, y: 0.52,
      status: MapNodeStatus.current, type: ChapterType.gatePuzzle,
      label: 'Puerta', emoji: '🚪'),
    MapNode(id: 'n-4a', chapterId: 'ch-4a', kingdom: Kingdom.ignis, x: 0.25, y: 0.38,
      status: MapNodeStatus.locked, label: 'Jardín', emoji: '🌺'),
    MapNode(id: 'n-4b', chapterId: 'ch-4b', kingdom: Kingdom.ignis, x: 0.75, y: 0.38,
      status: MapNodeStatus.locked, label: 'Laberinto', emoji: '🌀'),
    MapNode(id: 'n-5', chapterId: 'ch-5', kingdom: Kingdom.ignis, x: 0.5, y: 0.24,
      status: MapNodeStatus.locked, label: 'La Torre', emoji: '🗼'),
    MapNode(id: 'n-boss', chapterId: 'ch-boss', kingdom: Kingdom.ignis, x: 0.5, y: 0.10,
      status: MapNodeStatus.locked, type: ChapterType.miniBoss,
      label: 'Boss', emoji: '🐉'),
  ];

  static const mapPaths = [
    MapPath(fromNodeId: 'n-0', toNodeId: 'n-1', isCompleted: true),
    MapPath(fromNodeId: 'n-1', toNodeId: 'n-2', isCompleted: true),
    MapPath(fromNodeId: 'n-2', toNodeId: 'n-3', isCompleted: true),
    // Bifurcación
    MapPath(fromNodeId: 'n-3', toNodeId: 'n-4a', branch: MapPathBranch.branchA),
    MapPath(fromNodeId: 'n-3', toNodeId: 'n-4b', branch: MapPathBranch.branchB),
    // Se unen
    MapPath(fromNodeId: 'n-4a', toNodeId: 'n-5'),
    MapPath(fromNodeId: 'n-4b', toNodeId: 'n-5'),
    // Boss
    MapPath(fromNodeId: 'n-5', toNodeId: 'n-boss'),
  ];

  static const mapZone = MapZone(
    id: 'zone-1',
    name: 'El Puente Fraccionado',
    kingdom: Kingdom.ignis,
    subject: 'mates',
    nodes: mapNodes,
    paths: mapPaths,
  );
}
