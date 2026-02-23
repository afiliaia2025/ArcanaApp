import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

/// Nodo visual del World Map
/// Representa un capítulo en el mapa de aventura
class MapNodeWidget extends StatefulWidget {
  final MapNode node;
  final VoidCallback? onTap;

  const MapNodeWidget({
    super.key,
    required this.node,
    this.onTap,
  });

  @override
  State<MapNodeWidget> createState() => _MapNodeWidgetState();
}

class _MapNodeWidgetState extends State<MapNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Solo animar si es el nodo actual
    if (widget.node.status == MapNodeStatus.current) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBoss = widget.node.type == ChapterType.miniBoss ||
        widget.node.type == ChapterType.trimesterBoss ||
        widget.node.type == ChapterType.finalBoss;
    final isGate = widget.node.type == ChapterType.gatePuzzle;

    final nodeSize = isBoss ? 72.0 : (isGate ? 64.0 : 56.0);

    final color = switch (widget.node.status) {
      MapNodeStatus.completed => AppColors.success,
      MapNodeStatus.current => AppColors.primary,
      MapNodeStatus.locked => AppColors.nodeLocked,
    };

    final isLocked = widget.node.status == MapNodeStatus.locked;

    Widget nodeContent = Container(
      width: nodeSize,
      height: nodeSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isLocked
              ? AppColors.border
              : color == AppColors.primary
                  ? AppColors.primaryDark
                  : color,
          width: 3,
        ),
        boxShadow: isLocked
            ? []
            : [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                // Efecto 3D — sombra interior
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.2),
                  blurRadius: 0,
                  offset: const Offset(0, -2),
                ),
              ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLocked ? '🔒' : widget.node.emoji,
              style: TextStyle(fontSize: isBoss ? 28 : 22),
            ),
            if (widget.node.status == MapNodeStatus.completed)
              const Text('✅', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );

    // Animar nodo actual
    if (widget.node.status == MapNodeStatus.current) {
      nodeContent = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: nodeContent,
      );
    }

    return GestureDetector(
      onTap: isLocked ? null : widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          nodeContent,
          const SizedBox(height: 4),
          Text(
            widget.node.label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isLocked
                  ? AppColors.textTertiary
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
