import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/arcana_buttons.dart';
import '../widgets/magical_particles.dart';

// ─────────────────────────────────────────────
// MODELO DE ENEMIGO PARA ENGLISH
// ─────────────────────────────────────────────
class EnglishEnemy {
  final String name;
  final String emoji;
  final Color color;
  final String power;
  final String? imagePath;
  final int sectionIndex;

  const EnglishEnemy({
    required this.name,
    required this.emoji,
    required this.color,
    required this.power,
    this.imagePath,
    this.sectionIndex = 0,
  });

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

const List<EnglishEnemy> allEnglishEnemies = [
  // ── Unit 6: People (months, face, am/is/are) ──────────────────────────────
  EnglishEnemy(name: 'Monthmancer',  emoji: '🌙', color: Color(0xFF7C3AED), power: 'Time',        sectionIndex: 0), // months
  EnglishEnemy(name: 'Faceweaver',   emoji: '👤', color: Color(0xFF0F766E), power: 'The Face',    sectionIndex: 1), // face vocab
  EnglishEnemy(name: 'Adjectrix',    emoji: '✨', color: Color(0xFFB45309), power: 'Description', sectionIndex: 2), // am/is/are
  // ── Unit 5: My bedroom (furniture, this/that) ─────────────────────────────
  EnglishEnemy(name: 'Wordling',     emoji: '📦', color: Color(0xFF1E40AF), power: 'Vocabulary',  sectionIndex: 3),
  EnglishEnemy(name: 'Pointix',      emoji: '👉', color: Color(0xFF065F46), power: 'Pointing',    sectionIndex: 4),
  EnglishEnemy(name: 'Possessor',    emoji: '🎒', color: Color(0xFFDC2626), power: 'Possession',  sectionIndex: 5),
];

/// SharedPreferences keys
const String _engDefeatedKey = 'english_defeated_enemies';
const String _engVictoriesKey = 'english_enemy_victories';

Future<Set<String>> getEnglishDefeatedEnemies() async {
  final prefs = await SharedPreferences.getInstance();
  return (prefs.getStringList(_engDefeatedKey) ?? []).toSet();
}

Future<Map<String, int>> getEnglishEnemyVictories() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList(_engVictoriesKey) ?? [];
  final map = <String, int>{};
  for (final entry in data) {
    final parts = entry.split(':');
    if (parts.length == 2) map[parts[0]] = int.tryParse(parts[1]) ?? 0;
  }
  return map;
}

Future<void> _saveEnglishDefeatedEnemy(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(_engDefeatedKey) ?? [];
  if (!list.contains(name)) {
    list.add(name);
    await prefs.setStringList(_engDefeatedKey, list);
  }
  final victories = await getEnglishEnemyVictories();
  victories[name] = (victories[name] ?? 0) + 1;
  final encoded = victories.entries.map((e) => '${e.key}:${e.value}').toList();
  await prefs.setStringList(_engVictoriesKey, encoded);
}

// ─────────────────────────────────────────────
// MODELO DE EJERCICIO
// ─────────────────────────────────────────────
class _EnglishExercise {
  final String question;
  final String type;
  final List<String>? options;
  final String answer;
  final String? hint;
  final String? explanation;
  final int difficulty;

  const _EnglishExercise({
    required this.question,
    required this.type,
    this.options,
    required this.answer,
    this.hint,
    this.explanation,
    this.difficulty = 1,
  });
}

// ═════════════════════════════════════════════
// PANTALLA PRINCIPAL — Combate de Inglés
// ═════════════════════════════════════════════
class EnglishBattleScreen extends StatefulWidget {
  const EnglishBattleScreen({super.key});

  @override
  State<EnglishBattleScreen> createState() => _EnglishBattleScreenState();
}

class _EnglishBattleScreenState extends State<EnglishBattleScreen> {
  final _random = math.Random();
  late List<EnglishEnemy> _roundEnemies;
  List<_EnglishExercise> _allExercises = [];
  bool _loading = true;
  Set<String> _defeatedNames = {};

