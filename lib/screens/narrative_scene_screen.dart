import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/arcana_buttons.dart';
import 'exercise_screen.dart';

/// Pantalla de escena narrativa (viñeta).
/// Muestra una ilustración, texto narrativo y botón de continuar.
/// Es la transición entre ejercicios — construye la historia.
class NarrativeSceneScreen extends StatefulWidget {
  final int chapterNumber;
  final int sceneIndex;
  final int totalScenes;
  final String narrativeText;
  final Color gemColor;
  final String? illustrationAsset;

  const NarrativeSceneScreen({
    super.key,
    required this.chapterNumber,
    required this.sceneIndex,
    required this.totalScenes,
    required this.narrativeText,
    required this.gemColor,
    this.illustrationAsset,
  });

  @override
  State<NarrativeSceneScreen> createState() => _NarrativeSceneScreenState();
}

class _NarrativeSceneScreenState extends State<NarrativeSceneScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _textRevealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    // Revelar texto automáticamente después de un momento
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _textRevealed = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo sutil
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.gemColor.withValues(alpha: 0.05),
                  ArcanaColors.background,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header con indicador de escenas
                _buildSceneHeader(),

                // Contenido
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildContent(),
                  ),
                ),

                // Botón continuar
                if (_textRevealed) _buildContinueButton(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Indicador cap/escena
          Text(
            'Cap ${widget.chapterNumber} · Escena ${widget.sceneIndex}/${widget.totalScenes}',
            style: ArcanaTextStyles.caption.copyWith(
              color: widget.gemColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Puntos de progreso de escenas
          Row(
            children: List.generate(widget.totalScenes, (i) {
              final isActive = i < widget.sceneIndex;
              final isCurrent = i == widget.sceneIndex - 1;
              return Container(
                width: isCurrent ? 16 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? widget.gemColor
                      : ArcanaColors.surfaceBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final imageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ilustración
        FadeTransition(
          opacity: imageFade,
          child: Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: ArcanaColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.gemColor.withValues(alpha: 0.2),
              ),
            ),
            child: widget.illustrationAsset != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      widget.illustrationAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, s) => _buildPlaceholderIllustration(),
                    ),
                  )
                : _buildPlaceholderIllustration(),
          ),
        ),

        const SizedBox(height: 24),

        // Texto narrativo con animación de aparición
        AnimatedOpacity(
          opacity: _textRevealed ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeIn,
          child: AnimatedSlide(
            offset: _textRevealed ? Offset.zero : const Offset(0, 0.1),
            duration: const Duration(milliseconds: 800),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ArcanaColors.surface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ArcanaColors.surfaceBorder,
                ),
              ),
              child: Text(
                widget.narrativeText,
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: ArcanaColors.textPrimary,
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIllustration() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.landscape,
            color: widget.gemColor.withValues(alpha: 0.3),
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Ilustración de la escena',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return AnimatedOpacity(
      opacity: _textRevealed ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: ArcanaOutlinedButton(
          text: 'Continuar →',
          color: widget.gemColor,
          onPressed: () {
            // Avanza a un ejercicio interactivo
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ExerciseScreen(
                  chapterNumber: widget.chapterNumber,
                  sceneIndex: widget.sceneIndex,
                  totalScenes: widget.totalScenes,
                  question:
                      '¿Cuántos litros caben en una botella que tiene '
                      'capacidad de 2.500 mililitros?',
                  options: const [
                    '25 litros',
                    '2,5 litros',
                    '250 litros',
                    '0,25 litros',
                  ],
                  correctIndex: 1,
                  gemColor: widget.gemColor,
                  hint: 'Recuerda: 1 litro = 1.000 mililitros',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
