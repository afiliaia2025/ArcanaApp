import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../providers/adventure_provider.dart';
import '../services/exercise_service.dart';
import '../services/gemini_service.dart';
import '../theme/app_colors.dart';
import '../widgets/exercise_widgets.dart';

/// Pantalla de un capítulo — viñetas narrativas IA + ejercicios
/// Conectada a Firestore/Gemini a través del adventureProvider
class ChapterScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const ChapterScreen({super.key, required this.chapterId});

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  int _currentStep = 0;
  int? _selectedOption;
  bool? _answered;
  String _fillAnswer = '';

  // Datos del capítulo (Gemini o mock)
  List<Map<String, dynamic>> _vignettes = [];
  List<Exercise> _exercises = [];
  bool _isLoading = true;
  String _chapterTitle = '';
  ChapterType _chapterType = ChapterType.normal;
  int _totalXP = 50;
  int _correctCount = 0;

  // Imágenes de viñetas (lazy, bajo demanda)
  final Map<int, Uint8List> _vignetteImages = {};
  final Map<int, bool> _imageLoading = {};

  @override
  void initState() {
    super.initState();
    _loadChapter();
  }

  /// Carga viñetas (Gemini + caché) o fallback a mock
  Future<void> _loadChapter() async {
    setState(() => _isLoading = true);

    try {
      final adventure = ref.read(adventureProvider);

      // Si hay arco, cargar viñetas de Gemini (cacheadas)
      if (adventure.arcData != null) {
        // Obtener info del capítulo del arco
        final chapters = (adventure.arcData!['chapters'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>() ??
            [];
        final chapterData = chapters.firstWhere(
          (ch) => ch['id'] == widget.chapterId,
          orElse: () => <String, dynamic>{},
        );

        if (chapterData.isNotEmpty) {
          _chapterTitle = chapterData['title'] as String? ?? 'Capítulo';
          _chapterType = switch (chapterData['type'] as String? ?? 'normal') {
            'boss' => ChapterType.miniBoss,
            'gate' => ChapterType.gatePuzzle,
            _ => ChapterType.normal,
          };
          _totalXP = (chapterData['xp'] as int?) ?? 50;

          // Cargar viñetas (usa caché o genera con Gemini)
          final notifier = ref.read(adventureProvider.notifier);
          final vignettes =
              await notifier.loadChapterVignettes(widget.chapterId);

          if (vignettes.isNotEmpty) {
            _vignettes = vignettes;
            _exercises = _buildExercisesFromVignettes(vignettes);

            setState(() => _isLoading = false);

            // Pre-cargar imagen de la primera viñeta
            _loadVignetteImage(0);
            return;
          }
        }
      }

      // Fallback a mock data
      _loadMockData();
    } catch (e) {
      // Si falla Gemini, usa mock
      _loadMockData();
    }
  }

  void _loadMockData() {
    // Intentar cargar ejercicios del banco real primero
    _loadFromExerciseBank().then((loaded) {
      if (!loaded) {
        // Fallback a mock data si no hay banco disponible
        final chapter = MockData.chapters.firstWhere(
          (c) => c.id == widget.chapterId,
          orElse: () => MockData.chapters.first,
        );
        _chapterTitle = chapter.title;
        _chapterType = chapter.type;
        _totalXP = chapter.totalXP;
        _exercises = chapter.exercises;
        _vignettes = chapter.panels
            .map((p) => {
                  'text': p.text,
                  'backgroundTheme': p.backgroundTheme,
                })
            .toList();
        setState(() => _isLoading = false);
      }
    });
  }

  /// Carga ejercicios del banco curricular (900 ejercicios JSON)
  Future<bool> _loadFromExerciseBank() async {
    try {
      final exerciseService = ExerciseService();
      final trimester = ExerciseService.currentTrimester();

      // Por defecto usa 2º primaria y mates; si el perfil del usuario
      // está disponible, usa sus datos reales.
      String grade = '2_primaria';
      String subject = 'mates';

      // Intentar extraer info del perfil
      try {
        final adventure = ref.read(adventureProvider);
        if (adventure.arcData != null) {
          final arcGrade = adventure.arcData!['grade'] as String?;
          final arcSubject = adventure.arcData!['subject'] as String?;
          if (arcGrade != null) grade = ExerciseService.gradeToFolder(arcGrade);
          if (arcSubject != null) subject = arcSubject;
        }
      } catch (_) {
        // Silenciar si no hay adventure data
      }

      // Cargar un quiz de 5 ejercicios del trimestre actual
      final exercises = await exerciseService.getQuiz(
        grade: grade,
        subject: subject,
        trimester: trimester,
        count: 5,
      );

      if (exercises.isEmpty) return false;

      // Generar viñetas narrativas simples para los ejercicios
      final topics = await exerciseService.getTopics(
        grade: grade,
        subject: subject,
        trimester: trimester,
      );
      final topicName = topics.isNotEmpty ? topics.first.name : 'Aventura';

      _chapterTitle = '📚 $topicName';
      _chapterType = ChapterType.normal;
      _totalXP = exercises.fold(0, (sum, e) => sum + e.xpReward);
      _exercises = exercises;

      // Viñeta introductoria
      _vignettes = [
        {
          'text': '¡Bienvenido a una nueva misión de $topicName! '
              'Resuelve los siguientes desafíos para ganar XP y avanzar en tu aventura. '
              '¡Tú puedes! 💪',
          'backgroundTheme': 'forest',
        },
      ];

      if (mounted) setState(() => _isLoading = false);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Extrae ejercicios del JSON de viñetas generado por Gemini
  List<Exercise> _buildExercisesFromVignettes(
      List<Map<String, dynamic>> vignettes) {
    final exercises = <Exercise>[];
    for (int i = 0; i < vignettes.length; i++) {
      final v = vignettes[i];
      final exerciseData = v['exercise'] as Map<String, dynamic>?;
      if (exerciseData != null) {
        final type = switch (exerciseData['type'] as String? ?? '') {
          'fill_in_blank' => ExerciseType.fillInBlank,
          'true_false' => ExerciseType.trueFalse,
          'ordering' => ExerciseType.ordering,
          _ => ExerciseType.multipleChoice,
        };

        exercises.add(Exercise(
          id: 'ex_${widget.chapterId}_$i',
          type: type,
          question: exerciseData['question'] as String? ?? '',
          options: (exerciseData['options'] as List<dynamic>?)
                  ?.cast<String>() ??
              [],
          correctAnswer: exerciseData['answer'] as String? ?? '',
          explanation: exerciseData['explanation'] as String?,
          xpReward: (exerciseData['xp'] as int?) ?? 10,
        ));
      }
    }
    return exercises;
  }

  /// Carga imagen de viñeta bajo demanda (lazy)
  Future<void> _loadVignetteImage(int index) async {
    if (_vignetteImages.containsKey(index) ||
        _imageLoading[index] == true) {
      return;
    }
    if (index >= _vignettes.length) {
      return;
    }

    setState(() {
      _imageLoading[index] = true;
    });

    final vignette = _vignettes[index];
    final sceneDescription = vignette['imagePrompt'] as String? ??
        vignette['text'] as String? ??
        '';

    final imageBytes = await GeminiService.instance.generateVignetteImage(
      sceneDescription: sceneDescription,
    );

    if (imageBytes != null && mounted) {
      setState(() {
        _vignetteImages[index] = imageBytes;
        _imageLoading[index] = false;
      });
    } else if (mounted) {
      setState(() {
        _imageLoading[index] = false;
      });
    }
  }

  int get _totalSteps => _vignettes.length + _exercises.length;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                '🧙 Preparando la aventura...',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header del capítulo
            _ChapterHeader(
              title: _chapterTitle,
              type: _chapterType,
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onClose: () => Navigator.pop(context),
            ),

            // Contenido
            Expanded(
              child: _currentStep < _vignettes.length
                  ? _buildVignettePanel(_currentStep)
                  : _buildExercise(
                      _exercises[_currentStep - _vignettes.length],
                    ),
            ),

            // Botón continuar
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue ? _nextStep : null,
                  child: Text(
                    _currentStep < _vignettes.length
                        ? 'Continuar'
                        : _answered == null
                            ? 'Comprobar'
                            : _currentStep == _totalSteps - 1
                                ? '¡Completar! 🎉'
                                : 'Siguiente',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canContinue {
    if (_currentStep < _vignettes.length) return true;
    final exerciseIndex = _currentStep - _vignettes.length;
    if (exerciseIndex >= _exercises.length) return false;
    final exercise = _exercises[exerciseIndex];
    if (_answered != null) return true;
    if (exercise.type == ExerciseType.fillInBlank) {
      return _fillAnswer.isNotEmpty;
    }
    return _selectedOption != null;
  }

  void _nextStep() {
    if (_currentStep < _vignettes.length) {
      // Era una viñeta, avanza
      setState(() => _currentStep++);
      // Pre-cargar imagen de la siguiente viñeta
      if (_currentStep < _vignettes.length) {
        _loadVignetteImage(_currentStep);
      }
    } else if (_answered == null) {
      _checkAnswer();
    } else if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
        _selectedOption = null;
        _answered = null;
        _fillAnswer = '';
      });
    } else {
      _completeChapter();
    }
  }

  void _checkAnswer() {
    final exerciseIndex = _currentStep - _vignettes.length;
    final exercise = _exercises[exerciseIndex];

    bool correct;
    if (exercise.type == ExerciseType.fillInBlank) {
      correct = _fillAnswer.trim().toLowerCase() ==
          exercise.correctAnswer.toLowerCase();
    } else {
      correct = exercise.options[_selectedOption!] == exercise.correctAnswer;
    }

    if (correct) _correctCount++;
    setState(() => _answered = correct);
  }

  /// Marca capítulo completado en Firestore + XP + racha
  Future<void> _completeChapter() async {
    final adventure = ref.read(adventureProvider);
    if (adventure.arcData != null) {
      final notifier = ref.read(adventureProvider.notifier);
      await notifier.completeChapter(widget.chapterId, _totalXP);
    }
    if (mounted) _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          '🎉 ¡Capítulo completado!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _chapterTitle,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatChip('⭐', '+$_totalXP XP', AppColors.xp),
                const SizedBox(width: 12),
                _StatChip(
                  '✅',
                  '$_correctCount/${_exercises.length}',
                  AppColors.success,
                ),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Dialog
                Navigator.pop(context); // Chapter
              },
              child: const Text('Volver al mapa 🗺️'),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // VIÑETAS (con imágenes IA lazy)
  // ═══════════════════════════════════════════

  Widget _buildVignettePanel(int index) {
    final vignette = _vignettes[index];
    final text = vignette['text'] as String? ?? '';
    final theme = vignette['backgroundTheme'] as String?;
    final hasImage = _vignetteImages.containsKey(index);
    final isLoadingImage = _imageLoading[index] == true;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF312E81),
              Color(0xFF4338CA),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de la viñeta (IA)
              if (hasImage)
                Expanded(
                  flex: 3,
                  child: Image.memory(
                    _vignetteImages[index]!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else if (isLoadingImage)
                const Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white54),
                        SizedBox(height: 8),
                        Text(
                          '🎨 Dibujando escena...',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    _emojiForTheme(theme),
                    style: const TextStyle(fontSize: 48),
                  ),
                ),

              // Texto narrativo
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _emojiForTheme(String? theme) {
    return switch (theme) {
      'numbers' => '🔢',
      'words' => '📖',
      'nature' => '🌿',
      'time' => '⏳',
      'languages' => '🌍',
      _ => '✨',
    };
  }

  // ═══════════════════════════════════════════
  // EJERCICIOS
  // ═══════════════════════════════════════════

  Widget _buildExercise(Exercise exercise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pregunta
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Text(
              exercise.question,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Opciones según tipo
          if (exercise.type == ExerciseType.ordering)
            SortExerciseWidget(
              exercise: exercise,
              answered: _answered != null,
              onAnswer: (correct) {
                if (correct) _correctCount++;
                setState(() => _answered = correct);
              },
            )
          else if (exercise.type == ExerciseType.matching)
            MatchExerciseWidget(
              exercise: exercise,
              answered: _answered != null,
              onAnswer: (correct) {
                if (correct) _correctCount++;
                setState(() => _answered = correct);
              },
            )
          else if (exercise.type == ExerciseType.fillInBlank)
            _buildFillInBlank(exercise)
          else
            ...exercise.options.asMap().entries.map((entry) =>
                _buildOption(entry.key, entry.value, exercise)),

          // Feedback
          if (_answered != null) _buildFeedback(exercise),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String option, Exercise exercise) {
    final isSelected = _selectedOption == index;
    final isCorrect = _answered != null && option == exercise.correctAnswer;
    final isWrong = _answered != null && isSelected && !isCorrect;

    Color bgColor;
    Color borderColor;
    if (_answered != null) {
      if (isCorrect) {
        bgColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
      } else if (isWrong) {
        bgColor = AppColors.lives.withValues(alpha: 0.1);
        borderColor = AppColors.lives;
      } else {
        bgColor = AppColors.surfaceVariant;
        borderColor = AppColors.borderLight;
      }
    } else {
      bgColor = isSelected
          ? AppColors.primary.withValues(alpha: 0.1)
          : AppColors.surfaceVariant;
      borderColor = isSelected ? AppColors.primary : AppColors.borderLight;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap:
            _answered == null ? () => setState(() => _selectedOption = index) : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected || isCorrect
                      ? (isCorrect
                          ? AppColors.success
                          : isWrong
                              ? AppColors.lives
                              : AppColors.primary)
                      : AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: isSelected || isCorrect
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (_answered != null && isCorrect)
                const Text('✅', style: TextStyle(fontSize: 20)),
              if (_answered != null && isWrong)
                const Text('❌', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFillInBlank(Exercise exercise) {
    return TextField(
      onChanged: (v) => setState(() => _fillAnswer = v),
      enabled: _answered == null,
      decoration: InputDecoration(
        hintText: 'Escribe tu respuesta...',
        suffixIcon: _answered != null
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _answered! ? '✅' : '❌',
                  style: const TextStyle(fontSize: 20),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildFeedback(Exercise exercise) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _answered!
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.lives.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _answered! ? AppColors.success : AppColors.lives,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _answered!
                ? '✅ ¡Correcto! +${exercise.xpReward} XP'
                : '❌ ¡Casi!',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _answered! ? AppColors.success : AppColors.lives,
            ),
          ),
          if (exercise.explanation != null) ...[
            const SizedBox(height: 8),
            Text(
              exercise.explanation!,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// WIDGETS AUXILIARES
// ═══════════════════════════════════════════

class _ChapterHeader extends StatelessWidget {
  final String title;
  final ChapterType type;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onClose;

  const _ChapterHeader({
    required this.title,
    required this.type,
    required this.currentStep,
    required this.totalSteps,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final typeEmoji = switch (type) {
      ChapterType.miniBoss || ChapterType.trimesterBoss => '⚔️',
      ChapterType.finalBoss => '💀',
      ChapterType.gatePuzzle => '🚪',
      ChapterType.normal => '📖',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: totalSteps > 0 ? (currentStep + 1) / totalSteps : 0,
                minHeight: 8,
                backgroundColor: AppColors.borderLight,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(typeEmoji, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String emoji;
  final String value;
  final Color color;

  const _StatChip(this.emoji, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
