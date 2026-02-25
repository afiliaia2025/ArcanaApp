import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';
import 'story_chapter_screen.dart';
import '../data/story_prologue.dart';
import '../data/story_chapter1_ignis.dart';

/// Pantalla de Intro de Capítulo — 2 columnas siempre horizontal.
/// Izq: título + metadata + modo lectura.  Der: descripción narrativa.
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
  late AnimationController _fadeCtrl;
  String _readingMode = 'extended';

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.gemColor.withValues(alpha: 0.08),
                  ArcanaColors.background,
                ],
              ),
            ),
          ),
          MagicalParticles(particleCount: 15, color: widget.gemColor, maxSize: 2),
          SafeArea(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn),
              child: Column(
                children: [
                  // ── Header ──
                  Padding(
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
                            child: const Icon(Icons.arrow_back, color: ArcanaColors.textPrimary, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Cap ${widget.chapterNumber}',
                          style: ArcanaTextStyles.cardTitle.copyWith(color: widget.gemColor),
                        ),
                      ],
                    ),
                  ),

                  // ── 2 columnas ──
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── COL IZQ: Título + metadata ──
                          Expanded(child: _buildLeftColumn()),
                          const SizedBox(width: 12),
                          // ── COL DER: Descripción narrativa ──
                          Expanded(child: _buildRightColumn()),
                        ],
                      ),
                    ),
                  ),

                  // ── Botón empezar ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 4, 32, 20),
                    child: GestureDetector(
                      onTap: _startChapter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: ArcanaColors.goldGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: ArcanaColors.gold.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '⚔️ ¡EMPEZAR!',
                          style: ArcanaTextStyles.cardTitle.copyWith(
                            color: const Color(0xFF1A1130),
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startChapter() {
    final chapter = widget.chapterNumber == 0 ? storyPrologue : chapter1Ignis;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoryChapterScreen(
          chapter: chapter,
          gemColor: widget.gemColor,
          readingMode: _readingMode,
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.gemColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji de capítulo
          Text('🔥', style: TextStyle(fontSize: 52)),

          const SizedBox(height: 16),

          // Título
          Text(
            widget.title,
            style: ArcanaTextStyles.screenTitle.copyWith(color: ArcanaColors.textPrimary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Separador
          Container(
            width: 60, height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, widget.gemColor, Colors.transparent],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Meta chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8, runSpacing: 6,
            children: [
              _chip('🎭 ${widget.totalScenes} escenas'),
              _chip('⏱ ~5 min'),
              _chip('📚 ${widget.topic}'),
            ],
          ),

          const SizedBox(height: 20),

          // Modo lectura
          _buildReadingModeToggle(),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.gemColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.gemColor.withValues(alpha: 0.12)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: widget.gemColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('📖 Sinopsis', style: ArcanaTextStyles.caption.copyWith(
                color: widget.gemColor, fontWeight: FontWeight.w600,
              )),
            ),
            const SizedBox(height: 16),
            Text(
              '"${widget.description}"',
              style: ArcanaTextStyles.bodyMedium.copyWith(
                color: ArcanaColors.textPrimary,
                fontStyle: FontStyle.italic,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ArcanaColors.surfaceBorder,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: ArcanaTextStyles.caption.copyWith(
        color: ArcanaColors.textSecondary, fontSize: 10,
      )),
    );
  }

  Widget _buildReadingModeToggle() {
    return Column(
      children: [
        Text('Modo de lectura', style: ArcanaTextStyles.caption.copyWith(
          color: ArcanaColors.textSecondary, fontSize: 11,
        )),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _modeBtn('🐢', 'Estándar', 'standard'),
            const SizedBox(width: 8),
            _modeBtn('🚀', 'Extendida', 'extended'),
          ],
        ),
      ],
    );
  }

  Widget _modeBtn(String emoji, String label, String mode) {
    final active = _readingMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _readingMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? widget.gemColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? widget.gemColor : ArcanaColors.surfaceBorder,
            width: active ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(label, style: ArcanaTextStyles.caption.copyWith(
              color: active ? widget.gemColor : ArcanaColors.textMuted,
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            )),
          ],
        ),
      ),
    );
  }
}
