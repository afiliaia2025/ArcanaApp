import 'package:flutter/material.dart';
import 'arcana_colors.dart';

/// ARCANA GAME THEME — Design System centralizado
/// Todas las constantes de game UI. Nada de valores hardcoded en los widgets.
/// Ver GDD: docs/gdd/12_UI_SISTEMA.md
class ArcanaGameTheme {
  ArcanaGameTheme._();

  // ─── Colores de reinos ───────────────────────
  static const Color ignis = Color(0xFFDC2626);   // Matemáticas
  static const Color ignisLight = Color(0xFFF87171);
  static const Color lexis = Color(0xFFD97706);   // Lengua
  static const Color lexisLight = Color(0xFFFBB954);
  static const Color sylva = Color(0xFF16A34A);   // Ciencias
  static const Color sylvaLight = Color(0xFF4ADE80);
  static const Color babel = Color(0xFF0284C7);   // Inglés
  static const Color babelLight = Color(0xFF38BDF8);

  // ─── Feedback de combate ─────────────────────
  static const Color hitGreen = Color(0xFF22C55E);
  static const Color hitRed = Color(0xFFEF4444);
  static const Color timerWarning = Color(0xFFF97316);
  static const Color timerDanger = Color(0xFFDC2626);
  static const Color rayPlayer = Color(0xFF38BDF8);   // rayo jugador (azul)
  static const Color rayEnemy = Color(0xFFEF4444);    // rayo enemigo (rojo)

  // ─── Página del libro ────────────────────────
  static const Color pageBackground = Color(0xD00F0520); // rgba(15,5,32,0.82)
  static const Color pageBorder = Color(0x40F4C025);     // gold 25% opacidad
  static const Color pageSpine = Color(0x20F4C025);      // pliegue central
  static const Color narrationText = Color(0xFFE8DFF5);  // texto narrativo

  // ─── Dimensiones de combate ──────────────────
  /// Fracción del ancho para zona de personaje (izq/dcha)
  static const double combatCharacterFlex = 0.22;
  /// Fracción del ancho para zona central de pregunta
  static const double combatQuestionFlex = 0.56;
  /// Altura de la barra HUD superior
  static const double combatHudHeight = 56.0;
  /// Altura mínima de botón de respuesta (táctil para niño)
  static const double answerButtonMinHeight = 64.0;
  /// Padding interior botón de respuesta
  static const EdgeInsets answerButtonPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  // ─── Dimensiones del libro ───────────────────
  /// Padding interior de cada página
  static const EdgeInsets pagePadding = EdgeInsets.all(24);
  /// Radio de esquinas de la página
  static const double pageRadius = 16.0;
  /// Anchura del "pliegue" central del libro
  static const double spineWidth = 8.0;
  /// Máximo de palabras por página de narración
  static const int maxWordsPerPage = 80;

  // ─── Tipografía de juego ─────────────────────
  /// Texto de narración en el libro (legible para 7 años)
  static const TextStyle narration = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: narrationText,
    height: 1.6,
    letterSpacing: 0.2,
  );

  /// Pregunta del ejercicio (grande y clara)
  static const TextStyle question = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: Color(0xFFF1EDF8),
    height: 1.4,
  );

  /// Texto en botón de respuesta
  static const TextStyle answerOption = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Color(0xFFF1EDF8),
  );

  /// Nombre de personaje en HUD
  static const TextStyle hudName = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFFF1EDF8),
    letterSpacing: 1.5,
  );

  /// Puntuación en HUD
  static const TextStyle hudScore = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: ArcanaColors.gold,
  );

  /// Timer (solo boss)
  static const TextStyle timer = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: ArcanaColors.gold,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ─── Decoraciones de componentes ─────────────

  /// Carta de pregunta (piedra mágica / scroll)
  static BoxDecoration questionCard({Color? borderColor}) => BoxDecoration(
    color: const Color(0xFF130B25),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: borderColor ?? ArcanaColors.gold.withValues(alpha: 0.4),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: (borderColor ?? ArcanaColors.gold).withValues(alpha: 0.15),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ],
  );

  /// Botón de respuesta — estado normal
  static BoxDecoration answerButton({Color? kingdomColor}) => BoxDecoration(
    color: const Color(0xFF1A0A30),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: (kingdomColor ?? ArcanaColors.gold).withValues(alpha: 0.5),
      width: 2,
    ),
  );

  /// Botón de respuesta — correcto
  static BoxDecoration answerButtonCorrect = BoxDecoration(
    color: hitGreen.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: hitGreen, width: 2),
    boxShadow: [BoxShadow(color: hitGreen.withValues(alpha: 0.3), blurRadius: 8)],
  );

  /// Botón de respuesta — incorrecto
  static BoxDecoration answerButtonWrong = BoxDecoration(
    color: hitRed.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: hitRed, width: 2),
    boxShadow: [BoxShadow(color: hitRed.withValues(alpha: 0.3), blurRadius: 8)],
  );

  /// Botón de respuesta — neutro tras revelar resultado
  static BoxDecoration answerButtonFaded = BoxDecoration(
    color: const Color(0xFF0F0520).withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFF2D1A4A), width: 1),
  );

  /// Página del libro (fondo translúcido con borde dorado)
  static BoxDecoration bookPage({
    bool isLeft = false,
    bool isRight = false,
  }) =>
      BoxDecoration(
        color: pageBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isLeft ? pageRadius : 4),
          bottomLeft: Radius.circular(isLeft ? pageRadius : 4),
          topRight: Radius.circular(isRight ? pageRadius : 4),
          bottomRight: Radius.circular(isRight ? pageRadius : 4),
        ),
        border: Border.all(color: pageBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // ─── Gradientes de fondo por reino ───────────
  static RadialGradient arenaGradient(Color kingdomColor) => RadialGradient(
    center: Alignment.topCenter,
    radius: 1.5,
    colors: [
      kingdomColor.withValues(alpha: 0.12),
      const Color(0xFF0A0510),
    ],
  );

  // ─── Duración de animaciones ─────────────────
  static const Duration rayDuration = Duration(milliseconds: 800);
  static const Duration shakeDuration = Duration(milliseconds: 500);
  static const Duration answerRevealDelay = Duration(milliseconds: 600);
  static const Duration nextQuestionDelay = Duration(milliseconds: 1800);
  static const Duration pageFlipDuration = Duration(milliseconds: 400);
}
