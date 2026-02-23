import 'package:flutter/material.dart';

/// Paleta de colores de Arcana — "Los Arcanos del Saber"
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════
  // COLORES PRINCIPALES
  // ═══════════════════════════════════════════

  /// Índigo principal — identidad de Arcana
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  /// Crema — fondo principal (cálido, acogedor)
  static const Color background = Color(0xFFFFFBF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F5F0);

  // ═══════════════════════════════════════════
  // GAMIFICACIÓN
  // ═══════════════════════════════════════════

  /// Dorado — XP, recompensas, estrellas
  static const Color xp = Color(0xFFF59E0B);
  static const Color xpLight = Color(0xFFFBBF24);

  /// Esmeralda — acierto, éxito, progreso
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);

  /// Coral — vidas, errores
  static const Color lives = Color(0xFFF43F5E);
  static const Color livesLight = Color(0xFFFB7185);

  /// Naranja — racha (streak)
  static const Color streak = Color(0xFFFF6B35);

  /// Azul brillante — gemas
  static const Color gems = Color(0xFF06B6D4);

  // ═══════════════════════════════════════════
  // ARCANOS (asignaturas)
  // ═══════════════════════════════════════════

  /// Arcano de los Números (Mates) — Azul profundo
  static const Color arcanoNumeros = Color(0xFF3B82F6);

  /// Arcano de las Palabras (Lengua) — Violeta
  static const Color arcanoPalabras = Color(0xFF8B5CF6);

  /// Arcano de la Naturaleza (Ciencias) — Verde
  static const Color arcanoNaturaleza = Color(0xFF22C55E);

  /// Arcano del Tiempo (Historia) — Ámbar
  static const Color arcanoTiempo = Color(0xFFF59E0B);

  /// Arcano de las Lenguas (Inglés) — Rosa
  static const Color arcanoLenguas = Color(0xFFEC4899);

  // ═══════════════════════════════════════════
  // NEUTROS
  // ═══════════════════════════════════════════

  static const Color textPrimary = Color(0xFF1E1B4B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color shadow = Color(0x1A000000);

  // ═══════════════════════════════════════════
  // WORLD MAP
  // ═══════════════════════════════════════════

  /// Nodo completado
  static const Color nodeCompleted = success;

  /// Nodo actual (pulsando)
  static const Color nodeCurrent = primary;

  /// Nodo bloqueado
  static const Color nodeLocked = Color(0xFFD1D5DB);

  /// Camino del mapa
  static const Color pathColor = Color(0xFFE5E7EB);
  static const Color pathCompleted = Color(0xFFA5B4FC);

  // ═══════════════════════════════════════════
  // DARK MODE (base)
  // ═══════════════════════════════════════════

  static const Color darkBackground = Color(0xFF0F0D23);
  static const Color darkSurface = Color(0xFF1A1833);
  static const Color darkSurfaceVariant = Color(0xFF252342);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
}
