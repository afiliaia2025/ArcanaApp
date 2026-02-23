import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/firebase_providers.dart';
import '../theme/app_colors.dart';

/// Dashboard del profesor — vista de clase y progreso de alumnos
class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No autenticado')),
      );
    }

    final profileAsync = ref.watch(userProfileProvider(user.uid));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(child: Text('Error al cargar')),
        data: (profile) {
          final classCode = profile?['classCode'] as String? ?? '';
          final teacherName = profile?['displayName'] as String? ?? 'Profe';

          return CustomScrollView(
            slivers: [
              // AppBar con info de clase
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF312E81),
                          Color(0xFF4338CA),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '¡Hola, $teacherName! 📚',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (classCode.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: classCode));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('¡Código de clase copiado!')),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.vpn_key,
                                          color: Colors.white70, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Código clase: $classCode',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.copy,
                                          color: Colors.white54, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Métricas rápidas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildQuickMetrics(profile),
                ),
              ),

              // Lista de alumnos
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildStudentList(classCode, ref),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickMetrics(Map<String, dynamic>? profile) {
    return Row(
      children: [
        _MetricCard(
          icon: '👨‍🎓',
          label: 'Alumnos',
          value: '${(profile?['studentCount'] as int?) ?? 0}',
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        _MetricCard(
          icon: '📊',
          label: 'Media XP',
          value: '${(profile?['avgXp'] as int?) ?? 0}',
          color: AppColors.xp,
        ),
        const SizedBox(width: 8),
        _MetricCard(
          icon: '🔥',
          label: 'Media racha',
          value: '${(profile?['avgStreak'] as int?) ?? 0}',
          color: AppColors.lives,
        ),
      ],
    );
  }

  Widget _buildStudentList(String classCode, WidgetRef ref) {
    if (classCode.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Column(
          children: [
            Text('📝', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Text(
              'Crea una clase para ver alumnos',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    final studentsAsync = ref.watch(_classStudentsProvider(classCode));

    return studentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Text('Error al cargar alumnos'),
      data: (students) {
        if (students.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                '🔗 Comparte el código de clase con tus alumnos',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Nunito', fontSize: 14),
              ),
            ),
          );
        }

        // Ordenar por XP
        students.sort((a, b) =>
            ((b['xp'] as int?) ?? 0).compareTo((a['xp'] as int?) ?? 0));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                '📋 Mis alumnos',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ...students.map((s) => _StudentCard(student: s)),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════
// PROVIDERS LOCALES
// ═══════════════════════════════════════════

final _classStudentsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, code) {
  return ref.watch(firestoreServiceProvider).getClassStudents(code);
});

// ═══════════════════════════════════════════
// WIDGETS AUXILIARES
// ═══════════════════════════════════════════

class _MetricCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Map<String, dynamic> student;

  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final name = student['displayName'] as String? ?? 'Alumno';
    final avatar = (student['avatar']?['emoji'] as String?) ?? '👤';
    final level = (student['level'] as int?) ?? 1;
    final xp = (student['xp'] as int?) ?? 0;
    final streak = (student['streak'] as int?) ?? 0;
    final lastActive = student['lastActiveDate'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Text(avatar, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Nv $level • 🔥 $streak días',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$xp XP',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.xp,
                ),
              ),
              if (lastActive != null)
                Text(
                  _timeAgo(lastActive),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays == 0) return 'Hoy';
      if (diff.inDays == 1) return 'Ayer';
      return 'Hace ${diff.inDays} días';
    } catch (_) {
      return '';
    }
  }
}
