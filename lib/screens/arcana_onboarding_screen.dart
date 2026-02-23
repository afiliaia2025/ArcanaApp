import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';

/// Splash Screen — Logo de Arcana con animación de runas y destellos.
/// Dura ~2.5s y luego navega al siguiente paso.
class ArcanaSplashScreen extends StatefulWidget {
  const ArcanaSplashScreen({super.key});

  @override
  State<ArcanaSplashScreen> createState() => _ArcanaSplashScreenState();
}

class _ArcanaSplashScreenState extends State<ArcanaSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    // Navegar al login después de la animación
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, a, b) => const _LoginScreen(),
              transitionDuration: const Duration(milliseconds: 800),
              transitionsBuilder: (_, anim, a2, child) {
                return FadeTransition(opacity: anim, child: child);
              },
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050310),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Partículas doradas
          const MagicalParticles(
            particleCount: 40,
            color: ArcanaColors.gold,
            maxSize: 3.0,
          ),

          // Animación de runas de fondo
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _RunesPainter(
                  progress: _controller.value,
                  color: ArcanaColors.violet,
                ),
              );
            },
          ),

          // Logo central
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = Tween<double>(begin: 0.3, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
                  ),
                );

                final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
                  ),
                );

                final glow = Tween<double>(begin: 0.0, end: 30.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                  ),
                );

                return Opacity(
                  opacity: opacity.value,
                  child: Transform.scale(
                    scale: scale.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icono/Logo
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ArcanaColors.gold.withValues(alpha: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: ArcanaColors.gold.withValues(alpha: 0.3),
                                blurRadius: glow.value,
                                spreadRadius: glow.value * 0.3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: ArcanaColors.gold,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Título
                        Text(
                          'ARCANA',
                          style: ArcanaTextStyles.heroTitle.copyWith(
                            fontSize: 42,
                            letterSpacing: 12,
                            color: ArcanaColors.gold,
                            shadows: [
                              Shadow(
                                color: ArcanaColors.gold.withValues(alpha: 0.5),
                                blurRadius: glow.value,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Subtítulo
                        Opacity(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
                            ),
                          ).value,
                          child: Text(
                            'Aprende con magia ✨',
                            style: ArcanaTextStyles.subtitle.copyWith(
                              color: ArcanaColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter de runas giratorias de fondo
class _RunesPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RunesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.45;
    final paint = Paint()
      ..color = color.withValues(alpha: progress * 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Círculos concéntricos de runas
    for (var i = 0; i < 3; i++) {
      final radius = maxRadius * (0.4 + i * 0.25) * progress;
      final angle = progress * math.pi * 2 * (i.isEven ? 1 : -1);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawCircle(Offset.zero, radius, paint);

      // Marcas en el círculo
      for (var j = 0; j < 8; j++) {
        final markAngle = j * math.pi / 4;
        final start = Offset(
          math.cos(markAngle) * (radius - 6),
          math.sin(markAngle) * (radius - 6),
        );
        final end = Offset(
          math.cos(markAngle) * (radius + 6),
          math.sin(markAngle) * (radius + 6),
        );
        canvas.drawLine(start, end, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_RunesPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────
// Login Screen temporal — Solo para completar la navegación
// ─────────────────────────────────────────────────────────
class _LoginScreen extends StatelessWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MagicalParticles(
            particleCount: 20,
            color: ArcanaColors.gold,
            maxSize: 1.5,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Logo mini
                  const Icon(
                    Icons.auto_awesome,
                    color: ArcanaColors.gold,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ARCANA',
                    style: ArcanaTextStyles.heroTitle.copyWith(
                      color: ArcanaColors.gold,
                      fontSize: 28,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu aventura mágica empieza aquí',
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: ArcanaColors.textSecondary,
                    ),
                  ),
                  const Spacer(),

                  // Botón Alumno
                  _buildRoleButton(
                    context,
                    icon: Icons.school,
                    emoji: '🎒',
                    title: 'Soy Alumno',
                    subtitle: 'Empieza tu aventura',
                    color: ArcanaColors.turquoise,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const OnboardingFlowScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Botón Padre
                  _buildRoleButton(
                    context,
                    icon: Icons.family_restroom,
                    emoji: '👨‍👩‍👧',
                    title: 'Soy Padre/Madre',
                    subtitle: 'Crea la cuenta de tu hijo',
                    color: ArcanaColors.violet,
                    onTap: () {
                      // TODO: Flujo padre (Google Sign-In)
                    },
                  ),

                  const SizedBox(height: 24),

                  // Código familiar
                  GestureDetector(
                    onTap: () {
                      // TODO: Introducir código familiar
                    },
                    child: Text(
                      '¿Tienes un código familiar? Introdúcelo aquí',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: ArcanaColors.gold,
                        decoration: TextDecoration.underline,
                        decorationColor: ArcanaColors.gold.withValues(alpha: 0.5),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(
    BuildContext context, {
    required IconData icon,
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ArcanaTextStyles.cardTitle.copyWith(color: color),
                  ),
                  Text(
                    subtitle,
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Onboarding Flow — 8 pasos interactivos
// ─────────────────────────────────────────────────────────
class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  int _currentStep = 0;
  final int _totalSteps = 8;

  // Datos recopilados
  String _name = '';
  String _nick = '';
  String _selectedAvatar = '🧙';
  String _selectedGrade = '';
  final List<String> _selectedSubjects = [];
  String _hardestSubject = '';
  final List<String> _selectedInterests = [];
  String _selectedRegion = '';

  final _nameController = TextEditingController();
  final _nickController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nickController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      // Finalizar onboarding → ir al mapa
      Navigator.of(context).pushReplacementNamed('/world-map');
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0: return true; // Bienvenida
      case 1: return _name.isNotEmpty && _nick.isNotEmpty; // Nombre + Nick
      case 2: return _selectedGrade.isNotEmpty; // Curso
      case 3: return _selectedSubjects.length >= 2; // Asignaturas
      case 4: return _hardestSubject.isNotEmpty; // Más difícil
      case 5: return _selectedInterests.length >= 3; // Intereses
      case 6: return _selectedRegion.isNotEmpty; // Región
      case 7: return true; // Final
      default: return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso
            _buildProgressBar(),

            // Contenido del paso
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) {
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  );
                },
                child: _buildStep(),
              ),
            ),

            // Botones navegación
            _buildNavButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          if (_currentStep > 0)
            GestureDetector(
              onTap: _prevStep,
              child: const Icon(Icons.arrow_back, color: ArcanaColors.textSecondary, size: 20),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: ArcanaColors.surfaceBorder,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (_currentStep + 1) / _totalSteps,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: ArcanaColors.goldGradient,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_currentStep + 1}/$_totalSteps',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0: return _buildWelcomeStep();
      case 1: return _buildNameStep();
      case 2: return _buildGradeStep();
      case 3: return _buildSubjectsStep();
      case 4: return _buildHardestStep();
      case 5: return _buildInterestsStep();
      case 6: return _buildRegionStep();
      case 7: return _buildFinalStep();
      default: return const SizedBox();
    }
  }

  // ─── Paso 0: Bienvenida ────────────────────
  Widget _buildWelcomeStep() {
    return Padding(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🧙‍♂️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            '¡Bienvenido, aprendiz!',
            style: ArcanaTextStyles.screenTitle.copyWith(color: ArcanaColors.gold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Vamos a preparar tu aventura mágica.\nSolo necesito saber unas cositas sobre ti...',
            style: ArcanaTextStyles.bodyMedium.copyWith(
              color: ArcanaColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Paso 1: Nombre + Nick + Avatar ────────
  Widget _buildNameStep() {
    const avatars = ['🧙', '🧑‍🚀', '🦸', '🤖', '🐱', '🎮', '🦊', '🐉', '⚡', '🌟', '🦄', '🐼'];

    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('¿Cómo te llamas?', '📝'),

          const SizedBox(height: 16),
          _buildTextField(
            controller: _nameController,
            hint: 'Tu nombre real (solo lo ve tu familia)',
            icon: Icons.person,
            onChanged: (v) => setState(() => _name = v),
          ),

          const SizedBox(height: 16),
          _buildTextField(
            controller: _nickController,
            hint: 'Tu nick de aventurero (ej: DragonMaster)',
            icon: Icons.badge,
            onChanged: (v) => setState(() => _nick = v),
          ),

          const SizedBox(height: 24),
          Text(
            'Elige tu avatar',
            style: ArcanaTextStyles.sectionTitle.copyWith(
              color: ArcanaColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: avatars.map((a) {
              final isSelected = _selectedAvatar == a;
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = a),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? ArcanaColors.gold.withValues(alpha: 0.2)
                        : ArcanaColors.surface,
                    border: Border.all(
                      color: isSelected ? ArcanaColors.gold : ArcanaColors.surfaceBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(a, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Paso 2: Curso ────────────────────────
  Widget _buildGradeStep() {
    final grades = {
      '📗 Primaria': ['1º Primaria', '2º Primaria', '3º Primaria', '4º Primaria', '5º Primaria', '6º Primaria'],
      '📙 ESO': ['1º ESO', '2º ESO', '3º ESO', '4º ESO'],
      '🎓 Bachillerato': ['1º Bachillerato', '2º Bachillerato'],
    };

    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('¿En qué curso estás?', '🎓'),
          const SizedBox(height: 16),
          ...grades.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: ArcanaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.value.map((grade) {
                    final isSelected = _selectedGrade == grade;
                    return _buildChip(
                      label: grade,
                      isSelected: isSelected,
                      color: ArcanaColors.turquoise,
                      onTap: () => setState(() => _selectedGrade = grade),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ─── Paso 3: Asignaturas ──────────────────
  Widget _buildSubjectsStep() {
    final subjects = [
      ('📐', 'Matemáticas'),
      ('📖', 'Lengua'),
      ('🧪', 'Ciencias'),
      ('🌍', 'Sociales'),
      ('🇬🇧', 'Inglés'),
      ('🎨', 'Plástica'),
      ('🎵', 'Música'),
      ('🏃', 'Ed. Física'),
      ('🇫🇷', 'Francés'),
      ('💻', 'Tecnología'),
    ];

    return SingleChildScrollView(
      key: const ValueKey(3),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('¿Qué asignaturas tienes?', '📚'),
          Text(
            'Selecciona mínimo 2',
            style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textMuted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subjects.map((s) {
              final isSelected = _selectedSubjects.contains(s.$2);
              return _buildChip(
                label: '${s.$1} ${s.$2}',
                isSelected: isSelected,
                color: ArcanaColors.turquoise,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSubjects.remove(s.$2);
                    } else {
                      _selectedSubjects.add(s.$2);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Paso 4: Más difícil ──────────────────
  Widget _buildHardestStep() {
    return SingleChildScrollView(
      key: const ValueKey(4),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('¿Cuál te cuesta más?', '😅'),
          Text(
            'Será tu primera aventura recomendada',
            style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textMuted),
          ),
          const SizedBox(height: 16),
          ..._selectedSubjects.map((subject) {
            final isSelected = _hardestSubject == subject;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildChip(
                label: subject,
                isSelected: isSelected,
                color: ArcanaColors.ruby,
                onTap: () => setState(() => _hardestSubject = subject),
                fullWidth: true,
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Paso 5: Intereses ────────────────────
  Widget _buildInterestsStep() {
    final interests = [
      '🚀 Espacio', '🐉 Dragones', '⚽ Deportes', '🎮 Videojuegos',
      '🦖 Dinosaurios', '🏴‍☠️ Piratas', '🦸 Superhéroes', '🧪 Experimentos',
      '🐾 Animales', '🏰 Castillos', '🤖 Robots', '🧙 Magia',
      '🎬 Películas', '🌊 Océano', '🎸 Música', '🍕 Cocina',
    ];

    return SingleChildScrollView(
      key: const ValueKey(5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('¿Qué te mola?', '🎯'),
          Text(
            'Elige 3-6 temas (personalizamos tu aventura)',
            style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textMuted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              final canAdd = _selectedInterests.length < 6 || isSelected;
              return Opacity(
                opacity: canAdd ? 1.0 : 0.4,
                child: _buildChip(
                  label: interest,
                  isSelected: isSelected,
                  color: ArcanaColors.violet,
                  onTap: canAdd ? () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest);
                      } else {
                        _selectedInterests.add(interest);
                      }
                    });
                  } : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Paso 6: Comunidad Autónoma ───────────
  Widget _buildRegionStep() {
    final regions = [
      'Andalucía', 'Aragón', 'Asturias', 'Baleares', 'Canarias',
      'Cantabria', 'Castilla-La Mancha', 'Castilla y León', 'Cataluña',
      'Ceuta', 'Extremadura', 'Galicia', 'La Rioja', 'Madrid',
      'Melilla', 'Murcia', 'Navarra', 'País Vasco', 'C. Valenciana',
    ];

    return SingleChildScrollView(
      key: const ValueKey(6),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('¿Dónde estudias?', '📍'),
          Text(
            'Para adaptar el temario a tu comunidad',
            style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textMuted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: regions.map((region) {
              final isSelected = _selectedRegion == region;
              return _buildChip(
                label: region,
                isSelected: isSelected,
                color: ArcanaColors.emerald,
                onTap: () => setState(() => _selectedRegion = region),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Paso 7: ¡Tu aventura empieza! ────────
  Widget _buildFinalStep() {
    return Padding(
      key: const ValueKey(7),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar grande
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ArcanaColors.gold.withValues(alpha: 0.15),
              border: Border.all(color: ArcanaColors.gold, width: 2),
            ),
            child: Center(
              child: Text(_selectedAvatar, style: const TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '¡Hola, $_nick!',
            style: ArcanaTextStyles.screenTitle.copyWith(color: ArcanaColors.gold),
          ),
          const SizedBox(height: 8),
          Text(
            '$_selectedGrade · $_selectedRegion',
            style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Text(
            'Tu aventura está lista 🗺️',
            style: ArcanaTextStyles.bodyLarge.copyWith(
              color: ArcanaColors.textPrimary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Resumen de asignaturas
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: _selectedSubjects.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: ArcanaColors.turquoise.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s,
                  style: ArcanaTextStyles.caption.copyWith(
                    color: ArcanaColors.turquoise,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'Empezamos con: $_hardestSubject 💪',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.ruby,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Widgets helper ───────────────────────
  Widget _buildStepTitle(String title, String emoji) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 10),
        Text(
          title,
          style: ArcanaTextStyles.screenTitle.copyWith(
            color: ArcanaColors.textPrimary,
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.surfaceBorder),
      ),
      child: TextField(
        controller: controller,
        style: ArcanaTextStyles.bodyMedium.copyWith(
          color: ArcanaColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: ArcanaTextStyles.bodyMedium.copyWith(
            color: ArcanaColors.textMuted,
          ),
          prefixIcon: Icon(icon, color: ArcanaColors.textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required Color color,
    VoidCallback? onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : ArcanaColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : ArcanaColors.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: ArcanaTextStyles.bodyMedium.copyWith(
            color: isSelected ? color : ArcanaColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          textAlign: fullWidth ? TextAlign.center : null,
        ),
      ),
    );
  }

  Widget _buildNavButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: AnimatedOpacity(
          opacity: _canProceed ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: _canProceed ? _nextStep : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: _canProceed ? ArcanaColors.goldGradient : null,
                color: _canProceed ? null : ArcanaColors.surfaceBorder,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _canProceed
                    ? [
                        BoxShadow(
                          color: ArcanaColors.gold.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                _currentStep == _totalSteps - 1
                    ? '¡Empezar aventura! ⚔️'
                    : 'Continuar →',
                style: ArcanaTextStyles.cardTitle.copyWith(
                  color: _canProceed ? const Color(0xFF1A1130) : ArcanaColors.textMuted,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
