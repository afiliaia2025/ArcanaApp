import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';

/// Pantalla de práctica directa de restas.
/// Carga los 25 ejercicios de restas_completo.json y los presenta
/// sección por sección con música de fondo y feedback visual con
/// imágenes del proyecto (Orión/Aprendiz).
class RestasPracticeScreen extends StatefulWidget {
  const RestasPracticeScreen({super.key});

  @override
  State<RestasPracticeScreen> createState() => _RestasPracticeScreenState();
}

class _RestasPracticeScreenState extends State<RestasPracticeScreen>
    with TickerProviderStateMixin {
  // Datos del JSON
  List<_Section> _sections = [];
  bool _isLoading = true;

  // Estado del ejercicio
  int _currentSectionIdx = 0;
  int _currentExerciseIdx = 0;
  int _correctCount = 0;
  int _totalAnswered = 0;
  bool _showFeedback = false;
  bool _lastWasCorrect = false;
  bool _showHint = false;
  String? _selectedOption = null;
  final TextEditingController _fillController = TextEditingController();

  // Digit boxes (input derecha→izquierda)
  List<TextEditingController> _digitControllers = [];
  List<FocusNode> _digitFocusNodes = [];
  int _expectedDigits = 3; // por defecto

  // Timer contrarreloj
  bool _isTimedSection = false;
  int _timerSeconds = 0;
  Timer? _exerciseTimer;

  // Audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _musicPlaying = false;

  // Animaciones
  late AnimationController _feedbackController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  bool _showAnswer = false;
  List<_Particle> _explosionParticles = [];

  // Mensajes motivacionales
  static const _successMessages = [
    '✨ ¡Muy bien! ✨',
    '⭐ ¡Genial! ⭐',
    '🌟 ¡Increíble! 🌟',
    '💪 ¡Eso es! 💪',
    '✨ ¡Perfecto! ✨',
    '🚀 ¡Bravoo! 🚀',
    '🏆 ¡Campeón! 🏆',
  ];
  String _currentSuccessMsg = '✨ ¡Muy bien! ✨';

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fillController.addListener(() => setState(() {}));
    _loadData();
    _startMusic();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _audioPlayer.dispose();
    _fillController.dispose();
    _exerciseTimer?.cancel();
    _disposeDigitBoxes();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/curriculum/2_primaria/restas_completo.json',
      );
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      final sectionsJson = data['sections'] as List;
      _sections = sectionsJson.map((s) {
        final secMap = s as Map<String, dynamic>;
        final exercises = (secMap['exercises'] as List).map((e) {
          final exMap = e as Map<String, dynamic>;
          return _Exercise(
            id: exMap['id'] as String,
            type: exMap['type'] as String,
            question: exMap['question'] as String,
            options: (exMap['options'] as List?)?.cast<String>(),
            answer: exMap['answer'].toString(),
            difficulty: exMap['difficulty'] as int? ?? 1,
            hint: exMap['hint'] as String? ?? '',
            explanation: exMap['explanation'] as String? ?? '',
          );
        }).toList();

        return _Section(
          id: secMap['id'] as String,
          title: secMap['title'] as String,
          intro: secMap['intro'] as String?,
          exercises: exercises..shuffle(),
          timed: secMap['timed'] as bool? ?? false,
          timePerExercise: secMap['timePerExercise'] as int? ?? 15,
        );
      }).toList();

      if (mounted) {
        setState(() => _isLoading = false);
        _initDigitBoxes();
        _checkTimedSection();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando ejercicios: $e')),
        );
      }
    }
  }

  Future<void> _startMusic() async {
    try {
      await _audioPlayer.setSource(AssetSource(
        'music/whimsical-orchestral-fantasy-theme-gentle-celesta-melody-warm-strings-soft-harp-arpeggios-magical-chimes-children\'s-adventure-game-soundtrack-studio-ghibli-inspired-90-bpm-hopeful-and-inviting-high-quality-loop_022.mp3',
      ));
      await _audioPlayer.setVolume(0.3);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();
      if (mounted) setState(() => _musicPlaying = true);
    } catch (_) {
      // Audio no disponible — no es crítico
    }
  }

  void _toggleMusic() async {
    if (_musicPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    if (mounted) setState(() => _musicPlaying = !_musicPlaying);
  }

  // ─── Lógica de ejercicios ──────────────────

  _Exercise get _currentExercise =>
      _sections[_currentSectionIdx].exercises[_currentExerciseIdx];

  int get _totalExercises =>
      _sections.fold(0, (sum, s) => sum + s.exercises.length);

  int get _globalExerciseIndex {
    int idx = 0;
    for (int i = 0; i < _currentSectionIdx; i++) {
      idx += _sections[i].exercises.length;
    }
    return idx + _currentExerciseIdx;
  }

  void _submitAnswer(String answer) {
    if (_showFeedback) return;

    final ex = _currentExercise;
    bool correct;

    if (ex.type == 'true_false') {
      correct = answer.toLowerCase() == ex.answer.toLowerCase();
    } else {
      correct = answer.trim().toLowerCase() == ex.answer.trim().toLowerCase();
    }

    setState(() {
      _showFeedback = true;
      _lastWasCorrect = correct;
      _totalAnswered++;
      if (correct) {
        _correctCount++;
        _showAnswer = true;
        _currentSuccessMsg = _successMessages[math.Random().nextInt(_successMessages.length)];
        _spawnExplosion();
        _glowController.forward(from: 0).then((_) => _glowController.reverse());
      }
    });

    _feedbackController.forward(from: 0);
  }

  void _spawnExplosion() {
    final rng = math.Random();
    _explosionParticles = List.generate(48, (i) {
      final angle = (i / 48) * 2 * math.pi + rng.nextDouble() * 0.5;
      final speed = 80.0 + rng.nextDouble() * 180;
      return _Particle(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed - 30,
        color: [
          ArcanaColors.gold,
          const Color(0xFF34D399),
          Colors.amber,
          Colors.white,
          const Color(0xFFFFD700),
          const Color(0xFFFBBF24),
        ][i % 6],
        size: 3.0 + rng.nextDouble() * 6,
      );
    });
    _particleController.forward(from: 0);
  }

  // ─── Digit Boxes (derecha→izquierda) ──────────

  void _initDigitBoxes() {
    _disposeDigitBoxes();
    if (_sections.isEmpty) return;
    final ex = _currentExercise;
    _expectedDigits = ex.answer.length;
    _digitControllers = List.generate(
      _expectedDigits,
      (_) => TextEditingController(),
    );
    _digitFocusNodes = List.generate(
      _expectedDigits,
      (_) => FocusNode(),
    );
  }

  void _disposeDigitBoxes() {
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final n in _digitFocusNodes) {
      n.dispose();
    }
    _digitControllers = [];
    _digitFocusNodes = [];
  }

  String _getDigitAnswer() {
    return _digitControllers.map((c) => c.text).join();
  }

  // ─── Timer contrarreloj ──────────────────

  void _checkTimedSection() {
    if (_sections.isEmpty) return;
    final sec = _sections[_currentSectionIdx];
    _isTimedSection = sec.timed;
    if (_isTimedSection) {
      _startTimer(sec.timePerExercise);
    }
  }

  void _startTimer(int seconds) {
    _exerciseTimer?.cancel();
    setState(() => _timerSeconds = seconds);
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _timerSeconds--);
      if (_timerSeconds <= 0) {
        timer.cancel();
        // Tiempo agotado — respuesta incorrecta
        _submitAnswer('__timeout__');
      }
    });
  }

  void _nextExercise() {
    setState(() {
      _showFeedback = false;
      _lastWasCorrect = false;
      _selectedOption = null;
      _fillController.clear();
      _showHint = false;
      _showAnswer = false;
      _explosionParticles = [];
    });

    _exerciseTimer?.cancel();

    if (_currentExerciseIdx < _sections[_currentSectionIdx].exercises.length - 1) {
      setState(() => _currentExerciseIdx++);
    } else if (_currentSectionIdx < _sections.length - 1) {
      setState(() {
        _currentSectionIdx++;
        _currentExerciseIdx = 0;
      });
    } else {
      _showCompletionDialog();
      return;
    }

    _initDigitBoxes();
    _checkTimedSection();
  }

  void _showCompletionDialog() {
    final pct = (_correctCount / _totalExercises * 100).round();
    final stars = pct >= 90 ? 3 : (pct >= 70 ? 2 : (pct >= 50 ? 1 : 0));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: ArcanaColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen de Orión felicitando
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/characters/orion.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Text('🧙', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pct >= 70 ? '¡Excelente trabajo!' : '¡Sigue practicando!',
              style: ArcanaTextStyles.screenTitle.copyWith(
                color: ArcanaColors.gold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            // Estrellas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Icon(
                  i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i < stars ? ArcanaColors.gold : ArcanaColors.surfaceBorder,
                  size: 36,
                );
              }),
            ),
            const SizedBox(height: 12),
            Text(
              '$_correctCount / $_totalExercises correctas ($pct%)',
              style: ArcanaTextStyles.bodyMedium.copyWith(
                color: ArcanaColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '+${_correctCount * 10} XP ganados ⚡',
              style: ArcanaTextStyles.cardTitle.copyWith(
                color: ArcanaColors.turquoise,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Volver al mapa',
              style: TextStyle(color: ArcanaColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _currentSectionIdx = 0;
                _currentExerciseIdx = 0;
                _correctCount = 0;
                _totalAnswered = 0;
                _showFeedback = false;
                _selectedOption = null;
                _fillController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ArcanaColors.turquoise,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Repetir 🔄'),
          ),
        ],
      ),
    );
  }

  // ─── Build ──────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: ArcanaColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: ArcanaColors.gold),
              const SizedBox(height: 16),
              Text(
                'Cargando ejercicios...',
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: ArcanaColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_sections.isEmpty) {
      return Scaffold(
        backgroundColor: ArcanaColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Error'),
        ),
        body: const Center(child: Text('No se encontraron ejercicios')),
      );
    }

    final section = _sections[_currentSectionIdx];
    final exercise = _currentExercise;
    final progress = (_globalExerciseIndex + 1) / _totalExercises;

    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo ilustrado
          Image.asset(
            'assets/images/screens/restas_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),

          // Overlay gradiente para legibilidad (transparente arriba → oscuro abajo)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x00120B28),  // transparente
                  Color(0x99120B28),  // 60% alpha
                  Color(0xDD120B28),  // 87% alpha
                ],
                stops: [0.0, 0.25, 0.5, 1.0],
              ),
            ),
          ),

          // Partículas mágicas sutiles
          const MagicalParticles(
            particleCount: 8,
            color: ArcanaColors.gold,
            maxSize: 2.0,
          ),

          // Explosión de partículas al acertar
          if (_explosionParticles.isNotEmpty)
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                final t = _particleController.value;
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ExplosionPainter(
                    particles: _explosionParticles,
                    progress: t,
                    center: Offset(
                      MediaQuery.of(context).size.width / 2,
                      MediaQuery.of(context).size.height * 0.38,
                    ),
                  ),
                );
              },
            ),

          // Flash dorado al acertar
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, _) {
              final v = _glowController.value;
              if (v == 0) return const SizedBox.shrink();
              return IgnorePointer(
                child: Container(
                  color: ArcanaColors.gold.withValues(alpha: v * 0.12),
                ),
              );
            },
          ),

          SafeArea(
            child: Column(
              children: [
                // ─── Header ──────────────────────
                _buildHeader(section, progress),

                // ─── Contenido ───────────────────
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Intro de sección (si es el primer ejercicio)
                            if (_currentExerciseIdx == 0 && section.intro != null)
                              _buildSectionIntro(section),

                            // Ejercicio (pregunta + operación visual centrada)
                            _buildExerciseCard(exercise),

                            const SizedBox(height: 16),

                            // Opciones — se ocultan al mostrar feedback
                            if (!_showFeedback) ...[
                              if (exercise.type == 'multiple_choice')
                                _buildMultipleChoice(exercise)
                              else if (exercise.type == 'true_false')
                                _buildTrueFalse()
                              else if (exercise.type == 'fill_blank')
                                _buildFillBlank(),
                            ],

                            // Hint
                            if (_showHint && !_showFeedback)
                              _buildHintCard(exercise),

                            // Feedback + Siguiente inline
                            if (_showFeedback) ...[
                              _buildFeedbackCard(exercise),
                              const SizedBox(height: 12),
                              _buildNextButton(),
                              const SizedBox(height: 16),
                            ],

                            // Pista (solo si no hay feedback)
                            if (!_showFeedback && !_showHint)
                              _buildHintButton(),

                            // Comprobar (solo fill_blank sin feedback)
                            if (!_showFeedback && exercise.type == 'fill_blank')
                              _buildCheckButton(exercise),
                          ],
                        ),
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

  Widget _buildHeader(_Section section, double progress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        children: [
          // Top row: Back + Title + Music toggle
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                onPressed: () {
                  _audioPlayer.stop();
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: Text(
                  '🔥 ${section.title}',
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  _musicPlaying ? Icons.music_note : Icons.music_off,
                  color: _musicPlaying ? ArcanaColors.gold : Colors.white38,
                ),
                onPressed: _toggleMusic,
              ),
            ],
          ),

          // Progress bar — fina y dorada
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(ArcanaColors.gold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${_globalExerciseIndex + 1}/$_totalExercises',
                  style: ArcanaTextStyles.caption.copyWith(
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionIntro(_Section section) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArcanaColors.gemIgnis.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ArcanaColors.gemIgnis.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Imagen del aprendiz
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/characters/apprentice.png',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Text('🧑‍🎓', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              section.intro!,
              style: ArcanaTextStyles.bodyMedium.copyWith(
                color: ArcanaColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(_Exercise exercise) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1040).withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ArcanaColors.gold.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ArcanaColors.gold.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Dificultad + tipo — badges semi-transparentes
              Row(
                children: [
                  ...List.generate(exercise.difficulty, (i) {
                    return Icon(Icons.star, color: ArcanaColors.gold.withValues(alpha: 0.9), size: 14);
                  }),
                  ...List.generate(3 - exercise.difficulty, (i) {
                    return Icon(Icons.star_outline, color: Colors.white24, size: 14);
                  }),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _typeColor(exercise.type).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _typeLabel(exercise.type),
                      style: ArcanaTextStyles.caption.copyWith(
                        color: _typeColor(exercise.type).withValues(alpha: 0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Pregunta — texto grande blanco
              Text(
                exercise.question,
                textAlign: TextAlign.center,
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),

              // Representación vertical de la resta
              if (_extractSubtraction(exercise.question) != null)
                _buildVerticalSubtraction(_extractSubtraction(exercise.question)!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleChoice(_Exercise exercise) {
    return Column(
      children: exercise.options!.map((option) {
        final isSelected = _selectedOption == option;
        final isCorrect = option.trim().toLowerCase() == exercise.answer.trim().toLowerCase();
        final showResult = _showFeedback;

        // Colores cristal
        Color bgColor = const Color(0xFF1A1040).withValues(alpha: 0.5);
        Color borderColor = ArcanaColors.gold.withValues(alpha: 0.2);
        Color textColor = const Color(0xFFF0F0F0);

        if (showResult && isCorrect) {
          bgColor = const Color(0xFF34D399).withValues(alpha: 0.2);
          borderColor = const Color(0xFF34D399);
          textColor = const Color(0xFF34D399);
        } else if (showResult && isSelected && !isCorrect) {
          bgColor = const Color(0xFFF87171).withValues(alpha: 0.15);
          borderColor = const Color(0xFFF87171);
          textColor = const Color(0xFFF87171);
        } else if (isSelected) {
          bgColor = ArcanaColors.gold.withValues(alpha: 0.15);
          borderColor = ArcanaColors.gold;
          textColor = ArcanaColors.gold;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: _showFeedback ? null : () {
              setState(() => _selectedOption = option);
              _submitAnswer(option);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '✦',
                        style: TextStyle(
                          fontSize: 14,
                          color: borderColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        option,
                        style: ArcanaTextStyles.bodyMedium.copyWith(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      if (showResult && isCorrect)
                        const Icon(Icons.check_circle, color: Color(0xFF34D399), size: 22),
                      if (showResult && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Color(0xFFF87171), size: 22),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalse() {
    return Row(
      children: [
        Expanded(
          child: _buildTFButton('Verdadero', 'true', const Color(0xFF34D399)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTFButton('Falso', 'false', const Color(0xFFF87171)),
        ),
      ],
    );
  }

  Widget _buildTFButton(String label, String value, Color color) {
    final isSelected = _selectedOption == value;
    final ex = _currentExercise;
    final showResult = _showFeedback;
    final isCorrect = ex.answer.toLowerCase() == value;

    Color bgColor = const Color(0xFF1A1040).withValues(alpha: 0.5);
    Color borderColor = ArcanaColors.gold.withValues(alpha: 0.2);

    if (showResult && isCorrect) {
      bgColor = const Color(0xFF34D399).withValues(alpha: 0.2);
      borderColor = const Color(0xFF34D399);
    } else if (showResult && isSelected && !isCorrect) {
      bgColor = const Color(0xFFF87171).withValues(alpha: 0.15);
      borderColor = const Color(0xFFF87171);
    } else if (isSelected) {
      bgColor = color.withValues(alpha: 0.15);
      borderColor = color;
    }

    return GestureDetector(
      onTap: _showFeedback ? null : () {
        setState(() => _selectedOption = value);
        _submitAnswer(value);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Center(
              child: Text(
                label,
                style: ArcanaTextStyles.cardTitle.copyWith(
                  color: isSelected ? color : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFillBlank() {
    final ex = _currentExercise;
    final numDigits = ex.answer.length;

    // Labels debajo de cada caja
    const digitLabels = ['', 'U', 'D', 'C', 'UM'];
    final labels = <String>[];
    for (int i = 0; i < numDigits; i++) {
      labels.insert(0, i < digitLabels.length ? digitLabels[i] : '');
    }

    return Column(
      children: [
        // Indicador de dirección
        if (!_showFeedback)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '← Escribe de derecha a izquierda',
                  style: ArcanaTextStyles.bodyMedium.copyWith(
                    color: ArcanaColors.gold.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(numDigits, (i) {
            // Asegurarse de que tenemos suficientes controllers
            if (i >= _digitControllers.length) return const SizedBox();

            final isLastToFill = i == numDigits - 1; // unidades = última caja
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: SizedBox(
                        width: 54,
                        height: 64,
                        child: TextField(
                          controller: _digitControllers[i],
                          focusNode: _digitFocusNodes[i],
                          enabled: !_showFeedback,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: ArcanaTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '·',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.2),
                              fontSize: 32,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1A1040)
                                .withValues(alpha: 0.5),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ArcanaColors.gold
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ArcanaColors.gold
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ArcanaColors.gold
                                    .withValues(alpha: 0.8),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty && i > 0) {
                              // Avanzar al siguiente dígito a la izquierda
                              _digitFocusNodes[i - 1].requestFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    i < labels.length ? labels[i] : '',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: ArcanaColors.gold.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHintCard(_Exercise exercise) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ArcanaColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  exercise.hint,
                  style: ArcanaTextStyles.bodyMedium.copyWith(
                    color: ArcanaColors.gold,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(_Exercise exercise) {
    final isCorrect = _lastWasCorrect;
    final feedbackColor = isCorrect
        ? const Color(0xFF34D399)
        : const Color(0xFFF87171);

    return AnimatedBuilder(
      animation: _feedbackController,
      builder: (context, child) {
        return Transform.scale(
          scale: Tween<double>(begin: 0.8, end: 1.0)
              .animate(CurvedAnimation(
                parent: _feedbackController,
                curve: Curves.elasticOut,
              ))
              .value,
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: feedbackColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: feedbackColor.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                // Mensaje
                Text(
                  isCorrect ? _currentSuccessMsg : 'La respuesta es:',
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: feedbackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34D399).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      exercise.answer,
                      style: ArcanaTextStyles.screenTitle.copyWith(
                        color: const Color(0xFF34D399),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                if (isCorrect)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+10 XP ⚡',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: ArcanaColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                if (exercise.hint.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    '💡 ${exercise.hint}',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Botón "Siguiente →" — ancho completo, gradiente dorado
  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextExercise,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ArcanaColors.gold, ArcanaColors.gemIgnis],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: ArcanaColors.gold.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'Siguiente →',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Botón "Pista" — cristal dorado centrado
  Widget _buildHintButton() {
    return Center(
      child: GestureDetector(
        onTap: () => setState(() => _showHint = true),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: ArcanaColors.gold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'Pista',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Botón "Comprobar" (fill_blank) — ancho completo
  Widget _buildCheckButton(_Exercise exercise) {
    final canSubmit = _fillController.text.trim().isNotEmpty;
    return GestureDetector(
      onTap: canSubmit ? () => _submitAnswer(_getAnswer(exercise)) : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: canSubmit
              ? const LinearGradient(
                  colors: [ArcanaColors.turquoise, Color(0xFF06B6D4)],
                )
              : null,
          color: canSubmit ? null : Colors.white12,
          borderRadius: BorderRadius.circular(14),
          boxShadow: canSubmit
              ? [
                  BoxShadow(
                    color: ArcanaColors.turquoise.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          'Comprobar ✓',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: canSubmit ? Colors.white : Colors.white38,
          ),
        ),
      ),
    );
  }

  bool get _canSubmit {
    final ex = _currentExercise;
    if (ex.type == 'fill_blank') return _fillController.text.trim().isNotEmpty;
    return _selectedOption != null;
  }

  String _getAnswer(_Exercise exercise) {
    if (exercise.type == 'fill_blank') return _fillController.text.trim();
    return _selectedOption ?? '';
  }

  Color _typeColor(String type) {
    return switch (type) {
      'multiple_choice' => ArcanaColors.turquoise,
      'true_false' => ArcanaColors.violet,
      'fill_blank' => ArcanaColors.gemIgnis,
      _ => ArcanaColors.textMuted,
    };
  }

  String _typeLabel(String type) {
    return switch (type) {
      'multiple_choice' => 'Opciones',
      'true_false' => 'V/F',
      'fill_blank' => 'Completar',
      _ => type,
    };
  }

  // ─── Formato vertical de restas (como en el cuaderno) ──────

  /// Extrae números de una resta simple/encadenada del texto de la pregunta.
  /// Devuelve null para problemas de texto (word problems).
  List<String>? _extractSubtraction(String question) {
    // No formatear problemas de texto (contienen muchas palabras)
    if (question.contains('gallinas') ||
        question.contains('páginas') ||
        question.contains('cromos') ||
        question.contains('butacas') ||
        question.contains('canicas') ||
        question.contains('granja') ||
        question.contains('libro') ||
        question.contains('cine') ||
        question.contains('Pedro') ||
        question.contains('compruebo') ||
        question.contains('correcta') ||
        question.contains('falta')) {
      return null;
    }

    // Buscar patrón: números separados por − (guión largo o corto)
    final regex = RegExp(r'(\d+)\s*[−\-–]\s*(\d+)(?:\s*[−\-–]\s*(\d+))?');
    final match = regex.firstMatch(question);
    if (match == null) return null;

    final numbers = <String>[match.group(1)!, match.group(2)!];
    if (match.group(3) != null) numbers.add(match.group(3)!);
    return numbers;
  }

  Widget _buildVerticalSubtraction(List<String> numbers) {
    final maxLen = numbers.fold(0, (max, n) => n.length > max ? n.length : max);
    final resultStr = _showAnswer ? _currentExercise.answer : '?';
    // El resultado se pad para alinear dígito a dígito
    final resultMaxLen = resultStr.length > maxLen ? resultStr.length : maxLen;

    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: ArcanaColors.gemIgnis.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ArcanaColors.gemIgnis.withValues(alpha: 0.12),
        ),
      ),
      child: Center(
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNumberRow(numbers[0], maxLen, showMinus: false),
              const SizedBox(height: 4),
              for (int i = 1; i < numbers.length; i++) ...[
                _buildNumberRow(numbers[i], maxLen, showMinus: true),
                if (i < numbers.length - 1) const SizedBox(height: 4),
              ],
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: (maxLen + 2) * 22.0,
                height: 3,
                decoration: BoxDecoration(
                  color: ArcanaColors.textPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Resultado alineado dígito a dígito
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildResultRow(resultStr, maxLen, key: ValueKey(_showAnswer)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fila de resultado alineada dígito a dígito con la operación
  Widget _buildResultRow(String result, int maxLen, {Key? key}) {
    final padded = result.padLeft(maxLen);
    final isAnswer = _showAnswer;
    final color = isAnswer
        ? const Color(0xFF34D399)
        : ArcanaColors.gemIgnis.withValues(alpha: 0.5);

    return SizedBox(
      key: key,
      width: (maxLen + 2) * 22.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Espacio del signo menos (vacío en resultado)
          const SizedBox(width: 28),
          // Dígitos del resultado
          ...padded.split('').map((ch) {
            return SizedBox(
              width: 22,
              child: Text(
                ch == ' ' ? '' : ch,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNumberRow(String number, int maxLen, {required bool showMinus}) {
    final padded = number.padLeft(maxLen);

    return SizedBox(
      width: (maxLen + 2) * 22.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Signo menos
          SizedBox(
            width: 28,
            child: Text(
              showMinus ? '−' : '',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: ArcanaColors.textPrimary,
              ),
            ),
          ),
          // Dígitos
          ...padded.split('').map((ch) {
            return SizedBox(
              width: 22,
              child: Text(
                ch == ' ' ? '' : ch,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: ArcanaColors.textPrimary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// MODELOS DE DATOS LOCALES
// ═══════════════════════════════════════════

class _Section {
  final String id;
  final String title;
  final String? intro;
  final List<_Exercise> exercises;
  final bool timed;
  final int timePerExercise;

  const _Section({
    required this.id,
    required this.title,
    this.intro,
    required this.exercises,
    this.timed = false,
    this.timePerExercise = 15,
  });
}

class _Exercise {
  final String id;
  final String type;
  final String question;
  final List<String>? options;
  final String answer;
  final int difficulty;
  final String hint;
  final String explanation;

  const _Exercise({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    required this.answer,
    required this.difficulty,
    required this.hint,
    required this.explanation,
  });
}

class _Particle {
  final double dx;
  final double dy;
  final Color color;
  final double size;

  const _Particle({
    required this.dx,
    required this.dy,
    required this.color,
    required this.size,
  });
}

class _ExplosionPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Offset center;

  _ExplosionPainter({
    required this.particles,
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final x = center.dx + p.dx * progress;
      final y = center.dy + p.dy * progress - 20 * progress;
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x, y),
        p.size * (1.0 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ExplosionPainter old) => old.progress != progress;
}
