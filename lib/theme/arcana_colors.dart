import 'package:flutter/material.dart';

/// Paleta de colores de ArcanaApp.
/// Basada en el art bible: dark fantasy, grimorio mágico.
class ArcanaColors {
  ArcanaColors._();

  // ─── Fondos ────────────────────────────────────
  static const Color background = Color(0xFF0C1222);
  static const Color surface = Color(0xFF1A2332);
  static const Color surfaceLight = Color(0xFF243044);
  static const Color surfaceBorder = Color(0xFF2D3B50);

  // ─── Dorados (accento principal) ───────────────
  static const Color gold = Color(0xFFF0B429);
  static const Color goldLight = Color(0xFFFFD666);
  static const Color goldDark = Color(0xFFC4911F);
  static const Color goldShimmer = Color(0xFFFFF3D0);

  // ─── Turquesa (interactivos, XP) ──────────────
  static const Color turquoise = Color(0xFF38BDF8);
  static const Color turquoiseLight = Color(0xFF7DD3FC);
  static const Color turquoiseDark = Color(0xFF0284C7);

  // ─── Violeta (villano, peligro) ───────────────
  static const Color violet = Color(0xFF7C3AED);
  static const Color violetLight = Color(0xFFA78BFA);
  static const Color violetDark = Color(0xFF5B21B6);

  // ─── Verde (éxito, naturaleza) ────────────────
  static const Color emerald = Color(0xFF34D399);
  static const Color emeraldLight = Color(0xFF6EE7B7);
  static const Color emeraldDark = Color(0xFF059669);

  // ─── Rojo (error, vidas) ──────────────────────
  static const Color ruby = Color(0xFFF87171);
  static const Color rubyLight = Color(0xFFFCA5A5);
  static const Color rubyDark = Color(0xFFDC2626);

  // ─── Texto ────────────────────────────────────
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textGold = Color(0xFFF0B429);
  static const Color textMuted = Color(0xFF64748B);

  // ─── Gemas (bordes temáticos) ─────────────────
  static const Color gemIgnis = Color(0xFF38BDF8);    // Math - azul cristal
  static const Color gemLexis = Color(0xFFF0B429);    // Lengua - dorado
  static const Color gemSylva = Color(0xFF34D399);    // Science - verde
  static const Color gemBabel = Color(0xFF7C3AED);    // English - violeta

  // ─── Gradientes ───────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0C1222), Color(0xFF151D30)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC4911F), Color(0xFFF0B429), Color(0xFFFFD666)],
  );

  static const LinearGradient goldButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD666), Color(0xFFF0B429), Color(0xFFC4911F)],
  );

  static const RadialGradient glowGold = RadialGradient(
    colors: [Color(0x40F0B429), Color(0x00F0B429)],
  );

  static const RadialGradient glowTurquoise = RadialGradient(
    colors: [Color(0x4038BDF8), Color(0x0038BDF8)],
  );
}
