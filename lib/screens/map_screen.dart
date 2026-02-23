import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/gem_card.dart';
import '../widgets/arcana_hud.dart';
import '../widgets/magical_particles.dart';
import 'gem_zone_screen.dart';
import 'player_profile_screen.dart';
import 'achievements_screen.dart';
import 'orion_chat_screen.dart';
import 'boss_battle_screen.dart';
import 'daily_rewards_screen.dart';
import 'restas_battle_screen.dart';
import 'english_battle_screen.dart';
import 'multiplicacion/multiplicacion_hub_screen.dart';

/// Pantalla del Mapa Principal (Home).
/// Muestra las 4 gemas con su progreso y el boss final bloqueado.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  int _selectedNavIndex = 0;
  Set<String> _defeatedEnemies = {};
  Map<String, int> _enemyVictories = {};
  Set<String> _engDefeatedEnemies = {};
  Map<String, int> _engEnemyVictories = {};

  // Datos de las 4 gemas — solo Ignis desbloqueada para el vertical slice
  final List<GemData> _gems = const [
    GemData(
      name: 'Ignis',
      subject: 'Matemáticas',
      color: ArcanaColors.gemIgnis,
      completed: 1,
      total: 13,
      iconAsset: 'assets/images/icons/gem_ignis.png',
    ),
    GemData(
      name: 'Lexis',
      subject: 'Lengua',
      color: ArcanaColors.gemLexis,
      completed: 0,
      total: 10,
      iconAsset: 'assets/images/icons/gem_lexis.png',
      isLocked: true,
    ),
    GemData(
      name: 'Sylva',
      subject: 'Ciencia',
      color: ArcanaColors.gemSylva,
      completed: 0,
      total: 6,
      iconAsset: 'assets/images/icons/gem_sylva.png',
      isLocked: true,
    ),
    GemData(
      name: 'Babel',
      subject: 'Inglés',
      color: ArcanaColors.gemBabel,
      completed: 0,
      total: 10,
      iconAsset: 'assets/images/icons/gem_babel.png',
      isLocked: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _loadDefeatedEnemies();
  }

  Future<void> _loadDefeatedEnemies() async {
    final defeated = await getDefeatedEnemies();
    final victories = await getEnemyVictories();
    final engDefeated = await getEnglishDefeatedEnemies();
    final engVictories = await getEnglishEnemyVictories();
    if (mounted) setState(() {
      _defeatedEnemies = defeated;
      _enemyVictories = victories;
      _engDefeatedEnemies = engDefeated;
      _engEnemyVictories = engVictories;
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _handleNavTap(int index) {
    switch (index) {
      case 0: // Mapa - ya estamos aquí
        break;
      case 1: // Escanear
        // TODO: Conectar a ScanScreen con import adecuado
        break;
      case 2: // Orión
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OrionChatScreen()),
        );
        break;
      case 3: // Perfil
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PlayerProfileScreen()),
        );
        break;
      case 4: // Logros
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AchievementsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allGemsCompleted = _gems.every((g) => g.isCompleted);

    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ─── Fondo ilustrado ─────────────────
          Image.asset(
            'assets/images/screens/menu_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF12182B),
                    ArcanaColors.background,
                    Color(0xFF0A0E1A),
                  ],
                ),
              ),
            ),
          ),
          // Overlay gradiente sutil para legibilidad
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x00120B28),
                  Color(0x80120B28),
                  Color(0xCC120B28),
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // ─── Partículas subtle ────────────────
          const MagicalParticles(
            particleCount: 30,
            color: ArcanaColors.gold,
            maxSize: 2.0,
          ),

          // ─── Contenido ────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                const ArcanaTopBar(
                  title: 'ARCANA',
                  lives: 5,
                  coins: 120,
                  xp: 4600,
                ),

                // Acceso rápido al cofre diario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DailyRewardsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ArcanaColors.gold.withValues(alpha: 0.08),
                            ArcanaColors.ruby.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ArcanaColors.gold.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🎁', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            'Cofre diario disponible · 🔥 5 días',
                            style: ArcanaTextStyles.caption.copyWith(
                              color: ArcanaColors.gold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Acceso directo: Práctica de Restas ─────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RestasBattleScreen(),
                        ),
                      );
                      // Refrescar enemigos derrotados al volver
                      _loadDefeatedEnemies();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ArcanaColors.gemIgnis.withValues(alpha: 0.12),
                            ArcanaColors.ruby.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _defeatedEnemies.length == allBattleEnemies.length
                              ? ArcanaColors.emerald.withValues(alpha: 0.4)
                              : ArcanaColors.gemIgnis.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/icons/gem_ignis.png',
                                  width: 28,
                                  height: 28,
                                  errorBuilder: (_, __, ___) =>
                                      const Text('🔥', style: TextStyle(fontSize: 20)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '⚔️ Combate de Restas',
                                      style: ArcanaTextStyles.cardTitle.copyWith(
                                        color: ArcanaColors.gemIgnis,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _defeatedEnemies.length == allBattleEnemies.length
                                          ? '¡Todos los secuaces derrotados!'
                                          : '${_defeatedEnemies.length}/${allBattleEnemies.length} derrotados · Derrota a los secuaces',
                                      style: ArcanaTextStyles.caption.copyWith(
                                        color: _defeatedEnemies.length == allBattleEnemies.length
                                            ? ArcanaColors.emerald
                                            : ArcanaColors.textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _defeatedEnemies.length == allBattleEnemies.length
                                      ? ArcanaColors.emerald.withValues(alpha: 0.15)
                                      : ArcanaColors.gemIgnis.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _defeatedEnemies.length == allBattleEnemies.length
                                      ? '👑 ¡Victoria!'
                                      : '¡Luchar!',
                                  style: ArcanaTextStyles.caption.copyWith(
                                    color: _defeatedEnemies.length == allBattleEnemies.length
                                        ? ArcanaColors.emerald
                                        : ArcanaColors.gemIgnis,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Fila de emojis de enemigos derrotados
                          if (_defeatedEnemies.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: allBattleEnemies.map((enemy) {
                                final isDefeated = _defeatedEnemies.contains(enemy.name);
                                final victories = _enemyVictories[enemy.name] ?? 0;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Opacity(
                                    opacity: isDefeated ? 1.0 : 0.25,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Text(
                                          enemy.emoji,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        if (victories > 0)
                                          Positioned(
                                            right: -6,
                                            top: -6,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ArcanaColors.emerald,
                                                border: Border.all(
                                                  color: ArcanaColors.background,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$victories',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Boss de las Restas (siempre accesible) ─────
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RestasBossScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFF1744).withValues(alpha: 0.15),
                              const Color(0xFF7C4DFF).withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFF1744).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/bosses/jefe_restas.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Text('🐲', style: TextStyle(fontSize: 22)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🔥 Dios de las Restas',
                                    style: ArcanaTextStyles.cardTitle.copyWith(
                                      color: const Color(0xFFFF1744),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '¿Puedes sacarte un 10/10?',
                                    style: ArcanaTextStyles.caption.copyWith(
                                      color: ArcanaColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF1744).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '¡DESAFIAR!',
                                style: ArcanaTextStyles.caption.copyWith(
                                  color: const Color(0xFFFF1744),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ─── Acceso directo: English Combat ─────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EnglishBattleScreen(),
                        ),
                      );
                      _loadDefeatedEnemies();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF60A5FA).withValues(alpha: 0.12),
                            ArcanaColors.gemBabel.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _engDefeatedEnemies.length == allEnglishEnemies.length
                              ? ArcanaColors.emerald.withValues(alpha: 0.4)
                              : const Color(0xFF60A5FA).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🗣️', style: TextStyle(fontSize: 22)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '⚔️ English Combat — Unit 5',
                                      style: ArcanaTextStyles.cardTitle.copyWith(
                                        color: const Color(0xFF60A5FA),
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _engDefeatedEnemies.length == allEnglishEnemies.length
                                          ? 'All enemies defeated!'
                                          : '${_engDefeatedEnemies.length}/${allEnglishEnemies.length} defeated · Defeat the minions',
                                      style: ArcanaTextStyles.caption.copyWith(
                                        color: _engDefeatedEnemies.length == allEnglishEnemies.length
                                            ? ArcanaColors.emerald
                                            : ArcanaColors.textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF60A5FA).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _engDefeatedEnemies.length == allEnglishEnemies.length
                                      ? '👑 Victory!' : 'Fight!',
                                  style: ArcanaTextStyles.caption.copyWith(
                                    color: _engDefeatedEnemies.length == allEnglishEnemies.length
                                        ? ArcanaColors.emerald : const Color(0xFF60A5FA),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_engDefeatedEnemies.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: allEnglishEnemies.map((enemy) {
                                final isDefeated = _engDefeatedEnemies.contains(enemy.name);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Opacity(
                                    opacity: isDefeated ? 1.0 : 0.25,
                                    child: Text(enemy.emoji, style: const TextStyle(fontSize: 18)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Boss de English (examen Unit 5) ─────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EnglishBossScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF7C3AED).withValues(alpha: 0.15),
                            const Color(0xFF60A5FA).withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/bosses/enchantress.png',
                              width: 36, height: 36, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Text('🦉', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🏰 The Grimoire — Unit 5 Exam',
                                  style: ArcanaTextStyles.cardTitle.copyWith(
                                    color: const Color(0xFF7C3AED),
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Can you score 8/10?',
                                  style: ArcanaTextStyles.caption.copyWith(
                                    color: ArcanaColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'CHALLENGE!',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: const Color(0xFF7C3AED),
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Acceso directo: Dojo de Multiplicar ─────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MultiplicacionHubScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFEAB308).withValues(alpha: 0.12),
                            ArcanaColors.gemIgnis.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFEAB308).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('✖️', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '✖️ Dojo de Multiplicar',
                                  style: ArcanaTextStyles.cardTitle.copyWith(
                                    color: const Color(0xFFEAB308),
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Aprende, entrena y examínate de las tablas',
                                  style: ArcanaTextStyles.caption.copyWith(
                                    color: ArcanaColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAB308).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '¡Entrar!',
                              style: ArcanaTextStyles.caption.copyWith(
                                color: const Color(0xFFEAB308),
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Contenido principal  
                Expanded(
                  child: _buildMainContent(allGemsCompleted),
                ),

                // Bottom Nav
                ArcanaBottomNav(
                  selectedIndex: _selectedNavIndex,
                  onItemTapped: (index) {
                    setState(() => _selectedNavIndex = index);
                    _handleNavTap(index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool allGemsCompleted) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // ─── Grid de Gemas (2×2) ──────────────
          _buildGemsGrid(),

          const SizedBox(height: 24),

          // ─── Boss Final ───────────────────────
          BossFinalCard(
            isUnlocked: allGemsCompleted,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BossBattleScreen(
                    bossName: 'Numerox',
                    gemColor: ArcanaColors.ruby,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGemsGrid() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, _) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: List.generate(_gems.length, (index) {
            // Animación escalonada para cada card
            final delay = index * 0.15;
            final start = delay;
            final end = (delay + 0.5).clamp(0.0, 1.0);

            final cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _entryController,
                curve: Interval(start, end, curve: Curves.easeOutBack),
              ),
            );

            return FadeTransition(
              opacity: cardAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(cardAnimation),
                child: GemCard(
                  data: _gems[index],
                  onTap: () {
                    final gem = _gems[index];
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GemZoneScreen(
                          gemName: gem.name,
                          subject: gem.subject,
                          gemColor: gem.color,
                          gemIconAsset: gem.iconAsset,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
