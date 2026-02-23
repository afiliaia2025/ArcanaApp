import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/arcana_buttons.dart';
import '../widgets/magical_particles.dart';
import 'map_screen.dart';

/// Pantalla de título / portada de ArcanaApp.
/// La primera pantalla que ve el jugador — debe ser ESPECTACULAR.
///
/// Si existe la imagen de portada en assets/images/screens/title_bg.png,
/// la usa como fondo. Si no, muestra un fondo degradado navy con partículas.
class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _titleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _titleScale;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _buttonsOpacity;

  final AudioPlayer _bgMusic = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Animación de entrada de toda la pantalla
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Animación del título
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _titleScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _buttonsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Arrancar animaciones en secuencia
    _fadeController.forward().then((_) {
      _titleController.forward();
    });

    // Arrancar música de fondo
    _startBgMusic();
  }

  Future<void> _startBgMusic() async {
    try {
      await _bgMusic.setSource(AssetSource(
        'music/whimsical-orchestral-fantasy-theme-gentle-celesta-melody-warm-strings-soft-harp-arpeggios-magical-chimes-children\'s-adventure-game-soundtrack-studio-ghibli-inspired-90-bpm-hopeful-and-inviting-high-quality-loop_022.mp3',
      ));
      await _bgMusic.setVolume(0.25);
      await _bgMusic.setReleaseMode(ReleaseMode.loop);
      await _bgMusic.resume();
    } catch (_) {}
  }

  void _navigateToMap() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, b) => const MapScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (_, animation, a, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _titleController.dispose();
    _bgMusic.stop();
    _bgMusic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ─── Fondo ──────────────────────────
            _buildBackground(),

            // ─── Partículas mágicas ─────────────
            const MagicalParticles(
              particleCount: 60,
              color: ArcanaColors.gold,
              maxSize: 3.5,
            ),

            // Partículas turquesa (más sutiles)
            const MagicalParticles(
              particleCount: 20,
              color: ArcanaColors.turquoise,
              maxSize: 2.0,
            ),

            // ─── Viñeta oscura (bordes) ─────────
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [Colors.transparent, Color(0xCC0C1222)],
                ),
              ),
            ),

            // ─── Contenido principal ────────────
            AnimatedBuilder(
              animation: _titleController,
              builder: (context, _) => _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    // Intenta cargar la imagen de portada
    return Image.asset(
      'assets/images/screens/title_bg.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback: gradiente oscuro con estrellas
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1040), // Violeta oscuro arriba
                Color(0xFF0C1222), // Navy abajo
                Color(0xFF0A0E1A), // Más oscuro en la base
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empujar botones al fondo (debajo del personaje de la imagen)
            const Spacer(flex: 7),

            // ─── Botones ──────────────────────
            FadeTransition(
              opacity: _buttonsOpacity,
              child: Column(
                children: [
                  // Botón primario: Nueva Aventura
                  ArcanaGoldButton(
                    text: 'Nueva Aventura',
                    icon: Icons.auto_awesome,
                    width: 300,
                    onPressed: () => _navigateToMap(),
                  ),
                  const SizedBox(height: 16),

                  // Botón secundario: Continuar
                  ArcanaOutlinedButton(
                    text: 'Continuar',
                    icon: Icons.menu_book_rounded,
                    color: ArcanaColors.goldLight,
                    onPressed: () => _navigateToMap(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─── Versión ──────────────────────
            FadeTransition(
              opacity: _buttonsOpacity,
              child: Text(
                'v0.1.0',
                style: ArcanaTextStyles.caption.copyWith(
                  color: ArcanaColors.textMuted.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Separador dorado ornamental: ──◆──
  Widget _buildOrnamentalDivider() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                ArcanaColors.gold.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.diamond, color: ArcanaColors.gold, size: 10),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ArcanaColors.gold.withValues(alpha: 0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
