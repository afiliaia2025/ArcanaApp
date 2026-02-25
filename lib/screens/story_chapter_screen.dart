import 'package:flutter/material.dart';
import '../models/story_models.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';
import 'chapter_result_screen.dart';

/// Pantalla principal de historia interactiva.
/// Renderiza un StoryChapter como un libro de "elige tu propia aventura"
/// intercalando viñetas narrativas con ejercicios curriculares.
///
/// Flujo: Viñeta → Ejercicio → (acierto: camino A / fallo: camino B)
///        → Decisión → Viñeta → … → Final (ChapterResultScreen)
class StoryChapterScreen extends StatefulWidget {
  final StoryChapter chapter;
  final Color gemColor;
  final String readingMode; // 'standard' o 'extended'

  const StoryChapterScreen({
    super.key,
    required this.chapter,
    required this.gemColor,
    this.readingMode = 'extended',
  });

  @override
  State<StoryChapterScreen> createState() => _StoryChapterScreenState();
}

class _StoryChapterScreenState extends State<StoryChapterScreen>
    with TickerProviderStateMixin {
  late String _currentNodeId;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // Estado del ejercicio actual
  int? _selectedAnswer;
  bool _answered = false;
  bool _isCorrect = false;
  bool _showHint = false;

  // Historial de nodos visitados
  final List<String> _visitedNodes = [];
  int _correctCount = 0;
  int _totalExercises = 0;

  @override
  void initState() {
    super.initState();
    _currentNodeId = widget.chapter.startNodeId;

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  StoryNode get _currentNode => widget.chapter.nodes[_currentNodeId]!;

  bool get _isStandard => widget.readingMode == 'standard';

  /// Devuelve el texto adaptado al modo de lectura.
  /// En modo estándar, trunca a ~120 caracteres.
  String _narrativeText(String? text) {
    if (text == null) return '';
    if (!_isStandard) return text;
    if (text.length <= 120) return text;
    // Cortar en el último espacio antes de 120
    final cut = text.substring(0, 120).lastIndexOf(' ');
    return '${text.substring(0, cut > 0 ? cut : 120)}…';
  }

  void _goToNode(String nodeId) {
    _visitedNodes.add(_currentNodeId);

    // Resetear estado de ejercicio
    _selectedAnswer = null;
    _answered = false;
    _isCorrect = false;
    _showHint = false;

    // Animar transición
    _fadeController.reset();
    _slideController.reset();

    setState(() {
      _currentNodeId = nodeId;
    });

    _fadeController.forward();
    _slideController.forward();
  }

  void _handleContinue() {
    final node = _currentNode;

    if (node.type == StoryNodeType.ending) {
      // Ir a la pantalla de resultados
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChapterResultScreen(
            chapterTitle: widget.chapter.title,
            gemColor: widget.gemColor,
          ),
        ),
      );
      return;
    }

    if (node.nextNode != null) {
      _goToNode(node.nextNode!);
    }
  }

  void _handleAnswer(int index) {
    if (_answered) return;

    final node = _currentNode;
    final correct = index == node.correctIndex;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _isCorrect = correct;
      _totalExercises++;
      if (correct) _correctCount++;
    });
  }

  void _handleExerciseContinue() {
    final node = _currentNode;
    if (_isCorrect && node.onCorrect != null) {
      _goToNode(node.onCorrect!);
    } else if (!_isCorrect && node.onIncorrect != null) {
      _goToNode(node.onIncorrect!);
    } else if (node.nextNode != null) {
      _goToNode(node.nextNode!);
    }
  }

  void _handleChoice(String nodeId) {
    _goToNode(nodeId);
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.gemColor.withValues(alpha: 0.08),
                  ArcanaColors.background,
                  const Color(0xFF0A0E1A),
                ],
              ),
            ),
          ),

          // Partículas
          MagicalParticles(
            particleCount: _currentNode.type == StoryNodeType.exercise ? 10 : 20,
            color: _currentNode.type == StoryNodeType.exercise
                ? ArcanaColors.gold
                : widget.gemColor,
            maxSize: 2.0,
          ),

          // Contenido
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _fadeController,
                      curve: Curves.easeIn,
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeOut,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildCurrentNode(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Botón atrás
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: ArcanaColors.surface,
                  title: Text(
                    '¿Salir del capítulo?',
                    style: ArcanaTextStyles.cardTitle.copyWith(
                      color: ArcanaColors.textPrimary,
                    ),
                  ),
                  content: Text(
                    'Perderás el progreso de este capítulo.',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: ArcanaColors.textSecondary,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Seguir jugando'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Salir',
                        style: TextStyle(color: ArcanaColors.ruby),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ArcanaColors.surface,
                border: Border.all(color: ArcanaColors.surfaceBorder),
              ),
              child: const Icon(
                Icons.close,
                color: ArcanaColors.textPrimary,
                size: 16,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Título del capítulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cap ${widget.chapter.number} · ${widget.chapter.gemName}',
                  style: ArcanaTextStyles.caption.copyWith(
                    color: widget.gemColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.chapter.title,
                  style: ArcanaTextStyles.bodySmall.copyWith(
                    color: ArcanaColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Tipo de nodo actual
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _nodeTypeColor().withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _nodeTypeColor().withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_nodeTypeEmoji(), style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  _nodeTypeLabel(),
                  style: ArcanaTextStyles.caption.copyWith(
                    color: _nodeTypeColor(),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _nodeTypeColor() {
    switch (_currentNode.type) {
      case StoryNodeType.narrative:
        return widget.gemColor;
      case StoryNodeType.exercise:
        return ArcanaColors.gold;
      case StoryNodeType.decision:
        return ArcanaColors.turquoise;
      case StoryNodeType.ending:
        return ArcanaColors.emerald;
    }
  }

  String _nodeTypeEmoji() {
    switch (_currentNode.type) {
      case StoryNodeType.narrative:
        return '📖';
      case StoryNodeType.exercise:
        return '⚔️';
      case StoryNodeType.decision:
        return '🔀';
      case StoryNodeType.ending:
        return '🏆';
    }
  }

  String _nodeTypeLabel() {
    switch (_currentNode.type) {
      case StoryNodeType.narrative:
        return 'Historia';
      case StoryNodeType.exercise:
        return 'Ejercicio';
      case StoryNodeType.decision:
        return 'Decisión';
      case StoryNodeType.ending:
        return '¡Final!';
    }
  }

  // ═══════════════════════════════════════════════
  // NODO ACTUAL
  // ═══════════════════════════════════════════════

  Widget _buildCurrentNode() {
    switch (_currentNode.type) {
      case StoryNodeType.narrative:
        return _buildNarrativeNode();
      case StoryNodeType.exercise:
        return _buildExerciseNode();
      case StoryNodeType.decision:
        return _buildDecisionNode();
      case StoryNodeType.ending:
        return _buildEndingNode();
    }
  }

  // ─── NARRATIVA (2 columnas) ──────────────────

  Widget _buildNarrativeNode() {
    final node = _currentNode;
    return Column(
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── COL IZQ: Texto narrativo ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ArcanaColors.surface.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: widget.gemColor.withValues(alpha: 0.15)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (node.speaker != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: widget.gemColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _speakerName(node.speaker!),
                              style: ArcanaTextStyles.caption.copyWith(
                                color: widget.gemColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          _narrativeText(node.text),
                          style: ArcanaTextStyles.bodyMedium.copyWith(
                            color: ArcanaColors.textPrimary,
                            height: 1.7,
                            fontSize: _isStandard ? 18 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ── COL DER: Ilustración ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: widget.gemColor.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: widget.gemColor.withValues(alpha: 0.12)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(node.emoji ?? '📖', style: const TextStyle(fontSize: 72)),
                        const SizedBox(height: 12),
                        if (node.speaker != null)
                          Text(
                            _speakerName(node.speaker!).replaceAll(RegExp(r'^[^ ]+ '), ''),
                            style: ArcanaTextStyles.caption.copyWith(
                              color: widget.gemColor.withValues(alpha: 0.6),
                              fontSize: 11,
                              letterSpacing: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildContinueButton('Continuar →', _handleContinue),
        const SizedBox(height: 16),
      ],
    );
  }

  String _speakerName(String speaker) {
    switch (speaker) {
      case 'narrator':
        return '📖 Narrador';
      case 'orion':
        return '🦉 Orión';
      case 'noctus':
        return '🧙‍♂️ Noctus';
      default:
        return speaker;
    }
  }

  // ─── EJERCICIO (2 columnas) ──────────────────

  Widget _buildExerciseNode() {
    final node = _currentNode;
    return Column(
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── COL IZQ: Contexto narrativo ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ArcanaColors.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: widget.gemColor.withValues(alpha: 0.15)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(node.emoji ?? '⚔️', style: const TextStyle(fontSize: 36)),
                        const SizedBox(height: 12),
                        if (node.text != null)
                          Text(
                            _narrativeText(node.text),
                            style: ArcanaTextStyles.bodyMedium.copyWith(
                              color: ArcanaColors.textSecondary,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                          ),
                        // Pista de Orión
                        if (!_answered && node.hint != null && !_showHint) ...[
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => setState(() => _showHint = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: ArcanaColors.turquoise.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ArcanaColors.turquoise.withValues(alpha: 0.2)),
                              ),
                              child: Text('🦉 Pedir pista', style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.turquoise)),
                            ),
                          ),
                        ],
                        if (_showHint && node.hint != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ArcanaColors.turquoise.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ArcanaColors.turquoise.withValues(alpha: 0.2)),
                            ),
                            child: Row(children: [
                              const Text('🦉', style: TextStyle(fontSize: 18)),
                              const SizedBox(width: 6),
                              Expanded(child: Text(node.hint!, style: ArcanaTextStyles.bodySmall.copyWith(color: ArcanaColors.turquoise, fontStyle: FontStyle.italic))),
                            ]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // ── COL DER: Ejercicio ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ArcanaColors.gold.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.15)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Pregunta
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: ArcanaColors.gold.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            node.question ?? '',
                            style: ArcanaTextStyles.bodyLarge.copyWith(
                              color: ArcanaColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Opciones
                        if (node.options != null)
                          ...List.generate(node.options!.length, (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildOptionButton(i, node),
                          )),
                        // Feedback
                        if (_answered) ...[
                          const SizedBox(height: 8),
                          _buildExerciseFeedback(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOptionButton(int index, StoryNode node) {
    final isSelected = _selectedAnswer == index;
    final isCorrectOption = index == node.correctIndex;

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (!_answered) {
      bgColor = ArcanaColors.surface;
      borderColor = ArcanaColors.surfaceBorder;
      textColor = ArcanaColors.textPrimary;
    } else if (isCorrectOption) {
      bgColor = ArcanaColors.emerald.withValues(alpha: 0.12);
      borderColor = ArcanaColors.emerald;
      textColor = ArcanaColors.emerald;
    } else if (isSelected && !_isCorrect) {
      bgColor = ArcanaColors.ruby.withValues(alpha: 0.12);
      borderColor = ArcanaColors.ruby;
      textColor = ArcanaColors.ruby;
    } else {
      bgColor = ArcanaColors.surface.withValues(alpha: 0.4);
      borderColor = ArcanaColors.surfaceBorder.withValues(alpha: 0.4);
      textColor = ArcanaColors.textMuted;
    }

    return GestureDetector(
      onTap: () => _handleAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && _answered
              ? [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.25),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Letra de opción
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: ArcanaTextStyles.caption.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                node.options![index],
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: textColor,
                ),
              ),
            ),
            if (_answered && isCorrectOption)
              const Icon(Icons.check_circle, color: ArcanaColors.emerald, size: 20),
            if (_answered && isSelected && !_isCorrect)
              const Icon(Icons.cancel, color: ArcanaColors.ruby, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseFeedback() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect
            ? ArcanaColors.emerald.withValues(alpha: 0.08)
            : ArcanaColors.ruby.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isCorrect
              ? ArcanaColors.emerald.withValues(alpha: 0.3)
              : ArcanaColors.ruby.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _isCorrect ? '✅' : '❌',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isCorrect
                      ? '¡Correcto! +50 XP ⚡'
                      : 'No pasa nada. Hay otro camino.',
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: _isCorrect ? ArcanaColors.emerald : ArcanaColors.ruby,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildContinueButton(
            _isCorrect ? 'Continuar la aventura →' : 'Buscar otro camino →',
            _handleExerciseContinue,
          ),
        ],
      ),
    );
  }

  // ─── DECISIÓN (2 columnas) ──────────────────

  Widget _buildDecisionNode() {
    final node = _currentNode;
    return Column(
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── COL IZQ: Contexto ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ArcanaColors.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ArcanaColors.surfaceBorder),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🔀', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: ArcanaColors.turquoise.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Elige tu camino', style: ArcanaTextStyles.caption.copyWith(
                            color: ArcanaColors.turquoise, fontWeight: FontWeight.w600,
                          )),
                        ),
                        const SizedBox(height: 16),
                        if (node.text != null)
                          Text(
                            _narrativeText(node.text),
                            style: ArcanaTextStyles.bodyMedium.copyWith(
                              color: ArcanaColors.textPrimary,
                              height: 1.6,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // ── COL DER: Opciones ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ArcanaColors.turquoise.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ArcanaColors.turquoise.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (node.choiceA != null && node.onChoiceA != null)
                        _buildChoiceCard(
                          node.choiceA!, ArcanaColors.turquoise,
                          () => _handleChoice(node.onChoiceA!),
                        ),
                      const SizedBox(height: 12),
                      if (node.choiceB != null && node.onChoiceB != null)
                        _buildChoiceCard(
                          node.choiceB!, ArcanaColors.violet,
                          () => _handleChoice(node.onChoiceB!),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChoiceCard(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: ArcanaTextStyles.cardTitle.copyWith(
                  color: color,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.arrow_forward, color: color, size: 18),
          ],
        ),
      ),
    );
  }

  // ─── FINAL (2 columnas) ──────────────────────

  Widget _buildEndingNode() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── COL IZQ: Estadísticas ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ArcanaColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ArcanaColors.surfaceBorder),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¡Capítulo completado!', style: ArcanaTextStyles.screenTitle.copyWith(color: ArcanaColors.gold)),
                      const SizedBox(height: 6),
                      Text(widget.chapter.title, style: ArcanaTextStyles.bodyMedium.copyWith(color: ArcanaColors.textSecondary)),
                      const SizedBox(height: 20),
                      _buildStatRow('📖 Viñetas leídas', '${_visitedNodes.length}'),
                      const SizedBox(height: 8),
                      _buildStatRow('✅ Ejercicios acertados', '$_correctCount / $_totalExercises'),
                      const SizedBox(height: 8),
                      _buildStatRow('⚡ XP ganada', '${_correctCount * 50}'),
                    ],
                  ),
                ),
              ),
              // ── COL DER: Celebración ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: ArcanaColors.gold.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.15)),
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 80)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildContinueButton('Ver resultados 🏆', _handleContinue),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: ArcanaTextStyles.bodyMedium.copyWith(
            color: ArcanaColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: ArcanaTextStyles.cardTitle.copyWith(
            color: ArcanaColors.gold,
          ),
        ),
      ],
    );
  }

  // ─── BOTÓN GENÉRICO ─────────────────────────

  Widget _buildContinueButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
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
          text,
          style: ArcanaTextStyles.cardTitle.copyWith(
            color: const Color(0xFF1A1130),
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
