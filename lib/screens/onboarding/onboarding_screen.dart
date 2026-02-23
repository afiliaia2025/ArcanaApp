import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_colors.dart';
import 'photo_avatar_screen.dart';

/// Onboarding gamificado — "Tu primera aventura"
/// 8 pasos interactivos que recogen datos del usuario
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < 7) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      // Onboarding completado → guardar en Firebase + generar arco
      final notifier = ref.read(onboardingProvider.notifier);
      await notifier.completeOnboarding();
      final state = ref.read(onboardingProvider);
      if (state.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
        return;
      }
      if (mounted) context.go('/world-map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(8, (index) {
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: index <= _currentPage
                            ? AppColors.primary
                            : AppColors.borderLight,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Páginas
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) =>
                    setState(() => _currentPage = page),
                children: [
                  _buildRolePage(),
                  _buildNamePage(),
                  _buildAvatarPage(),
                  _buildGradePage(),
                  _buildSubjectsPage(),
                  _buildInterestsPage(),
                  _buildRegionPage(),
                  _buildReadyPage(),
                ],
              ),
            ),

            // Botón
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue ? _nextPage : null,
                  child: Text(
                    _currentPage == 7
                        ? '¡Empezar aventura! 🚀'
                        : 'Continuar',
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
    final s = ref.watch(onboardingProvider);
    if (s.isSaving) return false;
    return switch (_currentPage) {
      0 => s.role.isNotEmpty,
      1 => s.name.isNotEmpty && s.nick.isNotEmpty,
      2 => true,
      3 => s.grade.isNotEmpty,
      4 => s.subjects.length >= 2,
      5 => s.interests.length >= 3,
      6 => s.region.isNotEmpty,
      7 => true,
      _ => false,
    };
  }

  // ═══════════════════════════════════════════
  // PASO 1: ¿Quién eres?
  // ═══════════════════════════════════════════

  Widget _buildRolePage() {
    return _OnboardingPage(
      emoji: '⚔️',
      title: '¿Quién eres, aventurero?',
      subtitle: 'Tu rol determina tu camino',
      child: Column(
        children: [
          _RoleCard(
            emoji: '🎒',
            title: 'Soy alumno',
            subtitle: 'Quiero aprender jugando',
            isSelected: ref.watch(onboardingProvider).role == 'student',
            onTap: () => ref.read(onboardingProvider.notifier).setRole('student'),
          ),
          const SizedBox(height: 12),
          _RoleCard(
            emoji: '👨‍👩‍👧',
            title: 'Soy padre/madre',
            subtitle: 'Quiero ayudar a mi hijo',
            isSelected: ref.watch(onboardingProvider).role == 'parent',
            onTap: () => ref.read(onboardingProvider.notifier).setRole('parent'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 2: Nombre + Nick
  // ═══════════════════════════════════════════

  Widget _buildNamePage() {
    return _OnboardingPage(
      emoji: '✏️',
      title: '¿Cómo te llamas?',
      subtitle: 'Tu nick es tu identidad de aventurero',
      child: Column(
        children: [
          TextField(
            onChanged: (v) => ref.read(onboardingProvider.notifier).setName(v),
            decoration: const InputDecoration(
              hintText: 'Tu nombre (solo lo ven tus padres)',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (v) => ref.read(onboardingProvider.notifier).setNick(v),
            decoration: const InputDecoration(
              hintText: 'Tu nick de aventurero (ej: Pablo_Astro)',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 3: Avatar
  // ═══════════════════════════════════════════

  Widget _buildAvatarPage() {
    final state = ref.watch(onboardingProvider);
    final hasPhotoAvatar = state.avatarData['photoAvatarBytes'] != null;

    return _OnboardingPage(
      emoji: hasPhotoAvatar ? '✨' : state.avatar,
      title: 'Tu personaje',
      subtitle: 'Conviértete en héroe de tu aventura',
      child: Column(
        children: [
          // ── Opción 1: Avatar con foto + IA ──
          GestureDetector(
            onTap: () => _openPhotoAvatar(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: hasPhotoAvatar ? AppColors.primary : AppColors.borderLight,
                  width: hasPhotoAvatar ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Preview del avatar generado o icono
                  if (hasPhotoAvatar)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        state.avatarData['photoAvatarBytes'] as Uint8List,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('📸', style: TextStyle(fontSize: 32)),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasPhotoAvatar
                              ? '¡Avatar creado! ✨'
                              : '📸 Crear con tu foto',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasPhotoAvatar
                              ? 'Toca para cambiar estilo'
                              : 'La IA dibuja tu cara como personaje',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    hasPhotoAvatar ? Icons.edit : Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Separador
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'o elige un emoji',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 12),

          // ── Opción 2: Emojis clásicos ──
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _avatarEmojis.length,
            itemBuilder: (context, index) {
              final emoji = _avatarEmojis[index];
              final isSelected = !hasPhotoAvatar && state.avatar == emoji;
              return GestureDetector(
                onTap: () {
                  final notifier = ref.read(onboardingProvider.notifier);
                  notifier.setAvatar(emoji);
                  // Limpiar avatar foto si se elige emoji
                  notifier.setAvatarData({});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 26)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static const _avatarEmojis = [
    '🧑‍🚀', '🦸', '🧙', '🤖', '🐱', '🎮',
    '🦊', '🐉', '🦁', '🐺', '🦄', '🐼',
    '👾', '🧝', '🥷', '🏴‍☠️', '🧛', '🎯',
  ];

  void _openPhotoAvatar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoAvatarScreen(
          onComplete: (avatarBytes, style) {
            final notifier = ref.read(onboardingProvider.notifier);
            notifier.setAvatarData({
              'photoAvatarBytes': avatarBytes,
              'style': style.id,
              'styleName': style.name,
              'stylePrompt': style.prompt,
            });
            notifier.setAvatar('✨'); // indicador visual
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 4: Curso
  // ═══════════════════════════════════════════

  Widget _buildGradePage() {
    final grades = {
      '📗 Primaria': [
        ('1_primaria', '1º Primaria'),
        ('2_primaria', '2º Primaria'),
        ('3_primaria', '3º Primaria'),
        ('4_primaria', '4º Primaria'),
        ('5_primaria', '5º Primaria'),
        ('6_primaria', '6º Primaria'),
      ],
      '📙 ESO': [
        ('1_eso', '1º ESO'),
        ('2_eso', '2º ESO'),
        ('3_eso', '3º ESO'),
        ('4_eso', '4º ESO'),
      ],
      '🎓 Bachillerato': [
        ('1_bach', '1º Bachillerato'),
        ('2_bach', '2º Bachillerato'),
      ],
    };

    return _OnboardingPage(
      emoji: '📚',
      title: '¿En qué curso estás?',
      subtitle: 'Para adaptar los ejercicios a tu nivel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grades.entries.map((section) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Text(
                  section.key,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: section.value.map((grade) {
                  final isSelected = ref.watch(onboardingProvider).grade == grade.$1;
                  return ChoiceChip(
                    label: Text(grade.$2),
                    selected: isSelected,
                    onSelected: (_) =>
                        ref.read(onboardingProvider.notifier).setGrade(grade.$1),
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 5: Asignaturas
  // ═══════════════════════════════════════════

  Widget _buildSubjectsPage() {
    final allSubjects = [
      ('mates', '🔢 Matemáticas'),
      ('lengua', '📖 Lengua'),
      ('ciencias', '🔬 Ciencias'),
      ('historia', '🏛️ Historia'),
      ('ingles', '🇬🇧 Inglés'),
      ('fisica', '⚡ Física'),
      ('quimica', '🧪 Química'),
      ('biologia', '🧬 Biología'),
      ('geografia', '🌍 Geografía'),
      ('musica', '🎵 Música'),
    ];

    return _OnboardingPage(
      emoji: '📚',
      title: '¿Qué asignaturas tienes?',
      subtitle: 'Elige al menos 2. La IA generará Arcanos para cada una.',
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allSubjects.map((subj) {
              final isSelected = ref.watch(onboardingProvider).subjects.contains(subj.$1);
              return FilterChip(
                label: Text(subj.$2),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(onboardingProvider.notifier).toggleSubject(subj.$1);
                },
              );
            }).toList(),
          ),
          if (ref.watch(onboardingProvider).subjects.length >= 2) ...[
            const SizedBox(height: 24),
            const Text(
              '¿Cuál es la MÁS DIFÍCIL? 😅',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ref.watch(onboardingProvider).subjects.map((subj) {
                final label = allSubjects
                    .firstWhere((s) => s.$1 == subj,
                        orElse: () => (subj, subj))
                    .$2;
                return ChoiceChip(
                  label: Text(label),
                  selected: ref.watch(onboardingProvider).hardestSubject == subj,
                  onSelected: (_) =>
                      ref.read(onboardingProvider.notifier).setHardestSubject(subj),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 6: Gustos
  // ═══════════════════════════════════════════

  Widget _buildInterestsPage() {
    final allInterests = [
      ('espacio', '🚀 Espacio'),
      ('dragones', '🐉 Dragones'),
      ('deportes', '⚽ Deportes'),
      ('videojuegos', '🎮 Videojuegos'),
      ('dinosaurios', '🦖 Dinosaurios'),
      ('piratas', '🏴‍☠️ Piratas'),
      ('superheroes', '🦸 Superhéroes'),
      ('experimentos', '🧪 Experimentos'),
      ('animales', '🐾 Animales'),
      ('castillos', '🏰 Castillos'),
      ('robots', '🤖 Robots'),
      ('magia', '🧙 Magia'),
    ];

    return _OnboardingPage(
      emoji: '💫',
      title: '¿Qué te mola?',
      subtitle:
          'La IA personalizará tu aventura con tus gustos. ¡Elige mínimo 3!',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: allInterests.map((interest) {
          final isSelected = ref.watch(onboardingProvider).interests.contains(interest.$1);
          return FilterChip(
            label: Text(interest.$2),
            selected: isSelected,
            onSelected: (_) {
              ref.read(onboardingProvider.notifier).toggleInterest(interest.$1);
            },
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 7: Región
  // ═══════════════════════════════════════════

  Widget _buildRegionPage() {
    final regions = [
      'andalucia', 'aragon', 'asturias', 'baleares', 'canarias',
      'cantabria', 'castilla_la_mancha', 'castilla_y_leon', 'cataluna',
      'ceuta', 'extremadura', 'galicia', 'la_rioja', 'madrid',
      'melilla', 'murcia', 'navarra', 'pais_vasco', 'valencia',
    ];

    return _OnboardingPage(
      emoji: '🇪🇸',
      title: '¿De dónde eres?',
      subtitle: 'Para usar el currículo de tu comunidad autónoma',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: regions.map((r) {
          final label = r.replaceAll('_', ' ');
          final capitalizedLabel =
              label[0].toUpperCase() + label.substring(1);
          return ChoiceChip(
            label: Text(capitalizedLabel),
            selected: ref.watch(onboardingProvider).region == r,
            onSelected: (_) => ref.read(onboardingProvider.notifier).setRegion(r),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PASO 8: ¡Listo!
  // ═══════════════════════════════════════════

  Widget _buildReadyPage() {
    final s = ref.watch(onboardingProvider);
    return _OnboardingPage(
      emoji: '⚔️',
      title: '¡Hola, ${s.nick}!',
      subtitle: s.isSaving ? 'Generando tu aventura...' : 'Tus Arcanos te esperan',
      child: Column(
        children: [
          // Avatar grande
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: s.isSaving
                  ? const CircularProgressIndicator()
                  : Text(s.avatar, style: const TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${s.name} • ${s.grade.replaceAll('_', 'º ')}',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Arcanos desbloqueados
          ...(s.subjects.take(3).map((subject) {
            final (emoji, name) = switch (subject) {
              'mates' => ('🔢', 'Arcano de los Números'),
              'lengua' => ('📖', 'Arcano de las Palabras'),
              'ciencias' => ('🔬', 'Arcano de la Naturaleza'),
              'historia' => ('🏛️', 'Arcano del Tiempo'),
              'ingles' => ('🇬🇧', 'Arcano de las Lenguas'),
              _ => ('✨', subject),
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(
                      '$name desbloqueado ✨',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// WIDGETS REUTILIZABLES
// ═══════════════════════════════════════════

/// Layout estándar de una página de onboarding
class _OnboardingPage extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget child;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          child,
        ],
      ),
    );
  }
}

/// Card de selección de rol
class _RoleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }
}
