import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import 'orion_bubble.dart';

// ─────────────────────────────────────────────
// NOCTUS INTRO OVERLAY
// Pantalla de intro dramática de Noctus antes de un boss.
// Muestra 2 líneas de diálogo de Noctus y la respuesta de Orión,
// luego llama a onComplete() para iniciar el combate.
//
// Uso:
//   NoctusIntroOverlay(
//     enemyName: 'Serpentix',
//     enemyEmoji: '🐍',
//     noctusLine: '¡Mis restas te aplastarán, pequeño aprendiz!',
//     onComplete: () { /* iniciar combate */ },
//   )
// ─────────────────────────────────────────────
class NoctusIntroOverlay extends StatefulWidget {
  final String enemyName;
  final String enemyEmoji;
  final Color enemyColor;
  final String noctusLine;
  final VoidCallback onComplete;
  final bool isBoss;

  const NoctusIntroOverlay({
    super.key,
    required this.enemyName,
    required this.enemyEmoji,
    required this.noctusLine,
    required this.onComplete,
    this.enemyColor = const Color(0xFFFF1744),
    this.isBoss = false,
  });

  @override
  State<NoctusIntroOverlay> createState() => _NoctusIntroOverlayState();
}

class _NoctusIntroOverlayState extends State<NoctusIntroOverlay>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _slideCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _noctusSlide;
  late Animation<double> _pulse;

  int _dialogStep = 0; // 0 = Noctus habla, 1 = Orión responde, 2 = listo

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _noctusSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutBack));
    _pulse = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Avanzar automáticamente al paso 1 en 2s
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _dialogStep = 1);
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        color: Colors.black.withValues(alpha: 0.88),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // ─── Noctus habla ───────────────────
              SlideTransition(
                position: _noctusSlide,
                child: _buildNoctusCard(),
              ),

              const SizedBox(height: 24),

              // ─── Orión responde ─────────────────
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _dialogStep >= 1 ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: OrionFloating(
                    message: widget.isBoss
                        ? '¡Es el guardián del reino! Usa todo lo que has aprendido 💪'
                        : '¡No te dejes intimidar! ¡Tú puedes con ${widget.enemyName}!',
                    mood: OrionMood.excited,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ─── Botón de combate ───────────────
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _dialogStep >= 1 ? 1.0 : 0.0,
                child: GestureDetector(
                  onTap: widget.onComplete,
                  child: ScaleTransition(
                    scale: _pulse,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 48),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.enemyColor,
                            widget.enemyColor.withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.enemyColor.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.isBoss ? '⚔️ ¡ENFRENTAR AL BOSS!' : '⚔️ ¡AL COMBATE!',
                            style: ArcanaTextStyles.cardTitle.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoctusCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0030), Color(0xFF0A0018)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C4DFF).withValues(alpha: 0.25),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Encabezado Noctus
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
                    border: Border.all(
                      color: const Color(0xFF7C4DFF).withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Center(
                    child: Text('🌑', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOCTUS',
                      style: ArcanaTextStyles.cardTitle.copyWith(
                        color: const Color(0xFF9D7BFF),
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Señor de la Ignorancia',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Enemigo que envía
                Column(
                  children: [
                    Text(widget.enemyEmoji, style: const TextStyle(fontSize: 30)),
                    Text(
                      widget.enemyName,
                      style: ArcanaTextStyles.caption.copyWith(
                        color: widget.enemyColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Línea divisora
            Container(
              height: 1,
              color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            // Diálogo de Noctus
            Text(
              '"${widget.noctusLine}"',
              style: ArcanaTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
