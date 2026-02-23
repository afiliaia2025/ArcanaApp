import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';

/// Pantalla de recompensas diarias — cofre mágico con streak.
/// El jugador reclama un cofre cada día. A mayor racha, mejor recompensa.
class DailyRewardsScreen extends StatefulWidget {
  const DailyRewardsScreen({super.key});

  @override
  State<DailyRewardsScreen> createState() => _DailyRewardsScreenState();
}

class _DailyRewardsScreenState extends State<DailyRewardsScreen>
    with TickerProviderStateMixin {
  // Streak simulado
  final int _currentStreak = 5;
  final bool _todayClaimed = false;
  bool _chestOpened = false;
  int _rewardXP = 0;
  int _rewardCoins = 0;

  late AnimationController _floatController;
  late AnimationController _openController;

  // Definición de los 7 días
  final List<_DayReward> _weekRewards = const [
    _DayReward(day: 1, xp: 20, coins: 5, label: 'Lun'),
    _DayReward(day: 2, xp: 25, coins: 8, label: 'Mar'),
    _DayReward(day: 3, xp: 30, coins: 10, label: 'Mié'),
    _DayReward(day: 4, xp: 40, coins: 15, label: 'Jue'),
    _DayReward(day: 5, xp: 50, coins: 20, label: 'Vie'),
    _DayReward(day: 6, xp: 60, coins: 25, label: 'Sáb'),
    _DayReward(day: 7, xp: 100, coins: 50, label: 'Dom', isSpecial: true),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _openController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _openController.dispose();
    super.dispose();
  }

  void _claimReward() {
    if (_chestOpened || _todayClaimed) return;

    // Calcular recompensa según streak
    final dayIndex = (_currentStreak % 7);
    final reward = _weekRewards[dayIndex];

    setState(() {
      _chestOpened = true;
      _rewardXP = reward.xp;
      _rewardCoins = reward.coins;
    });

    _openController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        children: [
          // Partículas ambientales
          MagicalParticles(
            particleCount: _chestOpened ? 50 : 20,
            color: ArcanaColors.gold,
            maxSize: _chestOpened ? 3.0 : 1.5,
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 12),

                // Streak counter
                _buildStreakCounter(),
                const SizedBox(height: 16),

                // Cofre central
                Expanded(child: _buildChestArea()),

                // Calendario semanal
                _buildWeekCalendar(),
                const SizedBox(height: 16),

                // Botón reclamar
                _buildClaimButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ArcanaColors.surface,
                border: Border.all(color: ArcanaColors.surfaceBorder),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: ArcanaColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Cofre Diario',
            style: ArcanaTextStyles.screenTitle.copyWith(
              color: ArcanaColors.gold,
            ),
          ),
          const Spacer(),
          // Monedas del jugador
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: ArcanaColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '340',
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: ArcanaColors.gold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCounter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ArcanaColors.ruby.withValues(alpha: 0.1),
            ArcanaColors.gold.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(
            '$_currentStreak días de racha',
            style: ArcanaTextStyles.cardTitle.copyWith(
              color: ArcanaColors.gold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '¡Sigue así!',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChestArea() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatController, _openController]),
        builder: (context, child) {
          final floatOffset = math.sin(_floatController.value * math.pi) * 8;
          final openScale = _chestOpened
              ? Tween<double>(begin: 1.0, end: 1.15).animate(
                  CurvedAnimation(
                    parent: _openController,
                    curve: Curves.elasticOut,
                  ),
                ).value
              : 1.0;

          return Transform.translate(
            offset: Offset(0, _chestOpened ? 0 : -floatOffset),
            child: Transform.scale(
              scale: openScale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cofre
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ArcanaColors.gold.withValues(alpha: 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: ArcanaColors.gold.withValues(
                            alpha: _chestOpened ? 0.4 : 0.15,
                          ),
                          blurRadius: _chestOpened ? 40 : 20,
                          spreadRadius: _chestOpened ? 10 : 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _chestOpened ? '✨' : '🎁',
                        style: TextStyle(fontSize: _chestOpened ? 56 : 64),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Recompensa (visible solo al abrir)
                  if (_chestOpened) ...[
                    _buildRewardReveal(),
                  ] else ...[
                    Text(
                      _todayClaimed
                          ? 'Ya reclamaste tu cofre hoy'
                          : '¡Toca para abrir tu cofre!',
                      style: ArcanaTextStyles.bodyMedium.copyWith(
                        color: _todayClaimed
                            ? ArcanaColors.textMuted
                            : ArcanaColors.gold,
                      ),
                    ),
                    if (!_todayClaimed) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Día ${(_currentStreak % 7) + 1} de 7',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: ArcanaColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRewardReveal() {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _openController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
      child: Column(
        children: [
          Text(
            '¡Recompensa obtenida!',
            style: ArcanaTextStyles.cardTitle.copyWith(
              color: ArcanaColors.gold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRewardPill('⚡ $_rewardXP XP', ArcanaColors.turquoise),
              const SizedBox(width: 12),
              _buildRewardPill('🪙 $_rewardCoins', ArcanaColors.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: ArcanaTextStyles.cardTitle.copyWith(
          color: color,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semana de recompensas',
            style: ArcanaTextStyles.sectionTitle.copyWith(
              color: ArcanaColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: _weekRewards.map((reward) {
              final isClaimed = reward.day <= _currentStreak % 7;
              final isToday = reward.day == (_currentStreak % 7) + 1;
              final isSpecial = reward.isSpecial;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isClaimed
                          ? ArcanaColors.gold.withValues(alpha: 0.15)
                          : isToday
                              ? ArcanaColors.turquoise.withValues(alpha: 0.1)
                              : ArcanaColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isToday
                            ? ArcanaColors.turquoise
                            : isClaimed
                                ? ArcanaColors.gold.withValues(alpha: 0.3)
                                : ArcanaColors.surfaceBorder,
                        width: isToday ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          reward.label,
                          style: ArcanaTextStyles.caption.copyWith(
                            color: isClaimed
                                ? ArcanaColors.gold
                                : ArcanaColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isClaimed
                              ? '✅'
                              : isSpecial
                                  ? '👑'
                                  : '📦',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+${reward.xp}',
                          style: ArcanaTextStyles.caption.copyWith(
                            color: ArcanaColors.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimButton() {
    final canClaim = !_todayClaimed && !_chestOpened;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: canClaim ? _claimReward : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: canClaim ? ArcanaColors.goldGradient : null,
            color: canClaim ? null : ArcanaColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: canClaim
                ? null
                : Border.all(color: ArcanaColors.surfaceBorder),
            boxShadow: canClaim
                ? [
                    BoxShadow(
                      color: ArcanaColors.gold.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _chestOpened
                    ? '¡Vuelve mañana!'
                    : _todayClaimed
                        ? 'Ya reclamado hoy'
                        : '¡Abrir cofre mágico! 🎁',
                style: ArcanaTextStyles.cardTitle.copyWith(
                  color: canClaim
                      ? const Color(0xFF1A1130)
                      : ArcanaColors.textMuted,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modelo de recompensa por día
class _DayReward {
  final int day;
  final int xp;
  final int coins;
  final String label;
  final bool isSpecial;

  const _DayReward({
    required this.day,
    required this.xp,
    required this.coins,
    required this.label,
    this.isSpecial = false,
  });
}
