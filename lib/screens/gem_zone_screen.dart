import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';
import 'chapter_intro_screen.dart';
import 'boss_battle_screen.dart';

/// Modelo de datos para un capítulo dentro de una gema.
class ChapterData {
  final int number;
  final String title;
  final String topic;
  final ChapterState state;
  final bool isBoss;

  const ChapterData({
    required this.number,
    required this.title,
    this.topic = '',
    this.state = ChapterState.locked,
    this.isBoss = false,
  });
}

enum ChapterState { completed, current, locked }

/// Pantalla de la Zona de Gema — Mapa de capítulos vertical.
/// Muestra un camino de nodos (capítulos) conectados con líneas,
/// scrollable verticalmente, con el progreso del jugador.
class GemZoneScreen extends StatefulWidget {
  final String gemName;
  final String subject;
  final Color gemColor;
  final String gemIconAsset;

  const GemZoneScreen({
    super.key,
    required this.gemName,
    required this.subject,
    required this.gemColor,
    required this.gemIconAsset,
  });

  @override
  State<GemZoneScreen> createState() => _GemZoneScreenState();
}

class _GemZoneScreenState extends State<GemZoneScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late ScrollController _scrollController;

  // Datos de demo para capítulos
  late final List<ChapterData> _chapters;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scrollController = ScrollController();

    _chapters = [
      const ChapterData(number: 0, title: '📖 Prólogo: La Carta', topic: 'Intro a la aventura', state: ChapterState.completed),
      const ChapterData(number: 1, title: 'La Puerta de la Torre', topic: 'Números 0-99, unidades y decenas', state: ChapterState.current),
      const ChapterData(number: 2, title: 'Las Escaleras de Cristal', topic: 'Números hasta 199, series'),
      const ChapterData(number: 3, title: 'El Coleccionista de Runas', topic: 'Sumas y descomposición'),
      const ChapterData(number: 4, title: 'El Reloj de la Torre', topic: 'Hora en punto y media hora'),
      const ChapterData(number: 5, title: 'El Torneo', topic: 'Números hasta 299, comparar'),
      const ChapterData(number: 0, title: 'Boss: Numerox Guardián', isBoss: true),
      const ChapterData(number: 6, title: 'La Ventisca de Noctus', topic: 'Restas sin llevada'),
      const ChapterData(number: 7, title: 'Las Cometas del Mensajero', topic: 'Sumas con llevada'),
      const ChapterData(number: 8, title: 'El Huerto Encantado', topic: 'Medida: longitud'),
      const ChapterData(number: 9, title: 'La Fuente Seca', topic: 'Medida: capacidad'),
      const ChapterData(number: 0, title: 'Boss: General de Piedra', isBoss: true),
      const ChapterData(number: 10, title: 'El Pergamino Cifrado', topic: 'Multiplicación'),
      const ChapterData(number: 11, title: 'El Mercado Oscuro', topic: 'Monedas y billetes'),
      const ChapterData(number: 12, title: 'La Sala de los Espejos', topic: 'Geometría'),
      const ChapterData(number: 13, title: 'El Banquete Final', topic: 'Repaso general'),
      const ChapterData(number: 0, title: 'Boss Final: Ignis', isBoss: true),
    ];

    // Scroll al capítulo actual tras el build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentChapter();
    });
  }

  void _scrollToCurrentChapter() {
    final currentIndex = _chapters.indexWhere((c) => c.state == ChapterState.current);
    if (currentIndex >= 0 && _scrollController.hasClients) {
      final targetOffset = (currentIndex * 120.0 - 200).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _chapters.where(
      (c) => c.state == ChapterState.completed && !c.isBoss,
    ).length;
    final totalCount = _chapters.where((c) => !c.isBoss).length;

    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con gradiente de la gema
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.gemColor.withValues(alpha: 0.15),
                  ArcanaColors.background,
                  ArcanaColors.background,
                ],
              ),
            ),
          ),

          // Partículas sutiles del color de la gema
          MagicalParticles(
            particleCount: 25,
            color: widget.gemColor,
            maxSize: 2.0,
          ),

          // Contenido
          SafeArea(
            child: Column(
              children: [
                // ─── Header ─────────────────────
                _buildHeader(completedCount, totalCount),

                // ─── Mapa de capítulos ──────────
                Expanded(
                  child: _buildChapterMap(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int completed, int total) {
    final progress = completed / total;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.gemColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Botón atrás
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

          // Icono de gema
          Image.asset(
            widget.gemIconAsset,
            width: 32,
            height: 32,
            errorBuilder: (_, e, s) => Icon(
              Icons.diamond,
              color: widget.gemColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 10),

          // Nombre y progreso
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gema ${widget.gemName}',
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: widget.gemColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Barra de progreso
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: ArcanaColors.surfaceBorder,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.gemColor.withValues(alpha: 0.7),
                                  widget.gemColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.gemColor.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$completed/$total',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: widget.gemColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterMap() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      itemCount: _chapters.length,
      itemBuilder: (context, index) {
        final chapter = _chapters[index];
        final isLast = index == _chapters.length - 1;

        // Zigzag horizontal para que no sea una línea recta
        final offsetX = (index % 3 == 0)
            ? 0.0
            : (index % 3 == 1)
                ? 50.0
                : -50.0;

        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: Column(
            children: [
              // Nodo del capítulo
              _buildChapterNode(chapter, index),

              // Línea conectora (excepto el último)
              if (!isLast) _buildConnectorLine(chapter, _chapters[index + 1]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChapterNode(ChapterData chapter, int index) {
    final isCurrent = chapter.state == ChapterState.current;
    final isCompleted = chapter.state == ChapterState.completed;
    final isLocked = chapter.state == ChapterState.locked;

    final nodeSize = chapter.isBoss ? 80.0 : 64.0;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              if (chapter.isBoss) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BossBattleScreen(
                      bossName: chapter.title,
                      gemColor: widget.gemColor,
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChapterIntroScreen(
                      chapterNumber: chapter.number,
                      title: chapter.title,
                      topic: chapter.topic,
                      description:
                          'La aventura continúa en ${chapter.title}. '
                          'Nuevos desafíos y misterios te esperan en este capítulo de la gema ${widget.gemName}.',
                      gemColor: widget.gemColor,
                    ),
                  ),
                );
              }
            },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseScale =
              isCurrent ? 1.0 + _pulseController.value * 0.05 : 1.0;

          return Transform.scale(
            scale: pulseScale,
            child: Column(
              children: [
                // Nodo circular
                Container(
                  width: nodeSize,
                  height: nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLocked
                        ? ArcanaColors.surfaceBorder
                        : isCompleted
                            ? widget.gemColor.withValues(alpha: 0.2)
                            : widget.gemColor.withValues(alpha: 0.3),
                    border: Border.all(
                      color: isLocked
                          ? ArcanaColors.textMuted.withValues(alpha: 0.3)
                          : isCurrent
                              ? ArcanaColors.gold
                              : widget.gemColor,
                      width: isCurrent ? 3 : 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: ArcanaColors.gold.withValues(
                                alpha: 0.3 + _pulseController.value * 0.2,
                              ),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : isCompleted
                            ? [
                                BoxShadow(
                                  color: widget.gemColor.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                  ),
                  child: Center(
                    child: chapter.isBoss
                        ? Icon(
                            isCompleted ? Icons.check : Icons.whatshot,
                            color: isLocked
                                ? ArcanaColors.textMuted
                                : isCompleted
                                    ? ArcanaColors.gold
                                    : ArcanaColors.ruby,
                            size: 28,
                          )
                        : isCompleted
                            ? const Icon(
                                Icons.check,
                                color: ArcanaColors.gold,
                                size: 24,
                              )
                            : isLocked
                                ? const Icon(
                                    Icons.lock,
                                    color: ArcanaColors.textMuted,
                                    size: 20,
                                  )
                                : Text(
                                    '${chapter.number}',
                                    style:
                                        ArcanaTextStyles.cardTitle.copyWith(
                                      color: ArcanaColors.gold,
                                    ),
                                  ),
                  ),
                ),

                const SizedBox(height: 6),

                // Nombre del capítulo
                Text(
                  chapter.isBoss ? '⚔️ ${chapter.title}' : chapter.title,
                  style: (chapter.isBoss
                          ? ArcanaTextStyles.cardTitle
                          : ArcanaTextStyles.caption)
                      .copyWith(
                    color: isLocked
                        ? ArcanaColors.textMuted
                        : isCurrent
                            ? ArcanaColors.gold
                            : ArcanaColors.textSecondary,
                    fontWeight:
                        isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Indicador "TÚ ESTÁS AQUÍ"
                if (isCurrent) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: ArcanaColors.gold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ArcanaColors.gold.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      '→ TÚ',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: ArcanaColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConnectorLine(ChapterData from, ChapterData to) {
    final isActive = from.state == ChapterState.completed;
    return Container(
      width: 3,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isActive
              ? [widget.gemColor, widget.gemColor.withValues(alpha: 0.5)]
              : [
                  ArcanaColors.surfaceBorder,
                  ArcanaColors.surfaceBorder.withValues(alpha: 0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: widget.gemColor.withValues(alpha: 0.3),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
    );
  }
}
