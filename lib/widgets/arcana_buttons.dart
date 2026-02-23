import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';

/// Botón primario dorado estilo RPG.
/// Usa gradiente dorado con bordes ornamentales.
class ArcanaGoldButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final IconData? icon;

  const ArcanaGoldButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 280,
    this.height = 56,
    this.icon,
  });

  @override
  State<ArcanaGoldButton> createState() => _ArcanaGoldButtonState();
}

class _ArcanaGoldButtonState extends State<ArcanaGoldButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: ArcanaColors.goldButtonGradient,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ArcanaColors.goldLight.withValues(alpha: 0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ArcanaColors.gold.withValues(
                      alpha: _glowAnimation.value,
                    ),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  const BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: const Color(0xFF1A1000), size: 22),
                      const SizedBox(width: 8),
                    ],
                    Text(widget.text, style: ArcanaTextStyles.buttonPrimary),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Botón secundario (outlined, turquesa o dorado).
class ArcanaOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  const ArcanaOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = ArcanaColors.turquoise,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: ArcanaTextStyles.buttonSecondary.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
