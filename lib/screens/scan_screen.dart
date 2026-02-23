import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/adventure_provider.dart';
import '../services/gemini_service.dart';
import '../services/firestore_service.dart';
import '../theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Pantalla de escaneo de material escolar — conectada a Gemini Vision
/// Flujo: Foto → OCR (Gemini) → Ejercicios miméticos → Nuevo capítulo
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _picker = ImagePicker();
  final _gemini = GeminiService.instance;
  final _firestore = FirestoreService();

  // Estado del flujo
  Uint8List? _capturedImage;
  Map<String, dynamic>? _analysisResult;
  List<Map<String, dynamic>>? _generatedExercises;
  bool _isAnalyzing = false;
  bool _isGenerating = false;
  String? _error;
  int _processingStep = 0;

  // Historial de escaneos del usuario (Firestore)
  List<Map<String, dynamic>> _recentScans = [];

  @override
  void initState() {
    super.initState();
    _loadRecentScans();
  }

  Future<void> _loadRecentScans() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final scans = await _firestore.getRecentScans(user.uid);
    if (mounted) {
      setState(() {
        _recentScans = scans;
      });
    }
  }

  /// Capturar/elegir foto
  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();
      setState(() {
        _capturedImage = bytes;
        _error = null;
      });

      // Lanzar análisis automático
      await _analyzeImage(bytes);
    } catch (e) {
      setState(() {
        _error = 'Error al capturar imagen: $e';
      });
    }
  }

  /// Analizar foto con Gemini Vision (OCR + detección)
  Future<void> _analyzeImage(Uint8List imageBytes) async {
    setState(() {
      _isAnalyzing = true;
      _processingStep = 0;
      _error = null;
    });

    try {
      // Paso 1: Analizar con Gemini
      setState(() {
        _processingStep = 1;
      });
      final analysis = await _gemini.analyzeMaterial(imageBytes);

      setState(() {
        _analysisResult = analysis;
        _processingStep = 2;
      });

      // Paso 2: Generar ejercicios miméticos
      setState(() {
        _isGenerating = true;
        _processingStep = 3;
      });

      final exercises = await _gemini.generateMimeticExercises(
        topic: analysis['topic'] as String? ?? '',
        exerciseFormat: analysis['exercise_format'] as String? ?? 'mixed',
        grade: analysis['grade_estimate'] as String? ?? '4º Primaria',
        count: 6,
        detectedExercises:
            (analysis['detected_exercises'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>(),
      );

      setState(() {
        _generatedExercises = exercises;
        _processingStep = 4;
        _isAnalyzing = false;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _isGenerating = false;
        _error = 'Error al analizar: $e';
      });
    }
  }

  /// Crear capítulo en Firestore y navegar al juego
  Future<void> _createChapterAndPlay() async {
    if (_analysisResult == null || _generatedExercises == null) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      // Guardar escaneo en historial
      final scanData = {
        'subject': _analysisResult!['subject'] ?? '',
        'topic': _analysisResult!['topic'] ?? '',
        'exerciseCount': _generatedExercises!.length,
        'scannedAt': DateTime.now().toIso8601String(),
        'contentSummary': _analysisResult!['content_summary'] ?? '',
      };
      await _firestore.saveScan(user.uid, scanData);

      // Crear capítulo temporal con los ejercicios generados
      final chapterId =
          'scan_${DateTime.now().millisecondsSinceEpoch}';
      final adventure = ref.read(adventureProvider);

      // Guardar viñetas del capítulo escaneado
      final vignettes = _generatedExercises!
          .map((ex) => {
                'text': ex['question'] as String? ?? '',
                'exercise': {
                  'question': ex['question'],
                  'type': ex['type'] ?? 'multiple_choice',
                  'options': ex['options'] ?? [],
                  'answer':
                      ex['options'] != null &&
                              ex['correct'] != null &&
                              (ex['options'] as List).isNotEmpty
                          ? (ex['options'] as List)[
                              (ex['correct'] as int?) ?? 0]
                          : '',
                  'explanation': ex['explanation'] ?? '',
                  'xp': 10,
                },
              })
          .toList();

      await _firestore.saveChapterProgress(
        uid: user.uid,
        act: adventure.currentAct,
        chapterId: chapterId,
        progressData: {'vignettes': vignettes},
      );

      if (mounted) {
        context.push('/chapter/$chapterId');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al crear capítulo: $e';
        });
      }
    }
  }

  void _reset() {
    setState(() {
      _capturedImage = null;
      _analysisResult = null;
      _generatedExercises = null;
      _isAnalyzing = false;
      _isGenerating = false;
      _error = null;
      _processingStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('📸 Escanear material'),
        actions: [
          if (_capturedImage != null)
            IconButton(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              tooltip: 'Nuevo escaneo',
            ),
        ],
      ),
      body: _isAnalyzing || _isGenerating
          ? _buildProcessing()
          : _analysisResult != null
              ? _buildResult()
              : _buildScanMode(),
    );
  }

  // ═══════════════════════════════════════════
  // MODO ESCANEO (estado inicial)
  // ═══════════════════════════════════════════

  Widget _buildScanMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Zona de escaneo
          _buildScanZone(),
          const SizedBox(height: 24),
          _buildTipsCard(),
          const SizedBox(height: 24),
          if (_recentScans.isNotEmpty) _buildRecentScans(),
          if (_error != null) ...[
            const SizedBox(height: 16),
            _buildErrorBanner(),
          ],
        ],
      ),
    );
  }

  Widget _buildScanZone() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('📸', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Saca una foto a tu libro',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'La IA analizará la página y creará\nejercicios nuevos para ti',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Cámara'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galería'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PROCESAMIENTO (animación de pasos)
  // ═══════════════════════════════════════════

  Widget _buildProcessing() {
    const steps = [
      ('📸', 'Analizando imagen...'),
      ('🔍', 'Detectando asignatura y tema...'),
      ('🧩', 'Extrayendo ejercicios...'),
      ('🧠', 'Generando nuevos ejercicios...'),
      ('✅', '¡Listo!'),
    ];

    final currentStep = _processingStep.clamp(0, steps.length - 1);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen capturada (miniatura)
            if (_capturedImage != null)
              Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    _capturedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            Text(
              steps[currentStep].$1,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              steps[currentStep].$2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (currentStep + 1) / steps.length,
                minHeight: 6,
                backgroundColor: AppColors.borderLight,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // RESULTADO
  // ═══════════════════════════════════════════

  Widget _buildResult() {
    final subject = _analysisResult?['subject'] as String? ?? 'Desconocida';
    final topic = _analysisResult?['topic'] as String? ?? 'Sin tema';
    final summary =
        _analysisResult?['content_summary'] as String? ?? '';
    final exerciseCount = _generatedExercises?.length ?? 0;
    final concepts =
        (_analysisResult?['key_concepts'] as List<dynamic>?)
                ?.cast<String>() ??
            [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Preview de la foto
          if (_capturedImage != null)
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  _capturedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // Resultado del análisis
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                const Text(
                  '¡Material analizado!',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                _DetectedRow(
                    label: 'Asignatura', value: _emojiForSubject(subject)),
                const SizedBox(height: 8),
                _DetectedRow(label: 'Tema', value: topic),
                const SizedBox(height: 8),
                _DetectedRow(
                    label: 'Ejercicios', value: '$exerciseCount generados'),

                if (summary.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    summary,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                if (concepts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: concepts
                        .take(5)
                        .map((c) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                c,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Botón de jugar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _createChapterAndPlay,
              child: const Text('¡Jugar ahora! ⚔️'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _reset,
            child: const Text('Escanear otro material'),
          ),

          if (_error != null) ...[
            const SizedBox(height: 16),
            _buildErrorBanner(),
          ],
        ],
      ),
    );
  }

  String _emojiForSubject(String subject) {
    final lower = subject.toLowerCase();
    if (lower.contains('mate')) {
      return '🔢 $subject';
    }
    if (lower.contains('leng')) {
      return '📖 $subject';
    }
    if (lower.contains('ciencia') || lower.contains('natur')) {
      return '🔬 $subject';
    }
    if (lower.contains('social') || lower.contains('hist')) {
      return '🌍 $subject';
    }
    if (lower.contains('ingl')) {
      return '🇬🇧 $subject';
    }
    return '📚 $subject';
  }

  // ═══════════════════════════════════════════
  // WIDGETS AUXILIARES
  // ═══════════════════════════════════════════

  Widget _buildTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 Consejos para una buena foto',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildTipRow('☀️', 'Buena iluminación, sin sombras'),
          _buildTipRow('📐', 'Foto recta, sin ángulo'),
          _buildTipRow('📖', 'Que se vean los ejercicios completos'),
          _buildTipRow('✋', 'No tapes el texto con los dedos'),
        ],
      ),
    );
  }

  Widget _buildTipRow(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScans() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 Escaneos recientes',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._recentScans.take(5).map((scan) => _buildScanHistoryItem(
                subject: scan['subject'] as String? ?? '',
                topic: scan['topic'] as String? ?? '',
                exerciseCount: scan['exerciseCount'] as int? ?? 0,
                scannedAt: scan['scannedAt'] as String? ?? '',
              )),
        ],
      ),
    );
  }

  Widget _buildScanHistoryItem({
    required String subject,
    required String topic,
    required int exerciseCount,
    required String scannedAt,
  }) {
    String timeAgo = '';
    try {
      final dt = DateTime.parse(scannedAt);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) {
        timeAgo = 'Hace ${diff.inMinutes} min';
      } else if (diff.inHours < 24) {
        timeAgo = 'Hace ${diff.inHours} h';
      } else {
        timeAgo = 'Hace ${diff.inDays} días';
      }
    } catch (_) {
      timeAgo = '';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(_emojiForSubject(subject).split(' ').first,
              style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$exerciseCount ejercicios • $timeAgo',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lives.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lives.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error ?? '',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: AppColors.lives,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _error = null;
              });
            },
            child: const Icon(Icons.close, size: 18, color: AppColors.lives),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// WIDGET AUXILIAR
// ═══════════════════════════════════════════

class _DetectedRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetectedRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
