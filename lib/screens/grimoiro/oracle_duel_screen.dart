import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';
import '../../widgets/arcana_buttons.dart';
import '../../widgets/magical_particles.dart';

// ═══════════════════════════════════════════════════════════
// ORACLE DUEL SCREEN — Duelo de Conocimiento
// ═══════════════════════════════════════════════════════════
//
// Sistema de puntuación:
//   Jugador acierta  → +1 Aprendiz → rayo al Oráculo
//   Jugador falla    → +1 Oráculo  → rayo al Aprendiz
//   Aprendiz llega a 8  → VICTORIA ("Has derrotado al Gran Oráculo")
//   Oráculo llega a 10  → DERROTA  ("El Oráculo te ha vencido")
//
// El resultado guarda el récord en SharedPreferences.
// Sin narrativa de examen. Sin la palabra "examen".
// ═══════════════════════════════════════════════════════════

class OracleDuelScreen extends StatefulWidget {
  final int unitNumber;
  final String unitTitle;
  final String jsonAsset;
  final Color accentColor;

  const OracleDuelScreen({
    super.key,
    required this.unitNumber,
    required this.unitTitle,
    required this.jsonAsset,
    required this.accentColor,
  });

  @override
  State<OracleDuelScreen> createState() => _OracleDuelScreenState();
}

