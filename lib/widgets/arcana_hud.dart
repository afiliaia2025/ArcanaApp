import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';

/// Barra superior del juego (HUD).
/// Muestra: icono de Orión, título, vidas, monedas, XP.
class ArcanaTopBar extends StatelessWidget {
  final String title;
  final int lives;
  final int coins;
  final int xp;
  final VoidCallback? onOrionTap;
  final VoidCallback? onSettingsTap;

  const ArcanaTopBar({
    super.key,
    this.title = 'ARCANA',
    this.lives = 5,
    this.coins = 120,
    this.xp = 4600,
    this.onOrionTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ArcanaColors.gold.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono de Orión (tutor)
          GestureDetector(
            onTap: onOrionTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ArcanaColors.turquoise.withValues(alpha: 0.15),
                border: Border.all(
                  color: ArcanaColors.turquoise.withValues(alpha: 0.4),
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/characters/orion.png',
                  width: 28,
                  height: 28,
                  errorBuilder: (_, e, s) => const Icon(
                    Icons.auto_awesome,
                    color: ArcanaColors.turquoise,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Título
          Text(
            title,
            style: ArcanaTextStyles.cardTitle.copyWith(
              color: ArcanaColors.gold,
              letterSpacing: 3,
            ),
          ),

          const Spacer(),

          // Vidas (corazones)
          _buildStat(
            icon: Icons.favorite,
            iconColor: ArcanaColors.ruby,
            value: '$lives',
          ),

          const SizedBox(width: 16),

          // Monedas
          _buildStat(
            assetPath: 'assets/images/icons/coin.png',
            fallbackIcon: Icons.monetization_on,
            iconColor: ArcanaColors.gold,
            value: '$coins',
          ),

          const SizedBox(width: 16),

          // XP
          _buildStat(
            icon: Icons.star,
            iconColor: ArcanaColors.turquoise,
            value: '$xp',
          ),

          const SizedBox(width: 12),

          // Settings
          GestureDetector(
            onTap: onSettingsTap,
            child: Icon(
              Icons.settings,
              color: ArcanaColors.textMuted,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    IconData? icon,
    String? assetPath,
    IconData? fallbackIcon,
    required Color iconColor,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (assetPath != null)
          Image.asset(
            assetPath,
            width: 20,
            height: 20,
            errorBuilder: (_, e, s) => Icon(
              fallbackIcon ?? Icons.circle,
              color: iconColor,
              size: 18,
            ),
          )
        else
          Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 4),
        Text(
          value,
          style: ArcanaTextStyles.statValue.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}

/// Barra de navegación inferior estilo RPG.
class ArcanaBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  const ArcanaBottomNav({
    super.key,
    this.selectedIndex = 0,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ArcanaColors.gold.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x60000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.map, 'Mapa'),
          _buildNavItem(1, Icons.camera_alt, 'Escanear'),
          _buildNavItem(2, Icons.auto_awesome, 'Orión'),
          _buildNavItem(3, Icons.person, 'Perfil'),
          _buildNavItem(4, Icons.emoji_events, 'Logros'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onItemTapped?.call(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? ArcanaColors.gold.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? ArcanaColors.gold : ArcanaColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected ? ArcanaColors.gold : ArcanaColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
