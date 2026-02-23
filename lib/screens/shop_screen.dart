import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/firebase_providers.dart';
import '../services/firestore_service.dart';
import '../theme/app_colors.dart';

/// Tienda de gemas — cosméticos y conveniencia
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  final _firestore = FirestoreService();
  List<String> _inventory = [];
  bool _purchasing = false;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final items = await _firestore.getInventory(user.uid);
    if (mounted) {
      setState(() {
        _inventory = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No autenticado')));
    }

    final profileAsync = ref.watch(userProfileProvider(user.uid));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🏪 Tienda'),
        actions: [
          // Balance de gemas
          profileAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
            data: (profile) {
              final gems = (profile?['gems'] as int?) ?? 0;
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gems.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💎', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text(
                      '$gems',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gems,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Packs de gemas
            _sectionTitle('💎 Packs de gemas'),
            const SizedBox(height: 12),
            Row(
              children: [
                _GemPackCard(
                  gems: 100,
                  price: '€1.99',
                  bonus: null,
                  onTap: () => _showComingSoon(),
                ),
                const SizedBox(width: 8),
                _GemPackCard(
                  gems: 500,
                  price: '€7.99',
                  bonus: '+20%',
                  onTap: () => _showComingSoon(),
                ),
                const SizedBox(width: 8),
                _GemPackCard(
                  gems: 1200,
                  price: '€14.99',
                  bonus: '+50%',
                  onTap: () => _showComingSoon(),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Sección: Avatares
            _sectionTitle('🎨 Avatares exclusivos'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _avatarItems
                  .map((item) => _ShopItemCard(
                        item: item,
                        owned: _inventory.contains(item['id']),
                        purchasing: _purchasing,
                        onPurchase: () => _purchaseItem(
                          item['id'] as String,
                          item['cost'] as int,
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 32),

            // Sección: Temas
            _sectionTitle('🎭 Temas visuales'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _themeItems
                  .map((item) => _ShopItemCard(
                        item: item,
                        owned: _inventory.contains(item['id']),
                        purchasing: _purchasing,
                        onPurchase: () => _purchaseItem(
                          item['id'] as String,
                          item['cost'] as int,
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 32),

            // Sección: Conveniencia
            _sectionTitle('⚡ Conveniencia'),
            const SizedBox(height: 12),
            ..._convenienceItems.map((item) => _ConvenienceCard(
                  item: item,
                  purchasing: _purchasing,
                  onPurchase: () => _purchaseItem(
                    item['id'] as String,
                    item['cost'] as int,
                  ),
                )),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🚧 Compras in-app próximamente')),
    );
  }

  Future<void> _purchaseItem(String itemId, int cost) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _purchasing = true;
    });

    final ok = await _firestore.purchaseItem(user.uid, itemId, cost);

    if (mounted) {
      setState(() {
        _purchasing = false;
      });

      if (ok) {
        setState(() {
          _inventory.add(itemId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ ¡Comprado!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ No tienes suficientes gemas')),
        );
      }
    }
  }

  // ═══════════════════════════════════════════
  // CATÁLOGO
  // ═══════════════════════════════════════════

  static final List<Map<String, dynamic>> _avatarItems = [
    {'id': 'avatar_ninja', 'name': 'Ninja', 'emoji': '🥷', 'cost': 50},
    {'id': 'avatar_dragon', 'name': 'Dragón', 'emoji': '🐉', 'cost': 50},
    {'id': 'avatar_mage', 'name': 'Mago', 'emoji': '🧙', 'cost': 50},
    {'id': 'avatar_robot', 'name': 'Robot', 'emoji': '🤖', 'cost': 75},
    {'id': 'avatar_alien', 'name': 'Alien', 'emoji': '👽', 'cost': 75},
    {'id': 'avatar_pirate', 'name': 'Pirata', 'emoji': '🏴‍☠️', 'cost': 75},
  ];

  static final List<Map<String, dynamic>> _themeItems = [
    {'id': 'theme_dark', 'name': 'Modo Oscuro', 'emoji': '🌙', 'cost': 100},
    {'id': 'theme_neon', 'name': 'Neón', 'emoji': '💜', 'cost': 100},
    {'id': 'theme_retro', 'name': 'Retro', 'emoji': '👾', 'cost': 100},
    {'id': 'theme_nature', 'name': 'Bosque', 'emoji': '🌲', 'cost': 100},
  ];

  static final List<Map<String, dynamic>> _convenienceItems = [
    {
      'id': 'streak_freeze',
      'name': 'Streak Freeze',
      'desc': 'Protege tu racha 1 día',
      'emoji': '🧊',
      'cost': 30,
    },
    {
      'id': 'life_refill',
      'name': 'Recarga de vidas',
      'desc': 'Vuelve a tener 5 vidas',
      'emoji': '❤️‍🔥',
      'cost': 20,
    },
    {
      'id': 'hint_pack',
      'name': 'Pack de pistas',
      'desc': '5 pistas extra para ejercicios',
      'emoji': '💡',
      'cost': 25,
    },
  ];
}

// ═══════════════════════════════════════════
// WIDGETS
// ═══════════════════════════════════════════

class _GemPackCard extends StatelessWidget {
  final int gems;
  final String price;
  final String? bonus;
  final VoidCallback onTap;

  const _GemPackCard({
    required this.gems,
    required this.price,
    required this.bonus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.gems.withValues(alpha: 0.1),
                AppColors.gems.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gems.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Text('💎', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                '$gems',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gems,
                ),
              ),
              if (bonus != null) ...[
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    bonus!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                price,
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
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool owned;
  final bool purchasing;
  final VoidCallback onPurchase;

  const _ShopItemCard({
    required this.item,
    required this.owned,
    required this.purchasing,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: owned || purchasing ? null : onPurchase,
      child: Container(
        width: (MediaQuery.of(context).size.width - 48) / 3,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: owned
              ? AppColors.success.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: owned
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            Text(item['emoji'] as String,
                style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              item['name'] as String,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            owned
                ? const Text(
                    '✅ Tuyo',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text(
                    '💎 ${item['cost']}',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gems,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _ConvenienceCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool purchasing;
  final VoidCallback onPurchase;

  const _ConvenienceCard({
    required this.item,
    required this.purchasing,
    required this.onPurchase,
  });

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
          Text(item['emoji'] as String, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  item['desc'] as String,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: purchasing ? null : onPurchase,
            child: Text('💎 ${item['cost']}'),
          ),
        ],
      ),
    );
  }
}
