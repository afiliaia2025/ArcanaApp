import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/arcana_buttons.dart';
import '../widgets/magical_particles.dart';
import 'story_chapter_screen.dart';
import '../data/story_prologue.dart';
import '../data/story_chapter1_ignis.dart';

/// Pantalla de Intro de Capítulo.
/// Se muestra antes de empezar un capítulo, con la ilustración,
/// título, descripción, meta-datos y botón de empezar.
class ChapterIntroScreen extends StatefulWidget {
  final int chapterNumber;
  final String title;
  final String description;
  final int totalScenes;
  final String topic;
  final Color gemColor;

  const ChapterIntroScreen({
    super.key,
    required this.chapterNumber,
    required this.title,
    required this.description,
    this.totalScenes = 6,
    this.topic = 'Medidas de capacidad',
    required this.gemColor,
  });

  @override
  State<ChapterIntroScreen> createState() => _ChapterIntroScreenState();
}

class _ChapterIntroScreenState extends State<ChapterIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  String _readingMode = 'extended'; // 'standard' o 'extended'

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.gemColor.withValues(alpha: 0.1),
                  ArcanaColors.background,
                ],
              ),
            ),
          ),

          MagicalParticles(
            particleCount: 15,
            color: widget.gemColor,
            maxSize: 2.0,
          ),

          SafeArea(
            child: AnimatedBuilder(
              animation: _entryController,
              builder: (context, child) {
                return Column(
                  children: [
                    // Header
                    _buildHeader(),

                    const SizedBox(height: 16),

                    // Contenido central
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: _buildContent(),
                      ),
                    ),

                    // Botón de empezar
                    _buildStartButton(),

                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ArcanaColors.surfaceBorder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: ArcanaColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Cap ${widget.chapterNumber}',
            style: ArcanaTextStyles.cardTitle.copyWith(
              color: widget.gemColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final illustrationFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    final textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ilustración del capítulo (placeholder)
        FadeTransition(
          opacity: illustrationFade,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: ArcanaColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.gemColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: widget.gemColor.withValues(alpha: 0.3),
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ilustración del capítulo',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Título
        SlideTransition(
          position: textSlide,
          child: Column(
            children: [
              Text(
                widget.title,
                style: ArcanaTextStyles.screenTitle.copyWith(
                  color: ArcanaColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Separador
              Container(
                width: 80,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      widget.gemColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Descripción narrativa
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ArcanaColors.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ArcanaColors.surfaceBorder,
                  ),
                ),
                child: Text(
                  '"${widget.description}"',
                  style: ArcanaTextStyles.bodyMedium.copyWith(
                    color: ArcanaColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Meta-datos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMetaChip(
                    Icons.theater_comedy,
                    '${widget.totalScenes} escenas',
                  ),
                  const SizedBox(width: 16),
                  _buildMetaChip(Icons.timer, '~5 min'),
                  const SizedBox(width: 16),
                  _buildMetaChip(Icons.school, widget.topic),
                ],
              ),

              const SizedBox(height: 20),

              // ─── Selector de modo de lectura ─────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ArcanaColors.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ArcanaColors.surfaceBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Modo de lectura',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: ArcanaColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _readingMode = 'standard'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _readingMode == 'standard'
                                    ? widget.gemColor.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _readingMode == 'standard'
                                      ? widget.gemColor
                                      : ArcanaColors.surfaceBorder,
                                  width: _readingMode == 'standard' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text('🐢', style: TextStyle(fontSize: 24)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Estándar',
                                    style: ArcanaTextStyles.caption.copyWith(
                                      color: _readingMode == 'standard'
                                          ? widget.gemColor
                                          : ArcanaColors.textMuted,
                                      fontWeight: _readingMode == 'standard'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Texto corto',
                                    style: ArcanaTextStyles.caption.copyWith(
                                      color: ArcanaColors.textMuted,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _readingMode = 'extended'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _readingMode == 'extended'
                                    ? widget.gemColor.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _readingMode == 'extended'
                                      ? widget.gemColor
                                      : ArcanaColors.surfaceBorder,
                                  width: _readingMode == 'extended' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text('🚀', style: TextStyle(fontSize: 24)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Extendida',
                                    style: ArcanaTextStyles.caption.copyWith(
                                      color: _readingMode == 'extended'
                                          ? widget.gemColor
                                          : ArcanaColors.textMuted,
                                      fontWeight: _readingMode == 'extended'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Texto completo',
                                    style: ArcanaTextStyles.caption.copyWith(
                                      color: ArcanaColors.textMuted,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ],
    );
  }

  Widget _buildMetaChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ArcanaColors.surfaceBorder,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: widget.gemColor, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    final buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    return FadeTransition(
      opacity: buttonFade,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: ArcanaGoldButton(
          text: '¡Empezar!',
          icon: Icons.play_arrow,
          width: 280,
          onPressed: () {
            // Elegir qué capítulo lanzar según el número
            final chapter = widget.chapterNumber == 0
                ? storyPrologue
                : chapter1Ignis;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StoryChapterScreen(
                  chapter: chapter,
                  gemColor: widget.gemColor,
                  readingMode: _readingMode,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
