import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';
import '../../widgets/magical_particles.dart';
import '../../services/multiplication_generator.dart';

// ─────────────────────────────────────────────
// MODELO DE ENEMIGO PARA MULTIPLICACIÓN
// ─────────────────────────────────────────────
class MultiEnemy {
  final String name;
  final String emoji;
  final Color color;
  final String power;

  const MultiEnemy({
    required this.name,
    required this.emoji,
    required this.color,
    required this.power,
  });

  Widget buildSprite({double size = 44}) {
    return Text(emoji, style: TextStyle(fontSize: size));
  }
}

const List<MultiEnemy> allMultiEnemies = [
  MultiEnemy(name: 'Chispix', emoji: '⚡', color: Color(0xFFEAB308), power: 'Chisporroteo'),
  MultiEnemy(name: 'Llamarada', emoji: '🔥', color: Color(0xFFEA580C), power: 'Fuego'),
  MultiEnemy(name: 'Magmion', emoji: '🌋', color: Color(0xFFDC2626), power: 'Lava'),
  MultiEnemy(name: 'Cristalón', emoji: '💎', color: Color(0xFF7C3AED), power: 'Fractal'),
  MultiEnemy(name: 'Obsidius', emoji: '🪨', color: Color(0xFF475569), power: 'Roca'),
];

/// El Boss de Multiplicar
const MultiEnemy cristaliaBoss = MultiEnemy(
  name: 'Cristalia',
  emoji: '👹',
  color: Color(0xFFFF1744),
  power: 'Fractal Absoluto',
);

/// SharedPreferences keys
const String _multiDefeatedKey = 'multi_defeated_enemies';
const String _multiVictoriesKey = 'multi_enemy_victories';

Future<void> _saveMultiVictory(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(_multiDefeatedKey) ?? [];
  if (!list.contains(name)) {
    list.add(name);
    await prefs.setStringList(_multiDefeatedKey, list);
  }
  // Incrementar conteo
  final victories = <String, int>{};
  for (final entry in prefs.getStringList(_multiVictoriesKey) ?? []) {
    final parts = entry.split(':');
    if (parts.length == 2) victories[parts[0]] = int.tryParse(parts[1]) ?? 0;
  }
  victories[name] = (victories[name] ?? 0) + 1;
  final encoded = victories.entries.map((e) => '${e.key}:${e.value}').toList();
  await prefs.setStringList(_multiVictoriesKey, encoded);
}

// ─────────────────────────────────────────────
// PANTALLA PRINCIPAL — Orquesta VS → Combate → Resultado
// ─────────────────────────────────────────────
class MultiplicacionBattleScreen extends StatefulWidget {
  final bool isBoss;
  final int minTable;
  final int maxTable;

  const MultiplicacionBattleScreen({
    super.key,
    required this.isBoss,
    required this.minTable,
    required this.maxTable,
  });

  @override
  State<MultiplicacionBattleScreen> createState() => _MultiplicacionBattleScreenState();
}

class _MultiplicacionBattleScreenState extends State<MultiplicacionBattleScreen> {
  final _random = math.Random();
  late MultiEnemy _currentEnemy;
  String _phase = 'vs';

  int _playerScore = 0;
  int _enemyScore = 0;
  int _currentExerciseIndex = 0;
  final int _totalExercises = 10;
  late MultiplicationExercise _currentExercise;

  // Para el combo conmutativo en modo entrenar
  MultiplicationExercise? _pendingCommutative;

  @override
  void initState() {
    super.initState();
    if (widget.isBoss) {
      _currentEnemy = cristaliaBoss;
    } else {
      final enemies = allMultiEnemies.toList()..shuffle(_random);
      _currentEnemy = enemies.first;
    }
    _generateNextExercise();
  }

  void _generateNextExercise() {
    // En modo entrenar, inyectar combo conmutativo
    if (!widget.isBoss && _pendingCommutative != null) {
      _currentExercise = _pendingCommutative!;
      _pendingCommutative = null;
      return;
    }

    if (widget.isBoss) {
      _currentExercise = MultiplicationGenerator.generateMixedRange(
        widget.minTable, widget.maxTable,
      );
    } else {
      // Entrenar: elegir una tabla al azar dentro del rango
      final table = widget.minTable + _random.nextInt((widget.maxTable - widget.minTable) + 1);
      _currentExercise = MultiplicationGenerator.generateSpecificTable(table);
    }

    // Preparar un combo conmutativo para el siguiente turno (solo entrenar, 40% probabilidad)
    if (!widget.isBoss && _random.nextDouble() < 0.4) {
      // Invertir los factores
      final f1 = _currentExercise.factor2;
      final f2 = _currentExercise.factor1;
      if (f1 != f2) { // Solo si son distintos (3x4 ≠ 4x3 visualmente)
        _pendingCommutative = MultiplicationExercise(
          question: '$f1 × $f2 = ?',
          factor1: f1,
          factor2: f2,
          correctAnswer: f1 * f2,
          options: MultiplicationGenerator.generateOptionsFor(f1, f2, f1 * f2),
          hint: _currentExercise.hint,
        );
      }
    }
  }

