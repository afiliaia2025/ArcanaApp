import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';
import '../../widgets/magical_particles.dart';

// ═══════════════════════════════════════════════════════════
// ORION TRAINING SCREEN — Entrenamiento con Orión
// ═══════════════════════════════════════════════════════════
//
// Modo de práctica infinita, sin timer, sin presión.
// Orión guía al jugador a través de 3 tipos de ejercicio:
//   1. FlashCard  — ver la pregunta, voltear para ver la respuesta
//   2. MultipleChoice — elegir la respuesta correcta (MCQ / T/F)
//   3. FillReveal — ver la respuesta censurada, elegir la correcta
//
// Métricas:
//   🔥 Racha  — contador de aciertos consecutivos (reset al fallar)
//   📊 Total  — total de ejercicios completados en la sesión
//
// No hay derrota. Solo aprendizaje continuo.
// ═══════════════════════════════════════════════════════════

// ── Exercise data model ───────────────────────────────────
class _TrainingExercise {
  final String question;
  final String type; // multiple_choice | true_false | fill_blank
  final List<String>? options;
  final String answer;
  final String? hint;
  final String? explanation;

  const _TrainingExercise({
    required this.question,
    required this.type,
    this.options,
    required this.answer,
    this.hint,
    this.explanation,
  });
}

// ── Exercise mode for the UI ──────────────────────────────
enum _TrainingMode { flashcard, multipleChoice }

// ══════════════════════════════════════════════════════════
// Main Widget
// ══════════════════════════════════════════════════════════
class OrionTrainingScreen extends StatefulWidget {
  final int unitNumber;
  final String unitTitle;
  final String jsonAsset;
  final Color accentColor;

  const OrionTrainingScreen({
    super.key,
    required this.unitNumber,
    required this.unitTitle,
    required this.jsonAsset,
    required this.accentColor,
  });

  @override
  State<OrionTrainingScreen> createState() => _OrionTrainingScreenState();
}

