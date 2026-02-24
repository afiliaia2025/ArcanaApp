import 'package:flutter/material.dart';
import '../theme/arcana_game_theme.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';

/// Barra dual de puntuación de combate (reemplaza corazones).
/// Oro = jugador, Rojo = enemigo. Anima cuando cambia el marcador.
class ArcanaDualScoreBar extends StatelessWidget {
  final int playerScore;
  final int enemyScore;
  final int totalExercises;
  final int round;
  final int totalRounds;
  final String enemyName;
  final Color? enemyColor;

  const ArcanaDualScoreBar({
    super.key,
    required this.playerScore,
    required this.enemyScore,
    required this.totalExercises,
    required this.round,
    required this.totalRounds,
    required this.enemyName,
    this.enemyColor,
  });

  @override
  Widget build(BuildContext context) {
    final total = playerScore + enemyScore;
    final playerFraction = totalExercises == 0
        ? 0.5
        : (playerScore / totalExercises)
            .clamp(0.0, 1.0);

    return Container(
      height: ArcanaGameTheme.combatHudHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0510),
        border: Border(
          bottom: BorderSide(
            color: ArcanaColors.gold.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // ─── Nombre jugador ───────────────────
          Text('APRENDIZ', style: ArcanaGameTheme.hudName.copyWith(
            color: ArcanaColors.turquoise,
          )),
          const SizedBox(width: 8),
          // ─── Score jugador ────────────────────
          Text('$playerScore', style: ArcanaGameTheme.hudScore.copyWith(
            color: ArcanaColors.gold,
          )),
          const SizedBox(width: 8),
          // ─── Barra dual ───────────────────────
          Expanded(
            child: _DualBar(playerFraction: playerFraction),
          ),
          const SizedBox(width: 8),
          // ─── Score enemigo ────────────────────
          Text('$enemyScore', style: ArcanaGameTheme.hudScore.copyWith(
            color: enemyColor ?? ArcanaGameTheme.hitRed,
          )),
          const SizedBox(width: 8),
          // ─── Nombre enemigo ───────────────────
          Text(
            enemyName.toUpperCase(),
            style: ArcanaGameTheme.hudName.copyWith(
              color: enemyColor ?? ArcanaGameTheme.hitRed,
            ),
          ),
        ],
      ),
    );
  }
}

class _DualBar extends StatelessWidget {
  final double playerFraction; // 0.0-1.0

  const _DualBar({required this.playerFraction});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 10,
        child: Stack(
          children: [
            // Fondo
            Container(color: const Color(0xFF1A0830)),
            // Barra jugador (dorada, crece izq→dcha)
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 400),
              alignment: Alignment.centerLeft,
              widthFactor: playerFraction,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFFF4C025),
                    Color(0xFFFFD666),
                  ]),
                  boxShadow: [
                    BoxShadow(
                      color: ArcanaColors.gold.withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            // Barra enemigo (roja, crece dcha→izq)
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 400),
              alignment: Alignment.centerRight,
              widthFactor: (1.0 - playerFraction).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFFEF4444),
                    Color(0xFFDC2626),
                  ]),
                  boxShadow: [
                    BoxShadow(
                      color: ArcanaGameTheme.hitRed.withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            // Línea central
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 2,
                color: const Color(0xFF0A0510),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Timer circular para el boss (solo aparece en BossBattleScreen).
class ArcanaTimerBadge extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const ArcanaTimerBadge({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
  });

  Color get _color {
    final ratio = secondsLeft / totalSeconds;
    if (ratio > 0.4) return ArcanaColors.gold;
    if (ratio > 0.2) return ArcanaGameTheme.timerWarning;
    return ArcanaGameTheme.timerDanger;
  }

  @override
  Widget build(BuildContext context) {
    final isLow = secondsLeft <= 5;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLow
            ? ArcanaGameTheme.timerDanger.withValues(alpha: 0.2)
            : const Color(0xFF1A0830),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded, size: 16, color: _color),
          const SizedBox(width: 4),
          Text('${secondsLeft}s',
              style: ArcanaGameTheme.timer.copyWith(color: _color)),
        ],
      ),
    );
  }
}
