import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/firebase_providers.dart';
import '../theme/app_colors.dart';

/// Dashboard del padre — progreso de los hijos en tiempo real
class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

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
          final parentName =
              profile?['displayName'] as String? ?? 'Padre/Madre';
          final childUids =
              List<String>.from(profile?['children'] ?? []);

          return CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF059669),
                          Color(0xFF10B981),
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
                              '¡Hola, $parentName! 👋',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${childUids.length} hijo${childUids.length != 1 ? "s" : ""} vinculado${childUids.length != 1 ? "s" : ""}',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Contenido
              if (childUids.isEmpty)
                SliverFillRemaining(
                  child: _buildNoChildren(),
                )
              else
                SliverToBoxAdapter(
                  child: _buildChildrenList(childUids, ref),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoChildren() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('👨‍👧‍👦', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            const Text(
              'No tienes hijos vinculados',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pide a tu hijo que introduzca tu código\nfamiliar durante el onboarding',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenList(List<String> childUids, WidgetRef ref) {
    final childrenAsync = ref.watch(_childrenProvider(childUids));

    return childrenAsync.when(
      loading: () =>
          const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          )),
      error: (e, st) => const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Error al cargar datos'),
      ),
      data: (children) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: children.map((child) => _ChildCard(child: child)).toList(),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════
// PROVIDERS LOCALES
// ═══════════════════════════════════════════

final _childrenProvider = StreamProvider.family<
    List<Map<String, dynamic>>, List<String>>((ref, uids) {
  return ref.watch(firestoreServiceProvider).childrenProgressStream(uids);
});

// ═══════════════════════════════════════════
// WIDGET: TARJETA DE HIJO
// ═══════════════════════════════════════════

class _ChildCard extends StatelessWidget {
  final Map<String, dynamic> child;

  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final name = child['displayName'] as String? ?? 'Hijo';
    final avatar = (child['avatar']?['emoji'] as String?) ?? '👤';
    final level = (child['level'] as int?) ?? 1;
    final xp = (child['xp'] as int?) ?? 0;
    final streak = (child['streak'] as int?) ?? 0;
    final lives = (child['lives'] as int?) ?? 5;
    final lastActive = child['lastActiveDate'] as String?;

    final daysInactive = _daysInactive(lastActive);
    final isInactive = daysInactive >= 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isInactive
              ? AppColors.lives.withValues(alpha: 0.3)
              : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header del hijo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isInactive
                    ? [
                        AppColors.lives.withValues(alpha: 0.05),
                        AppColors.lives.withValues(alpha: 0.02),
                      ]
                    : [
                        AppColors.primary.withValues(alpha: 0.05),
                        AppColors.primary.withValues(alpha: 0.02),
                      ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Text(avatar, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Nivel $level',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isInactive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lives.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⚠️ ${daysInactive}d sin jugar',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lives,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBubble(icon: '⭐', value: '$xp', label: 'XP'),
                _StatBubble(icon: '🔥', value: '$streak', label: 'Racha'),
                _StatBubble(icon: '❤️', value: '$lives', label: 'Vidas'),
                _StatBubble(
                  icon: '📅',
                  value: _lastActiveStr(lastActive),
                  label: 'Último acceso',
                ),
              ],
            ),
          ),

          // Barra de progreso del nivel
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso nivel ${level + 1}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${xp % 200}/200 XP',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (xp % 200) / 200,
                    minHeight: 6,
                    backgroundColor: AppColors.borderLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          // Progreso por gema/asignatura
          _buildGemProgressSection(),

          // Áreas de mejora
          _buildImprovementAreas(),
        ],
      ),
    );
  }

  Widget _buildGemProgressSection() {
    final gems = child['gemProgress'] as Map<String, dynamic>? ?? {};
    final ignisProgress = (gems['ignis'] as num?)?.toDouble() ?? 0.08;
    final lexisProgress = (gems['lexis'] as num?)?.toDouble() ?? 0.0;
    final sylvaProgress = (gems['sylva'] as num?)?.toDouble() ?? 0.0;
    final babelProgress = (gems['babel'] as num?)?.toDouble() ?? 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: 8),
          const Text(
            '📊 Progreso por asignatura',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _buildGemBar('Mates', ignisProgress, const Color(0xFFEF4444)),
          const SizedBox(height: 6),
          _buildGemBar('Lengua', lexisProgress, const Color(0xFFF59E0B)),
          const SizedBox(height: 6),
          _buildGemBar('Ciencia', sylvaProgress, const Color(0xFF10B981)),
          const SizedBox(height: 6),
          _buildGemBar('Inglés', babelProgress, const Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _buildGemBar(String label, double progress, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 55,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${(progress * 100).round()}%',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementAreas() {
    final errors = child['commonErrors'] as List<dynamic>? ?? [];

    if (errors.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF059669).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Text('✅', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '¡Todavía no hay datos de errores! Empieza a jugar para ver estadísticas.',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: 8),
          const Text(
            '⚡ Áreas de mejora',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...errors.take(3).map((e) {
            final desc = e as String? ?? '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Text('🔸', style: TextStyle(fontSize: 10)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      desc,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  int _daysInactive(String? lastActive) {
    if (lastActive == null) return 99;
    try {
      final dt = DateTime.parse(lastActive);
      return DateTime.now().difference(dt).inDays;
    } catch (_) {
      return 99;
    }
  }

  String _lastActiveStr(String? lastActive) {
    final days = _daysInactive(lastActive);
    if (days == 0) return 'Hoy';
    if (days == 1) return 'Ayer';
    if (days > 30) return '+30d';
    return '${days}d';
  }
}

class _StatBubble extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatBubble({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 10,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
