import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';

/// Backgrounds estándar del juego. Cada enum mapea a un asset de imagen.
enum ArcanaScreen {
  title,
  worldMap,
  combatArena,
  bossArena,
  dojo,
  orionCave,
  shop,
  profile,
  results,
}

/// Paleta de fallback para cada pantalla (si la imagen no está disponible).
final Map<ArcanaScreen, List<Color>> _fallbackGradients = {
  ArcanaScreen.title: const [
    Color(0xFF1A0A3D), // deep violet
    Color(0xFF0C1222), // navy
    Color(0xFF0A0E1A), // almost black
  ],
  ArcanaScreen.worldMap: const [
    Color(0xFF0B1D3A), // deep ocean blue
    Color(0xFF12302B), // deep forest
    Color(0xFF0A0E1A),
  ],
  ArcanaScreen.combatArena: const [
    Color(0xFF1A0A2E), // deep purple
    Color(0xFF2D0A0A), // dark crimson
    Color(0xFF0A0E1A),
  ],
  ArcanaScreen.bossArena: const [
    Color(0xFF2A0010), // blood red
    Color(0xFF1A0030), // dark violet
    Color(0xFF050005),
  ],
  ArcanaScreen.dojo: const [
    Color(0xFF1A1200), // dark gold
    Color(0xFF0D1A2D), // midnight blue
    Color(0xFF0A0E1A),
  ],
  ArcanaScreen.orionCave: const [
    Color(0xFF04112B), // deep indigo
    Color(0xFF0A1A30), // midnight
    Color(0xFF010610),
  ],
  ArcanaScreen.shop: const [
    Color(0xFF1A1000), // dark amber
    Color(0xFF2E0A40), // deep purple
    Color(0xFF0A0E1A),
  ],
  ArcanaScreen.profile: const [
    Color(0xFF0A1422), // steel blue
    Color(0xFF0C1222),
    Color(0xFF0A0E1A),
  ],
  ArcanaScreen.results: const [
    Color(0xFF0A1A10), // dark green
    Color(0xFF0C1222),
    Color(0xFF0A0E1A),
  ],
};

/// Ruta del asset de imagen para cada pantalla.
final Map<ArcanaScreen, String> _assetPaths = {
  ArcanaScreen.title:      'assets/images/screens/title_bg.png',
  ArcanaScreen.worldMap:   'assets/images/screens/map_bg.png',
  ArcanaScreen.combatArena:'assets/images/screens/combat_arena_bg.png',
  ArcanaScreen.bossArena:  'assets/images/screens/boss_arena_bg.png',
  ArcanaScreen.dojo:       'assets/images/screens/dojo_bg.png',
  ArcanaScreen.orionCave:  'assets/images/screens/orion_bg.png',
  ArcanaScreen.shop:       'assets/images/screens/shop_bg.png',
  ArcanaScreen.profile:    'assets/images/screens/profile_bg.png',
  ArcanaScreen.results:    'assets/images/screens/results_bg.png',
};

/// Widget de fondo para las pantallas de Arcana.
/// Muestra la imagen del asset si existe; si no, un gradiente animado
/// con estrellas procedurales.
class ArcanaBackground extends StatelessWidget {
  final ArcanaScreen screen;
  /// Opacidad extra del overlay oscuro (0.0 = ninguno, 1.0 = negro total)
  final double overlayOpacity;
  final Widget? child;

  const ArcanaBackground({
    super.key,
    required this.screen,
    this.overlayOpacity = 0.35,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _fallbackGradients[screen] ??
        [const Color(0xFF1A0A3D), const Color(0xFF0A0E1A)];

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Imagen de fondo ──────────────────────────────────
        Image.asset(
          _assetPaths[screen]!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _FallbackGradient(colors: colors),
        ),

        // ── Overlay dark para legibilidad ────────────────────
        if (overlayOpacity > 0)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: overlayOpacity * 0.4),
                  Colors.black.withValues(alpha: overlayOpacity * 0.6),
                  Colors.black.withValues(alpha: overlayOpacity * 0.85),
                ],
              ),
            ),
          ),

        // ── Contenido ────────────────────────────────────────
        if (child != null) child!,
      ],
    );
  }
}

/// Gradiente + estrellas procedurales como fallback cuando no hay imagen.
class _FallbackGradient extends StatelessWidget {
  final List<Color> colors;
  const _FallbackGradient({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
        ),
        const _StarField(),
      ],
    );
  }
}

/// Estrellas procedurales (decorativas, sin animación, rápidas de pintar).
class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarPainter(),
      size: Size.infinite,
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 120; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = rng.nextDouble() * 1.5 + 0.3;
      final opacity = rng.nextDouble() * 0.7 + 0.2;
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    // Algunos puntos dorados (gemas)
    final goldPaint = Paint()..color = ArcanaColors.gold.withValues(alpha: 0.4);
    for (int i = 0; i < 10; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), rng.nextDouble() * 2 + 0.5, goldPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
