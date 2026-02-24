import 'package:flutter/material.dart';
import '../theme/arcana_game_theme.dart';
import '../theme/arcana_colors.dart';

/// Tarjeta de pregunta de combate — el "grimorio" central.
/// Usa el design system de ArcanaGameTheme.
class ArcanaQuestionCard extends StatelessWidget {
  final String question;
  final Color? kingdomColor;
  final List<String> options;
  final int? selectedIndex;
  final int? correctIndex;
  final bool answered;
  final void Function(int index) onOptionTap;

  const ArcanaQuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.onOptionTap,
    this.kingdomColor,
    this.selectedIndex,
    this.correctIndex,
    this.answered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ArcanaGameTheme.questionCard(borderColor: kingdomColor),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Pregunta ─────────────────────────
          Text(
            question,
            style: ArcanaGameTheme.question,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // ─── Opciones ─────────────────────────
          ...List.generate(options.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AnswerButton(
                label: options[i],
                index: i,
                answered: answered,
                isSelected: selectedIndex == i,
                isCorrect: correctIndex == i,
                kingdomColor: kingdomColor,
                onTap: answered ? null : () => onOptionTap(i),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final int index;
  final bool answered;
  final bool isSelected;
  final bool isCorrect;
  final Color? kingdomColor;
  final VoidCallback? onTap;

  const _AnswerButton({
    required this.label,
    required this.index,
    required this.answered,
    required this.isSelected,
    required this.isCorrect,
    this.kingdomColor,
    this.onTap,
  });

  BoxDecoration get _decoration {
    if (!answered) {
      return ArcanaGameTheme.answerButton(kingdomColor: kingdomColor);
    }
    if (isCorrect) return ArcanaGameTheme.answerButtonCorrect;
    if (isSelected && !isCorrect) return ArcanaGameTheme.answerButtonWrong;
    return ArcanaGameTheme.answerButtonFaded;
  }

  @override
  Widget build(BuildContext context) {
    final letters = ['A', 'B', 'C', 'D'];
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 64),
        decoration: _decoration,
        padding: ArcanaGameTheme.answerButtonPadding,
        child: Row(
          children: [
            // Letra
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
                style: ArcanaGameTheme.answerOption.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: ArcanaGameTheme.answerOption),
            ),
            if (answered && isCorrect)
              const Icon(Icons.check_circle_rounded,
                  color: ArcanaGameTheme.hitGreen, size: 24),
            if (answered && isSelected && !isCorrect)
              const Icon(Icons.cancel_rounded,
                  color: ArcanaGameTheme.hitRed, size: 24),
          ],
        ),
      ),
    );
  }
}
