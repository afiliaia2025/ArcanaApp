import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';

/// Pantalla de Perfil del jugador.
/// Muestra avatar, nombre, nivel, XP, estadísticas y logros destacados.
class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Partículas sutiles
          const MagicalParticles(
            particleCount: 15,
            color: ArcanaColors.gold,
            maxSize: 1.5,
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),

                  const SizedBox(height: 24),

                  // Card de perfil
                  _buildProfileCard(),

                  const SizedBox(height: 20),

                  // Nivel y XP
                  _buildLevelSection(),

                  const SizedBox(height: 20),

                  // Bastón del Mago
                  _buildStaffSection(),

                  const SizedBox(height: 20),

                  // Estadísticas
                  _buildStatsGrid(),

                  const SizedBox(height: 20),

                  // Progreso por gema
                  _buildGemProgress(),

                  const SizedBox(height: 20),

                  // Logros destacados
                  _buildFeaturedAchievements(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ArcanaColors.surfaceBorder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: ArcanaColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Mi Perfil',
          style: ArcanaTextStyles.screenTitle.copyWith(
            color: ArcanaColors.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1535),
            Color(0xFF12102A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ArcanaColors.gold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ArcanaColors.gold.withValues(alpha: 0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ArcanaColors.turquoise.withValues(alpha: 0.15),
              border: Border.all(
                color: ArcanaColors.gold,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: ArcanaColors.gold.withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/characters/apprentice.png',
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => const Icon(
                  Icons.person,
                  color: ArcanaColors.gold,
                  size: 40,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aprendiz',
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: ArcanaColors.textPrimary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Novato · 2º Primaria',
                  style: ArcanaTextStyles.caption.copyWith(
                    color: ArcanaColors.turquoise,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMiniStat(Icons.star, '150 XP', ArcanaColors.turquoise),
                    const SizedBox(width: 12),
                    _buildMiniStat(Icons.monetization_on, '30', ArcanaColors.gold),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          value,
          style: ArcanaTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelSection() {
    const level = 1;
    const currentXp = 150;
    const nextLevelXp = 500;
    const progress = currentXp / nextLevelXp;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.surfaceBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nivel $level',
                style: ArcanaTextStyles.cardTitle.copyWith(
                  color: ArcanaColors.gold,
                ),
              ),
              Text(
                '$currentXp / $nextLevelXp XP',
                style: ArcanaTextStyles.caption.copyWith(
                  color: ArcanaColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: ArcanaColors.surfaceBorder,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: ArcanaColors.goldGradient,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: ArcanaColors.gold.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bastón del Mago',
            style: ArcanaTextStyles.sectionTitle.copyWith(
              color: ArcanaColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Icono del bastón
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ArcanaColors.turquoise.withValues(alpha: 0.15),
                      ArcanaColors.gold.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ArcanaColors.turquoise.withValues(alpha: 0.3),
                  ),
                ),
                child: const Center(
                  child: Text('🪄', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              // Info del bastón
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vara de Aprendiz',
                      style: ArcanaTextStyles.cardTitle.copyWith(
                        color: ArcanaColors.turquoise,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nivel 1 · +0 poder',
                      style: ArcanaTextStyles.caption.copyWith(
                        color: ArcanaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Mejoras posibles
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ArcanaColors.surfaceBorder,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '0/3 gemas',
                  style: ArcanaTextStyles.caption.copyWith(
                    color: ArcanaColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Slots de gemas del bastón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStaffGemSlot('🔴', 'Ignis', false),
              _buildStaffGemSlot('🟡', 'Lexis', false),
              _buildStaffGemSlot('🟢', 'Sylva', false),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Completa gemas para insertar fragmentos en tu bastón',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textMuted,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStaffGemSlot(String emoji, String label, bool inserted) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: inserted
                ? ArcanaColors.gold.withValues(alpha: 0.15)
                : ArcanaColors.surfaceBorder,
            border: Border.all(
              color: inserted
                  ? ArcanaColors.gold.withValues(alpha: 0.5)
                  : ArcanaColors.surfaceBorder,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              inserted ? emoji : '◇',
              style: TextStyle(
                fontSize: inserted ? 18 : 14,
                color: ArcanaColors.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: ArcanaTextStyles.caption.copyWith(
            color: inserted ? ArcanaColors.textSecondary : ArcanaColors.textMuted,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Capítulos', '1', Icons.book, ArcanaColors.turquoise)),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard('Racha', '1 día', Icons.local_fire_department, ArcanaColors.ruby)),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard('Precisión', '--', Icons.gps_fixed, ArcanaColors.emerald)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: ArcanaTextStyles.cardTitle.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildGemProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso por Gema',
            style: ArcanaTextStyles.sectionTitle.copyWith(
              color: ArcanaColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildGemRow('Ignis', 'Mates', 1, 13, ArcanaColors.gemIgnis),
          _buildGemRow('Lexis', 'Lengua', 0, 10, ArcanaColors.gemLexis),
          _buildGemRow('Sylva', 'Ciencia', 0, 6, ArcanaColors.gemSylva),
          _buildGemRow('Babel', 'Inglés', 0, 10, ArcanaColors.gemBabel),
        ],
      ),
    );
  }

  Widget _buildGemRow(String name, String subject, int done, int total, Color color) {
    final progress = done / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 50,
            child: Text(
              name,
              style: ArcanaTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: ArcanaColors.surfaceBorder,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$done/$total',
            style: ArcanaTextStyles.caption.copyWith(
              color: ArcanaColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedAchievements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArcanaColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Logros Destacados',
            style: ArcanaTextStyles.sectionTitle.copyWith(
              color: ArcanaColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAchievementBadge('🚀', 'Primer\nPaso', true),
              _buildAchievementBadge('🗡️', 'Primer\nBoss', false),
              _buildAchievementBadge('🔥', 'Racha\n5 días', false),
              _buildAchievementBadge('⭐', '100%\nCapítulo', false),
              _buildAchievementBadge('👑', 'Gema\nCompleta', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String emoji, String label, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: unlocked
                ? ArcanaColors.gold.withValues(alpha: 0.15)
                : ArcanaColors.surfaceBorder,
            border: Border.all(
              color: unlocked
                  ? ArcanaColors.gold.withValues(alpha: 0.5)
                  : ArcanaColors.surfaceBorder,
            ),
          ),
          child: Center(
            child: Text(
              unlocked ? emoji : '🔒',
              style: TextStyle(fontSize: unlocked ? 22 : 18),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: ArcanaTextStyles.caption.copyWith(
            color: unlocked ? ArcanaColors.textSecondary : ArcanaColors.textMuted,
            fontSize: 9,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
