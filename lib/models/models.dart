// Modelos de datos para Arcana
// Ejercicios, capítulos, reinos, logros, y perfil de usuario

// ═══════════════════════════════════════════
// REINOS
// ═══════════════════════════════════════════

/// Los 4 reinos de Numeralia (cada uno = 1 asignatura)
enum Kingdom {
  ignis,   // 🔴 Mates — Forja de los Números (NPC: Vulkan)
  lexis,   // 🟡 Lengua — Bosque de las Palabras (NPC: Lexia)
  sylva,   // 🟢 Ciencias — Jardín Salvaje (NPC: Silvana)
  babel,   // 📘 Inglés — Ciudad de las Lenguas (NPC: Professor Pax)
}

/// Extensión con metadatos de cada reino
extension KingdomExt on Kingdom {
  String get displayName {
    switch (this) {
      case Kingdom.ignis: return 'Ignis';
      case Kingdom.lexis: return 'Lexis';
      case Kingdom.sylva: return 'Sylva';
      case Kingdom.babel: return 'Babel';
    }
  }

  String get subject {
    switch (this) {
      case Kingdom.ignis: return 'mates';
      case Kingdom.lexis: return 'lengua';
      case Kingdom.sylva: return 'ciencias';
      case Kingdom.babel: return 'ingles';
    }
  }

  String get emoji {
    switch (this) {
      case Kingdom.ignis: return '🔴';
      case Kingdom.lexis: return '🟡';
      case Kingdom.sylva: return '🟢';
      case Kingdom.babel: return '📘';
    }
  }

  String get npcName {
    switch (this) {
      case Kingdom.ignis: return 'Vulkan';
      case Kingdom.lexis: return 'Lexia';
      case Kingdom.sylva: return 'Silvana';
      case Kingdom.babel: return 'Professor Pax';
    }
  }

  /// Color hexadecimal primario del reino
  int get colorValue {
    switch (this) {
      case Kingdom.ignis: return 0xFFE53935; // Rojo fuego
      case Kingdom.lexis: return 0xFFFDD835; // Amarillo dorado
      case Kingdom.sylva: return 0xFF43A047; // Verde naturaleza
      case Kingdom.babel: return 0xFF1E88E5; // Azul cielo
    }
  }
}

// ═══════════════════════════════════════════
// PERFIL DE USUARIO
// ═══════════════════════════════════════════

/// Rol del usuario en la app
enum UserRole { student, parent, teacher }

/// Perfil completo del usuario
class UserProfile {
  final String id;
  final String displayName;
  final String nick;
  final String avatar;
  final UserRole role;
  final String grade;
  final String region;
  final List<String> subjects;
  final String hardestSubject;
  final List<String> interests;
  final bool onboardingComplete;

  // Gamificación
  final int xp;
  final int level;
  final int streak;
  final int lives;
  final int maxLives;

  // Social
  final List<String> friendIds;
  final String? parentId;
  final List<String> childrenIds;
  final int? dailyTimeLimitMinutes;

