import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// HUD (Head-Up Display) de videojuego
/// Muestra vidas, XP, racha y nivel — siempre visible arriba
class HudBar extends StatelessWidget {
  final int lives;
  final int maxLives;
  final int xp;
  final int level;
  final int streak;
  final double levelProgress;
  final VoidCallback? onProfileTap;

  const HudBar({
    super.key,
    required this.lives,
    required this.maxLives,
    required this.xp,
    required this.level,
    required this.streak,
    required this.levelProgress,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila principal: vidas | xp | racha | perfil
          Row(
            children: [
              // ❤️ Vidas
              _HudItem(
                icon: '❤️',
                value: '$lives',
                color: AppColors.lives,
              ),

              const SizedBox(width: 16),

              // ⭐ XP
              _HudItem(
                icon: '⭐',
                value: '$xp',
                color: AppColors.xp,
              ),

              const SizedBox(width: 16),

              // 🔥 Racha
              _HudItem(
                icon: '🔥',
                value: '$streak',
                color: AppColors.streak,
              ),

              const Spacer(),

              // Nivel
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Nivel $level',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Barra de progreso XP
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: levelProgress,
              minHeight: 6,
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.xp),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item individual del HUD (emoji + valor)
class _HudItem extends StatelessWidget {
  final String icon;
  final String value;
  final Color color;

  const _HudItem({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
