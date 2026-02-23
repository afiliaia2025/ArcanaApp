import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/arcana_buttons.dart';

/// Tipos de challenge visual (skin del ejercicio).
enum ChallengeType { battle, trap, door, spell, potion, riddle, decode }

/// Pantalla de Ejercicio — el corazón del gameplay.
/// Muestra una pregunta con opciones de respuesta, ambientada según
/// el challengeType. Incluye feedback visual de acierto/error.
class ExerciseScreen extends StatefulWidget {
  final int chapterNumber;
  final int sceneIndex;
  final int totalScenes;
  final ChallengeType challengeType;
  final String question;
  final List<String> options;
  final int correctIndex;
  final Color gemColor;
  final String? hint;

  const ExerciseScreen({
    super.key,
    required this.chapterNumber,
    required this.sceneIndex,
    required this.totalScenes,
    this.challengeType = ChallengeType.battle,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.gemColor,
    this.hint,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  int? _selectedIndex;
  bool _answered = false;
  bool _isCorrect = false;
  bool _showHint = false;
  late AnimationController _entryController;
  late AnimationController _feedbackController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      _isCorrect = index == widget.correctIndex;
    });
    _feedbackController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.gemColor.withValues(alpha: 0.08),
                  ArcanaColors.background,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Icono del tipo de challenge
                _buildChallengeIcon(),

                const SizedBox(height: 12),

                // Pregunta
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildQuestion(),
                        const SizedBox(height: 20),
                        _buildOptions(),
                      ],
                    ),
                  ),
                ),

                // Feedback o pista
                if (_answered) _buildFeedback(),
                if (!_answered && widget.hint != null) _buildHintButton(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Cap ${widget.chapterNumber} · Escena ${widget.sceneIndex}/${widget.totalScenes}',
            style: ArcanaTextStyles.caption.copyWith(
              color: widget.gemColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Tipo de challenge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: widget.gemColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.gemColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getChallengeIcon(),
                  color: widget.gemColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _getChallengeLabel(),
                  style: ArcanaTextStyles.caption.copyWith(
                    color: widget.gemColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getChallengeIcon() {
    switch (widget.challengeType) {
      case ChallengeType.battle:
        return Icons.flash_on;
      case ChallengeType.trap:
        return Icons.warning;
      case ChallengeType.door:
        return Icons.door_front_door;
      case ChallengeType.spell:
        return Icons.auto_awesome;
      case ChallengeType.potion:
        return Icons.science;
      case ChallengeType.riddle:
        return Icons.psychology;
      case ChallengeType.decode:
        return Icons.translate;
    }
  }

  String _getChallengeLabel() {
    switch (widget.challengeType) {
      case ChallengeType.battle:
        return 'Batalla';
      case ChallengeType.trap:
        return 'Trampa';
      case ChallengeType.door:
        return 'Puerta';
      case ChallengeType.spell:
        return 'Hechizo';
      case ChallengeType.potion:
        return 'Poción';
      case ChallengeType.riddle:
        return 'Acertijo';
      case ChallengeType.decode:
        return 'Descifrar';
    }
  }

  Widget _buildChallengeIcon() {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
      child: Icon(
        _getChallengeIcon(),
        color: widget.gemColor.withValues(alpha: 0.5),
        size: 48,
      ),
    );
  }

  Widget _buildQuestion() {
    final questionFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: questionFade,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ArcanaColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.gemColor.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          widget.question,
          style: ArcanaTextStyles.bodyLarge.copyWith(
            color: ArcanaColors.textPrimary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(widget.options.length, (index) {
        final delay = 0.3 + index * 0.1;
        final optionFade = CurvedAnimation(
          parent: _entryController,
          curve: Interval(
            delay.clamp(0.0, 1.0),
            (delay + 0.3).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        );

        return FadeTransition(
          opacity: optionFade,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildOptionButton(index),
          ),
        );
      }),
    );
  }

  Widget _buildOptionButton(int index) {
    final isSelected = _selectedIndex == index;
    final isCorrectOption = index == widget.correctIndex;

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (!_answered) {
      // Estado normal
      bgColor = ArcanaColors.surface;
      borderColor = ArcanaColors.surfaceBorder;
      textColor = ArcanaColors.textPrimary;
    } else if (isCorrectOption) {
      // Opción correcta (siempre se muestra)
      bgColor = ArcanaColors.emerald.withValues(alpha: 0.15);
      borderColor = ArcanaColors.emerald;
      textColor = ArcanaColors.emerald;
    } else if (isSelected && !_isCorrect) {
      // Opción seleccionada incorrecta
      bgColor = ArcanaColors.ruby.withValues(alpha: 0.15);
      borderColor = ArcanaColors.ruby;
      textColor = ArcanaColors.ruby;
    } else {
      // Opciones no seleccionadas tras responder
      bgColor = ArcanaColors.surface.withValues(alpha: 0.5);
      borderColor = ArcanaColors.surfaceBorder.withValues(alpha: 0.5);
      textColor = ArcanaColors.textMuted;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: isSelected && _answered
              ? [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Letra de opción (A, B, C, D)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: ArcanaTextStyles.caption.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.options[index],
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: textColor,
                ),
              ),
            ),
            // Icono de resultado
            if (_answered && isCorrectOption)
              const Icon(Icons.check_circle, color: ArcanaColors.emerald, size: 22),
            if (_answered && isSelected && !_isCorrect)
              const Icon(Icons.cancel, color: ArcanaColors.ruby, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    return AnimatedBuilder(
      animation: _feedbackController,
      builder: (context, child) {
        final slideUp = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _feedbackController,
          curve: Curves.easeOutBack,
        ));

        return SlideTransition(
          position: slideUp,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isCorrect
                  ? ArcanaColors.emerald.withValues(alpha: 0.1)
                  : ArcanaColors.ruby.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isCorrect
                    ? ArcanaColors.emerald.withValues(alpha: 0.5)
                    : ArcanaColors.ruby.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _isCorrect ? Icons.celebration : Icons.replay,
                      color: _isCorrect ? ArcanaColors.gold : ArcanaColors.ruby,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCorrect ? '¡CORRECTO!' : 'Inténtalo de nuevo',
                      style: ArcanaTextStyles.cardTitle.copyWith(
                        color: _isCorrect
                            ? ArcanaColors.gold
                            : ArcanaColors.ruby,
                      ),
                    ),
                    const Spacer(),
                    if (_isCorrect)
                      Text(
                        '+50 XP',
                        style: ArcanaTextStyles.xpValue,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _isCorrect
                          ? ArcanaGoldButton(
                              text: 'Continuar →',
                              onPressed: () => Navigator.of(context).pop(true),
                            )
                          : ArcanaOutlinedButton(
                              text: 'Reintentar',
                              color: ArcanaColors.turquoise,
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = null;
                                  _answered = false;
                                  _isCorrect = false;
                                });
                                _feedbackController.reset();
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHintButton() {
    if (_showHint) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ArcanaColors.turquoise.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ArcanaColors.turquoise.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.auto_awesome,
              color: ArcanaColors.turquoise,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.hint!,
                style: ArcanaTextStyles.bodySmall.copyWith(
                  color: ArcanaColors.turquoise,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: ArcanaOutlinedButton(
        text: 'Pedir pista 🦉',
        color: ArcanaColors.turquoise,
        icon: Icons.auto_awesome,
        onPressed: () {
          setState(() => _showHint = true);
        },
      ),
    );
  }
}
