import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';

/// Modelo de datos para una gema/asignatura.
class GemData {
  final String name;
  final String subject;
  final Color color;
  final int completed;
  final int total;
  final String iconAsset; // Ruta al icono de gema
  final bool isLocked;

  const GemData({
    required this.name,
    required this.subject,
    required this.color,
    required this.completed,
    required this.total,
    required this.iconAsset,
    this.isLocked = false,
  });

  double get progress => completed / total;
  bool get isCompleted => completed >= total;
}

/// Card de gema para el Mapa Principal.
/// Muestra el icono de la gema, nombre, asignatura y progreso.
class GemCard extends StatefulWidget {
  final GemData data;
  final VoidCallback? onTap;

  const GemCard({super.key, required this.data, this.onTap});

  @override
  State<GemCard> createState() => _GemCardState();
}

class _GemCardState extends State<GemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gem = widget.data;
    return GestureDetector(
      onTap: gem.isLocked ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          final shimmerValue = _shimmerController.value;
          return Container(
            width: 160,
            height: 200,
            decoration: BoxDecoration(
              color: ArcanaColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: gem.isCompleted
                    ? ArcanaColors.gold
                    : gem.color.withValues(alpha: 0.6 + shimmerValue * 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: gem.color.withValues(alpha: 0.2 + shimmerValue * 0.1),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    _buildGemIcon(gem),
                    const SizedBox(height: 12),
                    Text(
                      gem.name.toUpperCase(),
                      style: ArcanaTextStyles.cardTitle.copyWith(
                        color: gem.isLocked ? ArcanaColors.textMuted : gem.color,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gem.subject,
                      style: ArcanaTextStyles.caption.copyWith(
                        color: gem.isLocked
                            ? ArcanaColors.textMuted.withValues(alpha: 0.5)
                            : gem.color.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildProgressBar(gem),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      gem.isLocked ? '🔒' : '${gem.completed}/${gem.total}',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: ArcanaColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                // Overlay de bloqueo
                if (gem.isLocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xCC0A0E1A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, color: ArcanaColors.textMuted, size: 32),
                          SizedBox(height: 6),
                          Text(
                            'Bloqueado',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              color: ArcanaColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGemIcon(GemData gem) {
    // Intenta cargar el icono de asset; si falla, muestra un fallback
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gem.color.withValues(alpha: 0.15),
        border: Border.all(color: gem.color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: gem.color.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          gem.iconAsset,
          width: 40,
          height: 40,
          errorBuilder: (_, e, s) => Icon(
            _getFallbackIcon(gem.name),
            color: gem.color,
            size: 28,
          ),
        ),
      ),
    );
  }

  IconData _getFallbackIcon(String gemName) {
    switch (gemName.toLowerCase()) {
      case 'ignis':
        return Icons.diamond_outlined;
      case 'lexis':
        return Icons.auto_stories;
      case 'sylva':
        return Icons.eco;
      case 'babel':
        return Icons.language;
      default:
        return Icons.star;
    }
  }

  Widget _buildProgressBar(GemData gem) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: ArcanaColors.surfaceBorder,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: gem.progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gem.isCompleted
                  ? [ArcanaColors.goldDark, ArcanaColors.gold]
                  : [gem.color.withValues(alpha: 0.7), gem.color],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: gem.color.withValues(alpha: 0.5),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card del Boss Final (bloqueado/desbloqueado).
class BossFinalCard extends StatelessWidget {
  final bool isUnlocked;
  final VoidCallback? onTap;

  const BossFinalCard({
    super.key,
    this.isUnlocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: ArcanaColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? ArcanaColors.gold.withValues(alpha: 0.8)
                : ArcanaColors.surfaceBorder,
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: ArcanaColors.gold.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnlocked ? Icons.whatshot : Icons.lock,
              color: isUnlocked ? ArcanaColors.gold : ArcanaColors.textMuted,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'BOSS FINAL',
              style: ArcanaTextStyles.sectionTitle.copyWith(
                color: isUnlocked ? ArcanaColors.gold : ArcanaColors.textMuted,
              ),
            ),
            if (!isUnlocked) ...[
              const SizedBox(width: 8),
              Text(
                '· Completa las 4 gemas',
                style: ArcanaTextStyles.bodySmall.copyWith(
                  color: ArcanaColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
