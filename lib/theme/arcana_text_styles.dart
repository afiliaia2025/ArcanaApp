import 'package:flutter/material.dart';
import 'arcana_colors.dart';

/// Tipografía de ArcanaApp.
/// Títulos: Cinzel (serif ornamental dorada)
/// Body: Plus Jakarta Sans (legible, moderna)
class ArcanaTextStyles {
  ArcanaTextStyles._();

  // ─── Familia de fuentes ──────────────────────
  // Usamos Google Fonts; si no hay conexión, fallback a serif/sans-serif.
  static const String fontFamilyTitle = 'Cinzel';
  static const String fontFamilyBody = 'PlusJakartaSans';

  // ─── Títulos (Cinzel / serif dorada) ─────────
  static const TextStyle heroTitle = TextStyle(
    fontFamily: fontFamilyTitle,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    color: ArcanaColors.gold,
    letterSpacing: 6,
    shadows: [
      Shadow(color: Color(0x80F0B429), blurRadius: 20),
      Shadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2)),
    ],
  );

  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamilyTitle,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: ArcanaColors.gold,
    letterSpacing: 2,
    shadows: [
      Shadow(color: Color(0x60F0B429), blurRadius: 12),
    ],
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamilyTitle,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: ArcanaColors.gold,
    letterSpacing: 1.5,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamilyTitle,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ArcanaColors.textPrimary,
    letterSpacing: 1,
  );

  static const TextStyle chipLabel = TextStyle(
    fontFamily: fontFamilyTitle,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ArcanaColors.textPrimary,
    letterSpacing: 0.5,
  );

  // ─── Celebración (especial) ──────────────────
  static const TextStyle celebration = TextStyle(
    fontFamily: fontFamilyTitle,
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: ArcanaColors.gold,
    letterSpacing: 3,
    shadows: [
      Shadow(color: Color(0xA0F0B429), blurRadius: 30),
      Shadow(color: Color(0x60FFD666), blurRadius: 60),
    ],
  );

  // ─── Body (Plus Jakarta Sans / sans-serif) ───
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: ArcanaColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ArcanaColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ArcanaColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: ArcanaColors.textMuted,
  );

  // ─── Botones ──────────────────────────────────
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: fontFamilyTitle,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1A1000),
    letterSpacing: 1.5,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ArcanaColors.textPrimary,
    letterSpacing: 0.5,
  );

  // ─── Stats / HUD ─────────────────────────────
  static const TextStyle statValue = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: ArcanaColors.textPrimary,
  );

  static const TextStyle xpValue = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: ArcanaColors.turquoise,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: ArcanaColors.goldLight,
    letterSpacing: 2,
  );
}