class _OracleDuelScreenState extends State<OracleDuelScreen>
    with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────
  List<_DuelExercise> _exercises = [];
  bool _loading = true;
  String _phase = 'intro'; // intro | duel | victory | defeat

  int _playerScore = 0;
  int _oracleScore = 0;
  int _currentIndex = 0;
  int _bestRecord = 0; // previous best (player score when won)

  static const int _playerWin = 8;
  static const int _oracleWin = 10;

  // Answer state
  bool _answered = false;
  bool _correct = false;
  String? _selectedOption;

  // Animations
  late AnimationController _rayController;
  late AnimationController _playerShakeCtrl;
  late AnimationController _oracleShakeCtrl;
  late AnimationController _pulseController;

  final _random = math.Random();

  // ── SharedPreferences key ────────────────────────────────
  String get _recordKey => 'oracle_duel_unit${widget.unitNumber}_record';

  @override
  void initState() {
    super.initState();
    _rayController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _playerShakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _oracleShakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
        lowerBound: 0.95,
        upperBound: 1.05)
      ..repeat(reverse: true);
    _loadData();
  }

  @override
  void dispose() {
    _rayController.dispose();
    _playerShakeCtrl.dispose();
    _oracleShakeCtrl.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Load exercises + record ───────────────────────────────
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _bestRecord = prefs.getInt(_recordKey) ?? 0;

      final jsonStr = await rootBundle.loadString(widget.jsonAsset);
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final sections = data['sections'] as List;
      final all = <_DuelExercise>[];

      for (final section in sections) {
        for (final ex in section['exercises'] as List) {
          final type = ex['type'] as String;
          String answer;
          List<String>? options;

          if (type == 'multiple_choice') {
            options = List<String>.from(ex['options']);
            answer = ex['answer'] as String;
          } else if (type == 'true_false') {
            options = ['True', 'False'];
            answer = (ex['answer'] == true) ? 'True' : 'False';
          } else {
            answer = ex['answer'].toString();
          }

          all.add(_DuelExercise(
            question: ex['question'] as String,
            type: type,
            options: options,
            answer: answer,
            hint: ex['hint'] as String?,
            explanation: ex['explanation'] as String?,
          ));
        }
      }

      all.shuffle(_random);

      setState(() {
        _exercises = all;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Oracle Duel load error: $e');
    }
  }

  // ── Answer logic ──────────────────────────────────────────
  void _submitAnswer(String answer) {
    if (_answered) return;
    final correct =
        answer.trim().toLowerCase() == _currentExercise.answer.trim().toLowerCase();

    setState(() {
      _answered = true;
      _correct = correct;
      _selectedOption = answer;
      if (correct) {
        _playerScore++;
      } else {
        _oracleScore++;
      }
    });

    _rayController.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (correct) {
        _oracleShakeCtrl.forward(from: 0);
      } else {
        _playerShakeCtrl.forward(from: 0);
      }
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_playerScore >= _playerWin) {
      _endDuel(won: true);
      return;
    }
    if (_oracleScore >= _oracleWin) {
      _endDuel(won: false);
      return;
    }

    final nextIndex = _currentIndex + 1;
    if (nextIndex >= _exercises.length) {
      // All questions used — won by survival
      _endDuel(won: _playerScore > _oracleScore);
      return;
    }

    setState(() {
      _currentIndex = nextIndex;
      _answered = false;
      _correct = false;
      _selectedOption = null;
    });
  }

  Future<void> _endDuel({required bool won}) async {
    if (won) {
      final prefs = await SharedPreferences.getInstance();
      if (_playerScore > _bestRecord) {
        _bestRecord = _playerScore;
        await prefs.setInt(_recordKey, _bestRecord);
      }
    }
    if (mounted) {
      setState(() => _phase = won ? 'victory' : 'defeat');
    }
  }

  void _restart() {
    final all = List<_DuelExercise>.from(_exercises)..shuffle(_random);
    setState(() {
      _exercises = all;
      _phase = 'duel';
      _playerScore = 0;
      _oracleScore = 0;
      _currentIndex = 0;
      _answered = false;
      _correct = false;
      _selectedOption = null;
    });
  }

  _DuelExercise get _currentExercise => _exercises[_currentIndex];

  // ── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0510),
        body: const Center(
          child: CircularProgressIndicator(color: ArcanaColors.gold),
        ),
      );
    }

    switch (_phase) {
      case 'intro':
        return _buildIntro();
      case 'duel':
        return _buildDuel();
      case 'victory':
        return _buildResult(won: true);
      case 'defeat':
        return _buildResult(won: false);
      default:
        return const SizedBox();
    }
  }

  // ── Intro ─────────────────────────────────────────────────
  Widget _buildIntro() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(
              particleCount: 25, color: const Color(0xFFDC2626)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('💀', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 12),
                  Text(
                    'EL GRAN ORÁCULO',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: const Color(0xFFEF4444),
                      fontSize: 24,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DUELO DE CONOCIMIENTO',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textMuted,
                      letterSpacing: 3,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFDC2626).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '💀 El Gran Oráculo habla:\n\n'
                      '"¿Crees que dominas ${widget.unitTitle}?\n'
                      'Entonces acepta mi desafío...\n\n'
                      'Responde antes de que caiga\n'
                      'la sombra del tiempo.\n\n'
                      'Llega a 8 aciertos y habrás\n'
                      'derrotado al Gran Oráculo.\n'
                      'Pero si yo llego a 10... 💀"',
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: ArcanaColors.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_bestRecord > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: ArcanaColors.gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: ArcanaColors.gold.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '🏆 Tu récord: $_bestRecord aciertos',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: ArcanaColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 28),
                  ArcanaGoldButton(
                    text: '💀 ACEPTAR EL DESAFÍO',
                    width: 280,
                    onPressed: () =>
                        setState(() => _phase = 'duel'),
                  ),
                  const SizedBox(height: 12),
                  ArcanaOutlinedButton(
                    text: 'Volver',
                    icon: Icons.arrow_back,
                    color: ArcanaColors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Duel screen ───────────────────────────────────────────
  Widget _buildDuel() {
    final exercise = _currentExercise;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: SafeArea(
        child: Column(
          children: [
            // ── Dual score bar ───────────────────────────
            _buildDualBar(),
            const SizedBox(height: 8),

            // ── Fighters row with ray ────────────────────
            _buildFighters(),
            const SizedBox(height: 12),

            // ── Question + options ───────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildQuestionCard(exercise),
                    const SizedBox(height: 12),
                    if (exercise.type == 'multiple_choice' ||
                        exercise.type == 'true_false')
                      _buildOptions(exercise),
                    if (_answered && exercise.explanation != null) ...[
                      const SizedBox(height: 10),
                      _buildExplanationBubble(exercise.explanation!),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dual score bar ────────────────────────────────────────
  Widget _buildDualBar() {
    final playerRatio = _playerScore / _playerWin;
    final oracleRatio = _oracleScore / _oracleWin;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.black.withValues(alpha: 0.4),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white38, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              // Player label + score
              Text(
                '🧙 $_playerScore',
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: ArcanaColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Text(
                'VS',
                style: ArcanaTextStyles.caption.copyWith(
                  color: Colors.white38,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Text(
                '$_oracleScore 💀',
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              // Target indicators
              Text(
                '/$_playerWin',
                style: ArcanaTextStyles.caption.copyWith(
                    color: Colors.white24, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Double bar
          Row(
            children: [
              // Player bar (left, gold)
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 300),
                      widthFactor: playerRatio.clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            ArcanaColors.gold.withValues(alpha: 0.6),
                            ArcanaColors.gold,
                          ]),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                                color: ArcanaColors.gold.withValues(alpha: 0.4),
                                blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Oracle bar (right, red)
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 300),
                        widthFactor: oracleRatio.clamp(0.0, 1.0),
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xFFEF4444),
                              Color(0xFF991B1B),
                            ]),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFEF4444)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Derrota al Oráculo llegando a $_playerWin  ·  Él te vence si llega a $_oracleWin',
            style: ArcanaTextStyles.caption
                .copyWith(color: Colors.white24, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Fighters row ──────────────────────────────────────────
  Widget _buildFighters() {
    return SizedBox(
      height: 70,
      child: AnimatedBuilder(
        animation: _rayController,
        builder: (_, __) {
          return Stack(
            children: [
              // Ray painter
              Positioned.fill(
                child: CustomPaint(
                  painter: _OracleRayPainter(
                    progress: _rayController.value,
                    leftToRight: _correct,
                  ),
                ),
              ),
              // Fighters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Player wizard
                  AnimatedBuilder(
                    animation: _playerShakeCtrl,
                    builder: (_, child) {
                      final shake =
                          math.sin(_playerShakeCtrl.value * math.pi * 6) * 4;
                      return Transform.translate(
                          offset: Offset(shake, 0), child: child);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🧙', style: TextStyle(fontSize: 32)),
                          Text('TÚ',
                              style: ArcanaTextStyles.caption.copyWith(
                                  color: ArcanaColors.gold, fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
                  // Oracle
                  AnimatedBuilder(
                    animation: _oracleShakeCtrl,
                    builder: (_, child) {
                      final shake =
                          math.sin(_oracleShakeCtrl.value * math.pi * 6) * 4;
                      return Transform.translate(
                          offset: Offset(-shake, 0), child: child);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💀', style: TextStyle(fontSize: 32)),
                          Text('ORÁCULO',
                              style: ArcanaTextStyles.caption.copyWith(
                                  color: const Color(0xFFEF4444), fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Question card ─────────────────────────────────────────
  Widget _buildQuestionCard(_DuelExercise ex) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _answered
              ? (_correct
                  ? ArcanaColors.gold.withValues(alpha: 0.6)
                  : const Color(0xFFEF4444).withValues(alpha: 0.6))
              : Colors.white12,
          width: 1.5,
        ),
      ),
      child: Text(
        ex.question,
        style: ArcanaTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontSize: 16,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ── Options ───────────────────────────────────────────────
  Widget _buildOptions(_DuelExercise ex) {
    final options = ex.options ?? [];
    return Column(
      children: List.generate(options.length, (i) {
        final opt = options[i];
        final isSelected = _selectedOption == opt;
        final isCorrect = opt == ex.answer;

        Color bg = const Color(0xFF1A0A2E);
        Color border = Colors.white12;
        Color text = Colors.white;

        if (_answered) {
          if (isCorrect) {
            bg = ArcanaColors.gold.withValues(alpha: 0.12);
            border = ArcanaColors.gold;
            text = ArcanaColors.gold;
          } else if (isSelected) {
            bg = const Color(0xFFEF4444).withValues(alpha: 0.12);
            border = const Color(0xFFEF4444);
            text = const Color(0xFFEF4444);
          }
        } else if (isSelected) {
          border = widget.accentColor;
        }

        return GestureDetector(
          onTap: () => _submitAnswer(opt),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: border.withValues(alpha: 0.15),
                    border: Border.all(color: border),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: TextStyle(
                          color: text,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(opt,
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: text,
                        fontSize: 15,
                        fontWeight:
                            isCorrect && _answered ? FontWeight.bold : FontWeight.normal,
                      )),
                ),
                if (_answered) ...[
                  const SizedBox(width: 8),
                  Text(isCorrect ? '✓' : (isSelected ? '✗' : ''),
                      style: TextStyle(
                          color: isCorrect ? ArcanaColors.gold : const Color(0xFFEF4444),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Explanation bubble ────────────────────────────────────
  Widget _buildExplanationBubble(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (_correct ? ArcanaColors.gold : const Color(0xFFEF4444))
            .withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (_correct ? ArcanaColors.gold : const Color(0xFFEF4444))
              .withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_correct ? '💡' : '📖', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: ArcanaTextStyles.caption.copyWith(
                    color: ArcanaColors.textSecondary, fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }

  // ── Result screen ─────────────────────────────────────────
  Widget _buildResult({required bool won}) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(
            particleCount: won ? 40 : 15,
            color: won ? ArcanaColors.gold : const Color(0xFFEF4444),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      won ? '⚡' : '💀',
                      style: const TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      won
                          ? '¡Has derrotado al Gran Oráculo!'
                          : 'El Oráculo te ha vencido...',
                      style: ArcanaTextStyles.heroTitle.copyWith(
                        color: won ? ArcanaColors.gold : const Color(0xFFEF4444),
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      won
                          ? '"…Impresionante. El Gran Oráculo inclina\n su cabeza ante ti."'
                          : '"Interesante… Pocos llegan tan lejos.\nVuelve cuando estés listo, hechicero."',
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: ArcanaColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Score display
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ScoreChip(
                              label: 'Tus aciertos',
                              value: '$_playerScore',
                              color: ArcanaColors.gold),
                          _ScoreChip(
                              label: 'Del Oráculo',
                              value: '$_oracleScore',
                              color: const Color(0xFFEF4444)),
                          if (_bestRecord > 0)
                            _ScoreChip(
                                label: 'Récord',
                                value: '$_bestRecord',
                                color: const Color(0xFFa78bfa)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    ArcanaGoldButton(
                      text: '🔄 VOLVER A INTENTARLO',
                      width: 280,
                      onPressed: _restart,
                    ),
                    const SizedBox(height: 12),
                    ArcanaOutlinedButton(
                      text: 'Volver al Grimoiro',
                      icon: Icons.arrow_back,
                      color: ArcanaColors.textSecondary,
                      onPressed: () => Navigator.of(context).pop(),
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

// ══════════════════════════════════════════════
// Score chip (result screen)
// ══════════════════════════════════════════════
class _ScoreChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ScoreChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: ArcanaTextStyles.heroTitle
                .copyWith(color: color, fontSize: 28)),
        Text(label,
            style: ArcanaTextStyles.caption
                .copyWith(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}

// ══════════════════════════════════════════════
// Oracle Ray Painter
// ══════════════════════════════════════════════
class _OracleRayPainter extends CustomPainter {
  final double progress;
  final bool leftToRight;

  _OracleRayPainter({required this.progress, required this.leftToRight});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final color =
        leftToRight ? ArcanaColors.gold : const Color(0xFFEF4444);
    final startX = leftToRight ? 60.0 : size.width - 60;
    final endX = leftToRight ? size.width - 60 : 60.0;
    final cy = size.height / 2;
    final cx = startX + (endX - startX) * progress.clamp(0.0, 1.0);

    final ray = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0), color, color.withValues(alpha: 0.9)],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTRB(math.min(startX, cx), cy - 3,
          math.max(startX, cx), cy + 3))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(Offset(startX, cy), Offset(cx, cy), ray);

    final glow = Paint()
      ..color = color.withValues(alpha: 0.3 * progress)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawLine(Offset(startX, cy), Offset(cx, cy), glow);

    canvas.drawCircle(
        Offset(cx, cy), 6 * progress,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.9)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(Offset(cx, cy), 3 * progress, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _OracleRayPainter old) =>
      old.progress != progress;
}

// ══════════════════════════════════════════════
// Exercise model
// ══════════════════════════════════════════════
class _DuelExercise {
  final String question;
  final String type;
  final List<String>? options;
  final String answer;
  final String? hint;
  final String? explanation;

  const _DuelExercise({
    required this.question,
    required this.type,
    this.options,
    required this.answer,
    this.hint,
    this.explanation,
  });
}
