import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../theme/arcana_game_theme.dart';
import '../widgets/arcana_dual_score_bar.dart';
import '../widgets/magical_particles.dart';
import '../widgets/arcana_buttons.dart';


// ─────────────────────────────────────────────
// MODELO DE ENEMIGO (público para acceso desde map_screen)
// ─────────────────────────────────────────────
class BattleEnemy {
  final String name;
  final String emoji;
  final Color color;
  final String power;
  final String? imagePath;
  /// ID de la sección del currículum que cubre este enemigo (1-indexed)
  final int sectionIndex;

  const BattleEnemy({
    required this.name,
    required this.emoji,
    required this.color,
    required this.power,
    this.imagePath,
    this.sectionIndex = 0,
  });

  /// Widget que muestra la imagen del enemigo (imagen real o emoji)
  Widget buildSprite({double size = 44}) {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: size, height: size, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Text(emoji, style: TextStyle(fontSize: size)),
      );
    }
    return Text(emoji, style: TextStyle(fontSize: size));
  }
}

const List<BattleEnemy> allBattleEnemies = [
  // Cada enemigo mapea a una sección del currículum (sectionIndex 0-based)
  BattleEnemy(name: 'Murcigloom', emoji: '🦇', color: Color(0xFF7C3AED), power: 'Sombras', sectionIndex: 0),    // Sin llevada
  BattleEnemy(name: 'Serpentix', emoji: '🐍', color: Color(0xFF065F46), power: 'Veneno', sectionIndex: 1),      // Con llevada 2 cifras
  BattleEnemy(name: 'Aragnox', emoji: '🕷️', color: Color(0xFF991B1B), power: 'Telaraña', sectionIndex: 2),     // Con llevada 3 cifras
  BattleEnemy(name: 'Fantasmor', emoji: '👻', color: Color(0xFF64748B), power: 'Hielo', sectionIndex: 3),       // Prueba de la resta
  BattleEnemy(name: 'Lobocuro', emoji: '🐺', color: Color(0xFF475569), power: 'Aullido', sectionIndex: 4),      // Relación suma↔resta
  BattleEnemy(name: 'Incendius', emoji: '🔥', color: Color(0xFFEA580C), power: 'Fuego', sectionIndex: 5),       // Problemas
  BattleEnemy(name: 'Escorpius', emoji: '🦂', color: Color(0xFF7E22CE), power: 'Cadenas', sectionIndex: 6),     // Restas encadenadas
];

/// Clave de SharedPreferences para enemigos derrotados
const String _defeatedKey = 'restas_defeated_enemies';
const String _victoriesKey = 'restas_enemy_victories';

/// Obtener la lista de nombres de enemigos derrotados
Future<Set<String>> getDefeatedEnemies() async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(_defeatedKey) ?? [];
  return list.toSet();
}

/// Obtener el mapa de victorias por enemigo
Future<Map<String, int>> getEnemyVictories() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList(_victoriesKey) ?? [];
  final map = <String, int>{};
  for (final entry in data) {
    final parts = entry.split(':');
    if (parts.length == 2) {
      map[parts[0]] = int.tryParse(parts[1]) ?? 0;
    }
  }
  return map;
}

/// Guardar un enemigo como derrotado e incrementar contador
Future<void> _saveDefeatedEnemy(String name) async {
  final prefs = await SharedPreferences.getInstance();
  // Mantener compatibilidad con set
  final list = prefs.getStringList(_defeatedKey) ?? [];
  if (!list.contains(name)) {
    list.add(name);
    await prefs.setStringList(_defeatedKey, list);
  }
  // Incrementar conteo de victorias
  final victories = await getEnemyVictories();
  victories[name] = (victories[name] ?? 0) + 1;
  final encoded = victories.entries.map((e) => '${e.key}:${e.value}').toList();
  await prefs.setStringList(_victoriesKey, encoded);
}

// ─────────────────────────────────────────────
// MODELO DE EJERCICIO PARA EL COMBATE
// ─────────────────────────────────────────────
class _BattleExercise {
  final String question;
  final String type;
  final List<String>? options;
  final String answer;
  final String? hint;
  final int? minuendo;
  final int? sustraendo;
  final int? resultadoPropuesto;
  /// Nivel de dificultad 1-7 (sección del currículum)
  final int difficulty;

  const _BattleExercise({
    required this.question,
    required this.type,
    this.options,
    required this.answer,
    this.hint,
    this.minuendo,
    this.sustraendo,
    this.resultadoPropuesto,
    this.difficulty = 1,
  });
}

/// Intenta parsear dos números de una pregunta tipo "¿Cuánto es 89 − 34?"
/// o "Completa: 78 − 26 = ___"
(int?, int?) _parseSubtractionNumbers(String question) {
  final regex = RegExp(r'(\d+)\s*[−\-–]\s*(\d+)');
  final match = regex.firstMatch(question);
  if (match != null) {
    return (int.tryParse(match.group(1)!), int.tryParse(match.group(2)!));
  }
  return (null, null);
}

/// Parsea el resultado propuesto en preguntas V/F: "74 − 39 = 35 es correcta"
int? _parseProposedResult(String question) {
  // Patrón: = NÚMERO (antes de "es correcta" o similar)
  final regex = RegExp(r'=\s*(\d+)');
  final match = regex.firstMatch(question);
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }
  return null;
}

// ─────────────────────────────────────────────
// PANTALLA PRINCIPAL — Orquesta VS → Combate → Resultado
// ─────────────────────────────────────────────
class RestasBattleScreen extends StatefulWidget {
  const RestasBattleScreen({super.key});

  @override
  State<RestasBattleScreen> createState() => _RestasBattleScreenState();
}

class _RestasBattleScreenState extends State<RestasBattleScreen> {
  final _random = math.Random();
  late List<BattleEnemy> _roundEnemies;
  List<_BattleExercise> _allExercises = [];
  bool _loading = true;
  Set<String> _defeatedNames = {};

  int _currentRound = 0;
  String _phase = 'story_intro';
  bool _lastRoundWon = false;
  int _totalRounds = 3; // Se ajusta según enemigos disponibles

  int _playerScore = 0;
  int _enemyScore = 0;
  int _currentExerciseIndex = 0;
  late List<_BattleExercise> _roundExercises;
  // Dificultad adaptativa
  int _currentDifficulty = 1;
  int _consecutiveErrors = 0;

  @override
  void initState() {
    super.initState();
    _initBattle();
  }

  Future<void> _initBattle() async {
    _defeatedNames = await getDefeatedEnemies();
    _pickEnemies();
    _loadExercises();
  }

  void _pickEnemies() {
    // Siempre permitir combatir con todos los enemigos (se pueden repetir)
    final all = allBattleEnemies.toList();
    all.shuffle(_random);
    _totalRounds = math.min(3, all.length);
    _roundEnemies = all.take(_totalRounds).toList();
  }

