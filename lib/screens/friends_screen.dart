import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/social_provider.dart';
import '../services/firestore_service.dart';
import '../theme/app_colors.dart';

/// Pantalla de amigos — ranking semanal + solicitudes
class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firestore = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myCode = ref.watch(myFriendCodeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('👥 Amigos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Amigos'),
            Tab(icon: Icon(Icons.leaderboard), text: 'Ranking'),
            Tab(icon: Icon(Icons.mail), text: 'Solicitudes'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Mi código de amigo
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Text('🔑',
                    style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mi código de amigo',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      myCode,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: myCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡Código copiado! 📋')),
                    );
                  },
                  icon: const Icon(Icons.copy, color: AppColors.primary),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildRanking(),
                _buildRequests(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFriendDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Añadir amigo'),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PESTAÑA 1: MIS AMIGOS
  // ═══════════════════════════════════════════

  Widget _buildFriendsList() {
    final friends = ref.watch(friendsProvider);

    return friends.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Text('Error al cargar amigos')),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🤝', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  '¡Aún no tienes amigos!',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Comparte tu código o añade el de un amigo',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final friend = list[index];
            return _FriendCard(friend: friend);
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // PESTAÑA 2: RANKING
  // ═══════════════════════════════════════════

  Widget _buildRanking() {
    final friends = ref.watch(friendsProvider);

    return friends.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Text('Error')),
      data: (list) {
        // Ordenar por XP (ranking)
        final sorted = [...list]
          ..sort((a, b) =>
              ((b['xp'] as int?) ?? 0).compareTo((a['xp'] as int?) ?? 0));

        if (sorted.isEmpty) {
          return const Center(
            child: Text(
              '🏆 Añade amigos para ver el ranking',
              style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final friend = sorted[index];
            final medal = switch (index) {
              0 => '🥇',
              1 => '🥈',
              2 => '🥉',
              _ => '#${index + 1}',
            };
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: index < 3
                    ? AppColors.primary.withValues(alpha: 0.05 * (3 - index))
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Text(medal,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    (friend['avatar']?['emoji'] as String?) ?? '👤',
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend['displayName'] as String? ?? 'Aventurero',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Nivel ${friend['level'] ?? 1}',
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
                        '${friend['xp'] ?? 0} XP',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.xp,
                        ),
                      ),
                      Text(
                        '🔥 ${friend['streak'] ?? 0}',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppColors.lives,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // PESTAÑA 3: SOLICITUDES
  // ═══════════════════════════════════════════

  Widget _buildRequests() {
    final requests = ref.watch(friendRequestsProvider);

    return requests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Text('Error')),
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Text(
              '📬 No tienes solicitudes pendientes',
              style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final req = list[index];
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
                  Text(
                    (req['avatar']?['emoji'] as String?) ?? '👤',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      req['displayName'] as String? ?? 'Aventurero',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _acceptRequest(req['uid'] as String),
                    icon: const Icon(Icons.check_circle,
                        color: AppColors.success),
                  ),
                  IconButton(
                    onPressed: () => _rejectRequest(req['uid'] as String),
                    icon: const Icon(Icons.cancel, color: AppColors.lives),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // ACCIONES
  // ═══════════════════════════════════════════

  void _showAddFriendDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Añadir amigo'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            hintText: 'Código de amigo (ej: A1B2C3D4)',
            prefixIcon: Icon(Icons.person_search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final code = controller.text.trim();
              if (code.isEmpty) return;

              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final ok = await _firestore.sendFriendRequest(user.uid, code);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? '✅ ¡Solicitud enviada!'
                        : '❌ Código no encontrado o ya enviado'),
                  ),
                );
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptRequest(String fromUid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore.acceptFriendRequest(user.uid, fromUid);
  }

  Future<void> _rejectRequest(String fromUid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore.rejectFriendRequest(user.uid, fromUid);
  }
}

// ═══════════════════════════════════════════
// WIDGET: TARJETA DE AMIGO
// ═══════════════════════════════════════════

class _FriendCard extends StatelessWidget {
  final Map<String, dynamic> friend;

  const _FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
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
          Text(
            (friend['avatar']?['emoji'] as String?) ?? '👤',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['displayName'] as String? ?? 'Aventurero',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Nv ${friend['level'] ?? 1}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '🔥 ${friend['streak'] ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.lives,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '⭐ ${friend['xp'] ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.xp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
