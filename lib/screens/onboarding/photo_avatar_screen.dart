import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/avatar_service.dart';
import '../../theme/app_colors.dart';

/// Pantalla de creación de avatar fotográfico con IA
/// Flujo: subir foto → elegir estilo → IA genera personaje → aprobar
class PhotoAvatarScreen extends ConsumerStatefulWidget {
  final Function(Uint8List avatarBytes, AvatarStyle style) onComplete;

  const PhotoAvatarScreen({super.key, required this.onComplete});

  @override
  ConsumerState<PhotoAvatarScreen> createState() => _PhotoAvatarScreenState();
}

class _PhotoAvatarScreenState extends ConsumerState<PhotoAvatarScreen> {
  final _avatarService = AvatarService();
  final _picker = ImagePicker();

  // Estado
  int _step = 0; // 0: foto, 1: estilo, 2: preview
  Uint8List? _photoBytes;
  AvatarStyle? _selectedStyle;
  Uint8List? _generatedAvatar;
  bool _isGenerating = false;
  String? _error;
  int _attemptsUsed = 0;
  static const _maxAttempts = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Barra de progreso ──
            _buildProgressBar(),

            // ── Contenido según paso ──
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: switch (_step) {
                  0 => _buildPhotoStep(),
                  1 => _buildStyleStep(),
                  2 => _buildPreviewStep(),
                  _ => const SizedBox(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // BARRA DE PROGRESO
  // ═══════════════════════════════════════════

  Widget _buildProgressBar() {
    final labels = ['📸 Foto', '🎨 Estilo', '✨ Avatar'];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(3, (i) {
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: i <= _step ? AppColors.primary : AppColors.borderLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    fontWeight: i == _step ? FontWeight.w800 : FontWeight.w500,
                    color: i <= _step
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 1: SUBIR FOTO
  // ═══════════════════════════════════════════

  Widget _buildPhotoStep() {
    return Padding(
      key: const ValueKey('photo'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🧙‍♂️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            '¡Conviértete en héroe!',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sube una foto y la IA la transformará\nen un personaje de aventuras',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Preview de la foto seleccionada
          if (_photoBytes != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(
                _photoBytes!,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Botones de foto
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon: '📷',
                label: 'Cámara',
                onTap: () => _pickPhoto(ImageSource.camera),
              ),
              const SizedBox(width: 16),
              _ActionButton(
                icon: '📁',
                label: 'Galería',
                onTap: () => _pickPhoto(ImageSource.gallery),
              ),
            ],
          ),

          if (_photoBytes != null) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => _step = 1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Elegir estilo →',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Text(
            '🔒 Tu foto no se guarda. Solo se usa\npara crear el dibujo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 2: ELEGIR ESTILO
  // ═══════════════════════════════════════════

  Widget _buildStyleStep() {
    return Padding(
      key: const ValueKey('style'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            '¿Qué estilo mola más?',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Así se verán TODAS tus aventuras',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Grid de estilos 2x3
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: AvatarStyle.all.length,
              itemBuilder: (context, i) {
                final style = AvatarStyle.all[i];
                final isSelected = _selectedStyle?.id == style.id;
                return _StyleCard(
                  style: style,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedStyle = style),
                );
              },
            ),
          ),

          // Botones
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _step = 0),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('← Atrás'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _selectedStyle != null ? _generateAvatar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '✨ Crear avatar',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
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

  // ═══════════════════════════════════════════
  // PASO 3: PREVIEW + APROBAR
  // ═══════════════════════════════════════════

  Widget _buildPreviewStep() {
    return Padding(
      key: const ValueKey('preview'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isGenerating) ...[
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              '🎨 Creando tu personaje...',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'La IA está dibujando tu avatar.\nEsto puede tardar unos segundos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ] else if (_error != null) ...[
            const Text('😅', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _attemptsUsed < _maxAttempts ? _generateAvatar : null,
              child: Text('Reintentar (${_maxAttempts - _attemptsUsed} intentos)'),
            ),
          ] else if (_generatedAvatar != null) ...[
            const Text(
              '¡Tu personaje está listo!',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Estilo: ${_selectedStyle?.emoji} ${_selectedStyle?.name}',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Avatar generado
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.memory(
                  _generatedAvatar!,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botones aprobar / regenerar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _approveAvatar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '🎉 ¡Me encanta!',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (_attemptsUsed < _maxAttempts)
              TextButton(
                onPressed: _generateAvatar,
                child: Text(
                  '🔄 Otro intento (${_maxAttempts - _attemptsUsed} restantes)',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              const Text(
                'No quedan intentos. ¡Pero tu avatar mola! 😎',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),

            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _step = 1),
              child: const Text(
                '← Cambiar estilo',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // LÓGICA
  // ═══════════════════════════════════════════

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 512, // Reducir para ahorro de tokens
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() => _photoBytes = bytes);
      }
    } catch (_) {
      // Silenciar errores de permisos
    }
  }

  Future<void> _generateAvatar() async {
    if (_photoBytes == null || _selectedStyle == null) return;
    if (_attemptsUsed >= _maxAttempts) return;

    setState(() {
      _isGenerating = true;
      _error = null;
      _step = 2;
    });

    _attemptsUsed++;

    final result = await _avatarService.generateCharacter(
      photoBytes: _photoBytes!,
      style: _selectedStyle!,
      childName: '', // se pasa en onboarding
    );

    setState(() {
      _isGenerating = false;
      if (result != null) {
        _generatedAvatar = result;
      } else {
        _error = 'No se pudo generar el avatar.\nInténtalo de nuevo.';
      }
    });
  }

  void _approveAvatar() {
    if (_generatedAvatar != null && _selectedStyle != null) {
      // Descartar la foto original de memoria
      _photoBytes = null;
      widget.onComplete(_generatedAvatar!, _selectedStyle!);
    }
  }
}

// ═══════════════════════════════════════════
// WIDGETS INTERNOS
// ═══════════════════════════════════════════

/// Botón de acción (cámara/galería)
class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de estilo visual
class _StyleCard extends StatelessWidget {
  final AvatarStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleCard({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(style.emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 6),
            Text(
              style.name,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            Text(
              style.description,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