  Future<void> _loadExercises() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/curriculum/2_primaria/restas_completo.json',
      );
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final sections = data['sections'] as List;
      final exercises = <_BattleExercise>[];

      // Asignar dificultad 1-7 según índice de sección
      for (int secIdx = 0; secIdx < sections.length; secIdx++) {
        final section = sections[secIdx];
        final diffLevel = secIdx + 1; // 1 a 7
        for (final ex in section['exercises'] as List) {
          final type = ex['type'] as String;
          List<String>? options;
          String answer;
          final question = ex['question'] as String;
          var (m, s) = _parseSubtractionNumbers(question);

          if (type == 'multiple_choice') {
            options = List<String>.from(ex['options']);
            answer = ex['answer'] as String;
          } else if (type == 'true_false') {
            options = ['Verdadero', 'Falso'];
            answer = (ex['answer'] == true) ? 'Verdadero' : 'Falso';
          } else {
            answer = ex['answer'].toString();
          }

          // Validar que m − s == answer (evitar vertical engañoso
          // en encadenadas, relación suma↔resta, y problemas)
          if (m != null && s != null && type != 'true_false') {
            final numAnswer = int.tryParse(answer);
            if (numAnswer == null || (m - s) != numAnswer) {
              m = null;
              s = null;
            }
          }

          final rp = type == 'true_false' ? _parseProposedResult(question) : null;

          exercises.add(_BattleExercise(
            question: question,
            type: type,
            options: options,
            answer: answer,
            hint: ex['hint'] as String?,
            minuendo: m,
            sustraendo: s,
            resultadoPropuesto: rp,
            difficulty: diffLevel,
          ));
        }
      }

      setState(() {
        _allExercises = exercises;
        _loading = false;
        _prepareRound();
      });
    } catch (e) {
      debugPrint('Error cargando ejercicios: $e');
    }
  }

  /// Banda de dificultad máxima según el enemigo actual.
  /// Enemigo 0 (fácil) → max 2, Enemigo 5 (difícil) → max 7
  int _maxDifficultyForCurrentEnemy() {
    final enemyName = _roundEnemies[_currentRound].name;
    final globalIdx = allBattleEnemies.indexWhere((e) => e.name == enemyName);
    return math.min(7, globalIdx + 2);
  }

  /// Suelo mínimo de dificultad: nunca bajar más de 1 nivel
  /// desde la dificultad base del enemigo.
  int _minDifficultyForCurrentEnemy() {
    final maxDiff = _maxDifficultyForCurrentEnemy();
    // Base = punto medio de la banda; suelo = base - 1
    final baseDiff = math.max(1, (maxDiff ~/ 2));
    return math.max(1, baseDiff - 1);
  }

  void _prepareRound() {
    final maxDiff = _maxDifficultyForCurrentEnemy();
    _currentDifficulty = math.max(1, (maxDiff ~/ 2));
    _consecutiveErrors = 0;
    // Seleccionar ejercicios dentro de la banda
    final pool = _allExercises.where((e) => e.difficulty <= maxDiff).toList();
    pool.shuffle(_random);
    _roundExercises = pool.take(15).toList();
    _playerScore = 0;
    _enemyScore = 0;
    _currentExerciseIndex = 0;
  }

  void _startCombat() {
    setState(() => _phase = 'combat');
  }

  void _onExerciseFinished(bool correct) {
    setState(() {
      if (correct) {
        _playerScore++;
        _consecutiveErrors = 0;
        // Subir dificultad gradualmente
        _currentDifficulty = math.min(
          _maxDifficultyForCurrentEnemy(),
          _currentDifficulty + 1,
        );
      } else {
        _enemyScore++;
        _consecutiveErrors++;
        // Bajada suave: solo tras 3+ errores seguidos, y nunca por debajo del suelo
        final floor = _minDifficultyForCurrentEnemy();
        if (_consecutiveErrors >= 3) {
          _currentDifficulty = math.max(floor, _currentDifficulty - 1);
        }
        // Inyectar ejercicio un poco más fácil a continuación
        _injectEasierExercise();
      }

      if (_playerScore >= 7 || _enemyScore >= 7) {
        _lastRoundWon = _playerScore >= 7;
        if (_lastRoundWon) {
          _saveDefeatedEnemy(_roundEnemies[_currentRound].name);
          _defeatedNames.add(_roundEnemies[_currentRound].name);
        }
        _phase = _lastRoundWon && _currentRound < _totalRounds - 1
            ? 'round_result'
            : 'final_result';
        if (!_lastRoundWon) _phase = 'final_result';
        return;
      }

      _currentExerciseIndex++;

      if (_currentExerciseIndex >= _roundExercises.length) {
        _lastRoundWon = _playerScore > _enemyScore;
        if (_lastRoundWon) {
          _saveDefeatedEnemy(_roundEnemies[_currentRound].name);
          _defeatedNames.add(_roundEnemies[_currentRound].name);
        }
        if (_lastRoundWon && _currentRound < _totalRounds - 1) {
          _phase = 'round_result';
        } else {
          _phase = 'final_result';
        }
      }
    });
  }

  /// Inyecta un ejercicio de dificultad reducida en la siguiente posición
  void _injectEasierExercise() {
    final easierPool = _allExercises
        .where((e) => e.difficulty <= _currentDifficulty)
        .toList();
    if (easierPool.isEmpty) return;
    easierPool.shuffle(_random);
    final nextIdx = _currentExerciseIndex + 1;
    if (nextIdx < _roundExercises.length) {
      _roundExercises[nextIdx] = easierPool.first;
    } else {
      _roundExercises.add(easierPool.first);
    }
  }

  void _nextRound() {
    setState(() {
      _currentRound++;
      _prepareRound();
      _phase = 'vs';
    });
  }

  void _restartBattle() {
    setState(() {
      _currentRound = 0;
      _pickEnemies();
      if (_phase != 'all_defeated') {
        _prepareRound();
        _phase = 'story_intro';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: ArcanaColors.background,
        body: Center(
          child: CircularProgressIndicator(color: ArcanaColors.gold),
        ),
      );
    }

    switch (_phase) {
      case 'story_intro':
        return _StoryIntroScreen(
          onStart: () {
            setState(() {
              _prepareRound();
              _phase = 'vs';
            });
          },
          onBack: () => Navigator.of(context).pop(),
        );
      case 'all_defeated':
        return _AllDefeatedScreen(
          onExit: () => Navigator.of(context).pop(),
        );
      case 'vs':
        return _VSScreen(
          enemy: _roundEnemies[_currentRound],
          round: _currentRound + 1,
          totalRounds: _totalRounds,
          onStart: _startCombat,
          onBack: () => Navigator.of(context).pop(),
        );
      case 'combat':
        return _CombatScreen(
          key: ValueKey('combat_${_currentRound}_$_currentExerciseIndex'),
          enemy: _roundEnemies[_currentRound],
          round: _currentRound + 1,
          totalRounds: _totalRounds,
          exercise: _roundExercises[_currentExerciseIndex],
          exerciseNumber: _currentExerciseIndex + 1,
          totalExercises: _roundExercises.length,
          playerScore: _playerScore,
          enemyScore: _enemyScore,
          onFinished: _onExerciseFinished,
        );
      case 'round_result':
        return _RoundResultScreen(
          enemy: _roundEnemies[_currentRound],
          won: _lastRoundWon,
          playerScore: _playerScore,
          enemyScore: _enemyScore,
          round: _currentRound + 1,
          totalRounds: _totalRounds,
          onNext: _nextRound,
        );
      case 'final_result':
        return _FinalResultScreen(
          won: _lastRoundWon && _currentRound == _totalRounds - 1,
          roundsWon: _lastRoundWon ? _currentRound + 1 : _currentRound,
          totalRounds: _totalRounds,
          onRestart: _restartBattle,
          onExit: () => Navigator.of(context).pop(),
        );
      default:
        return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────
// PANTALLA VS — Estilo Street Fighter
// ─────────────────────────────────────────────
class _VSScreen extends StatefulWidget {
  final BattleEnemy enemy;
  final int round;
  final int totalRounds;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const _VSScreen({
    required this.enemy,
    required this.round,
    required this.totalRounds,
    required this.onStart,
    required this.onBack,
  });

  @override
  State<_VSScreen> createState() => _VSScreenState();
}

class _VSScreenState extends State<_VSScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _vsFlashController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _vsFlashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entryController.dispose();
    _vsFlashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slideLeft = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    final slideRight = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    final vsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    final buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ArcanaColors.turquoise.withValues(alpha: 0.15),
                        const Color(0xFF0A0510),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        widget.enemy.color.withValues(alpha: 0.2),
                        const Color(0xFF0A0510),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          CustomPaint(
            painter: _DiagonalLinePainter(
              color: ArcanaColors.gold.withValues(alpha: 0.3),
            ),
          ),

          MagicalParticles(
            particleCount: 20,
            color: ArcanaColors.gold,
            maxSize: 2.0,
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ArcanaColors.surfaceBorder,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: ArcanaColors.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ArcanaColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'RONDA ${widget.round}/3',
                          style: ArcanaTextStyles.cardTitle.copyWith(
                            color: ArcanaColors.gold,
                            fontSize: 13,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: SlideTransition(
                          position: slideLeft,
                          child: Column(
                            children: [
                              const Text('🧙‍♂️', style: TextStyle(fontSize: 80)),
                              const SizedBox(height: 8),
                              Text(
                                'APRENDIZ',
                                style: ArcanaTextStyles.cardTitle.copyWith(
                                  color: ArcanaColors.turquoise,
                                  letterSpacing: 2,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Magia de números',
                                style: ArcanaTextStyles.caption.copyWith(
                                  color: ArcanaColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      FadeTransition(
                        opacity: vsFade,
                        child: AnimatedBuilder(
                          animation: _vsFlashController,
                          builder: (context, child) {
                            return Text(
                              'VS',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: Color.lerp(
                                  ArcanaColors.gold,
                                  ArcanaColors.ruby,
                                  _vsFlashController.value,
                                ),
                                letterSpacing: 8,
                                shadows: [
                                  Shadow(
                                    color: ArcanaColors.gold.withValues(alpha: 0.6),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      Expanded(
                        child: SlideTransition(
                          position: slideRight,
                          child: Column(
                            children: [
                              Text(widget.enemy.emoji, style: const TextStyle(fontSize: 80)),
                              const SizedBox(height: 8),
                              Text(
                                widget.enemy.name.toUpperCase(),
                                style: ArcanaTextStyles.cardTitle.copyWith(
                                  color: widget.enemy.color,
                                  letterSpacing: 2,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.enemy.power,
                                style: ArcanaTextStyles.caption.copyWith(
                                  color: ArcanaColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                FadeTransition(
                  opacity: buttonFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: ArcanaGoldButton(
                      text: '¡LUCHAR!',
                      icon: Icons.flash_on,
                      width: 280,
                      onPressed: widget.onStart,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalLinePainter extends CustomPainter {
  final Color color;
  _DiagonalLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width / 2 - 40, 0),
      Offset(size.width / 2 + 40, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// PAINTER PARA EL RAYO MÁGICO
// ─────────────────────────────────────────────
class _MagicRayPainter extends CustomPainter {
  final double progress; // 0..1
  final bool leftToRight; // true = jugador→enemigo, false = enemigo→jugador
  final Color color;

  _MagicRayPainter({
    required this.progress,
    required this.leftToRight,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final startX = leftToRight ? 60.0 : size.width - 60;
    final endX = leftToRight ? size.width - 60 : 60.0;
    final centerY = size.height / 2;

    final currentX = startX + (endX - startX) * progress.clamp(0.0, 1.0);

    // Rayo principal — línea con glow
    final rayPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color,
          color.withValues(alpha: 0.9),
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTRB(
        math.min(startX, currentX),
        centerY - 3,
        math.max(startX, currentX),
        centerY + 3,
      ))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawLine(
      Offset(startX, centerY),
      Offset(currentX, centerY),
      rayPaint,
    );

    // Glow exterior
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3 * progress)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawLine(
      Offset(startX, centerY),
      Offset(currentX, centerY),
      glowPaint,
    );

    // Partículas de impacto al final del rayo
    if (progress > 0.7) {
      final impactProgress = ((progress - 0.7) / 0.3).clamp(0.0, 1.0);
      final rng = math.Random(42);
      for (int i = 0; i < 12; i++) {
        final angle = rng.nextDouble() * math.pi * 2;
        final dist = impactProgress * 30 * rng.nextDouble();
        final px = currentX + math.cos(angle) * dist;
        final py = centerY + math.sin(angle) * dist;
        final radius = (1 - impactProgress) * 3 * rng.nextDouble() + 1;
        canvas.drawCircle(
          Offset(px, py),
          radius,
          Paint()
            ..color = color.withValues(alpha: (1 - impactProgress) * 0.8)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }

    // Punto brillante en la punta del rayo
    canvas.drawCircle(
      Offset(currentX, centerY),
      6 * progress,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      Offset(currentX, centerY),
      3 * progress,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _MagicRayPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ─────────────────────────────────────────────
// PANTALLA DE COMBATE — Con resta vertical, rayos, cards centradas
// ─────────────────────────────────────────────
class _CombatScreen extends StatefulWidget {
  final BattleEnemy enemy;
  final int round;
  final int totalRounds;
  final _BattleExercise exercise;
  final int exerciseNumber;
  final int totalExercises;
  final int playerScore;
  final int enemyScore;
  final void Function(bool correct) onFinished;
  final int? timerSeconds; // Timer opcional para el boss

  const _CombatScreen({
    super.key,
    required this.enemy,
    required this.round,
    required this.totalRounds,
    required this.exercise,
    required this.exerciseNumber,
    required this.totalExercises,
    required this.playerScore,
    required this.enemyScore,
    required this.onFinished,
    this.timerSeconds,
  });

  @override
  State<_CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<_CombatScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _playerShakeController;
  late AnimationController _rayController;
  AnimationController? _timerController;

  bool _answered = false;
  bool _isCorrect = false;
  int? _selectedOption;

  // Para fill_blank
  List<TextEditingController> _digitControllers = [];
  List<FocusNode> _digitFocusNodes = [];
  int _expectedDigits = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _playerShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Timer opcional (para boss)
    if (widget.timerSeconds != null) {
      _timerController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.timerSeconds!),
      );
      _timerController!.addListener(() {
        if (_timerController!.isCompleted && !_answered) {
          _submitAnswer('__TIMEOUT__'); // forzar fallo
        }
        if (mounted) setState(() {});
      });
      _timerController!.forward();
    }

    if (widget.exercise.type == 'fill_blank') {
      _initDigitBoxes();
    }
  }

  void _initDigitBoxes() {
    _expectedDigits = widget.exercise.answer.length;
    _digitControllers = List.generate(
      _expectedDigits,
      (_) => TextEditingController(),
    );
    _digitFocusNodes = List.generate(
      _expectedDigits,
      (_) => FocusNode(),
    );
    for (final c in _digitControllers) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_digitFocusNodes.isNotEmpty && mounted) {
        _digitFocusNodes.last.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _playerShakeController.dispose();
    _rayController.dispose();
    _timerController?.dispose();
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final f in _digitFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _getDigitAnswer() {
    return _digitControllers.map((c) => c.text).join();
  }

  void _submitAnswer(String answer) {
    if (_answered) return;
    _timerController?.stop();

    final correct = answer.trim().toLowerCase() ==
        widget.exercise.answer.trim().toLowerCase();

    setState(() {
      _answered = true;
      _isCorrect = correct;
    });

    // Lanzar rayo mágico
    _rayController.forward(from: 0);

    // Sacudir al objetivo tras el rayo
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (correct) {
        _shakeController.forward(from: 0);
      } else {
        _playerShakeController.forward(from: 0);
      }
    });

    // Avanzar tras pausa
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        widget.onFinished(correct);
      }
    });
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() => _selectedOption = index);
    final options = widget.exercise.options!;
    _submitAnswer(options[index]);
  }

  void _submitFillBlank() {
    final answer = _getDigitAnswer();
    if (answer.isEmpty) return;
    _submitAnswer(answer);
  }

  /// ¿Puede mostrar la resta en vertical?
  bool get _canShowVertical =>
      widget.exercise.minuendo != null && widget.exercise.sustraendo != null;

  int get _remainingSeconds {
    if (_timerController == null || widget.timerSeconds == null) return 0;
    return (widget.timerSeconds! * (1 - _timerController!.value)).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.playerScore + widget.enemyScore;
    final maxPossible = widget.totalExercises;
    final barRatio = total == 0
        ? 0.5
        : widget.playerScore / maxPossible +
            (maxPossible - total) / (2 * maxPossible);
    final isLowTime = _timerController != null && _remainingSeconds <= 5;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  widget.enemy.color.withValues(alpha: 0.1),
                  const Color(0xFF0A0510),
                ],
              ),
            ),
          ),

          MagicalParticles(
            particleCount: 15,
            color: widget.enemy.color,
            maxSize: 2.0,
          ),

          SafeArea(
            child: Column(
              children: [
                // ─── Header ─────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          // Timer (solo si es boss)
                          if (_timerController != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLowTime
                                    ? const Color(0xFFFF1744).withValues(alpha: 0.2)
                                    : ArcanaColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isLowTime
                                      ? const Color(0xFFFF1744)
                                      : ArcanaColors.gold.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.timer, size: 14,
                                    color: isLowTime ? const Color(0xFFFF1744) : ArcanaColors.gold),
                                  const SizedBox(width: 4),
                                  Text('${_remainingSeconds}s',
                                    style: ArcanaTextStyles.cardTitle.copyWith(
                                      color: isLowTime ? const Color(0xFFFF1744) : ArcanaColors.gold,
                                      fontSize: 16, fontFamily: 'monospace',
                                    )),
                                ],
                              ),
                            )
                          else
                            Text(
                              'Ronda ${widget.round}/${widget.totalRounds}',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: ArcanaColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Pregunta ${widget.exerciseNumber}/${widget.totalExercises}',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: ArcanaColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Barra de timer (solo boss)
                if (_timerController != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (1 - _timerController!.value).clamp(0.0, 1.0),
                        backgroundColor: ArcanaColors.surface,
                        valueColor: AlwaysStoppedAnimation(
                          isLowTime ? const Color(0xFFFF1744) : ArcanaColors.emerald,
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ),

                const SizedBox(height: 6),

                // ─── Barra dual ─────────────────────
                _buildBattleBar(barRatio),

                const SizedBox(height: 6),

                // ─── Luchadores + rayo mágico ───────
                _buildFightersWithRay(),

                const SizedBox(height: 8),

                // ─── Pregunta + opciones ─────────────
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQuestion(),
                          const SizedBox(height: 14),
                          if (widget.exercise.type == 'fill_blank')
                            _buildFillBlank()
                          else
                            _buildOptions(),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Marcador inferior ──────────────
                _buildScoreboard(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Barra dual (nuevo design system) ─────
  Widget _buildBattleBar(double ratio) {
    return ArcanaDualScoreBar(
      playerScore: widget.playerScore,
      enemyScore: widget.enemyScore,
      totalExercises: widget.totalExercises,
      round: widget.round,
      totalRounds: widget.totalRounds,
      enemyName: widget.enemy.name,
      enemyColor: widget.enemy.color,
    );
  }

  // ─── Luchadores con rayo mágico entre ellos ─────
  Widget _buildFightersWithRay() {
    final isBoss = widget.enemy.imagePath != null;
    final spriteSize = isBoss ? 110.0 : 44.0;
    return SizedBox(
      height: isBoss ? 150 : 90,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _shakeController,
          _playerShakeController,
          _rayController,
        ]),
        builder: (context, child) {
          final enemyShake = math.sin(_shakeController.value * math.pi * 6) *
              (1 - _shakeController.value) * 12;
          final playerShake =
              math.sin(_playerShakeController.value * math.pi * 6) *
                  (1 - _playerShakeController.value) * 12;

          return Stack(
            children: [
              // Rayo mágico (fondo, entre luchadores)
              if (_answered)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MagicRayPainter(
                      progress: _rayController.value,
                      leftToRight: _isCorrect, // correcto = jugador→enemigo
                      color: _isCorrect
                          ? ArcanaColors.turquoise
                          : widget.enemy.color,
                    ),
                  ),
                ),

              // Luchadores sobre el rayo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Aprendiz
                    Transform.translate(
                      offset: Offset(playerShake, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: _answered && !_isCorrect ? 0.8 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: const Text('🧙‍♂️',
                                style: TextStyle(fontSize: 44)),
                          ),
                          if (_answered)
                            Text(
                              _isCorrect ? '💥 ¡Ataque!' : '😵 ¡Ouch!',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _isCorrect
                                    ? ArcanaColors.emerald
                                    : ArcanaColors.ruby,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Enemigo
                    Transform.translate(
                      offset: Offset(enemyShake, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: _answered && _isCorrect ? 0.8 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: widget.enemy.buildSprite(size: spriteSize),
                          ),
                          if (_answered)
                            Text(
                              _isCorrect ? '😵 ¡Aaagh!' : '😈 Ja ja',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _isCorrect
                                    ? ArcanaColors.emerald
                                    : widget.enemy.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Pregunta: vertical si es resta, texto si no ─────
  Widget _buildQuestion() {
    if (_canShowVertical) {
      return _buildVerticalSubtraction();
    }
    // Para preguntas de texto (sin números parseables)
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ArcanaGameTheme.questionCard(borderColor: widget.enemy.color),
      child: Text(
        widget.exercise.question,
        style: ArcanaGameTheme.question,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Muestra la resta en vertical con dígitos alineados: unidades, decenas, centenas
  Widget _buildVerticalSubtraction() {
    final minuendo = widget.exercise.minuendo!.toString();
    final sustraendo = widget.exercise.sustraendo!.toString();
    final rp = widget.exercise.resultadoPropuesto;
    final rpStr = rp?.toString();
    // Para la alineación, considerar el resultado propuesto
    int maxLen = math.max(minuendo.length, sustraendo.length);
    if (rpStr != null) maxLen = math.max(maxLen, rpStr.length);
    final mPadded = minuendo.padLeft(maxLen);
    final sPadded = sustraendo.padLeft(maxLen);

    final isTrueFalse = widget.exercise.type == 'true_false';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: ArcanaGameTheme.questionCard(borderColor: widget.enemy.color),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Minuendo (arriba)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 36),
              ...List.generate(maxLen, (i) {
                final ch = mPadded[i];
                return _digitBox(ch == ' ' ? '' : ch, isResult: false);
              }),
            ],
          ),
          const SizedBox(height: 4),
          // Sustraendo (abajo con signo −)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '−',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: ArcanaColors.ruby.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ...List.generate(maxLen, (i) {
                final ch = sPadded[i];
                return _digitBox(ch == ' ' ? '' : ch, isResult: false);
              }),
            ],
          ),
          const SizedBox(height: 4),
          // Línea divisoria
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 36),
              Container(
                width: maxLen * 44.0,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ArcanaColors.gold.withValues(alpha: 0.3),
                      ArcanaColors.gold,
                      ArcanaColors.gold.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          // Si es V/F, mostrar el resultado propuesto debajo de la línea
          if (isTrueFalse && rpStr != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Signo = 
                SizedBox(
                  width: 36,
                  child: Text(
                    '=',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: ArcanaColors.gold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ...List.generate(maxLen, (i) {
                  final rpPadded = rpStr.padLeft(maxLen);
                  final ch = rpPadded[i];
                  return _digitBox(
                    ch == ' ' ? '' : ch,
                    isResult: true,
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '¿Es correcto?',
              style: ArcanaTextStyles.bodyMedium.copyWith(
                color: ArcanaColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ] else ...[
            // Indicador de columnas (U, D, C...)
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 36),
                ...List.generate(maxLen, (i) {
                  final labels = ['U', 'D', 'C', 'UM'];
                  final idx = maxLen - 1 - i;
                  final label = idx < labels.length ? labels[idx] : '';
                  return SizedBox(
                    width: 44,
                    child: Text(
                      label,
                      style: ArcanaTextStyles.caption.copyWith(
                        color: ArcanaColors.textMuted.withValues(alpha: 0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Cajita para cada dígito en la operación vertical
  Widget _digitBox(String digit, {required bool isResult}) {
    return Container(
      width: 40,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      decoration: isResult
          ? BoxDecoration(
              color: ArcanaColors.surfaceLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: ArcanaColors.gold.withValues(alpha: 0.3),
              ),
            )
          : null,
      child: Text(
        digit,
        style: TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w800,
          fontSize: 26,
          color: ArcanaColors.textPrimary,
          height: 1.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ─── Opciones como cards centradas ─────────
  Widget _buildOptions() {
    final options = widget.exercise.options ?? [];
    final correctAnswer = widget.exercise.answer;

    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = _selectedOption == index;
        final isCorrectOption = options[index] == correctAnswer;

        BoxDecoration decoration;
        if (!_answered) {
          decoration = ArcanaGameTheme.answerButton(
              kingdomColor: widget.enemy.color);
        } else if (isCorrectOption) {
          decoration = ArcanaGameTheme.answerButtonCorrect;
        } else if (isSelected && !_isCorrect) {
          decoration = ArcanaGameTheme.answerButtonWrong;
        } else {
          decoration = ArcanaGameTheme.answerButtonFaded;
        }

        final letters = ['A', 'B', 'C', 'D'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: _answered ? null : () => _selectOption(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              constraints: const BoxConstraints(
                  minHeight: ArcanaGameTheme.answerButtonMinHeight),
              decoration: decoration,
              padding: ArcanaGameTheme.answerButtonPadding,
              child: Row(
                children: [
                  // Letra identificadora
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      letters[index % 4],
                      style: ArcanaGameTheme.answerOption
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texto de la opción
                  Expanded(
                    child: Text(
                      options[index],
                      style: ArcanaGameTheme.answerOption,
                    ),
                  ),
                  // Iconos de feedback
                  if (_answered && isCorrectOption)
                    const Icon(Icons.check_circle_rounded,
                        color: ArcanaGameTheme.hitGreen, size: 24),
                  if (_answered && isSelected && !_isCorrect)
                    const Icon(Icons.cancel_rounded,
                        color: ArcanaGameTheme.hitRed, size: 24),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Inserta un dígito en la posición activa (RTL: de derecha a izquierda)
  void _onCustomKeyTap(String digit) {
    if (_answered) return;
    // Buscar la primera casilla vacía desde la derecha
    for (int i = _expectedDigits - 1; i >= 0; i--) {
      if (_digitControllers[i].text.isEmpty) {
        _digitControllers[i].text = digit;
        break;
      }
    }
  }

  /// Borra el último dígito introducido (el más a la izquierda que tenga contenido)
  void _onCustomKeyDelete() {
    if (_answered) return;
    for (int i = 0; i < _expectedDigits; i++) {
      if (_digitControllers[i].text.isNotEmpty) {
        _digitControllers[i].text = '';
        break;
      }
    }
  }

  // ─── Fill blank con digit boxes + teclado custom ───────
  Widget _buildFillBlank() {
    final canSubmit = _digitControllers.any((c) => c.text.isNotEmpty);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cajitas de dígitos
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_expectedDigits, (i) {
            return Container(
              width: 52,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ArcanaColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _answered
                      ? (_isCorrect ? ArcanaColors.emerald : ArcanaColors.ruby)
                      : ArcanaColors.gold.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_answered
                            ? (_isCorrect ? ArcanaColors.emerald : ArcanaColors.ruby)
                            : ArcanaColors.gold)
                        .withValues(alpha: 0.15),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                _digitControllers[i].text,
                style: ArcanaTextStyles.heroTitle.copyWith(
                  color: ArcanaColors.textPrimary,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
        ),

        const SizedBox(height: 10),

        // Teclado numérico custom horizontal
        if (!_answered) ...[
          _buildCustomNumpad(),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: canSubmit ? _submitFillBlank : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                gradient: canSubmit ? ArcanaColors.goldButtonGradient : null,
                color: canSubmit ? null : ArcanaColors.surfaceBorder,
                borderRadius: BorderRadius.circular(12),
                border: canSubmit
                    ? Border.all(
                        color: ArcanaColors.goldLight.withValues(alpha: 0.6))
                    : null,
              ),
              child: Text(
                '⚔️ ¡Atacar!',
                style: ArcanaTextStyles.buttonPrimary.copyWith(
                  color: canSubmit
                      ? const Color(0xFF1A1000)
                      : ArcanaColors.textMuted,
                ),
              ),
            ),
          ),
        ]
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (_isCorrect ? ArcanaColors.emerald : ArcanaColors.ruby)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isCorrect ? ArcanaColors.emerald : ArcanaColors.ruby,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle : Icons.cancel,
                  color: _isCorrect ? ArcanaColors.emerald : ArcanaColors.ruby,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isCorrect
                      ? '¡Correcto! 💥'
                      : 'Respuesta: ${widget.exercise.answer}',
                  style: ArcanaTextStyles.bodyMedium.copyWith(
                    color:
                        _isCorrect ? ArcanaColors.emerald : ArcanaColors.ruby,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ─── Teclado numérico custom ──────────────
  Widget _buildCustomNumpad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ArcanaColors.gold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Números 1-9, 0
          ...List.generate(10, (i) {
            final digit = i == 9 ? '0' : '${i + 1}';
            return _numpadKey(
              label: digit,
              onTap: () => _onCustomKeyTap(digit),
            );
          }),
          // Botón borrar
          _numpadKey(
            label: '⌫',
            onTap: _onCustomKeyDelete,
            isDelete: true,
          ),
        ],
      ),
    );
  }

  Widget _numpadKey({
    required String label,
    required VoidCallback onTap,
    bool isDelete = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDelete
              ? ArcanaColors.ruby.withValues(alpha: 0.15)
              : ArcanaColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDelete
                ? ArcanaColors.ruby.withValues(alpha: 0.4)
                : ArcanaColors.gold.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isDelete ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: isDelete ? ArcanaColors.ruby : ArcanaColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ─── Marcador inferior ────────────────────
  Widget _buildScoreboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.surfaceBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🧙‍♂️ ', style: TextStyle(fontSize: 16)),
          Text(
            '${widget.playerScore}',
            style: ArcanaTextStyles.cardTitle.copyWith(
              color: ArcanaColors.turquoise,
              fontSize: 18,
            ),
          ),
          Text(
            '  —  ',
            style: ArcanaTextStyles.bodyMedium.copyWith(
              color: ArcanaColors.textMuted,
            ),
          ),
          Text(
            '${widget.enemyScore}',
            style: ArcanaTextStyles.cardTitle.copyWith(
              color: widget.enemy.color,
              fontSize: 18,
            ),
          ),
          widget.enemy.buildSprite(size: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RESULTADO DE RONDA (intermedio)
// ─────────────────────────────────────────────
class _RoundResultScreen extends StatelessWidget {
  final BattleEnemy enemy;
  final bool won;
  final int playerScore;
  final int enemyScore;
  final int round;
  final int totalRounds;
  final VoidCallback onNext;

  const _RoundResultScreen({
    required this.enemy,
    required this.won,
    required this.playerScore,
    required this.enemyScore,
    required this.round,
    required this.totalRounds,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(
            particleCount: 25,
            color: ArcanaColors.gold,
            maxSize: 2.0,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¡RONDA $round GANADA!',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: ArcanaColors.gold,
                      fontSize: 26,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${enemy.emoji} ${enemy.name} derrotado',
                    style: ArcanaTextStyles.bodyLarge.copyWith(
                      color: ArcanaColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$playerScore — $enemyScore',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: ArcanaColors.textPrimary,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+50 XP',
                    style: ArcanaTextStyles.xpValue.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ArcanaGoldButton(
                    text: '¡Siguiente enemigo!',
                    icon: Icons.arrow_forward,
                    width: 280,
                    onPressed: onNext,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RESULTADO FINAL
// ─────────────────────────────────────────────
class _FinalResultScreen extends StatelessWidget {
  final bool won;
  final int roundsWon;
  final int totalRounds;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const _FinalResultScreen({
    required this.won,
    required this.roundsWon,
    required this.totalRounds,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(
            particleCount: won ? 40 : 15,
            color: won ? ArcanaColors.gold : ArcanaColors.ruby,
            maxSize: won ? 3.0 : 2.0,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    won ? '🏆' : '💀',
                    style: const TextStyle(fontSize: 72),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    won ? '¡VICTORIA TOTAL!' : 'DERROTA',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: won ? ArcanaColors.gold : ArcanaColors.ruby,
                      fontSize: 28,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    won
                        ? '¡Has derrotado a los 3 secuaces de Noctus!'
                        : 'El secuaz te ha vencido. ¡Entrena más!',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: ArcanaColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rondas ganadas: $roundsWon/$totalRounds',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textMuted,
                    ),
                  ),
                  if (won) ...[
                    const SizedBox(height: 16),
                    Text(
                      '+200 XP  ·  +100 monedas',
                      style: ArcanaTextStyles.xpValue.copyWith(fontSize: 16),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ArcanaGoldButton(
                    text: won ? 'Volver al mapa' : '¡Reintentar!',
                    icon: won ? Icons.map : Icons.replay,
                    width: 280,
                    onPressed: won ? onExit : onRestart,
                  ),
                  if (!won) ...[
                    const SizedBox(height: 12),
                    ArcanaOutlinedButton(
                      text: 'Volver al mapa',
                      icon: Icons.arrow_back,
                      color: ArcanaColors.textSecondary,
                      onPressed: onExit,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA: ¡TODOS DERROTADOS!
// ─────────────────────────────────────────────
class _AllDefeatedScreen extends StatelessWidget {
  final VoidCallback onExit;

  const _AllDefeatedScreen({required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(
            particleCount: 60,
            color: ArcanaColors.gold,
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    Text(
                      '¡VICTORIA TOTAL!',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: ArcanaColors.gold,
                        fontSize: 28,
                        shadows: [
                          Shadow(
                            color: ArcanaColors.gold.withValues(alpha: 0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Has derrotado a todos los secuaces de Noctus',
                      style: ArcanaTextStyles.bodyLarge.copyWith(
                        color: ArcanaColors.textSecondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Grid de enemigos derrotados
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ArcanaColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ArcanaColors.gold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: allBattleEnemies.map((enemy) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: enemy.color.withValues(alpha: 0.15),
                                      border: Border.all(
                                        color: ArcanaColors.emerald.withValues(alpha: 0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        enemy.emoji,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ArcanaColors.emerald,
                                        border: Border.all(
                                          color: const Color(0xFF0A0510),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                enemy.name,
                                style: ArcanaTextStyles.caption.copyWith(
                                  color: ArcanaColors.textMuted,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '⭐ ¡Eres un maestro de las restas! ⭐',
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: ArcanaColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ArcanaGoldButton(
                      text: 'Volver al mapa',
                      icon: Icons.map,
                      width: 280,
                      onPressed: onExit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STORY INTRO — Noctus envía a sus esbirros
// ─────────────────────────────────────────────
class _StoryIntroScreen extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onBack;

  const _StoryIntroScreen({required this.onStart, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: 30, color: const Color(0xFF7C4DFF)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C4DFF).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/bosses/noctus.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF1A0A2E),
                            child: const Center(
                              child: Text('🐲', style: TextStyle(fontSize: 52)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'NOCTUS',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: const Color(0xFF7C4DFF),
                        fontSize: 24,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Señor de las Sombras',
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF7C4DFF).withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ArcanaColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF7C4DFF).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '💀 «¡Ja, ja, ja!',
                            style: ArcanaTextStyles.cardTitle.copyWith(
                              color: const Color(0xFF7C4DFF),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '¡Envío a mis esbirros a robar '
                            'tu sabiduría de las restas!\n\n'
                            'Derrota a todos mis secuaces '
                            'si te atreves... aunque dudo '
                            'que lo consigas.»',
                            style: ArcanaTextStyles.bodyMedium.copyWith(
                              color: ArcanaColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ─── Orión reacciona al reto de Noctus ───
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A0A2E),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                        ),
                        child: const Text(
                          '🧙 ¡No le escuches, Aprendiz! ¡Tú puedes con todos sus esbirros! 💪',
                          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ArcanaGoldButton(
                      text: '¡Acepto el desafío!',
                      icon: Icons.shield,
                      width: 280,
                      onPressed: onStart,
                    ),
                    const SizedBox(height: 12),
                    ArcanaOutlinedButton(
                      text: 'Volver al mapa',
                      icon: Icons.arrow_back,
                      color: ArcanaColors.textSecondary,
                      onPressed: onBack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// DIOS DE LAS RESTAS — Pantalla independiente
// ═════════════════════════════════════════════
/// Pantalla del boss de restas (accesible por separado desde el mapa).
class RestasBossScreen extends StatefulWidget {
  const RestasBossScreen({super.key});

  @override
  State<RestasBossScreen> createState() => _RestasBossScreenState();
}

class _RestasBossScreenState extends State<RestasBossScreen> {
  static const int _totalQuestions = 10;
  static const _bossEnemy = BattleEnemy(
    name: 'Serpiente de Números',
    emoji: '🐍',
    color: Color(0xFFD4A017),
    power: 'Restas',
    imagePath: 'assets/images/bosses/jefe_restas.png',
  );

  List<_BattleExercise> _allExercises = [];
  List<_BattleExercise> _questions = [];
  bool _loading = true;
  String _phase = 'intro'; // intro → combat → result
  int _currentQ = 0;
  int _score = 0;
  int _enemyScore = 0;

  /// Tiempo por pregunta según dificultad
  int _secondsForDifficulty(int difficulty) {
    if (difficulty <= 2) return 30;
    if (difficulty <= 4) return 40;
    if (difficulty <= 5) return 45;
    return 55;
  }

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/curriculum/2_primaria/restas_completo.json',
      );
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final sections = data['sections'] as List;
      final exercises = <_BattleExercise>[];

      for (int secIdx = 0; secIdx < sections.length; secIdx++) {
        final section = sections[secIdx];
        final diffLevel = secIdx + 1;
         for (final ex in section['exercises'] as List) {
          final type = ex['type'] as String;
          List<String>? opts;
          String answer;
          final question = ex['question'] as String;
          var (m, s) = _parseSubtractionNumbers(question);

          if (type == 'multiple_choice') {
            opts = (ex['options'] as List).map((o) => o.toString()).toList();
            answer = ex['answer'].toString();
          } else if (type == 'true_false') {
            opts = (ex['options'] as List?)?.map((o) => o.toString()).toList()
                ?? ['Verdadero', 'Falso'];
            answer = (ex['answer'] == true) ? 'Verdadero' : 'Falso';
          } else {
            answer = ex['answer'].toString();
          }

          // Validar que m − s == answer (evitar vertical engañoso)
          if (m != null && s != null && type != 'true_false') {
            final numAnswer = int.tryParse(answer);
            if (numAnswer == null || (m - s) != numAnswer) {
              m = null;
              s = null;
            }
          }

          final rp = type == 'true_false' ? _parseProposedResult(question) : null;

          exercises.add(_BattleExercise(
            question: question,
            type: type,
            options: opts,
            answer: answer,
            hint: ex['hint'] as String?,
            minuendo: m,
            sustraendo: s,
            resultadoPropuesto: rp,
            difficulty: diffLevel,
          ));
        }
      }

      // Selección equilibrada: 2 preguntas de cada sección del 1-5 (core)
      // Secciones: 1=sin llevada, 2=con llevada 2c, 3=con llevada 3c, 4=prueba, 5=relación suma↔resta
      final balanced = <_BattleExercise>[];
      for (int sec = 1; sec <= 5; sec++) {
        final pool = exercises.where((e) => e.difficulty == sec).toList();
        pool.shuffle();
        balanced.addAll(pool.take(2));
      }
      // Completar hasta _totalQuestions si faltan
      if (balanced.length < _totalQuestions) {
        final remaining = exercises.where((e) => !balanced.contains(e)).toList();
        remaining.shuffle();
        balanced.addAll(remaining.take(_totalQuestions - balanced.length));
      }

      setState(() {
        _allExercises = exercises;
        _questions = balanced.take(_totalQuestions).toList();
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error cargando ejercicios boss: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _onCombatFinished(bool correct) {
    if (correct) {
      _score++;
    } else {
      _enemyScore++;
    }

    if (_currentQ + 1 >= _questions.length) {
      // Terminaron todas las preguntas
      setState(() => _phase = 'result');
    } else {
      setState(() => _currentQ++);
    }
  }

  void _resetBoss() {
    setState(() {
      _phase = 'intro';
      _currentQ = 0;
      _score = 0;
      _enemyScore = 0;
      // Reordenar preguntas
      // Re-seleccionar equilibradamente
      final balanced = <_BattleExercise>[];
      for (int sec = 1; sec <= 5; sec++) {
        final pool = _allExercises.where((e) => e.difficulty == sec).toList();
        pool.shuffle();
        balanced.addAll(pool.take(2));
      }
      if (balanced.length < _totalQuestions) {
        final remaining = _allExercises.where((e) => !balanced.contains(e)).toList();
        remaining.shuffle();
        balanced.addAll(remaining.take(_totalQuestions - balanced.length));
      }
      _questions = balanced.take(_totalQuestions).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: ArcanaColors.background,
        body: Center(
          child: CircularProgressIndicator(color: ArcanaColors.gold),
        ),
      );
    }

    switch (_phase) {
      case 'intro':
        return _BossIntroScreen(
          onStart: () => setState(() => _phase = 'combat'),
          onBack: () => Navigator.of(context).pop(),
        );
      case 'combat':
        final exercise = _questions[_currentQ];
        final timer = _secondsForDifficulty(exercise.difficulty);
        return _CombatScreen(
          key: ValueKey('boss_q_$_currentQ'),
          enemy: _bossEnemy,
          round: 1,
          totalRounds: 1,
          exercise: exercise,
          exerciseNumber: _currentQ + 1,
          totalExercises: _totalQuestions,
          playerScore: _score,
          enemyScore: _enemyScore,
          timerSeconds: timer,
          onFinished: _onCombatFinished,
        );
      case 'result':
        return _BossResultScreen(
          score: _score,
          total: _totalQuestions,
          onRetry: _resetBoss,
          onExit: () => Navigator.of(context).pop(),
        );
      default:
        return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────
// BOSS INTRO — Dios de las Restas
// ─────────────────────────────────────────────
class _BossIntroScreen extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onBack;

  const _BossIntroScreen({required this.onStart, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: 40, color: const Color(0xFFFF1744)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '⚠️ D I O S  F I N A L ⚠️',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: const Color(0xFFFF1744),
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF1744).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/bosses/jefe_restas.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF1A0A2E),
                            child: const Center(
                              child: Text('🐲', style: TextStyle(fontSize: 56)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'DIOS DE LAS RESTAS',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFFF1744).withValues(alpha: 0.6),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ArcanaColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFF1744).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '🔥 «¡No podrás vencerme!',
                            style: ArcanaTextStyles.cardTitle.copyWith(
                              color: const Color(0xFFFF1744),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Soy el más poderoso y tengo '
                            'el poder del TIEMPO.\n\n'
                            '¡Solo un verdadero maestro de las '
                            'restas puede derrotarme!»',
                            style: ArcanaTextStyles.bodyMedium.copyWith(
                              color: ArcanaColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1744).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '📝 10 operaciones · ⏱️ 30-55 seg cada una\n'
                              '⭐ Necesitas 8/10 para aprobar',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: ArcanaColors.gold,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ArcanaGoldButton(
                      text: '¡ENFRENTARSE!',
                      icon: Icons.local_fire_department,
                      width: 280,
                      onPressed: onStart,
                    ),
                    const SizedBox(height: 12),
                    ArcanaOutlinedButton(
                      text: 'Volver al mapa',
                      icon: Icons.arrow_back,
                      color: ArcanaColors.textSecondary,
                      onPressed: onBack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOSS COMBAT — UI RPG con timer adaptativo
// ─────────────────────────────────────────────
class _BossCombatScreen extends StatefulWidget {
  final List<_BattleExercise> exercises;
  final void Function(bool won, int score, int total) onFinished;

  const _BossCombatScreen({
    required this.exercises,
    required this.onFinished,
  });

  @override
  State<_BossCombatScreen> createState() => _BossCombatScreenState();
}

class _BossCombatScreenState extends State<_BossCombatScreen>
    with TickerProviderStateMixin {
  static const int _totalQuestions = 10;
  static const int _bossMaxHp = 100;
  static const int _playerMaxHp = 3;

  /// Tiempo por pregunta según dificultad
  int _secondsForDifficulty(int difficulty) {
    if (difficulty <= 2) return 30;
    if (difficulty <= 4) return 40;
    if (difficulty <= 5) return 45;
    return 55;
  }

  late List<_BattleExercise> _questions;
  int _currentQ = 0;
  int _score = 0;
  int _bossHp = _bossMaxHp;
  int _playerHp = _playerMaxHp;
  bool _finished = false;
  String _fillAnswer = '';

  // Animaciones
  late AnimationController _timerController;
  late AnimationController _shakeController;
  late AnimationController _playerShakeController;
  late AnimationController _rayController;

  // Feedback
  bool _showingFeedback = false;
  bool _lastAnswerCorrect = false;
  String? _selectedOption;

  int get _currentSeconds => _secondsForDifficulty(
      _questions.isNotEmpty ? _questions[_currentQ].difficulty : 3);

  @override
  void initState() {
    super.initState();

    // Curva de dificultad progresiva
    final pool = List<_BattleExercise>.from(widget.exercises);
    pool.shuffle();
    final easy = pool.where((e) => e.difficulty <= 2).take(4).toList();
    final medium = pool.where((e) => e.difficulty >= 3 && e.difficulty <= 5).take(3).toList();
    final hard = pool.where((e) => e.difficulty >= 6).take(3).toList();
    final sorted = [...easy, ...medium, ...hard];
    if (sorted.length < _totalQuestions) {
      final remaining = pool.where((e) => !sorted.contains(e)).take(_totalQuestions - sorted.length);
      sorted.addAll(remaining);
    }
    _questions = sorted.take(_totalQuestions).toList();

    // Controladores de animación
    _shakeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
    _playerShakeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
    _rayController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800));

    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _currentSeconds),
    );
    _timerController.addListener(() {
      if (_timerController.isCompleted && !_finished && !_showingFeedback) {
        _handleAnswer(null); // Tiempo agotado
      }
      if (mounted) setState(() {});
    });
    _timerController.forward();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _shakeController.dispose();
    _playerShakeController.dispose();
    _rayController.dispose();
    super.dispose();
  }

  void _handleAnswer(String? selected) {
    if (_finished || _showingFeedback) return;
    _timerController.stop();

    final correct = selected != null &&
        selected.trim().toLowerCase() == _questions[_currentQ].answer.trim().toLowerCase();

    // Lanzar rayo mágico
    _rayController.forward(from: 0);

    // Sacudir al objetivo tras el rayo
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (correct) {
        _shakeController.forward(from: 0);
      } else {
        _playerShakeController.forward(from: 0);
      }
    });

    setState(() {
      _showingFeedback = true;
      _lastAnswerCorrect = correct;
      _selectedOption = selected;

      if (correct) {
        _score++;
        _bossHp = (_bossHp - (_bossMaxHp ~/ _totalQuestions)).clamp(0, _bossMaxHp);
      } else {
        _playerHp = (_playerHp - 1).clamp(0, _playerMaxHp);
      }
    });

    // Esperar para que el niño vea el resultado
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _showingFeedback = false;
        _selectedOption = null;
        _fillAnswer = '';
      });
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_finished) return;

    // Verificar condiciones de fin
    if (_playerHp <= 0 || _currentQ + 1 >= _totalQuestions || _bossHp <= 0) {
      setState(() => _finished = true);
      widget.onFinished(_score >= 8, _score, _totalQuestions);
      return;
    }

    setState(() {
      _currentQ++;
      _timerController.duration = Duration(seconds: _currentSeconds);
      _timerController.reset();
      _timerController.forward();
    });
  }

  int get _remainingSeconds {
    return (_currentSeconds * (1 - _timerController.value)).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0510),
        body: Center(child: Text('Sin preguntas', style: TextStyle(color: Colors.white))),
      );
    }

    final q = _questions[_currentQ];
    final isLowTime = _remainingSeconds <= 5;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con gradiente rojo boss
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  const Color(0xFFFF1744).withValues(alpha: 0.12),
                  const Color(0xFF0A0510),
                ],
              ),
            ),
          ),
          MagicalParticles(
            particleCount: 20,
            color: const Color(0xFFFF1744),
            maxSize: 2.0,
          ),

          SafeArea(
            child: Column(
              children: [
                // ─── Header con timer ─────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      // Timer
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLowTime
                              ? const Color(0xFFFF1744).withValues(alpha: 0.2)
                              : ArcanaColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isLowTime
                                ? const Color(0xFFFF1744)
                                : ArcanaColors.gold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer, size: 14,
                              color: isLowTime ? const Color(0xFFFF1744) : ArcanaColors.gold),
                            const SizedBox(width: 4),
                            Text('${_remainingSeconds}s',
                              style: ArcanaTextStyles.cardTitle.copyWith(
                                color: isLowTime ? const Color(0xFFFF1744) : ArcanaColors.gold,
                                fontSize: 16, fontFamily: 'monospace',
                              )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Barra del timer
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (1 - _timerController.value).clamp(0.0, 1.0),
                            backgroundColor: ArcanaColors.surface,
                            valueColor: AlwaysStoppedAnimation(
                              isLowTime ? const Color(0xFFFF1744) : ArcanaColors.emerald,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Pregunta N/total
                      Text('${_currentQ + 1}/$_totalQuestions',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: ArcanaColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // ─── Barras de HP ─────
                _buildHPBars(),

                const SizedBox(height: 4),

                // ─── Luchadores con rayo ─────
                _buildFighters(),

                const SizedBox(height: 6),

                // ─── Pregunta + opciones ─────
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Feedback visual
                          if (_showingFeedback)
                            _buildFeedbackBanner(),
                          _buildQuestionCard(q),
                          const SizedBox(height: 12),
                          if (q.type == 'fill_blank')
                            _buildFillBlank(q)
                          else
                            _buildOptions(q),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Vidas del jugador ─────
                _buildPlayerLives(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Barras de HP jugador vs boss ─────
  Widget _buildHPBars() {
    final bossRatio = _bossHp / _bossMaxHp;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🧙‍♂️ Aprendiz',
                style: ArcanaTextStyles.caption.copyWith(
                  color: ArcanaColors.turquoise, fontWeight: FontWeight.bold, fontSize: 11)),
              Text('🐲 Jefe  $_bossHp/$_bossMaxHp HP',
                style: ArcanaTextStyles.caption.copyWith(
                  color: const Color(0xFFFF1744), fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: ArcanaColors.surfaceBorder,
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  // Barra del jugador (izquierda, azul)
                  Expanded(
                    flex: 50,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: (_playerHp / _playerMaxHp).clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ArcanaColors.turquoise.withValues(alpha: 0.6), ArcanaColors.turquoise],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 2, color: ArcanaColors.background),
                  // Barra del boss (derecha, roja)
                  Expanded(
                    flex: 50,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: bossRatio.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFF1744),
                                const Color(0xFFFF1744).withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF1744).withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Luchadores con rayo mágico ─────
  Widget _buildFighters() {
    return SizedBox(
      height: 90,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _shakeController, _playerShakeController, _rayController,
        ]),
        builder: (context, child) {
          final enemyShake = math.sin(_shakeController.value * math.pi * 6) *
              (1 - _shakeController.value) * 12;
          final playerShake = math.sin(_playerShakeController.value * math.pi * 6) *
              (1 - _playerShakeController.value) * 12;

          return Stack(
            children: [
              // Rayo mágico entre luchadores
              if (_showingFeedback)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MagicRayPainter(
                      progress: _rayController.value,
                      leftToRight: _lastAnswerCorrect,
                      color: _lastAnswerCorrect
                          ? ArcanaColors.turquoise
                          : const Color(0xFFFF1744),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Aprendiz (izquierda)
                    Transform.translate(
                      offset: Offset(playerShake, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: _showingFeedback && !_lastAnswerCorrect ? 0.8 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: const Text('🧙‍♂️', style: TextStyle(fontSize: 44)),
                          ),
                          if (_showingFeedback)
                            Text(
                              _lastAnswerCorrect ? '💥 ¡Ataque!' : '😵 ¡Ouch!',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _lastAnswerCorrect ? ArcanaColors.emerald : ArcanaColors.ruby,
                                fontWeight: FontWeight.bold, fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Boss (derecha)
                    Transform.translate(
                      offset: Offset(enemyShake, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: _showingFeedback && _lastAnswerCorrect ? 0.8 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/bosses/jefe_restas.png',
                                width: 48, height: 48, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Text('🐲', style: TextStyle(fontSize: 44)),
                              ),
                            ),
                          ),
                          if (_showingFeedback)
                            Text(
                              _lastAnswerCorrect ? '😵 ¡Aaagh!' : '😈 Ja ja',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _lastAnswerCorrect
                                    ? ArcanaColors.emerald
                                    : const Color(0xFFFF1744),
                                fontWeight: FontWeight.bold, fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Banner de feedback ─────
  Widget _buildFeedbackBanner() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _lastAnswerCorrect
              ? ArcanaColors.emerald.withValues(alpha: 0.15)
              : const Color(0xFFFF1744).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _lastAnswerCorrect ? ArcanaColors.emerald : const Color(0xFFFF1744),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _lastAnswerCorrect ? Icons.check_circle : Icons.cancel,
              color: _lastAnswerCorrect ? ArcanaColors.emerald : const Color(0xFFFF1744),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _lastAnswerCorrect
                  ? '¡Correcto! ⭐'
                  : 'Respuesta: ${_questions[_currentQ].answer}',
              style: ArcanaTextStyles.cardTitle.copyWith(
                color: _lastAnswerCorrect ? ArcanaColors.emerald : const Color(0xFFFF1744),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Card de pregunta ─────
  Widget _buildQuestionCard(_BattleExercise q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFF1744).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/bosses/jefe_restas.png',
                  width: 24, height: 24, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Text('🐲', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 6),
              Text('Jefe pregunta:',
                style: ArcanaTextStyles.cardTitle.copyWith(
                  color: const Color(0xFFFF1744), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Text(q.question,
            style: ArcanaTextStyles.bodyLarge.copyWith(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ─── Opciones multiple choice / true-false ─────
  Widget _buildOptions(_BattleExercise q) {
    final opts = q.options ?? [];
    final correctAnswer = q.answer;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: opts.map((opt) {
        Color bgColor = ArcanaColors.surface;
        Color borderColor = ArcanaColors.gold.withValues(alpha: 0.3);
        Color textColor = Colors.white;

        if (_showingFeedback && _selectedOption == opt) {
          if (opt.trim().toLowerCase() == correctAnswer.trim().toLowerCase()) {
            bgColor = ArcanaColors.emerald.withValues(alpha: 0.3);
            borderColor = ArcanaColors.emerald;
            textColor = ArcanaColors.emerald;
          } else {
            bgColor = const Color(0xFFFF1744).withValues(alpha: 0.3);
            borderColor = const Color(0xFFFF1744);
            textColor = const Color(0xFFFF1744);
          }
        } else if (_showingFeedback && opt.trim().toLowerCase() == correctAnswer.trim().toLowerCase()) {
          bgColor = ArcanaColors.emerald.withValues(alpha: 0.15);
          borderColor = ArcanaColors.emerald.withValues(alpha: 0.5);
          textColor = ArcanaColors.emerald;
        }

        return SizedBox(
          width: 140,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: borderColor, width: _showingFeedback ? 2 : 1),
              ),
            ),
            onPressed: _showingFeedback ? null : () => _handleAnswer(opt),
            child: Text(opt,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center),
          ),
        );
      }).toList(),
    );
  }

  // ─── Fill blank con dígitos RTL ─────
  Widget _buildFillBlank(_BattleExercise q) {
    final maxLen = q.answer.length;
    final paddedAnswer = _fillAnswer.padLeft(maxLen);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxLen, (i) {
            final char = paddedAnswer[i] == ' ' ? '' : paddedAnswer[i];
            Color borderCol = char.isEmpty
                ? ArcanaColors.gold.withValues(alpha: 0.3)
                : ArcanaColors.gold;
            Color bgCol = ArcanaColors.surface;

            if (_showingFeedback && char.isNotEmpty) {
              if (_lastAnswerCorrect) {
                borderCol = ArcanaColors.emerald;
                bgCol = ArcanaColors.emerald.withValues(alpha: 0.2);
              } else {
                borderCol = const Color(0xFFFF1744);
                bgCol = const Color(0xFFFF1744).withValues(alpha: 0.2);
              }
            }

            return Container(
              width: 42, height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: bgCol,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderCol, width: _showingFeedback ? 2 : 1),
              ),
              child: Center(
                child: Text(char,
                  style: ArcanaTextStyles.heroTitle.copyWith(
                    color: _showingFeedback
                        ? (_lastAnswerCorrect ? ArcanaColors.emerald : const Color(0xFFFF1744))
                        : Colors.white,
                    fontSize: 22,
                  )),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            for (int d = 0; d <= 9; d++)
              _bossNumKey(d.toString(), () {
                if (_showingFeedback) return;
                if (_fillAnswer.length < maxLen) {
                  setState(() => _fillAnswer += d.toString());
                  if (_fillAnswer.length == maxLen) {
                    _handleAnswer(_fillAnswer);
                  }
                }
              }),
            _bossNumKey('⌫', () {
              if (_showingFeedback) return;
              if (_fillAnswer.isNotEmpty) {
                setState(() =>
                    _fillAnswer = _fillAnswer.substring(0, _fillAnswer.length - 1));
              }
            }),
          ],
        ),
      ],
    );
  }

  Widget _bossNumKey(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46, height: 42,
        decoration: BoxDecoration(
          color: ArcanaColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Text(label,
            style: ArcanaTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 17)),
        ),
      ),
    );
  }

  // ─── Vidas del jugador ─────
  Widget _buildPlayerLives() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Vidas: ',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textSecondary, fontSize: 12)),
          for (int i = 0; i < _playerMaxHp; i++)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                i < _playerHp ? Icons.favorite : Icons.favorite_border,
                color: i < _playerHp ? ArcanaColors.ruby : ArcanaColors.surfaceBorder,
                size: 20,
              ),
            ),
          const Spacer(),
          Text('⭐ $_score/$_totalQuestions',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.gold, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOSS RESULT — Resultado del examen
// ─────────────────────────────────────────────
class _BossResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const _BossResultScreen({
    required this.score,
    required this.total,
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final won = score >= 8;
    final color = won ? ArcanaColors.emerald : const Color(0xFFFF1744);
    final particleColor = won ? ArcanaColors.gold : const Color(0xFFFF1744);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: won ? 50 : 25, color: particleColor),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/bosses/jefe_restas.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Text('🐲', style: TextStyle(fontSize: 56)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      won ? '¡DIOS DERROTADO!' : 'El dios resiste...',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: color,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Puntuación visual
                    Text(
                      'Tu poder de restas:',
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: ArcanaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$score / $total',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: ArcanaColors.gold,
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Estrellas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(total, (i) {
                        return Icon(
                          i < score ? Icons.star : Icons.star_border,
                          color: ArcanaColors.gold,
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      won
                          ? '¡Eres un maestro absoluto de las restas! 🏆'
                          : 'Necesitas 8/10 para vencer.\n¡Sigue practicando!',
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: won ? ArcanaColors.gold : ArcanaColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (!won)
                      ArcanaGoldButton(
                        text: '¡Reintentar!',
                        icon: Icons.replay,
                        width: 280,
                        onPressed: onRetry,
                      ),
                    if (!won) const SizedBox(height: 12),
                    ArcanaOutlinedButton(
                      text: won ? '🏆 Volver al mapa' : 'Volver al mapa',
                      icon: Icons.arrow_back,
                      color: won ? ArcanaColors.gold : ArcanaColors.textSecondary,
                      onPressed: onExit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

