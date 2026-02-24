import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';
import 'story_chapter_screen.dart';
import '../data/story_prologue.dart';
import '../data/story_chapter1_ignis.dart';

/// Pantalla de Intro de Capítulo — diseño Libro Abierto.
/// Columna izquierda: ilustración animada + título + metadata.
/// Columna derecha: texto narrativo paginado.
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
  late AnimationController _glowCtrl;
  final _pageCtrl = PageController();
  int _currentPage = 0;
  String _readingMode = 'extended';
  late final List<String> _pages;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    // Split description into chunks of ~220 chars
    final words = widget.description.split(' ');
    const chunkSize = 220;
    final chunks = <String>[];
    var buf = '';
    for (final w in words) {
      if ((buf.isEmpty ? w : '$buf $w').length > chunkSize) {
        if (buf.isNotEmpty) chunks.add(buf.trim());
        buf = w;
      } else {
        buf = buf.isEmpty ? w : '$buf $w';
      }
    }
    if (buf.isNotEmpty) chunks.add(buf.trim());
    _pages = chunks.isEmpty ? [widget.description] : chunks;
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: const Color(0xFF080110),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.4,
                colors: [
                  widget.gemColor.withValues(alpha: 0.12),
                  const Color(0xFF050208),
                ],
              ),
            ),
          ),
          MagicalParticles(particleCount: 18, color: widget.gemColor, maxSize: 2),
          SafeArea(
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white38, size: 18),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.gemColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: widget.gemColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          '📖 IGNIS · CAP ${widget.chapterNumber}',
                          style: ArcanaTextStyles.caption.copyWith(
                            color: widget.gemColor,
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // ── BOOK ─────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: isWide ? _buildOpenBook() : _buildMobileBook(),
                  ),
                ),

                // ── Bottom CTA ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                  child: Row(
                    children: [
                      if (_pages.length > 1) ...[
                        ..._pages.asMap().entries.map((e) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 5),
                          width: e.key == _currentPage ? 18 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: e.key == _currentPage ? widget.gemColor : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                        const Spacer(),
                      ],
                      if (_currentPage < _pages.length - 1)
                        ElevatedButton.icon(
                          onPressed: () => _pageCtrl.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('Continuar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.gemColor.withValues(alpha: 0.85),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        )
                      else
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _startChapter,
                            icon: const Text('⚔️', style: TextStyle(fontSize: 16)),
                            label: const Text(
                              '¡EMPEZAR CAPÍTULO!',
                              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ArcanaColors.gold,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
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

  // ── Wide: true open-book ─────────────────────────────────────
  Widget _buildOpenBook() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.gemColor.withValues(alpha: 0.25),
            blurRadius: 40, spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Expanded(child: _buildLeftPage()),
            Container(width: 4, color: widget.gemColor.withValues(alpha: 0.4)),
            Expanded(child: _buildRightPage()),
          ],
        ),
      ),
    );
  }

  // ── Narrow: stacked ──────────────────────────────────────────
  Widget _buildMobileBook() {
    return Column(
      children: [
        _buildMobileHeader(),
        const SizedBox(height: 12),
        Expanded(child: _buildRightPage()),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color.lerp(
              widget.gemColor.withValues(alpha: 0.4),
              widget.gemColor.withValues(alpha: 0.9),
              _glowCtrl.value,
            )!,
          ),
        ),
        child: Row(
          children: [
            Text('🔥', style: TextStyle(fontSize: 40 + _glowCtrl.value * 4)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: widget.gemColor,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.topic,
                    style: ArcanaTextStyles.caption.copyWith(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPage() {
    return Container(
      color: const Color(0xFF0F0520),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated glowing orb
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (_, child) {
              final g = _glowCtrl.value;
              return Container(
                width: 130, height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(
                        widget.gemColor.withValues(alpha: 0.4),
                        widget.gemColor.withValues(alpha: 0.85),
                        g,
                      )!,
                      blurRadius: 30 + g * 20,
                      spreadRadius: 5 + g * 5,
                    ),
                  ],
                  gradient: RadialGradient(colors: [
                    Color.lerp(widget.gemColor, widget.gemColor.withValues(alpha: 0.5), g)!,
                    const Color(0xFF1A0A2E),
                  ]),
                ),
                child: child,
              );
            },
            child: const Center(child: Text('🔥', style: TextStyle(fontSize: 56))),
          ),
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: ArcanaTextStyles.heroTitle.copyWith(
              color: widget.gemColor,
              fontSize: 16,
              letterSpacing: 1.5,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 28, height: 1, color: Colors.white12),
              const SizedBox(width: 8),
              Text('✦', style: TextStyle(color: widget.gemColor, fontSize: 10)),
              const SizedBox(width: 8),
              Container(width: 28, height: 1, color: Colors.white12),
            ],
          ),
          const SizedBox(height: 6),
          Text('IGNIS · CAPÍTULO ${widget.chapterNumber}',
            style: ArcanaTextStyles.caption.copyWith(
              color: Colors.white38, letterSpacing: 3, fontSize: 9,
            ),
          ),
          const SizedBox(height: 24),
          // Meta chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              _chip('🎭 ${widget.totalScenes} escenas'),
              _chip('⏱ ~5 min'),
              _chip('📚 ${widget.topic}'),
            ],
          ),
          const SizedBox(height: 20),
          // Reading mode toggle
          _buildReadingModeToggle(),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: widget.gemColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.gemColor.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: ArcanaTextStyles.caption.copyWith(
        color: Colors.white60, fontSize: 10,
      )),
    );
  }

  Widget _buildReadingModeToggle() {
    return Column(
      children: [
        Text('Modo de lectura', style: ArcanaTextStyles.caption.copyWith(
          color: Colors.white38, fontSize: 10,
        )),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _modeBtn('🐢', 'Estándar',  'standard'),
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
            color: active ? widget.gemColor : Colors.white24,
            width: active ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(label, style: ArcanaTextStyles.caption.copyWith(
              color: active ? widget.gemColor : Colors.white38,
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPage() {
    return Container(
      color: const Color(0xFF130920),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.gemColor.withValues(alpha: 0.15),
                  border: Border.all(color: widget.gemColor.withValues(alpha: 0.5)),
                ),
                child: const Center(child: Text('🧙', style: TextStyle(fontSize: 14))),
              ),
              const SizedBox(width: 8),
              Text('Orión narra...',
                style: ArcanaTextStyles.caption.copyWith(
                  color: widget.gemColor.withValues(alpha: 0.8),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              if (_pages.length > 1)
                Text('${_currentPage + 1} / ${_pages.length}',
                  style: ArcanaTextStyles.caption.copyWith(color: Colors.white24, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 10),
          Text('"',
            style: TextStyle(
              fontSize: 32,
              color: widget.gemColor.withValues(alpha: 0.4),
              height: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => Text(
                _pages[i],
                style: const TextStyle(
                  color: Color(0xFFD4C4F0),
                  fontSize: 15,
                  height: 1.8,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('"',
              style: TextStyle(
                fontSize: 32,
                color: widget.gemColor.withValues(alpha: 0.4),
                height: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