  int _currentRound = 0;
  String _phase = 'story_intro';
  bool _lastRoundWon = false;
  int _totalRounds = 3;

  int _playerScore = 0;
  int _enemyScore = 0;
  int _currentExerciseIndex = 0;
  late List<_EnglishExercise> _roundExercises;

  @override
  void initState() {
    super.initState();
    _initBattle();
  }

  Future<void> _initBattle() async {
    _defeatedNames = await getEnglishDefeatedEnemies();
    _pickEnemies();
    _loadExercises();
  }

  void _pickEnemies() {
    final all = allEnglishEnemies.toList();
    all.shuffle(_random);
    _totalRounds = math.min(3, all.length);
    _roundEnemies = all.take(_totalRounds).toList();
  }

  Future<void> _loadExercises() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/curriculum/2_primaria/english_unit6.json',
      );
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final sections = data['sections'] as List;
      final exercises = <_EnglishExercise>[];

      for (int secIdx = 0; secIdx < sections.length; secIdx++) {
        final section = sections[secIdx];
        final diffLevel = secIdx + 1;
        for (final ex in section['exercises'] as List) {
          final type = ex['type'] as String;
          List<String>? options;
          String answer;
          final question = ex['question'] as String;

          if (type == 'multiple_choice') {
            options = List<String>.from(ex['options']);
            answer = ex['answer'] as String;
          } else if (type == 'true_false') {
            options = ['True', 'False'];
            answer = (ex['answer'] == true) ? 'True' : 'False';
          } else {
            answer = ex['answer'].toString();
          }

          exercises.add(_EnglishExercise(
            question: question,
            type: type,
            options: options,
            answer: answer,
            hint: ex['hint'] as String?,
            explanation: ex['explanation'] as String?,
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
      debugPrint('Error loading English exercises: $e');
    }
  }

  void _prepareRound() {
    final enemy = _roundEnemies[_currentRound];
    // Filtrar por sección del enemigo + adyacentes
    final maxDiff = math.min(6, enemy.sectionIndex + 2);
    final pool = _allExercises.where((e) => e.difficulty <= maxDiff).toList();
    pool.shuffle(_random);
    _roundExercises = pool.take(15).toList();
    _playerScore = 0;
    _enemyScore = 0;
    _currentExerciseIndex = 0;
  }

  void _onExerciseFinished(bool correct) {
    setState(() {
      if (correct) {
        _playerScore++;
      } else {
        _enemyScore++;
      }

      if (_playerScore >= 7 || _enemyScore >= 7) {
        _lastRoundWon = _playerScore >= 7;
        if (_lastRoundWon) {
          _saveEnglishDefeatedEnemy(_roundEnemies[_currentRound].name);
        }
        _phase = 'round_result';
      } else if (_currentExerciseIndex + 1 >= _roundExercises.length) {
        _lastRoundWon = _playerScore > _enemyScore;
        if (_lastRoundWon) {
          _saveEnglishDefeatedEnemy(_roundEnemies[_currentRound].name);
        }
        _phase = 'round_result';
      } else {
        _currentExerciseIndex++;
      }
    });
  }

  void _nextRound() {
    setState(() {
      if (_currentRound + 1 >= _totalRounds) {
        _phase = 'final_result';
      } else {
        _currentRound++;
        _prepareRound();
        _phase = 'vs';
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
          onStart: () => setState(() => _phase = 'vs'),
          onBack: () => Navigator.of(context).pop(),
        );
      case 'vs':
        final enemy = _roundEnemies[_currentRound];
        return _VSScreen(
          enemy: enemy,
          round: _currentRound + 1,
          totalRounds: _totalRounds,
          onStart: () => setState(() => _phase = 'combat'),
        );
      case 'combat':
        if (_roundExercises.isEmpty) return const SizedBox();
        final exercise = _roundExercises[_currentExerciseIndex];
        final enemy = _roundEnemies[_currentRound];
        return _CombatScreen(
          key: ValueKey('eng_r${_currentRound}_q$_currentExerciseIndex'),
          enemy: enemy,
          exercise: exercise,
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
          defeatedCount: _defeatedNames.length + (_lastRoundWon ? 1 : 0),
          totalEnemies: allEnglishEnemies.length,
          onExit: () => Navigator.of(context).pop(),
          onReplay: () {
            setState(() {
              _currentRound = 0;
              _phase = 'story_intro';
              _pickEnemies();
              _prepareRound();
            });
          },
        );
      default:
        return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────
// STORY INTRO — The Enchanted Room
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
          MagicalParticles(particleCount: 30, color: const Color(0xFF7C3AED)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('🏛️', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 12),
                  Text(
                    'THE MISSING WIZARD',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: const Color(0xFFa78bfa),
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CHAPTER 6 · BABEL',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textMuted,
                      letterSpacing: 3,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🧙 Orión speaks:\n'
                          '"The crystal halls of BABEL grow dark...\n'
                          'The Calendar Wizard has vanished!\n\n'
                          'Only someone who knows the months\n'
                          'of time can reveal the hidden path.\n\n'
                          'But beware — Noctus has sent\n'
                          'his word-wraiths to guard the way!\n\n'
                          '🗝️ Use your English to defeat them!"',
                          style: ArcanaTextStyles.bodyMedium.copyWith(
                            color: ArcanaColors.textSecondary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '⚔️ Defeat 3 of Noctus\u2019s wraiths to find the wizard!',
                            style: ArcanaTextStyles.caption.copyWith(
                              color: const Color(0xFFa78bfa),
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
                  Text(
                    'ENEMIES OF BABEL',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textMuted,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: allEnglishEnemies.take(3).map((e) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e.emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 4),
                          Text(
                            e.name,
                            style: ArcanaTextStyles.caption.copyWith(
                              color: e.color,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ArcanaGoldButton(
                    text: '⚔️ ENTER THE TOWER',
                    width: 280,
                    onPressed: onStart,
                  ),
                  const SizedBox(height: 12),
                  ArcanaOutlinedButton(
                    text: 'Back to map',
                    icon: Icons.arrow_back,
                    color: ArcanaColors.textSecondary,
                    onPressed: onBack,
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
// VS SCREEN
// ─────────────────────────────────────────────
class _VSScreen extends StatelessWidget {
  final EnglishEnemy enemy;
  final int round;
  final int totalRounds;
  final VoidCallback onStart;

  const _VSScreen({
    required this.enemy,
    required this.round,
    required this.totalRounds,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: 20, color: enemy.color),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ROUND $round / $totalRounds',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textMuted,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text('🧙‍♂️', style: TextStyle(fontSize: 52)),
                          const SizedBox(height: 4),
                          Text('YOU', style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.gold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'VS',
                          style: ArcanaTextStyles.heroTitle.copyWith(
                            color: const Color(0xFFFF1744),
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          enemy.buildSprite(size: 52),
                          const SizedBox(height: 4),
                          Text(enemy.name, style: ArcanaTextStyles.caption.copyWith(color: enemy.color)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '⚡ Power: ${enemy.power}',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: enemy.color,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ArcanaGoldButton(
                    text: '⚔️ FIGHT!',
                    width: 200,
                    onPressed: onStart,
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
// PAINTER PARA EL RAYO MÁGICO (English)
// ─────────────────────────────────────────────
class _MagicRayPainterEng extends CustomPainter {
  final double progress;
  final bool leftToRight;
  final Color color;

  _MagicRayPainterEng({
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
          Offset(px, py),
          radius,
          Paint()
            ..color = color.withValues(alpha: (1 - impactProgress) * 0.8)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }

    // Punto brillante en la punta
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
  bool shouldRepaint(covariant _MagicRayPainterEng oldDelegate) =>
      oldDelegate.progress != progress;
}

// ─────────────────────────────────────────────
// COMBAT SCREEN — Preguntas de inglés
// ─────────────────────────────────────────────
class _CombatScreen extends StatefulWidget {
  final EnglishEnemy enemy;
  final _EnglishExercise exercise;
  final int exerciseNumber;
  final int totalExercises;
  final int playerScore;
  final int enemyScore;
  final void Function(bool correct) onFinished;

  const _CombatScreen({
    super.key,
    required this.enemy,
    required this.exercise,
    required this.exerciseNumber,
    required this.totalExercises,
    required this.playerScore,
    required this.enemyScore,
    required this.onFinished,
  });

  @override
  State<_CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<_CombatScreen> with TickerProviderStateMixin {
  bool _answered = false;
  bool _correct = false;
  String? _selectedOption;
  String _fillAnswer = '';
  late AnimationController _shakeController;
  late AnimationController _playerShakeController;
  late AnimationController _rayController;

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
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _playerShakeController.dispose();
    _rayController.dispose();
    super.dispose();
  }

  void _submitAnswer(String answer) {
    if (_answered) return;

    final correct = answer.trim().toLowerCase() == widget.exercise.answer.trim().toLowerCase();

    setState(() {
      _answered = true;
      _correct = correct;
      _selectedOption = answer;
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
      if (mounted) widget.onFinished(correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: SafeArea(
        child: Column(
          children: [
            // Header: scores + progress
            _buildHeader(),
            const SizedBox(height: 8),
            // Battle bar
            _buildBattleBar(),
            const SizedBox(height: 4),
            // Fighters with ray
            _buildFightersWithRay(),
            const SizedBox(height: 12),
            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildQuestionCard(),
                    const SizedBox(height: 12),
                    if (e.type == 'multiple_choice' || e.type == 'true_false')
                      _buildOptions()
                    else
                      _buildFillBlank(),
                    if (_answered && e.explanation != null) ...[
                      const SizedBox(height: 12),
                      _buildExplanation(),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black.withValues(alpha: 0.3),
      child: Row(
        children: [
          // Exit button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          // Player score
          Text(
            '🧙‍♂️ ${widget.playerScore}',
            style: ArcanaTextStyles.bodyMedium.copyWith(
              color: ArcanaColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Progress
          Text(
            'Q${widget.exerciseNumber}',
            style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textMuted),
          ),
          const Spacer(),
          // Enemy score
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

  Widget _buildBattleBar() {
    final totalNeeded = 7;
    final playerRatio = widget.playerScore / totalNeeded;
    final enemyRatio = widget.enemyScore / totalNeeded;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 12,
          child: Row(
            children: [
              Expanded(
                flex: math.max(1, (playerRatio * 100).round()),
                child: Container(color: ArcanaColors.gold),
              ),
              Expanded(
                flex: math.max(1, (100 - (playerRatio + enemyRatio) * 50).round()),
                child: Container(color: Colors.grey.shade800),
              ),
              Expanded(
                flex: math.max(1, (enemyRatio * 100).round()),
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
                    painter: _MagicRayPainterEng(
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
                    // Aprendiz
                    Transform.translate(
                      offset: Offset(playerShake, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: _answered && !_correct ? 0.8 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: const Text('🧙‍♂️',
                                style: TextStyle(fontSize: 44)),
                          ),
                          if (_answered)
                            Text(
                              _correct ? '💥 Attack!' : '😵 Ouch!',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _correct
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
                            scale: _answered && _correct ? 0.8 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: widget.enemy.buildSprite(size: 44),
                          ),
                          if (_answered)
                            Text(
                              _correct ? '😵 Aaagh!' : '😈 Ha ha',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: _correct
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

  Widget _buildQuestionCard() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          if (_answered)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: (_correct ? ArcanaColors.emerald : const Color(0xFFFF1744)).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _correct ? '✅ Correct!' : '❌ Incorrect',
                style: ArcanaTextStyles.caption.copyWith(
                  color: _correct ? ArcanaColors.emerald : const Color(0xFFFF1744),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            widget.exercise.question,
            style: ArcanaTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 18,
              height: 1.5,
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
    final options = widget.exercise.options ?? [];
    return Center(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: options.asMap().entries.map((entry) {
            final i = entry.key;
            final option = entry.value;
            final isSelected = _selectedOption == option;
            final isCorrectOption = option.trim().toLowerCase() == widget.exercise.answer.trim().toLowerCase();

            Color bgColor = const Color(0xFF1A1030);
            Color borderColor = const Color(0xFF60A5FA).withValues(alpha: 0.3);

            if (_answered) {
              if (isCorrectOption) {
                bgColor = ArcanaColors.emerald.withValues(alpha: 0.2);
                borderColor = ArcanaColors.emerald;
              } else if (isSelected && !_correct) {
                bgColor = const Color(0xFFFF1744).withValues(alpha: 0.2);
                borderColor = const Color(0xFFFF1744);
              }
            }

            final labels = ['A', 'B', 'C', 'D'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: _answered ? null : () => _submitAnswer(option),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF60A5FA).withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Text(
                            labels[i % labels.length],
                            style: ArcanaTextStyles.caption.copyWith(
                              color: const Color(0xFF60A5FA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        option,
                        style: ArcanaTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      if (_answered && isCorrectOption) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.check_circle, color: ArcanaColors.emerald, size: 20),
                      ],
                      if (_answered && isSelected && !_correct) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.cancel, color: Color(0xFFFF1744), size: 20),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFillBlank() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1030),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _answered
                  ? (_correct ? ArcanaColors.emerald : const Color(0xFFFF1744))
                  : const Color(0xFF60A5FA).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _fillAnswer.isEmpty ? 'Type your answer...' : _fillAnswer,
                  style: ArcanaTextStyles.bodyMedium.copyWith(
                    color: _fillAnswer.isEmpty ? ArcanaColors.textMuted : Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              if (_answered)
                Icon(
                  _correct ? Icons.check_circle : Icons.cancel,
                  color: _correct ? ArcanaColors.emerald : const Color(0xFFFF1744),
                ),
            ],
          ),
        ),
        if (_answered && !_correct)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Answer: ${widget.exercise.answer}',
              style: ArcanaTextStyles.bodyMedium.copyWith(
                color: ArcanaColors.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (!_answered) ...[
          const SizedBox(height: 12),
          // Keyboard buttons for common answers
          _buildAnswerKeyboard(),
          const SizedBox(height: 8),
          ArcanaGoldButton(
            text: '✅ Submit',
            width: 200,
            onPressed: _fillAnswer.isNotEmpty ? () => _submitAnswer(_fillAnswer) : null,
          ),
        ],
      ],
    );
  }

  Widget _buildAnswerKeyboard() {
    // Para fill_blank en inglés, sugerir las respuestas más comunes
    final commonAnswers = <String>[
      "There's", "There are",
      "this", "that", "these", "those",
      "is", "are",
      "It's", "They're",
      "wood", "metal", "glass", "fabric", "plastic",
    ];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: commonAnswers.map((word) {
        final isSelected = _fillAnswer == word;
        return GestureDetector(
          onTap: () => setState(() => _fillAnswer = word),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF60A5FA).withValues(alpha: 0.3)
                  : const Color(0xFF1A1030),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF60A5FA)
                    : const Color(0xFF60A5FA).withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              word,
              style: ArcanaTextStyles.caption.copyWith(
                color: isSelected ? Colors.white : ArcanaColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExplanation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ArcanaColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
      ),
      child: Text(
        '💡 ${widget.exercise.explanation}',
        style: ArcanaTextStyles.caption.copyWith(
          color: ArcanaColors.gold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROUND RESULT
// ─────────────────────────────────────────────
class _RoundResultScreen extends StatelessWidget {
  final EnglishEnemy enemy;
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
            particleCount: won ? 40 : 15,
            color: won ? ArcanaColors.gold : const Color(0xFFFF1744),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  enemy.buildSprite(size: 56),
                  const SizedBox(height: 16),
                  Text(
                    won ? '${enemy.name} DEFEATED!' : '${enemy.name} wins...',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: won ? ArcanaColors.gold : const Color(0xFFFF1744),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$playerScore — $enemyScore',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ArcanaGoldButton(
                    text: round < totalRounds ? 'Next Battle ➡️' : 'See Results 🏆',
                    width: 250,
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
// FINAL RESULT
// ─────────────────────────────────────────────
class _FinalResultScreen extends StatelessWidget {
  final int defeatedCount;
  final int totalEnemies;
  final VoidCallback onExit;
  final VoidCallback onReplay;

  const _FinalResultScreen({
    required this.defeatedCount,
    required this.totalEnemies,
    required this.onExit,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: 40, color: const Color(0xFF60A5FA)),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🏰', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    'BATTLE COMPLETE!',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: const Color(0xFF60A5FA),
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enemies defeated: $defeatedCount / $totalEnemies',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: ArcanaColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ArcanaGoldButton(
                    text: '🔄 Play again',
                    width: 250,
                    onPressed: onReplay,
                  ),
                  const SizedBox(height: 12),
                  ArcanaOutlinedButton(
                    text: 'Back to map',
                    icon: Icons.arrow_back,
                    color: ArcanaColors.textSecondary,
                    onPressed: onExit,
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

// ═════════════════════════════════════════════
// BOSS — English Unit 5 Exam
// ═════════════════════════════════════════════
class EnglishBossScreen extends StatefulWidget {
  const EnglishBossScreen({super.key});

  @override
  State<EnglishBossScreen> createState() => _EnglishBossScreenState();
}

class _EnglishBossScreenState extends State<EnglishBossScreen> {
  static const int _totalQuestions = 10;
  List<_EnglishExercise> _allExercises = [];
  List<_EnglishExercise> _questions = [];
  bool _loading = true;
  String _phase = 'intro';
  int _currentQ = 0;
  int _score = 0;
  int _enemyScore = 0;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/curriculum/2_primaria/english_unit5.json',
      );
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final sections = data['sections'] as List;
      final exercises = <_EnglishExercise>[];

      for (int secIdx = 0; secIdx < sections.length; secIdx++) {
        final section = sections[secIdx];
        final diffLevel = secIdx + 1;
        for (final ex in section['exercises'] as List) {
          final type = ex['type'] as String;
          List<String>? options;
          String answer;

          if (type == 'multiple_choice') {
            options = List<String>.from(ex['options']);
            answer = ex['answer'] as String;
          } else if (type == 'true_false') {
            options = ['True', 'False'];
            answer = (ex['answer'] == true) ? 'True' : 'False';
          } else {
            answer = ex['answer'].toString();
          }

          exercises.add(_EnglishExercise(
            question: ex['question'] as String,
            type: type,
            options: options,
            answer: answer,
            hint: ex['hint'] as String?,
            explanation: ex['explanation'] as String?,
            difficulty: diffLevel,
          ));
        }
      }

      // Selección equilibrada: 2 de cada sección (hasta 5 secciones)
      final balanced = <_EnglishExercise>[];
      for (int sec = 1; sec <= 5; sec++) {
        final pool = exercises.where((e) => e.difficulty == sec).toList();
        pool.shuffle();
        balanced.addAll(pool.take(2));
      }
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
      debugPrint('Error loading English exercises: $e');
    }
  }

  void _onCombatFinished(bool correct) {
    if (correct) {
      _score++;
    } else {
      _enemyScore++;
    }

    if (_currentQ + 1 >= _questions.length) {
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
      final balanced = <_EnglishExercise>[];
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

  static const _bossEnemy = EnglishEnemy(
    name: 'Grimoire',
    emoji: '🦉',
    color: Color(0xFF7C3AED),
    power: 'English Mastery',
    imagePath: 'assets/images/bosses/enchantress.png',
    sectionIndex: 5,
  );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: ArcanaColors.background,
        body: Center(child: CircularProgressIndicator(color: ArcanaColors.gold)),
      );
    }

    switch (_phase) {
      case 'intro':
        return _BossIntroScreenEng(
          onStart: () => setState(() => _phase = 'combat'),
          onBack: () => Navigator.of(context).pop(),
        );
      case 'combat':
        final exercise = _questions[_currentQ];
        return _CombatScreen(
          key: ValueKey('eng_boss_q_$_currentQ'),
          enemy: _bossEnemy,
          exercise: exercise,
          exerciseNumber: _currentQ + 1,
          totalExercises: _totalQuestions,
          playerScore: _score,
          enemyScore: _enemyScore,
          onFinished: _onCombatFinished,
        );
      case 'result':
        return _BossResultScreenEng(
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
// BOSS INTRO — English
// ─────────────────────────────────────────────
class _BossIntroScreenEng extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onBack;

  const _BossIntroScreenEng({required this.onStart, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: 60, color: const Color(0xFF7C3AED)),
          // Extra green particles for the Grimoire's magic
          MagicalParticles(particleCount: 30, color: const Color(0xFF22C55E)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Warning text
                    Text(
                      '⚠️ F I N A L  B O S S ⚠️',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: const Color(0xFFFF1744),
                        fontSize: 18,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BOSS IMAGE — GRANDE con glow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF22C55E).withValues(alpha: 0.4),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                            blurRadius: 60,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/bosses/enchantress.png',
                          width: 200, height: 200, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Text('🦉', style: TextStyle(fontSize: 100)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Boss name
                    Text(
                      'THE GRIMOIRE',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Guardian of the Enchanted Room',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: const Color(0xFF22C55E),
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rules card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1744).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFF1744).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '📝 10 questions about Unit 5\n'
                        '⭐ You need 8/10 to defeat The Grimoire',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: ArcanaColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Boss dialogue
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '🦉 "You dare enter my room?\n'
                        'Furniture, demonstratives, possessives...\n'
                        'I know ALL the words. Do you?"',
                        style: ArcanaTextStyles.bodyMedium.copyWith(
                          color: const Color(0xFF22C55E),
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    ArcanaGoldButton(
                      text: '⚔️ FIGHT THE GRIMOIRE',
                      width: 300,
                      onPressed: onStart,
                    ),
                    const SizedBox(height: 10),
                    ArcanaOutlinedButton(
                      text: 'Back',
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
// BOSS RESULT — English
// ─────────────────────────────────────────────
class _BossResultScreenEng extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const _BossResultScreenEng({
    required this.score,
    required this.total,
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final won = score >= 8;
    final color = won ? ArcanaColors.emerald : const Color(0xFFFF1744);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: won ? 50 : 25, color: won ? ArcanaColors.gold : const Color(0xFFFF1744)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/bosses/enchantress.png',
                        width: 100, height: 100, fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text('🦉', style: TextStyle(fontSize: 64)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      won ? 'GRIMOIRE DEFEATED!' : 'The Grimoire resists...',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: color,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$score / $total',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: ArcanaColors.gold,
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                          ? 'You are a true English wizard! 🏆'
                          : 'You need 8/10 to win.\nKeep practising!',
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
                        text: '🔄 Try again!',
                        icon: Icons.replay,
                        width: 280,
                        onPressed: onRetry,
                      ),
                    if (!won) const SizedBox(height: 12),
                    ArcanaOutlinedButton(
                      text: won ? '🏆 Back to map' : 'Back to map',
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
