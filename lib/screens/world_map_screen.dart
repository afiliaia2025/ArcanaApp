import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../providers/adventure_provider.dart';
import '../providers/firebase_providers.dart';
import '../theme/app_colors.dart';
import '../widgets/hud_bar.dart';
import '../widgets/map_node_widget.dart';

/// Pantalla central de Arcana — el World Map estilo Nintendo
/// El jugador navega por un mapa de nodos (capítulos) con caminos
class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventure = ref.watch(adventureProvider);
    final authUser = FirebaseAuth.instance.currentUser;

    // Datos del perfil desde Firebase (fallback a mock)
    final profileAsync = authUser != null
        ? ref.watch(userProfileProvider(authUser.uid))
        : null;
    final profile = profileAsync?.value;

    // HUD values
    final lives = (profile?['lives'] as int?) ?? MockData.userProfile.lives;
    final maxLives = (profile?['maxLives'] as int?) ?? MockData.userProfile.maxLives;
    final xp = (profile?['xp'] as int?) ?? MockData.userProfile.xp;
    final level = (profile?['level'] as int?) ?? MockData.userProfile.level;
    final streak = (profile?['streak'] as int?) ?? MockData.userProfile.streak;
    final levelProgress = (profile?['levelProgress'] as num?)?.toDouble() ?? MockData.userProfile.levelProgress;

    // Usar datos reales si están disponibles, sino mock
    final nodes = adventure.mapNodes.isNotEmpty
        ? adventure.mapNodes
        : MockData.mapNodes;
    final paths = adventure.mapPaths.isNotEmpty
        ? adventure.mapPaths
        : MockData.mapPaths;
    final title = adventure.arcTitle.isNotEmpty
        ? adventure.arcTitle
        : MockData.mapZone.name;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Fondo del mapa ──
          _MapBackground(),

          // ── Contenido scrolleable ──
          SafeArea(
            child: Column(
              children: [
                // HUD arriba
                HudBar(
                  lives: lives,
                  maxLives: maxLives,
                  xp: xp,
                  level: level,
                  streak: streak,
                  levelProgress: levelProgress,
                  onProfileTap: () => context.go('/profile'),
                ),

                // Título de la zona
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '🔢 $title',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Contenido principal (carga / error / mapa)
                Expanded(child: _buildMapContent(adventure, nodes, paths, context)),
              ],
            ),
          ),

          // ── FAB: Escanear ──
          Positioned(
            bottom: 24,
            right: 24,
            child: _ScanFab(
              onTap: () => _showScanDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido del mapa según el estado
  Widget _buildMapContent(
    AdventureState adventure,
    List<MapNode> nodes,
    List<MapPath> paths,
    BuildContext context,
  ) {
    if (adventure.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando aventura...',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (adventure.error != null && adventure.mapNodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🧙', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              adventure.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Mapa real
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1.4,
            width: constraints.maxWidth,
            child: Stack(
              children: [
                // Caminos
                ..._buildPaths(
                  paths,
                  nodes,
                  constraints.maxWidth,
                  constraints.maxHeight * 1.4,
                ),

                // Nodos
                ...nodes.map((node) {
                  return Positioned(
                    left: node.x * constraints.maxWidth - 40,
                    top: node.y * constraints.maxHeight * 1.4 - 40,
                    child: MapNodeWidget(
                      node: node,
                      onTap: () {
                        context.push('/chapter/${node.chapterId}');
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construye las líneas de caminos entre nodos
  List<Widget> _buildPaths(
    List<MapPath> paths,
    List<MapNode> nodes,
    double width,
    double height,
  ) {
    return paths.map((path) {
      final fromNode = nodes.firstWhere((n) => n.id == path.fromNodeId);
      final toNode = nodes.firstWhere((n) => n.id == path.toNodeId);

      return CustomPaint(
        size: Size(width, height),
        painter: _PathPainter(
          from: Offset(fromNode.x * width, fromNode.y * height),
          to: Offset(toNode.x * width, toNode.y * height),
          isCompleted: path.isCompleted,
          branch: path.branch,
        ),
      );
    }).toList();
  }

  void _showScanDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '📸 Escanear material',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Saca una foto a tu libro o apuntes y la IA generará nuevos ejercicios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ScanOption(
                    icon: '📷',
                    label: 'Cámara',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Abrir cámara
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ScanOption(
                    icon: '📁',
                    label: 'Galería',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Abrir galería
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// WIDGETS INTERNOS
// ═══════════════════════════════════════════

/// Fondo decorativo del mapa
class _MapBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEEF2FF), // Índigo muy suave
            AppColors.background,
            Color(0xFFFEF3C7), // Dorado muy suave
          ],
        ),
      ),
    );
  }
}

/// Botón flotante de escanear
class _ScanFab extends StatelessWidget {
  final VoidCallback onTap;

  const _ScanFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text('📸', style: TextStyle(fontSize: 28)),
        ),
      ),
    );
  }
}

/// Opción en el diálogo de escaneo
class _ScanOption extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ScanOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// PAINTER: caminos del mapa
// ═══════════════════════════════════════════

class _PathPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final bool isCompleted;
  final MapPathBranch branch;

  _PathPainter({
    required this.from,
    required this.to,
    required this.isCompleted,
    required this.branch,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCompleted ? AppColors.pathCompleted : AppColors.pathColor
      ..strokeWidth = isCompleted ? 4 : 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Caminos no completados = línea más fina
    if (!isCompleted) {
      paint.strokeWidth = 2;
    }

    // Curva bezier para caminos más naturales
    final path = Path();
    path.moveTo(from.dx, from.dy);

    final midY = (from.dy + to.dy) / 2;
    path.cubicTo(
      from.dx, midY,
      to.dx, midY,
      to.dx, to.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PathPainter old) =>
      from != old.from || to != old.to || isCompleted != old.isCompleted;
}
