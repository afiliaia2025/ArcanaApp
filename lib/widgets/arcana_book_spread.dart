import 'package:flutter/material.dart';
import '../theme/arcana_game_theme.dart';
import '../theme/arcana_colors.dart';

/// Página del libro ilustrado de ArcanaApp.
/// Diseño translúcido sobre ilustración full-bleed.
///
/// Uso:
/// ```dart
/// ArcanaBookPage(
///   left: IllustrationWidget(),
///   right: NarrationWidget(),
/// )
/// ```
class ArcanaBookSpread extends StatelessWidget {
  /// Contenido de la página izquierda (suele ser ilustración).
  final Widget left;
  /// Contenido de la página derecha (texto narrativo / acción).
  final Widget right;
  /// Ilustración de fondo — se extiende bajo ambas páginas.
  final Widget? background;
  /// Progreso de capítulo (puntos en la parte inferior).
  final int? currentPage;
  final int? totalPages;
  /// Línea de Orión en esquina inferior derecha (opcional).
  final String? orionLine;

  const ArcanaBookSpread({
    super.key,
    required this.left,
    required this.right,
    this.background,
    this.currentPage,
    this.totalPages,
    this.orionLine,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ─── Ilustración de fondo ──────────────────
        if (background != null)
          Positioned.fill(child: background!),

        // ─── Páginas del libro ─────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Página izquierda
                      Expanded(
                        child: Container(
                          decoration: ArcanaGameTheme.bookPage(isLeft: true),
                          padding: ArcanaGameTheme.pagePadding,
                          child: left,
                        ),
                      ),
                      // Pliegue central
                      Container(
                        width: ArcanaGameTheme.spineWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.25),
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.25),
                            ],
                          ),
                        ),
                      ),
                      // Página derecha
                      Expanded(
                        child: Container(
                          decoration: ArcanaGameTheme.bookPage(isRight: true),
                          padding: ArcanaGameTheme.pagePadding,
                          child: right,
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Barra inferior ────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      // Puntos de progreso
                      if (currentPage != null && totalPages != null)
                        _PageDots(
                          current: currentPage!,
                          total: totalPages!,
                        ),
                      const Spacer(),
                      // Frase de Orión
                      if (orionLine != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🦉', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              orionLine!,
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 13,
                                color: ArcanaColors.gold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  final int current; // 1-based
  final int total;

  const _PageDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isActive = i == current - 1;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? ArcanaColors.gold
                : ArcanaColors.gold.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Página de narrativa: texto en voz del personaje.
/// Máx 80 palabras. Sin scroll.
class ArcanaNarrationPage extends StatelessWidget {
  final String text;
  final String? speakerName;
  final Widget? continueButton;

  const ArcanaNarrationPage({
    super.key,
    required this.text,
    this.speakerName,
    this.continueButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (speakerName != null) ...[
          Text(
            speakerName!,
            style: const TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 13,
              color: ArcanaColors.gold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: ArcanaColors.gold.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
        ],
        Expanded(
          child: Text(
            text,
            style: ArcanaGameTheme.narration,
          ),
        ),
        if (continueButton != null) ...[
          const SizedBox(height: 16),
          continueButton!,
        ],
      ],
    );
  }
}

/// Botón "Siguiente ►" estilo libro — dorado, sutilmente pulsante.
class ArcanaNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const ArcanaNextButton({
    super.key,
    required this.onTap,
    this.label = 'Siguiente ►',
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFC4911F), Color(0xFFF4C025), Color(0xFFFFD666)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ArcanaColors.gold.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A0A00),
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
