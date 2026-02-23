import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/exercise_service.dart';
import '../theme/app_colors.dart';
import '../widgets/exercise_widgets.dart';

// ═══════════════════════════════════════════
// PANTALLA DE PRÁCTICA LIBRE
// ═══════════════════════════════════════════
// Permite elegir asignatura, tema y dificultad
// para practicar con ejercicios del banco (900 ej.)

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  final _exerciseService = ExerciseService();

  String _selectedGrade = '2_primaria';
  String? _selectedSubject;
  CurriculumTopic? _selectedTopic;
  int _trimester = ExerciseService.currentTrimester();

  // Datos cargados
  List<CurriculumTopic> _topics = [];
  bool _isLoadingTopics = false;

  // Estado del quiz
  List<Exercise> _quizExercises = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _inQuiz = false;
  int? _selectedOption;
  bool? _answered;
  String _fillAnswer = '';

  // ── Asignaturas disponibles ──
  static const _subjects = [
    {'id': 'mates', 'name': 'Matemáticas', 'icon': '🔢', 'color': 0xFF4FC3F7},
    {'id': 'lengua', 'name': 'Lengua', 'icon': '📖', 'color': 0xFFFF8A65},
    {'id': 'ciencias', 'name': 'Ciencias', 'icon': '🔬', 'color': 0xFF81C784},
  ];

  static const _grades = [
    {'id': '2_primaria', 'name': '2º Primaria'},
    {'id': '3_primaria', 'name': '3º Primaria'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_inQuiz) return _buildQuiz();
    return _buildSelector();
  }

  // ═══════════════════════════════════════════
  // SELECTOR DE ASIGNATURA Y TEMA
  // ═══════════════════════════════════════════

  Widget _buildSelector() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '🎯 Practicar',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Selector de curso ──
            _buildSectionTitle('📚 Curso'),
            const SizedBox(height: 8),
            Row(
              children: _grades.map((g) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildGradeChip(g),
                ),
              )).toList(),
            ),

            const SizedBox(height: 24),

            // ── Selector de trimestre ──
            _buildSectionTitle('📅 Trimestre'),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 3].map((t) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildTrimesterChip(t),
                ),
              )).toList(),
            ),

            const SizedBox(height: 24),

            // ── Asignaturas ──
            _buildSectionTitle('🎓 Asignatura'),
            const SizedBox(height: 12),
            ..._subjects.map((s) => _buildSubjectCard(s)),

            // ── Temas (si hay asignatura seleccionada) ──
            if (_selectedSubject != null) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('📋 Temas'),
              const SizedBox(height: 12),
              if (_isLoadingTopics)
                const Center(child: CircularProgressIndicator())
              else
                ..._topics.map((t) => _buildTopicCard(t)),
            ],

            // ── Quiz rápido ──
            if (_selectedSubject != null && !_isLoadingTopics) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startQuiz,
                  icon: const Text('⚡', style: TextStyle(fontSize: 20)),
                  label: const Text('Quiz rápido (10 ejercicios)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildGradeChip(Map<String, String> grade) {
    final selected = _selectedGrade == grade['id'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGrade = grade['id']!;
          _selectedSubject = null;
          _topics = [];
          _selectedTopic = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          grade['name']!,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTrimesterChip(int t) {
    final selected = _trimester == t;
    final current = ExerciseService.currentTrimester();
    return GestureDetector(
      onTap: () {
        setState(() {
          _trimester = t;
          if (_selectedSubject != null) _loadTopics();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'T$t${t == current ? ' 📍' : ''}',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final selected = _selectedSubject == subject['id'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSubject = subject['id'] as String;
            _selectedTopic = null;
          });
          _loadTopics();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? Color(subject['color'] as int).withValues(alpha: 0.15)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? Color(subject['color'] as int)
                  : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(subject['icon'] as String, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Text(
                subject['name'] as String,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (selected)
                Icon(Icons.check_circle, color: Color(subject['color'] as int)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(CurriculumTopic topic) {
    final selected = _selectedTopic?.id == topic.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTopic = topic);
          _startTopicPractice(topic);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Text(topic.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.name,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${topic.exercises.length} ejercicios',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded,
                  color: AppColors.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // CARGA DE DATOS
  // ═══════════════════════════════════════════

  Future<void> _loadTopics() async {
    setState(() => _isLoadingTopics = true);
    try {
      final topics = await _exerciseService.getTopics(
        grade: _selectedGrade,
        subject: _selectedSubject!,
        trimester: _trimester,
      );
      setState(() {
        _topics = topics;
        _isLoadingTopics = false;
      });
    } catch (e) {
      setState(() => _isLoadingTopics = false);
    }
  }

  Future<void> _startTopicPractice(CurriculumTopic topic) async {
    final exercises = await _exerciseService.getExercisesByTopic(
      grade: _selectedGrade,
      subject: _selectedSubject!,
      trimester: _trimester,
      topicId: topic.id,
    );

    if (exercises.isEmpty) return;

    setState(() {
      _quizExercises = exercises;
      _currentIndex = 0;
      _correctCount = 0;
      _inQuiz = true;
      _selectedOption = null;
      _answered = null;
      _fillAnswer = '';
    });
  }

  Future<void> _startQuiz() async {
    final exercises = await _exerciseService.getQuiz(
      grade: _selectedGrade,
      subject: _selectedSubject!,
      trimester: _trimester,
      count: 10,
    );

    if (exercises.isEmpty) return;

    setState(() {
      _quizExercises = exercises;
      _currentIndex = 0;
      _correctCount = 0;
      _inQuiz = true;
      _selectedOption = null;
      _answered = null;
      _fillAnswer = '';
    });
  }

  // ═══════════════════════════════════════════
  // PANTALLA DE QUIZ
  // ═══════════════════════════════════════════

  Widget _buildQuiz() {
    if (_currentIndex >= _quizExercises.length) {
      return _buildQuizResults();
    }

    final exercise = _quizExercises[_currentIndex];
    final progress = (_currentIndex + 1) / _quizExercises.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _inQuiz = false),
        ),
        title: Column(
          children: [
            Text(
              'Ejercicio ${_currentIndex + 1}/${_quizExercises.length}',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        actions: [
          // Indicador de dificultad
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '⭐' * exercise.difficulty,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
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
                border: Border.all(color: AppColors.border),
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

            // Respuestas según tipo
            Expanded(
              child: _buildAnswerSection(exercise),
            ),

            // Hint (si no ha respondido y hay pista)
            if (_answered == null && exercise.hint != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '💡 ${exercise.hint}',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            // Feedback
            if (_answered != null) _buildFeedback(exercise),

            // Botón
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit ? _handleSubmit : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _answered == null
                      ? 'Comprobar'
                      : _currentIndex < _quizExercises.length - 1
                          ? 'Siguiente'
                          : '¡Ver resultados! 🏆',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSection(Exercise exercise) {
    switch (exercise.type) {
      case ExerciseType.multipleChoice:
      case ExerciseType.trueFalse:
        final options = exercise.type == ExerciseType.trueFalse
            ? ['Verdadero', 'Falso']
            : exercise.options;
        return ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, i) => _buildOptionTile(i, options[i], exercise),
        );

      case ExerciseType.fillInBlank:
        return Column(
          children: [
            TextField(
              onChanged: (v) => setState(() => _fillAnswer = v),
              enabled: _answered == null,
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case ExerciseType.ordering:
        return SortExerciseWidget(
          exercise: exercise,
          answered: _answered != null,
          onAnswer: (correct) {
            if (correct) _correctCount++;
            setState(() => _answered = correct);
          },
        );

      case ExerciseType.matching:
        return MatchExerciseWidget(
          exercise: exercise,
          answered: _answered != null,
          onAnswer: (correct) {
            if (correct) _correctCount++;
            setState(() => _answered = correct);
          },
        );

      default:
        // Para open_problem — mostrar como texto libre
        return Column(
          children: [
            TextField(
              onChanged: (v) => setState(() => _fillAnswer = v),
              enabled: _answered == null,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildOptionTile(int index, String option, Exercise exercise) {
    final isSelected = _selectedOption == index;
    Color? bgColor;
    Color? borderColor;

    if (_answered != null) {
      final isCorrect = _exerciseService.checkAnswer(exercise, option);
      if (isCorrect) {
        bgColor = AppColors.success.withValues(alpha: 0.15);
        borderColor = AppColors.success;
      } else if (isSelected) {
        bgColor = AppColors.lives.withValues(alpha: 0.15);
        borderColor = AppColors.lives;
      }
    } else if (isSelected) {
      bgColor = AppColors.primary.withValues(alpha: 0.12);
      borderColor = AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: _answered == null
            ? () => setState(() => _selectedOption = index)
            : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor ?? AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor ?? AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? (borderColor ?? AppColors.primary)
                      : AppColors.background,
                  border: Border.all(color: borderColor ?? AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (_answered != null && _exerciseService.checkAnswer(exercise, option))
                const Icon(Icons.check_circle, color: AppColors.success, size: 24),
              if (_answered != null && isSelected && !_exerciseService.checkAnswer(exercise, option))
                const Icon(Icons.cancel, color: AppColors.lives, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(Exercise exercise) {
    final isCorrect = _answered == true;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.lives.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.lives,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? '✅ ¡Correcto!' : '❌ Incorrecto',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isCorrect ? AppColors.success : AppColors.lives,
            ),
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 4),
            Text(
              'Respuesta correcta: ${exercise.correctAnswer}',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          if (exercise.explanation != null) ...[
            const SizedBox(height: 6),
            Text(
              exercise.explanation!,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // RESULTADOS DEL QUIZ
  // ═══════════════════════════════════════════

  Widget _buildQuizResults() {
    final total = _quizExercises.length;
    final percentage = ((_correctCount / total) * 100).round();
    final xpEarned = _quizExercises.fold<int>(0, (s, e) => s + e.xpReward);

    String emoji;
    String message;
    if (percentage >= 90) {
      emoji = '🏆';
      message = '¡Increíble! ¡Eres un crack!';
    } else if (percentage >= 70) {
      emoji = '⭐';
      message = '¡Muy bien! Sigue así';
    } else if (percentage >= 50) {
      emoji = '💪';
      message = '¡Buen intento! Practica más';
    } else {
      emoji = '📚';
      message = 'Necesitas repasar un poco';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 72)),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildResultBadge('✅', '$_correctCount/$total', 'Aciertos'),
                    const SizedBox(width: 20),
                    _buildResultBadge('📊', '$percentage%', 'Nota'),
                    const SizedBox(width: 20),
                    _buildResultBadge('⭐', '+$xpEarned', 'XP'),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('🔄 Intentar de nuevo'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _inQuiz = false;
                      _quizExercises = [];
                    }),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('🗺️ Volver'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultBadge(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // LÓGICA
  // ═══════════════════════════════════════════

  bool get _canSubmit {
    if (_answered != null) return true;
    final exercise = _quizExercises[_currentIndex];
    // Sort y match se gestionan con sus propios widgets
    if (exercise.type == ExerciseType.ordering ||
        exercise.type == ExerciseType.matching) {
      return _answered != null; // Solo muestra 'Siguiente' tras responder
    }
    if (exercise.type == ExerciseType.multipleChoice ||
        exercise.type == ExerciseType.trueFalse) {
      return _selectedOption != null;
    }
    return _fillAnswer.isNotEmpty;
  }

  void _handleSubmit() {
    if (_answered != null) {
      // Avanzar al siguiente
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = null;
        _fillAnswer = '';
      });
      return;
    }

    // Comprobar respuesta
    final exercise = _quizExercises[_currentIndex];
    bool correct;

    if (exercise.type == ExerciseType.multipleChoice) {
      final selectedAnswer = exercise.options[_selectedOption!];
      correct = _exerciseService.checkAnswer(exercise, selectedAnswer);
    } else if (exercise.type == ExerciseType.trueFalse) {
      final options = ['Verdadero', 'Falso'];
      correct = _exerciseService.checkAnswer(exercise, options[_selectedOption!]);
    } else {
      correct = _exerciseService.checkAnswer(exercise, _fillAnswer);
    }

    if (correct) _correctCount++;
    setState(() => _answered = correct);
  }
}
