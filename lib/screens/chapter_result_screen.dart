import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/arcana_buttons.dart';
import '../widgets/magical_particles.dart';

/// Pantalla de resultados al terminar un capítulo.
/// Muestra XP ganada, estrellas, estadísticas y botón de continuar.
class ChapterResultScreen extends StatefulWidget {
  final String chapterTitle;
  final int xpEarned;
  final int coinsEarned;
  final int correctAnswers;
  final int totalQuestions;
  final Color gemColor;

  const ChapterResultScreen({
    super.key,
    required this.chapterTitle,
    this.xpEarned = 150,
    this.coinsEarned = 25,
    this.correctAnswers = 5,
    this.totalQuestions = 6,
    required this.gemColor,
  });

  @override
  State<ChapterResultScreen> createState() => _ChapterResultScreenState();
}

class _ChapterResultScreenState extends State<ChapterResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _stars {
    final ratio = widget.correctAnswers / widget.totalQuestions;
    if (ratio >= 0.9) return 3;
    if (ratio >= 0.7) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Partículas doradas de celebración
          const MagicalParticles(
            particleCount: 50,
            color: ArcanaColors.gold,
            maxSize: 3.0,
          ),

          SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Título "¡Capítulo completado!"
                    _buildTitle(),

                    const SizedBox(height: 24),

                    // Estrellas
                    _buildStars(),

                    const SizedBox(height: 32),

                    // Recompensas
                    _buildRewards(),

                    const SizedBox(height: 24),

                    // Stats
                    _buildStats(),

                    const Spacer(flex: 3),

                    // Botón continuar
                    _buildContinueButton(),

                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fade,
      child: Column(
        children: [
          Text(
            '¡Capítulo Completado!',
            style: ArcanaTextStyles.screenTitle.copyWith(
              color: ArcanaColors.gold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.chapterTitle,
            style: ArcanaTextStyles.subtitle.copyWith(
              color: ArcanaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final delay = 0.2 + i * 0.15;
        final starScale = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              delay.clamp(0.0, 1.0),
              (delay + 0.2).clamp(0.0, 1.0),
              curve: Curves.elasticOut,
            ),
          ),
        );

        final isEarned = i < _stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ScaleTransition(
            scale: starScale,
            child: Icon(
              isEarned ? Icons.star : Icons.star_border,
              color: isEarned ? ArcanaColors.gold : ArcanaColors.textMuted,
              size: i == 1 ? 56 : 44, // Estrella central más grande
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRewards() {
    final fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fade,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRewardChip(Icons.star, '+${widget.xpEarned} XP', ArcanaColors.turquoise),
          const SizedBox(width: 24),
          _buildRewardChip(Icons.monetization_on, '+${widget.coinsEarned}', ArcanaColors.gold),
        ],
      ),
    );
  }

  Widget _buildRewardChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(
            text,
            style: ArcanaTextStyles.cardTitle.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fade,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 48),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ArcanaColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ArcanaColors.surfaceBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('Respuestas', '${widget.correctAnswers}/${widget.totalQuestions}'),
            Container(width: 1, height: 32, color: ArcanaColors.surfaceBorder),
            _buildStatItem('Precisión', '${((widget.correctAnswers / widget.totalQuestions) * 100).round()}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: ArcanaTextStyles.cardTitle.copyWith(
            color: ArcanaColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: ArcanaTextStyles.caption.copyWith(
            color: ArcanaColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    final fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
    );

    return FadeTransition(
      opacity: fade,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: ArcanaGoldButton(
          text: 'Volver al Mapa',
          icon: Icons.map,
          width: 280,
          onPressed: () {
            // Pop hasta el mapa
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