  // Clase / Profesor
  final String? classCode;
  final String? teacherUid;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.nick,
    this.avatar = '🧑‍🚀',
    this.role = UserRole.student,
    this.grade = '',
    this.region = '',
    this.subjects = const [],
    this.hardestSubject = '',
    this.interests = const [],
    this.onboardingComplete = false,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.lives = 5,
    this.maxLives = 5,
    this.friendIds = const [],
    this.parentId,
    this.childrenIds = const [],
    this.dailyTimeLimitMinutes,
    this.classCode,
    this.teacherUid,
  });

  /// XP necesario para subir al siguiente nivel
  int get xpForNextLevel => level * 100;

  /// Progreso hacia el siguiente nivel (0.0 a 1.0)
  double get levelProgress => (xp % xpForNextLevel) / xpForNextLevel;

  /// ¿Tiene un profesor vinculado? (El Archimago aparece)
  bool get hasArchimago => teacherUid != null && teacherUid!.isNotEmpty;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      nick: json['nick'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '🧑‍🚀',
      role: _parseRole(json['role'] as String? ?? 'student'),
      grade: json['grade'] as String? ?? '',
      region: json['region'] as String? ?? '',
      subjects: _parseStringList(json['subjects']),
      hardestSubject: json['hardestSubject'] as String? ?? '',
      interests: _parseStringList(json['interests']),
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      streak: json['streak'] as int? ?? 0,
      lives: json['lives'] as int? ?? 5,
      maxLives: json['maxLives'] as int? ?? 5,
      friendIds: _parseStringList(json['friendIds']),
      parentId: json['parentId'] as String?,
      childrenIds: _parseStringList(json['childrenIds']),
      dailyTimeLimitMinutes: json['dailyTimeLimitMinutes'] as int?,
      classCode: json['classCode'] as String?,
      teacherUid: json['teacherUid'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'nick': nick,
    'avatar': avatar,
    'role': role.name,
    'grade': grade,
    'region': region,
    'subjects': subjects,
    'hardestSubject': hardestSubject,
    'interests': interests,
    'onboardingComplete': onboardingComplete,
    'xp': xp,
    'level': level,
    'streak': streak,
    'lives': lives,
    'maxLives': maxLives,
    'friendIds': friendIds,
    'parentId': parentId,
    'childrenIds': childrenIds,
    'dailyTimeLimitMinutes': dailyTimeLimitMinutes,
    'classCode': classCode,
    'teacherUid': teacherUid,
  };

  static UserRole _parseRole(String role) {
    switch (role) {
      case 'parent': return UserRole.parent;
      case 'teacher': return UserRole.teacher;
      default: return UserRole.student;
    }
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }

  UserProfile copyWith({
    String? displayName,
    String? nick,
    String? avatar,
    UserRole? role,
    String? grade,
    String? region,
    List<String>? subjects,
    String? hardestSubject,
    List<String>? interests,
    bool? onboardingComplete,
    int? xp,
    int? level,
    int? streak,
    int? lives,
    List<String>? friendIds,
    String? classCode,
    String? teacherUid,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      nick: nick ?? this.nick,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      grade: grade ?? this.grade,
      region: region ?? this.region,
      subjects: subjects ?? this.subjects,
      hardestSubject: hardestSubject ?? this.hardestSubject,
      interests: interests ?? this.interests,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      lives: lives ?? this.lives,
      friendIds: friendIds ?? this.friendIds,
      parentId: parentId,
      childrenIds: childrenIds,
      dailyTimeLimitMinutes: dailyTimeLimitMinutes,
      classCode: classCode ?? this.classCode,
      teacherUid: teacherUid ?? this.teacherUid,
    );
  }
}

// ═══════════════════════════════════════════
// EJERCICIOS
// ═══════════════════════════════════════════

/// Tipo de ejercicio
enum ExerciseType {
  multipleChoice,   // Opción múltiple
  fillInBlank,      // Rellenar hueco
  trueFalse,        // Verdadero / Falso
  ordering,         // Ordenar elementos
  matching,         // Unir parejas
  dragAndDrop,      // Arrastrar y soltar
  freeResponse,     // Respuesta libre
  numericInput,     // Input numérico
}

/// Un ejercicio individual
class Exercise {
  final String id;
  final ExerciseType type;
  final String question;
  final List<String> options;       // Para multipleChoice
  final String correctAnswer;
  final String? explanation;        // Explicación adaptativa
  final String? hint;               // Pista para el alumno
  final int difficulty;             // 1=fácil, 2=medio, 3=difícil
  final List<List<String>>? pairs;  // Para matching [[clave, valor], ...]
  final List<String>? sortItems;    // Para ordering (items desordenados)
  final List<String>? sortAnswer;   // Para ordering (orden correcto)
  final int xpReward;
  final bool isCompleted;
  final bool? wasCorrect;

  const Exercise({
    required this.id,
    required this.type,
    required this.question,
    this.options = const [],
    required this.correctAnswer,
    this.explanation,
    this.hint,
    this.difficulty = 1,
    this.pairs,
    this.sortItems,
    this.sortAnswer,
    this.xpReward = 10,
    this.isCompleted = false,
    this.wasCorrect,
  });

  /// Crea un Exercise a partir del JSON del banco curricular
  factory Exercise.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'multiple_choice';
    final type = _parseType(typeStr);

    // Parsear pares para match
    List<List<String>>? pairs;
    if (json['pairs'] != null) {
      pairs = (json['pairs'] as List).map<List<String>>((p) =>
        (p as List).map<String>((e) => e.toString()).toList()
      ).toList();
    }