  void _startCombat() {
    setState(() => _phase = 'combat');
  }

  void _onExerciseFinished(bool correct) {
    setState(() {
      if (correct) {
        _playerScore++;
      } else {
        _enemyScore++;
      }

      // Condición de victoria/derrota: 7 puntos (o todos los ejercicios)
      if (_playerScore >= 7 || _enemyScore >= 7 || _currentExerciseIndex >= _totalExercises - 1) {
        final won = _playerScore > _enemyScore;
        if (won) {
          _saveMultiVictory(_currentEnemy.name);
        }
        _phase = 'final_result';
        return;
      }

      _currentExerciseIndex++;
      _generateNextExercise();
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case 'vs':
        return _VSScreen(
          enemy: _currentEnemy,
          isBoss: widget.isBoss,
          minTable: widget.minTable,
          maxTable: widget.maxTable,
          onStart: _startCombat,
          onBack: () => Navigator.of(context).pop(),
        );
      case 'combat':
        return _CombatScreen(
          key: ValueKey('multi_combat_$_currentExerciseIndex'),
          enemy: _currentEnemy,
          exercise: _currentExercise,
          exerciseNumber: _currentExerciseIndex + 1,
          totalExercises: _totalExercises,
          playerScore: _playerScore,
          enemyScore: _enemyScore,
          isBoss: widget.isBoss,
          isCommutativeCombo: _pendingCommutative != null && _currentExerciseIndex > 0,
          onFinished: _onExerciseFinished,
        );
      case 'final_result':
        return _FinalResultScreen(
          won: _playerScore > _enemyScore,
          playerScore: _playerScore,
          enemyScore: _enemyScore,
          enemy: _currentEnemy,
          isBoss: widget.isBoss,
          onRestart: () {
            setState(() {
              _playerScore = 0;
              _enemyScore = 0;
              _currentExerciseIndex = 0;
              _pendingCommutative = null;
              _generateNextExercise();
              _phase = 'vs';
            });
          },
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
  final MultiEnemy enemy;
  final bool isBoss;
  final int minTable;
  final int maxTable;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const _VSScreen({
    required this.enemy,
    required this.isBoss,
    required this.minTable,
    required this.maxTable,
    required this.onStart,
    required this.onBack,
  });

  @override
  State<_VSScreen> createState() => _VSScreenState();
}

class _VSScreenState extends State<_VSScreen> with TickerProviderStateMixin {
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
          // Fondo bicolor
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

          MagicalParticles(
            particleCount: 20,
            color: ArcanaColors.gold,
            maxSize: 2.0,
          ),

          SafeArea(
            child: Column(
              children: [
                // Botón atrás
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
                          child: const Icon(Icons.arrow_back, color: Colors.white54, size: 20),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Tablas ${widget.minTable}-${widget.maxTable}',
                        style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.gold),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Luchadores
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Jugador
                      SlideTransition(
                        position: slideLeft,
                        child: Column(
                          children: [
                            const Text('🧙‍♂️', style: TextStyle(fontSize: 60)),
                            const SizedBox(height: 8),
                            Text(
                              'Aprendiz',
                              style: ArcanaTextStyles.cardTitle.copyWith(
                                color: ArcanaColors.turquoise,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // VS
                      FadeTransition(
                        opacity: vsFade,
                        child: AnimatedBuilder(
                          animation: _vsFlashController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + _vsFlashController.value * 0.1,
                              child: Text(
                                'VS',
                                style: ArcanaTextStyles.heroTitle.copyWith(
                                  fontSize: 48,
                                  color: ArcanaColors.gold,
                                  shadows: [
                                    Shadow(
                                      color: ArcanaColors.gold.withValues(alpha: 0.5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Enemigo
                      SlideTransition(
                        position: slideRight,
                        child: Column(
                          children: [
                            widget.enemy.buildSprite(size: 60),
                            const SizedBox(height: 8),
                            Text(
                              widget.enemy.name,
                              style: ArcanaTextStyles.cardTitle.copyWith(
                                color: widget.enemy.color,
                              ),
                            ),
                            Text(
                              widget.enemy.power,
                              style: ArcanaTextStyles.caption.copyWith(
                                color: widget.enemy.color.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Botón luchar
                FadeTransition(
                  opacity: buttonFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ArcanaColors.gold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: widget.onStart,
                        child: Text(
                          widget.isBoss ? '⚔️ ¡EXAMEN!' : '⚔️ ¡LUCHAR!',
                          style: ArcanaTextStyles.cardTitle.copyWith(color: Colors.black),
                        ),
                      ),
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

// ─────────────────────────────────────────────
// MAGIC RAY PAINTER
// ─────────────────────────────────────────────
class _MagicRayPainterMulti extends CustomPainter {
  final double progress;
  final bool leftToRight;
  final Color color;

  _MagicRayPainterMulti({
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

    // Rayo principal
    final rayPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color,
          color.withValues(alpha: 0.9),
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTRB(
        math.min(startX, currentX), centerY - 3,
        math.max(startX, currentX), centerY + 3,
      ))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawLine(Offset(startX, centerY), Offset(currentX, centerY), rayPaint);

    // Glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3 * progress)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawLine(Offset(startX, centerY), Offset(currentX, centerY), glowPaint);

    // Partículas de impacto
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
          Offset(px, py), radius,
          Paint()
            ..color = color.withValues(alpha: (1 - impactProgress) * 0.8)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }

    // Punto brillante en la punta
    canvas.drawCircle(
      Offset(currentX, centerY), 6 * progress,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      Offset(currentX, centerY), 3 * progress,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _MagicRayPainterMulti oldDelegate) =>
      oldDelegate.progress != progress;
}

// ─────────────────────────────────────────────
// PANTALLA DE COMBATE
// ─────────────────────────────────────────────
class _CombatScreen extends StatefulWidget {
  final MultiEnemy enemy;
  final MultiplicationExercise exercise;
  final int exerciseNumber;
  final int totalExercises;
  final int playerScore;
  final int enemyScore;
  final bool isBoss;
  final bool isCommutativeCombo;
  final void Function(bool correct) onFinished;

  const _CombatScreen({
    super.key,
    required this.enemy,
    required this.exercise,
    required this.exerciseNumber,
    required this.totalExercises,
    required this.playerScore,
    required this.enemyScore,
    required this.isBoss,
    required this.isCommutativeCombo,
    required this.onFinished,
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
  bool _correct = false;
  int? _selectedOption;
  bool _showHint = false;

  // Timer para pistas (solo entrenar)
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );
    _playerShakeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );
    _rayController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );

    if (widget.isBoss) {
      // Boss: timer de 12 segundos por pregunta
      _timerController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 12),
      );
      _timerController!.addListener(() {
        if (_timerController!.isCompleted && !_answered) {
          _submitAnswer(-1); // forzar fallo por timeout
        }
        if (mounted) {
          setState(() {
            _remainingSeconds = (12 * (1 - _timerController!.value)).ceil();
          });
        }
      });
      _timerController!.forward();
    } else {
      // Entrenar: tras 5 segundos mostrar pista
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && !_answered && widget.exercise.hint.isNotEmpty) {
          setState(() => _showHint = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _playerShakeController.dispose();
    _rayController.dispose();
    _timerController?.dispose();
    super.dispose();
  }

  void _submitAnswer(int selectedValue) {
    if (_answered) return;
    _timerController?.stop();

    final correct = selectedValue == widget.exercise.correctAnswer;

    setState(() {
      _answered = true;
      _correct = correct;
    });

    // Lanzar rayo mágico
    _rayController.forward(from: 0);

    // Sacudir al objetivo
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (correct) {
        _shakeController.forward(from: 0);
      } else {
        _playerShakeController.forward(from: 0);
      }
    });

    // Avanzar
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) widget.onFinished(correct);
    });
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() => _selectedOption = index);
    _submitAnswer(widget.exercise.options[index]);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.playerScore + widget.enemyScore;
    final playerRatio = total > 0 ? widget.playerScore / total : 0.5;
    final isLowTime = widget.isBoss && _remainingSeconds <= 4;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ─────────────────
            _buildHeader(isLowTime),

            // ─── Barra de vida ─────────
            _buildBattleBar(playerRatio),

            // ─── Luchadores con rayo ────
            _buildFightersWithRay(),

            // ─── Combo conmutativo ──────
            if (widget.isCommutativeCombo && !_answered)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF60A5FA).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '🪞 ¡Combo Espejo! ¿Es lo mismo al revés?',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: const Color(0xFF60A5FA),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const Spacer(),

            // ─── Pregunta ───────────────
            _buildQuestionCard(),

            const SizedBox(height: 16),

            // ─── Pista de Orión (solo entrenar) ──
            if (_showHint && !_answered && !widget.isBoss)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ArcanaColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Text('🦉', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.exercise.hint,
                          style: ArcanaTextStyles.caption.copyWith(
                            color: ArcanaColors.gold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // ─── Opciones ───────────────
            _buildOptions(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLowTime) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
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
              Text(
                '🧙‍♂️ ${widget.playerScore}',
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: ArcanaColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Timer del boss o número de pregunta
          if (widget.isBoss && _timerController != null)
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
              'Pregunta ${widget.exerciseNumber}/${widget.totalExercises}',
              style: ArcanaTextStyles.caption.copyWith(
                color: ArcanaColors.textSecondary, fontSize: 12,
              ),
            ),
          const Spacer(),
          Text(
            '${widget.enemyScore} ${widget.enemy.emoji}',
            style: ArcanaTextStyles.bodyMedium.copyWith(
              color: widget.enemy.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleBar(double playerRatio) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: 8,
          child: Row(
            children: [
              Flexible(
                flex: (playerRatio * 100).round().clamp(1, 99),
                child: Container(color: const Color(0xFF60A5FA)),
              ),
              Flexible(
                flex: ((1 - playerRatio) * 100).round().clamp(1, 99),
                child: Container(color: widget.enemy.color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFightersWithRay() {
    return SizedBox(
      height: 90,
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
              // Rayo mágico
              if (_answered)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MagicRayPainterMulti(
                      progress: _rayController.value,
                      leftToRight: _correct,
                      color: _correct
                          ? const Color(0xFF60A5FA)
                          : widget.enemy.color,
                    ),
                  ),
                ),
              // Luchadores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Jugador
                    Transform.translate(
                      offset: Offset(playerShake, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: _answered && !_correct ? 0.85 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: const Text('🧙‍♂️', style: TextStyle(fontSize: 44)),
                          ),
                          if (_answered)
                            Text(
                              _correct ? '💥 ¡Ataque!' : '😵 ¡Ouch!',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _correct ? const Color(0xFF60A5FA) : const Color(0xFFFF1744),
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
                            scale: _answered && _correct ? 0.85 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: widget.enemy.buildSprite(size: 44),
                          ),
                          if (_answered)
                            Text(
                              _correct ? '😵 ¡Aaagh!' : '😈 ¡Ja ja!',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _correct ? const Color(0xFFFF1744) : widget.enemy.color,
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

  Widget _buildQuestionCard() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1030),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _answered
                  ? (_correct ? ArcanaColors.emerald : const Color(0xFFFF1744))
                  : const Color(0xFF60A5FA).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_answered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _correct ? '✅ ¡Correcto!' : '❌ Era: ${widget.exercise.correctAnswer}',
                    style: ArcanaTextStyles.cardTitle.copyWith(
                      color: _correct ? ArcanaColors.emerald : const Color(0xFFFF1744),
                    ),
                  ),
                ),
              Text(
                widget.exercise.question,
                style: ArcanaTextStyles.heroTitle.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    final options = widget.exercise.options;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(options.length, (i) {
            final isSelected = _selectedOption == i;
            final value = options[i];
            final isCorrectOption = value == widget.exercise.correctAnswer;

            Color bgColor = ArcanaColors.surface;
            Color borderColor = const Color(0xFF60A5FA).withValues(alpha: 0.3);

            if (_answered) {
              if (isCorrectOption) {
                bgColor = ArcanaColors.emerald.withValues(alpha: 0.2);
                borderColor = ArcanaColors.emerald;
              } else if (isSelected && !isCorrectOption) {
                bgColor = const Color(0xFFFF1744).withValues(alpha: 0.2);
                borderColor = const Color(0xFFFF1744);
              }
            } else if (isSelected) {
              borderColor = const Color(0xFF60A5FA);
            }

            return GestureDetector(
              onTap: () => _selectOption(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Text(
                  '$value',
                  style: ArcanaTextStyles.screenTitle.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA DE RESULTADO FINAL
// ─────────────────────────────────────────────
class _FinalResultScreen extends StatelessWidget {
  final bool won;
  final int playerScore;
  final int enemyScore;
  final MultiEnemy enemy;
  final bool isBoss;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const _FinalResultScreen({
    required this.won,
    required this.playerScore,
    required this.enemyScore,
    required this.enemy,
    required this.isBoss,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  won ? '🏆' : '💀',
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 24),
                Text(
                  won
                      ? (isBoss ? '¡EXAMEN SUPERADO!' : '¡VICTORIA!')
                      : (isBoss ? 'Examen fallido...' : 'Derrota...'),
                  style: ArcanaTextStyles.heroTitle.copyWith(
                    color: won ? ArcanaColors.gold : const Color(0xFFFF1744),
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tú: $playerScore  —  ${enemy.emoji} ${enemy.name}: $enemyScore',
                  style: ArcanaTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                if (won && isBoss) ...[
                  const SizedBox(height: 24),
                  Text(
                    '¡Cristalia ha sido derrotada!\nHas demostrado que dominas las tablas.',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: ArcanaColors.emerald,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ArcanaColors.surface,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onExit,
                        child: const Text('🔙 Salir'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ArcanaColors.gold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onRestart,
                        child: const Text('🔄 Reintentar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
