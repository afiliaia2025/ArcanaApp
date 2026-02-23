import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';
import '../widgets/magical_particles.dart';

/// Modelo de datos para un logro.
class AchievementData {
  final String emoji;
  final String title;
  final String description;
  final bool unlocked;
  final double progress; // 0.0 a 1.0
  final String? unlockedDate;

  const AchievementData({
    required this.emoji,
    required this.title,
    required this.description,
    this.unlocked = false,
    this.progress = 0.0,
    this.unlockedDate,
  });
}

/// Pantalla de Logros — Muestra todos los logros disponibles
/// organizados por categoría con progreso visual.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  // Datos de demo
  static const _achievements = <String, List<AchievementData>>{
    '⚔️ Combate': [
      AchievementData(emoji: '🗡️', title: 'Primera Sangre', description: 'Derrota a tu primer boss', unlocked: true, progress: 1.0, unlockedDate: 'Hace 3 días'),
      AchievementData(emoji: '🛡️', title: 'Sin Rasguños', description: 'Derrota un boss sin perder vidas', unlocked: false, progress: 0.0),
      AchievementData(emoji: '👑', title: 'Rey del Calabozo', description: 'Derrota a todos los bosses', unlocked: false, progress: 0.25),
    ],
    '📚 Aprendizaje': [
      AchievementData(emoji: '⭐', title: 'Estrella Perfecta', description: 'Consigue 3 estrellas en un capítulo', unlocked: true, progress: 1.0, unlockedDate: 'Hace 5 días'),
      AchievementData(emoji: '🧠', title: 'Mente Brillante', description: '10 respuestas correctas seguidas', unlocked: true, progress: 1.0, unlockedDate: 'Ayer'),
      AchievementData(emoji: '📖', title: 'Rata de Biblioteca', description: 'Completa 50 capítulos', unlocked: false, progress: 0.46),
      AchievementData(emoji: '🎯', title: 'Francotirador', description: '95% de precisión en 20 ejercicios', unlocked: false, progress: 0.7),
    ],
    '🔥 Constancia': [
      AchievementData(emoji: '🔥', title: 'En Llamas', description: 'Racha de 5 días', unlocked: true, progress: 1.0, unlockedDate: 'Hoy'),
      AchievementData(emoji: '🌋', title: 'Imparable', description: 'Racha de 15 días', unlocked: false, progress: 0.33),
      AchievementData(emoji: '💎', title: 'Diamante', description: 'Racha de 30 días', unlocked: false, progress: 0.16),
    ],
    '💎 Gemas': [
      AchievementData(emoji: '🔴', title: 'Maestro Ignis', description: 'Completa la Gema Ignis', unlocked: false, progress: 0.61),
      AchievementData(emoji: '📜', title: 'Maestro Lexis', description: 'Completa la Gema Lexis', unlocked: false, progress: 0.5),
      AchievementData(emoji: '🌿', title: 'Maestro Sylva', description: 'Completa la Gema Sylva', unlocked: false, progress: 0.66),
      AchievementData(emoji: '🌀', title: 'Maestro Babel', description: 'Completa la Gema Babel', unlocked: false, progress: 0.6),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievements.values.expand((a) => a).where((a) => a.unlocked).length;
    final totalCount = _achievements.values.expand((a) => a).length;

    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MagicalParticles(
            particleCount: 12,
            color: ArcanaColors.gold,
            maxSize: 1.5,
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, unlockedCount, totalCount),
                // Lista de logros
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: _achievements.entries.map((entry) {
                      return _buildCategory(entry.key, entry.value);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int unlocked, int total) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ArcanaColors.surfaceBorder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, color: ArcanaColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Text('Logros', style: ArcanaTextStyles.screenTitle.copyWith(color: ArcanaColors.gold)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: ArcanaColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$unlocked/$total',
              style: ArcanaTextStyles.cardTitle.copyWith(color: ArcanaColors.gold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, List<AchievementData> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: ArcanaTextStyles.sectionTitle.copyWith(color: ArcanaColors.textPrimary),
        ),
        const SizedBox(height: 10),
        ...achievements.map((a) => _buildAchievementTile(a)),
      ],
    );
  }

  Widget _buildAchievementTile(AchievementData data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.unlocked
            ? ArcanaColors.gold.withValues(alpha: 0.05)
            : ArcanaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: data.unlocked
              ? ArcanaColors.gold.withValues(alpha: 0.3)
              : ArcanaColors.surfaceBorder,
        ),
      ),
      child: Row(
        children: [
          // Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.unlocked
                  ? ArcanaColors.gold.withValues(alpha: 0.15)
                  : ArcanaColors.surfaceBorder,
            ),
            child: Center(
              child: Text(
                data.unlocked ? data.emoji : '🔒',
                style: TextStyle(fontSize: data.unlocked ? 22 : 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: ArcanaTextStyles.cardTitle.copyWith(
                    color: data.unlocked ? ArcanaColors.gold : ArcanaColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.description,
                  style: ArcanaTextStyles.caption.copyWith(
                    color: ArcanaColors.textMuted,
                  ),
                ),
                if (!data.unlocked && data.progress > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: ArcanaColors.surfaceBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: data.progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ArcanaColors.turquoise,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${(data.progress * 100).round()}%',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: ArcanaColors.turquoise,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Fecha o check
          if (data.unlocked)
            Column(
              children: [
                const Icon(Icons.check_circle, color: ArcanaColors.gold, size: 18),
                const SizedBox(height: 2),
                Text(
                  data.unlockedDate ?? '',
                  style: ArcanaTextStyles.caption.copyWith(
                    color: ArcanaColors.textMuted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