    // Parsear items para sort
    List<String>? sortItems;
    List<String>? sortAnswer;
    if (json['items'] != null) {
      sortItems = (json['items'] as List).map<String>((e) => e.toString()).toList();
    }
    if (json['answer'] is List) {
      sortAnswer = (json['answer'] as List).map<String>((e) => e.toString()).toList();
    }

    // Opciones para multiple choice
    List<String> options = [];
    if (json['options'] != null) {
      options = (json['options'] as List).map<String>((e) => e.toString()).toList();
    }

    // Respuesta como String
    String correctAnswer;
    if (json['answer'] is List) {
      correctAnswer = (json['answer'] as List).join(', ');
    } else {
      correctAnswer = json['answer']?.toString() ?? '';
    }

    // XP según dificultad
    final difficulty = json['difficulty'] as int? ?? 1;
    final xp = difficulty == 1 ? 10 : (difficulty == 2 ? 15 : 25);

    return Exercise(
      id: json['id'] as String? ?? '',
      type: type,
      question: json['question'] as String? ?? '',
      options: options,
      correctAnswer: correctAnswer,
      explanation: json['explanation'] as String?,
      hint: json['hint'] as String?,
      difficulty: difficulty,
      pairs: pairs,
      sortItems: sortItems,
      sortAnswer: sortAnswer,
      xpReward: xp,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': _typeToString(type),
    'question': question,
    'options': options,
    'answer': correctAnswer,
    'explanation': explanation,
    'hint': hint,
    'difficulty': difficulty,
    if (pairs != null) 'pairs': pairs,
    if (sortItems != null) 'items': sortItems,
    if (sortAnswer != null) 'sortAnswer': sortAnswer,
  };

  /// Convierte el string del JSON al enum ExerciseType
  static ExerciseType _parseType(String type) {
    switch (type) {
      case 'multiple_choice': return ExerciseType.multipleChoice;
      case 'fill_blank':      return ExerciseType.fillInBlank;
      case 'true_false':      return ExerciseType.trueFalse;
      case 'sort':            return ExerciseType.ordering;
      case 'match':           return ExerciseType.matching;
      case 'drag_drop':       return ExerciseType.dragAndDrop;
      case 'open_problem':    return ExerciseType.freeResponse;
      case 'numeric':         return ExerciseType.numericInput;
      default:                return ExerciseType.multipleChoice;
    }
  }

  static String _typeToString(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoice: return 'multiple_choice';
      case ExerciseType.fillInBlank:    return 'fill_blank';
      case ExerciseType.trueFalse:      return 'true_false';
      case ExerciseType.ordering:       return 'sort';
      case ExerciseType.matching:       return 'match';
      case ExerciseType.dragAndDrop:    return 'drag_drop';
      case ExerciseType.freeResponse:   return 'open_problem';
      case ExerciseType.numericInput:   return 'numeric';
    }
  }

  Exercise copyWith({
    bool? isCompleted,
    bool? wasCorrect,
    String? explanation,
  }) {
    return Exercise(
      id: id,
      type: type,
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation ?? this.explanation,
      hint: hint,
      difficulty: difficulty,
      pairs: pairs,
      sortItems: sortItems,
      sortAnswer: sortAnswer,
      xpReward: xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      wasCorrect: wasCorrect ?? this.wasCorrect,
    );
  }
}

// ═══════════════════════════════════════════
// CAPÍTULOS Y VIÑETAS
// ═══════════════════════════════════════════

/// Una viñeta narrativa (panel de la historia)
class StoryPanel {
  final String id;
  final String text;
  final String? backgroundTheme; // 'numbers', 'nature', 'time'...
  final bool isUnlocked;

  const StoryPanel({
    required this.id,
    required this.text,
    this.backgroundTheme,
    this.isUnlocked = false,
  });
}

/// Tipo de capítulo
enum ChapterType {
  normal,           // Capítulo estándar
  gatePuzzle,       // Prueba-puerta 🚪
  miniBoss,         // Mini-boss (examen por reino) ⚔️
  trimesterBoss,    // Boss trimestral 🏰
  finalBoss,        // Boss final: Noctus 💀
}

