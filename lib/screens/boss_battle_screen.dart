import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/arcana_buttons.dart';
import '../widgets/magical_particles.dart';

/// Pantalla de Boss Battle — Combate por turnos.
/// El jugador debe responder preguntas correctamente para hacer daño al boss.
/// Si falla, el boss ataca. Barra de vida del boss + vida del jugador.
class BossBattleScreen extends StatefulWidget {
  final String bossName;
  final String bossAsset;
  final Color gemColor;
  final int bossMaxHp;
  final int playerMaxHp;

  const BossBattleScreen({
    super.key,
    required this.bossName,
    this.bossAsset = 'assets/images/bosses/shadow_lord.png',
    required this.gemColor,
    this.bossMaxHp = 100,
    this.playerMaxHp = 3,
  });

  @override
  State<BossBattleScreen> createState() => _BossBattleScreenState();
}

class _BossBattleScreenState extends State<BossBattleScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _shakeController;
  late AnimationController _bossIdleController;

  int _bossHp = 100;
  int _playerHp = 3;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _isCorrect = false;
  bool _battleEnded = false;
  bool _playerWon = false;

  // Preguntas de demo para el boss
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuánto es 7 × 8?',
      'options': ['54', '56', '58', '64'],
      'correct': 1,
    },
    {
      'question': '¿Cuál es el resultado de 144 ÷ 12?',
      'options': ['11', '12', '13', '14'],
      'correct': 1,
    },
    {
      'question': 'Si un triángulo tiene lados de 3, 4 y 5 cm, ¿es rectángulo?',
      'options': ['No, es equilátero', 'Sí, es rectángulo', 'No, es isósceles', 'Es imposible'],
      'correct': 1,
    },
    {
      'question': '¿Cuánto es 25% de 200?',
      'options': ['25', '40', '50', '75'],
      'correct': 2,
    },
    {
      'question': '¿Cuántos minutos hay en 2 horas y media?',
      'options': ['120', '130', '140', '150'],
      'correct': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _bossHp = widget.bossMaxHp;
    _playerHp = widget.playerMaxHp;

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bossIdleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entryController.dispose();
    _shakeController.dispose();
    _bossIdleController.dispose();
    super.dispose();
  }

  void _advanceToNextQuestion() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || _battleEnded) return;
      setState(() {
        _currentQuestion = (_currentQuestion + 1) % _questions.length;
        _selectedAnswer = null;
        _answered = false;
        _isCorrect = false;
      });
    });
  }

  void _selectAnswer(int index) {
    if (_answered || _battleEnded) return;

    final question = _questions[_currentQuestion];
    final correct = index == question['correct'];

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _isCorrect = correct;
    });

    if (correct) {
      // Daño al boss
      _shakeController.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _bossHp = (_bossHp - 25).clamp(0, widget.bossMaxHp);
          if (_bossHp <= 0) {
            _battleEnded = true;
            _playerWon = true;
          }
        });
        // Solo avanzar si la batalla NO ha terminado
        if (!_battleEnded) _advanceToNextQuestion();
      });
    } else {
      // Boss ataca al jugador
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() {
          _playerHp = (_playerHp - 1).clamp(0, widget.playerMaxHp);
          if (_playerHp <= 0) {
            _battleEnded = true;
            _playerWon = false;
          }
        });
        // Solo avanzar si la batalla NO ha terminado
        if (!_battleEnded) _advanceToNextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo oscuro amenazante
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  widget.gemColor.withValues(alpha: 0.15),
                  const Color(0xFF0A0510),
                ],
              ),
            ),
          ),

          // Partículas rojas/violetas
          MagicalParticles(
            particleCount: 30,
            color: ArcanaColors.ruby,
            maxSize: 2.5,
          ),

          SafeArea(
            child: _battleEnded ? _buildBattleResult() : _buildBattleUI(),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleUI() {
    return Column(
      children: [
        // ─── Boss Area ─────────────────
        _buildBossArea(),

        const SizedBox(height: 8),

        // ─── Pregunta y opciones ───────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildQuestion(),
                const SizedBox(height: 16),
                _buildAnswerOptions(),
              ],
            ),
          ),
        ),

        // ─── Vidas del jugador ─────────
        _buildPlayerHp(),

        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBossArea() {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeController, _bossIdleController]),
      builder: (context, child) {
        // Efecto shake cuando recibe daño
        final shakeOffset = math.sin(_shakeController.value * math.pi * 6) *
            (1 - _shakeController.value) * 10;

        // Movimiento idle del boss
        final idleOffset = math.sin(_bossIdleController.value * math.pi * 2) * 4;

        return Transform.translate(
          offset: Offset(shakeOffset, idleOffset),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Nombre del boss
                Text(
                  '⚔️ ${widget.bossName}',
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: ArcanaColors.ruby,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),

                // Barra de vida del boss
                _buildBossHpBar(),

                const SizedBox(height: 12),

                // Sprite del boss
                Expanded(
                  child: Image.asset(
                    widget.bossAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, e, s) => Icon(
                      Icons.whatshot,
                      color: ArcanaColors.ruby,
                      size: 64,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBossHpBar() {
    final hpRatio = _bossHp / widget.bossMaxHp;
    final hpColor = hpRatio > 0.5
        ? ArcanaColors.ruby
        : hpRatio > 0.25
            ? Colors.orange
            : Colors.red;

    return Column(
      children: [
        Container(
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: ArcanaColors.surfaceBorder,
            borderRadius: BorderRadius.circular(6),
          ),
          child: AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 500),
            alignment: Alignment.centerLeft,
            widthFactor: hpRatio.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [hpColor.withValues(alpha: 0.7), hpColor],
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: hpColor.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$_bossHp/${widget.bossMaxHp} HP',
          style: ArcanaTextStyles.caption.copyWith(
            color: hpColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    final question = _questions[_currentQuestion];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.gemColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        question['question'] as String,
        style: ArcanaTextStyles.bodyLarge.copyWith(
          color: ArcanaColors.textPrimary,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerOptions() {
    final question = _questions[_currentQuestion];
    final options = question['options'] as List<String>;
    final correctIdx = question['correct'] as int;

    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = _selectedAnswer == index;
        final isCorrectOption = index == correctIdx;

        Color bgColor = ArcanaColors.surface;
        Color borderColor = ArcanaColors.surfaceBorder;

        if (_answered) {
          if (isCorrectOption) {
            bgColor = ArcanaColors.emerald.withValues(alpha: 0.15);
            borderColor = ArcanaColors.emerald;
          } else if (isSelected && !_isCorrect) {
            bgColor = ArcanaColors.ruby.withValues(alpha: 0.15);
            borderColor = ArcanaColors.ruby;
          } else {
            bgColor = ArcanaColors.surface.withValues(alpha: 0.4);
            borderColor = ArcanaColors.surfaceBorder.withValues(alpha: 0.3);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => _selectAnswer(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: borderColor.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: ArcanaTextStyles.caption.copyWith(
                          color: _answered && isCorrectOption
                              ? ArcanaColors.emerald
                              : ArcanaColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      options[index],
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: _answered && !isCorrectOption && !isSelected
                            ? ArcanaColors.textMuted
                            : ArcanaColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_answered && isCorrectOption)
                    const Icon(Icons.check_circle, color: ArcanaColors.emerald, size: 20),
                  if (_answered && isSelected && !_isCorrect)
                    const Icon(Icons.cancel, color: ArcanaColors.ruby, size: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlayerHp() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.surfaceBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tus vidas: ',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textSecondary,
            ),
          ),
          ...List.generate(widget.playerMaxHp, (i) {
            final isAlive = i < _playerHp;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedScale(
                scale: isAlive ? 1.0 : 0.6,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isAlive ? Icons.favorite : Icons.favorite_border,
                  color: isAlive ? ArcanaColors.ruby : ArcanaColors.textMuted,
                  size: 24,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBattleResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono de resultado
          Icon(
            _playerWon ? Icons.emoji_events : Icons.replay,
            color: _playerWon ? ArcanaColors.gold : ArcanaColors.ruby,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            _playerWon ? '¡VICTORIA!' : '¡Boss te ha derrotado!',
            style: ArcanaTextStyles.heroTitle.copyWith(
              color: _playerWon ? ArcanaColors.gold : ArcanaColors.ruby,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _playerWon
                ? 'Has derrotado a ${widget.bossName}'
                : 'Entrena más y vuelve a intentarlo',
            style: ArcanaTextStyles.bodyMedium.copyWith(
              color: ArcanaColors.textSecondary,
            ),
          ),
          if (_playerWon) ...[
            const SizedBox(height: 16),
            Text('+200 XP  ·  +50 monedas', style: ArcanaTextStyles.xpValue),
          ],
          const SizedBox(height: 32),
          ArcanaGoldButton(
            text: _playerWon ? 'Continuar' : 'Reintentar',
            icon: _playerWon ? Icons.arrow_forward : Icons.replay,
            width: 240,
            onPressed: () {
              if (_playerWon) {
                Navigator.of(context).pop(true);
              } else {
                // Reset battle
                setState(() {
                  _bossHp = widget.bossMaxHp;
                  _playerHp = widget.playerMaxHp;
                  _currentQuestion = 0;
                  _selectedAnswer = null;
                  _answered = false;
                  _isCorrect = false;
                  _battleEnded = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