class _OrionTrainingScreenState extends State<OrionTrainingScreen>
    with TickerProviderStateMixin {
  // ── Data ─────────────────────────────────────────────────
  List<_TrainingExercise> _pool = [];
  List<_TrainingExercise> _missed = []; // Spaced repetition pool
  bool _loading = true;

  // ── Session state ─────────────────────────────────────────
  int _streak = 0;
  int _bestStreak = 0;
  int _totalDone = 0;
  int _currentIndex = 0;

  // ── Current exercise UI state ─────────────────────────────
  _TrainingMode _mode = _TrainingMode.multipleChoice;
  bool _answered = false;
  bool _correct = false;
  String? _selectedOption;
  bool _cardFlipped = false; // For flashcard mode

  // ── Animations ────────────────────────────────────────────
  late AnimationController _streakPulse;
  late AnimationController _cardFlip;
  late AnimationController _feedbackPulse;

  final _random = math.Random();

  // ── Orión messages ────────────────────────────────────────
  static const List<String> _correctMessages = [
    '✨ ¡Perfecto! Sigo con tí.',
    '🔥 ¡Eso es! La racha continúa.',
    '⚡ ¡Excelente! Eres digno de BABEL.',
    '🌟 ¡Bien hecho, hechicero! Sigue así.',
    '💫 ¡Impresionante! Tu mente es aguda.',
  ];
  static const List<String> _wrongMessages = [
    '📖 No pasa nada. Recuérdalo bien.',
    '🌙 Ese nos costará. Pero aprenderás.',
    '💡 La respuesta correcta es importante. Aún así, sigue.',
    '🔮 Los grandes magos también se equivocan. Adelante.',
  ];


  String _orionMessage = '🧙 Orión dice: "Practiquemos. No hay prisa."';

  @override
  void initState() {
    super.initState();
    _streakPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 1.0,
      upperBound: 1.3,
    );
    _cardFlip = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _feedbackPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _loadData();
  }

  @override
  void dispose() {
    _streakPulse.dispose();
    _cardFlip.dispose();
    _feedbackPulse.dispose();
    super.dispose();
  }

  // ── Load exercises ────────────────────────────────────────
  Future<void> _loadData() async {
    try {
      final jsonStr = await rootBundle.loadString(widget.jsonAsset);
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final sections = data['sections'] as List;
      final all = <_TrainingExercise>[];

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

          all.add(_TrainingExercise(
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
        _pool = all;
        _loading = false;
        _pickMode();
      });
    } catch (e) {
      debugPrint('OrionTraining load error: $e');
    }
  }

  // ── Pick a mode for the current exercise ──────────────────
  void _pickMode() {
    final ex = _currentExercise;
    if (ex.type == 'fill_blank') {
      _mode = _TrainingMode.flashcard; // fill_blank → show as flashcard
    } else {
      // Occasionally serve flashcard for variety (30% chance)
      _mode = (_random.nextDouble() < 0.3)
          ? _TrainingMode.flashcard
          : _TrainingMode.multipleChoice;
    }
    _cardFlipped = false;
  }

  _TrainingExercise get _currentExercise {
    // Use missed pool if it has grown large (spaced repetition)
    if (_missed.length >= 5 && _random.nextDouble() < 0.4) {
      final ex = _missed[_random.nextInt(_missed.length)];
      return ex;
    }
    return _pool[_currentIndex % _pool.length];
  }

  // ── Submit answer ─────────────────────────────────────────
  void _submitAnswer(String answer) {
    if (_answered) return;
    final correct =
        answer.trim().toLowerCase() == _currentExercise.answer.trim().toLowerCase();

    setState(() {
      _answered = true;
      _correct = correct;
      _selectedOption = answer;
      _totalDone++;

      if (correct) {
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
        // Remove from missed if it was there
        _missed.removeWhere((e) => e.question == _currentExercise.question);
        // Orión message
        final streakKey = _streak;
        final specialMsg = (streakKey == 5 || streakKey == 10 ||
                streakKey == 15 || streakKey == 20)
            ? _getStreakMsg(streakKey)
            : null;
        _orionMessage = specialMsg ??
            _correctMessages[_random.nextInt(_correctMessages.length)];
        _streakPulse.forward(from: 0).then((_) => _streakPulse.reverse());
      } else {
        _streak = 0;
        // Add to missed pool for spaced repetition
        _missed.add(_currentExercise);
        _orionMessage =
            _wrongMessages[_random.nextInt(_wrongMessages.length)];
      }
    });

    _feedbackPulse.forward(from: 0).then((_) => _feedbackPulse.reverse());
  }

  String? _getStreakMsg(int streak) {
    const msgs = {
      5: '🔥 ¡5 seguidas! ¡Tu magia crece!',
      10: '⚡ ¡10! ¡Increíble! ¡Eres una leyenda!',
      15: '🏆 ¡15 en racha! ¡El Oráculo tiembla!',
      20: '💎 ¡20 seguidas! ¡Maestro de BABEL!',
    };
    return msgs[streak];
  }

  void _next() {
    setState(() {
      _currentIndex++;
      _answered = false;
      _correct = false;
      _selectedOption = null;
      _cardFlipped = false;
      _pickMode();
      if (_answered == false) {
        _orionMessage = '🧙 Orión: "Siguiente. Tú puedes."';
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0510),
        body: const Center(
            child: CircularProgressIndicator(color: ArcanaColors.gold)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(
              particleCount: 15, color: const Color(0xFFF97316), maxSize: 2),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                _buildOrionBubble(),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        if (_mode == _TrainingMode.flashcard)
                          _buildFlashcard()
                        else
                          _buildMultipleChoice(),
                        const SizedBox(height: 12),
                        if (_answered) _buildFeedbackBar(),
                        const SizedBox(height: 8),
                        if (_answered) _buildNextButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.black.withValues(alpha: 0.4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          // Mode label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color(0xFFF97316).withValues(alpha: 0.4)),
            ),
            child: Text(
              '🔥 ORIÓN · UNIT ${widget.unitNumber}',
              style: ArcanaTextStyles.caption.copyWith(
                color: const Color(0xFFF97316),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Spacer(),
          // Streak
          AnimatedBuilder(
            animation: _streakPulse,
            builder: (_, child) => Transform.scale(
              scale: _streakPulse.value,
              child: child,
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text(
                  '$_streak',
                  style: ArcanaTextStyles.bodyMedium.copyWith(
                    color: _streak > 0
                        ? const Color(0xFFF97316)
                        : Colors.white38,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Total done
          Text(
            '📚 $_totalDone',
            style: ArcanaTextStyles.caption.copyWith(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ── Orión bubble ──────────────────────────────────────────
  Widget _buildOrionBubble() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(_orionMessage),
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0A2E),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
              color: const Color(0xFFF97316).withValues(alpha: 0.25)),
        ),
        child: Text(
          _orionMessage,
          style: ArcanaTextStyles.caption.copyWith(
            color: ArcanaColors.textSecondary,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  // ── Flashcard ─────────────────────────────────────────────
  Widget _buildFlashcard() {
    return GestureDetector(
      onTap: () {
        if (!_cardFlipped) {
          setState(() => _cardFlipped = true);
          _cardFlip.forward(from: 0);
        }
      },
      child: AnimatedBuilder(
        animation: _cardFlip,
        builder: (_, child) {
          final angle = _cardFlip.value * math.pi;
          final isFront = angle < math.pi / 2;
          final displayAngle = isFront ? angle : angle - math.pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(displayAngle),
            child: isFront ? _flashcardFront() : _flashcardBack(),
          );
        },
      ),
    );
  }

  Widget _flashcardFront() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A0A2E),
            widget.accentColor.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            _currentExercise.question,
            style: ArcanaTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 18,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_currentExercise.hint != null)
            Text(
              '💡 ${_currentExercise.hint}',
              style: ArcanaTextStyles.caption.copyWith(
                color: Colors.white38,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              '👆 Toca para ver la respuesta',
              style: ArcanaTextStyles.caption.copyWith(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _flashcardBack() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ArcanaColors.gold.withValues(alpha: 0.1),
            const Color(0xFF1A0A2E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: ArcanaColors.gold.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        children: [
          Text(
            '✅ Respuesta:',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.gold.withValues(alpha: 0.7),
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _currentExercise.answer,
            style: ArcanaTextStyles.heroTitle.copyWith(
              color: ArcanaColors.gold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          if (_currentExercise.explanation != null) ...[
            const SizedBox(height: 12),
            Text(
              _currentExercise.explanation!,
              style: ArcanaTextStyles.caption.copyWith(
                color: ArcanaColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 20),
          // Self-assessment buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SelfAssessBtn(
                label: '❌ No lo sabía',
                color: const Color(0xFFEF4444),
                onTap: () => _submitAnswer('__wrong__'),
              ),
              _SelfAssessBtn(
                label: '✅ Lo sabía',
                color: ArcanaColors.gold,
                onTap: () => _submitAnswer(_currentExercise.answer),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Multiple choice ───────────────────────────────────────
  Widget _buildMultipleChoice() {
    final ex = _currentExercise;
    return Column(
      children: [
        // Question card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0A2E),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _answered
                  ? (_correct
                      ? ArcanaColors.gold.withValues(alpha: 0.6)
                      : const Color(0xFFEF4444).withValues(alpha: 0.6))
                  : Colors.white12,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                ex.question,
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (ex.hint != null && !_answered) ...[
                const SizedBox(height: 8),
                Text(
                  '💡 ${ex.hint}',
                  style: ArcanaTextStyles.caption.copyWith(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Options
        if (ex.options != null)
          ...List.generate(ex.options!.length, (i) {
            final opt = ex.options![i];
            final isSelected = _selectedOption == opt;
            final isCorrect = opt == ex.answer;

            Color bg = const Color(0xFF1A0A2E);
            Color border = Colors.white12;
            Color textColor = Colors.white;

            if (_answered) {
              if (isCorrect) {
                bg = ArcanaColors.gold.withValues(alpha: 0.12);
                border = ArcanaColors.gold;
                textColor = ArcanaColors.gold;
              } else if (isSelected) {
                bg = const Color(0xFFEF4444).withValues(alpha: 0.12);
                border = const Color(0xFFEF4444);
                textColor = const Color(0xFFEF4444);
              }
            }

            return GestureDetector(
              onTap: () => _submitAnswer(opt),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
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
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        opt,
                        style: ArcanaTextStyles.bodyMedium.copyWith(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: isCorrect && _answered
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (_answered)
                      Text(
                        isCorrect ? '✓' : (isSelected ? '✗' : ''),
                        style: TextStyle(
                          color: isCorrect
                              ? ArcanaColors.gold
                              : const Color(0xFFEF4444),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  // ── Feedback bar ──────────────────────────────────────────
  Widget _buildFeedbackBar() {
    final ex = _currentExercise;
    return AnimatedBuilder(
      animation: _feedbackPulse,
      builder: (_, child) =>
          Transform.scale(scale: _feedbackPulse.value, child: child),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: (_correct ? ArcanaColors.gold : const Color(0xFFEF4444))
              .withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (_correct ? ArcanaColors.gold : const Color(0xFFEF4444))
                .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_correct ? '💡' : '📖',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                ex.explanation ??
                    (_correct ? 'Correcto!' : 'Respuesta: ${ex.answer}'),
                style: ArcanaTextStyles.caption.copyWith(
                  color: ArcanaColors.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Next button ───────────────────────────────────────────
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _next,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              (_correct ? ArcanaColors.gold : const Color(0xFFEF4444))
                  .withValues(alpha: 0.85),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(
          _correct ? '▶ Siguiente ($_streak🔥)' : '▶ Continuar',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Self-assessment button (flashcard back)
// ══════════════════════════════════════════════
class _SelfAssessBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SelfAssessBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