/// Un capítulo completo (nodo del mapa)
class Chapter {
  final String id;
  final String title;
  final Kingdom kingdom;            // A qué reino pertenece
  final int trimester;              // 1, 2 o 3
  final int orderInKingdom;         // Posición dentro del reino (1-12)
  final String subject;             // 'mates', 'lengua', 'ciencias', 'ingles'
  final String topic;               // 'sumas_sin_llevada', 'verbos_presente'...
  final List<StoryPanel> panels;
  final List<Exercise> exercises;
  final ChapterType type;
  final bool isCompleted;
  final bool isUnlocked;
  final int totalXP;

  const Chapter({
    required this.id,
    required this.title,
    required this.kingdom,
    required this.trimester,
    this.orderInKingdom = 1,
    required this.subject,
    required this.topic,
    this.panels = const [],
    this.exercises = const [],
    this.type = ChapterType.normal,
    this.isCompleted = false,
    this.isUnlocked = false,
    this.totalXP = 50,
  });

  /// Progreso (ejercicios completados / total)
  double get progress {
    if (exercises.isEmpty) return 0;
    return exercises.where((e) => e.isCompleted).length / exercises.length;
  }

  int get exercisesCompleted =>
      exercises.where((e) => e.isCompleted).length;

  int get exercisesCorrect =>
      exercises.where((e) => e.wasCorrect == true).length;

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      kingdom: _parseKingdom(json['kingdom'] as String? ?? 'ignis'),
      trimester: json['trimester'] as int? ?? 1,
      orderInKingdom: json['order'] as int? ?? 1,
      subject: json['subject'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      type: _parseChapterType(json['type'] as String? ?? 'normal'),
      totalXP: json['totalXP'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'kingdom': kingdom.name,
    'trimester': trimester,
    'order': orderInKingdom,
    'subject': subject,
    'topic': topic,
    'type': type.name,
    'totalXP': totalXP,
  };

  static Kingdom _parseKingdom(String value) {
    switch (value) {
      case 'ignis': return Kingdom.ignis;
      case 'lexis': return Kingdom.lexis;
      case 'sylva': return Kingdom.sylva;
      case 'babel': return Kingdom.babel;
      default: return Kingdom.ignis;
    }
  }

  static ChapterType _parseChapterType(String value) {
    switch (value) {
      case 'normal':        return ChapterType.normal;
      case 'gatePuzzle':    return ChapterType.gatePuzzle;
      case 'miniBoss':      return ChapterType.miniBoss;
      case 'trimesterBoss': return ChapterType.trimesterBoss;
      case 'finalBoss':     return ChapterType.finalBoss;
      default:              return ChapterType.normal;
    }
  }
}

// ═══════════════════════════════════════════
// PROGRESO POR CAPÍTULO
// ═══════════════════════════════════════════

/// Progreso del alumno en un capítulo específico
class ChapterProgress {
  final String chapterId;
  final Kingdom kingdom;
  final int stars;              // 0-3 estrellas
  final int attempts;           // Veces que ha jugado
  final int totalExercises;
  final int correctAnswers;
  final int wrongAnswers;
  final int xpEarned;
  final Duration timeSpent;
  final DateTime? completedAt;
  final bool challengeCompleted; // ⭐ Desafío extra

  const ChapterProgress({
    required this.chapterId,
    required this.kingdom,
    this.stars = 0,
    this.attempts = 0,
    this.totalExercises = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.xpEarned = 0,
    this.timeSpent = Duration.zero,
    this.completedAt,
    this.challengeCompleted = false,
  });

  /// Calcular estrellas: ⭐ completar + ⭐ sin fallos + ⭐ desafío extra
  int get calculatedStars {
    int s = 0;
    if (correctAnswers + wrongAnswers >= totalExercises) s++; // Completado
    if (wrongAnswers == 0 && totalExercises > 0) s++;          // Sin fallos
    if (challengeCompleted) s++;                                // Desafío extra
    return s;
  }

