import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';

/// Partículas mágicas flotantes.
/// Crea el efecto de destellos dorados/turquesa flotando por la pantalla.
class MagicalParticles extends StatefulWidget {
  final int particleCount;
  final Color color;
  final double maxSize;

  const MagicalParticles({
    super.key,
    this.particleCount = 50,
    this.color = ArcanaColors.gold,
    this.maxSize = 4.0,
  });

  @override
  State<MagicalParticles> createState() => _MagicalParticlesState();
}

class _MagicalParticlesState extends State<MagicalParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      widget.particleCount,
      (_) => _Particle.random(_random),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
            maxSize: widget.maxSize,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double speed;
  final double size;
  final double opacity;
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
  });

  factory _Particle.random(Random random) {
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      speed: 0.2 + random.nextDouble() * 0.8,
      size: 0.3 + random.nextDouble() * 0.7,
      opacity: 0.2 + random.nextDouble() * 0.6,
      phase: random.nextDouble() * 2 * pi,
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;
  final double maxSize;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.color,
    required this.maxSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final time = (progress + p.phase) % 1.0;

      // Movimiento suave ascendente con ondulación horizontal
      final dx = p.x * size.width + sin(time * 2 * pi + p.phase) * 20;
      final dy = ((p.y - time * p.speed) % 1.0) * size.height;

      // Parpadeo suave
      final flicker = (sin(time * 2 * pi * 3 + p.phase) + 1) / 2;
      final alpha = (p.opacity * (0.5 + flicker * 0.5)).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * maxSize);

      canvas.drawCircle(Offset(dx, dy), p.size * maxSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
