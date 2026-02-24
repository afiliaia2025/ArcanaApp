import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';

// ─────────────────────────────────────────────
// ORIÓN — COMPAÑERO FLOTANTE DEL JUGADOR
// Muestra al búho con una burbuja de diálogo.
// Uso: OrionBubble(message: '¡Tú puedes, Aprendiz!')
//       OrionBubble.reaction(correct: true)
// ─────────────────────────────────────────────

enum OrionMood { happy, excited, sad, nervous, proud, crying, default_ }

class OrionBubble extends StatefulWidget {
  final String message;
  final OrionMood mood;
  final bool autoHide;
  final Duration hideDuration;
  final VoidCallback? onDismiss;
  final bool showDismiss;

  const OrionBubble({
    super.key,
    required this.message,
    this.mood = OrionMood.default_,
    this.autoHide = false,
    this.hideDuration = const Duration(seconds: 4),
    this.onDismiss,
    this.showDismiss = true,
  });

  /// Reacción rápida a un ejercicio (fábrica de conveniencia)
  static OrionBubble reaction({required bool correct, Key? key}) {
    if (correct) {
      final msgs = [
        '¡INCREÍBLE! ¡Eso es! 🎉',
        '¡Lo sabía! ¡Eres un MAGO! ✨',
        '¡PERFECTO! Noctus está temblando 😤',
        '¡Sí, SÍ, SÍ! ¡Así se hace! 🦉',
      ];
      msgs.shuffle();
      return OrionBubble(
        key: key,
        message: msgs.first,
        mood: OrionMood.excited,
        autoHide: true,
        hideDuration: const Duration(seconds: 2),
        showDismiss: false,
      );
    } else {
      final msgs = [
        'No pasa nada… ¡Inténtalo otra vez! 💪',
        'Casi, casi… El conocimiento necesita práctica 🦉',
        '¡Eh! Los magos también fallan. ¡Venga! 🌟',
      ];
      msgs.shuffle();
      return OrionBubble(
        key: key,
        message: msgs.first,
        mood: OrionMood.sad,
        autoHide: true,
        hideDuration: const Duration(seconds: 3),
        showDismiss: false,
      );
    }
  }

  /// Frases de ánimo para el mapa / hub
  static const List<String> mapGreetings = [
    '🦉 ¡Buenos días, Aprendiz! Noctus no descansa… ¿y tú?',
    '🦉 El reino Ignis te necesita. ¡Vamos a entrenar!',
    '🦉 Cada ejercicio es un golpe a las sombras de Noctus.',
    '🦉 Recuerda: un mago no memoriza, ¡COMPRENDE!',
    '🦉 ¿Hoy practicamos? Yo tomo notas… (para no olvidarlas YO).',
  ];

  @override
  State<OrionBubble> createState() => _OrionBubbleState();
}

class _OrionBubbleState extends State<OrionBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();

    if (widget.autoHide) {
      Future.delayed(widget.hideDuration, _hide);
    }
  }

  void _hide() {
    if (!mounted) return;
    _ctrl.reverse().then((_) {
      if (mounted) setState(() => _visible = false);
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _owlEmoji {
    switch (widget.mood) {
      case OrionMood.happy:    return '🦉';
      case OrionMood.excited:  return '🦅';
      case OrionMood.sad:      return '😔';
      case OrionMood.nervous:  return '😰';
      case OrionMood.proud:    return '😤';
      case OrionMood.crying:   return '😭';
      default:                 return '🦉';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        alignment: Alignment.bottomLeft,
        child: _buildBubble(),
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Burbuja de diálogo
          Container(
            padding: EdgeInsets.fromLTRB(14, 10, widget.showDismiss ? 28 : 14, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E1040).withValues(alpha: 0.95),
                  const Color(0xFF12082A).withValues(alpha: 0.95),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(
                color: ArcanaColors.gold.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: ArcanaColors.gold.withValues(alpha: 0.12),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Orión
                Text(_owlEmoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                // Texto
                Flexible(
                  child: Text(
                    widget.message,
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botón X para descartar
          if (widget.showDismiss)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: _hide,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: const Icon(Icons.close, size: 12, color: Colors.white54),
                ),
              ),
            ),

          // Triángulo (cola de la burbuja) — abajo-izquierda
          Positioned(
            bottom: -8,
            left: 10,
            child: CustomPaint(
              painter: _BubbleTailPainter(),
              size: const Size(12, 9),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pinta el triángulo inferior de la burbuja de diálogo
class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E1040).withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = ArcanaColors.gold.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
// ORION FLOATING COMPANION
// Widget de nivel superior que muestra al búho
// flotando en una esquina con su burbuja.
// ─────────────────────────────────────────────
class OrionFloating extends StatefulWidget {
  final String message;
  final OrionMood mood;

  const OrionFloating({
    super.key,
    required this.message,
    this.mood = OrionMood.default_,
  });

  @override
  State<OrionFloating> createState() => _OrionFloatingState();
}

class _OrionFloatingState extends State<OrionFloating>
    with SingleTickerProviderStateMixin {
  late AnimationController _bobCtrl;
  late Animation<double> _bobAnim;

  @override
  void initState() {
    super.initState();
    _bobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _bobAnim = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _bobCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bobAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -_bobAnim.value),
        child: child,
      ),
      child: OrionBubble(message: widget.message, mood: widget.mood),
    );
  }
}