  factory ChapterProgress.fromJson(Map<String, dynamic> json) {
    return ChapterProgress(
      chapterId: json['chapterId'] as String? ?? '',
      kingdom: Chapter._parseKingdom(json['kingdom'] as String? ?? 'ignis'),
      stars: json['stars'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
      totalExercises: json['totalExercises'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      wrongAnswers: json['wrongAnswers'] as int? ?? 0,
      xpEarned: json['xpEarned'] as int? ?? 0,
      timeSpent: Duration(seconds: json['timeSpentSeconds'] as int? ?? 0),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
      challengeCompleted: json['challengeCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'chapterId': chapterId,
    'kingdom': kingdom.name,
    'stars': stars,
    'attempts': attempts,
    'totalExercises': totalExercises,
    'correctAnswers': correctAnswers,
    'wrongAnswers': wrongAnswers,
    'xpEarned': xpEarned,
    'timeSpentSeconds': timeSpent.inSeconds,
    'completedAt': completedAt?.toIso8601String(),
    'challengeCompleted': challengeCompleted,
  };
}

// ═══════════════════════════════════════════
// LOGROS (ACHIEVEMENTS)
// ═══════════════════════════════════════════

/// Categoría de logro
enum AchievementCategory {
  primerosPasos,   // 🔥 Primeros pasos
  maestria,        // ⭐ Maestría
  conocimiento,    // 📚 Conocimiento
  constancia,      // 💪 Constancia
  combate,         // ⚔️ Combate
  archimago,       // 🧙 Archimago (solo con profe)
  secretos,        // 🌟 Secretos
}

/// Un logro desbloqueado o por desbloquear
class Achievement {
  final String id;
  final String name;
  final AchievementCategory category;
  final String description;         // "Completar el primer capítulo"
  final String orionReaction;       // "¡Has dado tu primer paso!"
  final String reward;              // "Icono de perfil: estrella"
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.orionReaction,
    required this.reward,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: _parseCategory(json['category'] as String? ?? 'primerosPasos'),
      description: json['description'] as String? ?? '',
      orionReaction: json['orionReaction'] as String? ?? '',
      reward: json['reward'] as String? ?? '',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.name,
    'description': description,
    'orionReaction': orionReaction,
    'reward': reward,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

  static AchievementCategory _parseCategory(String value) {
    switch (value) {
      case 'primerosPasos': return AchievementCategory.primerosPasos;
      case 'maestria':      return AchievementCategory.maestria;
      case 'conocimiento':  return AchievementCategory.conocimiento;
      case 'constancia':    return AchievementCategory.constancia;
      case 'combate':       return AchievementCategory.combate;
      case 'archimago':     return AchievementCategory.archimago;
      case 'secretos':      return AchievementCategory.secretos;
      default:              return AchievementCategory.primerosPasos;
    }
  }

  Achievement copyWith({bool? isUnlocked, DateTime? unlockedAt}) {
    return Achievement(
      id: id,
      name: name,
      category: category,
      description: description,
      orionReaction: orionReaction,
      reward: reward,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

// ═══════════════════════════════════════════
// WORLD MAP
// ═══════════════════════════════════════════

/// Un nodo en el World Map
class MapNode {
  final String id;
  final String chapterId;
  final Kingdom kingdom;
  final double x;               // Posición X (0.0 a 1.0)
  final double y;               // Posición Y (0.0 a 1.0)
  final MapNodeStatus status;
  final ChapterType type;
  final String label;           // Título corto
  final String emoji;           // Emoji del nodo

  const MapNode({
    required this.id,
    required this.chapterId,
    required this.kingdom,
    required this.x,
    required this.y,
    this.status = MapNodeStatus.locked,
    this.type = ChapterType.normal,
    this.label = '',
    this.emoji = '●',
  });
}

/// Estado de un nodo
enum MapNodeStatus {
  locked,       // 🔒 Gris, bloqueado
  current,      // 💙 Azul, pulsando
  completed,    // ✅ Verde, hecho
}

/// Conexión entre dos nodos (camino)
class MapPath {
  final String fromNodeId;
  final String toNodeId;
  final bool isCompleted;
  final MapPathBranch branch;   // ¿Es camino A o B (bifurcación)?

  const MapPath({
    required this.fromNodeId,
    required this.toNodeId,
    this.isCompleted = false,
    this.branch = MapPathBranch.main,
  });
}

/// Tipo de rama del camino
enum MapPathBranch {
  main,     // Camino principal
  branchA,  // Bifurcación A (acierto)
  branchB,  // Bifurcación B (fallo)
}

/// Zona del mapa (agrupa capítulos de un reino)
class MapZone {
  final String id;
  final String name;
  final Kingdom kingdom;
  final String subject;
  final List<MapNode> nodes;
  final List<MapPath> paths;

  const MapZone({
    required this.id,
    required this.name,
    required this.kingdom,
    required this.subject,
    this.nodes = const [],
    this.paths = const [],
  });
}
