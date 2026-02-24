import 'package:flutter/material.dart';
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';
import '../../widgets/arcana_buttons.dart';
import '../../widgets/magical_particles.dart';
import 'oracle_duel_screen.dart';
import '../english_battle_screen.dart';

// ═══════════════════════════════════════════════════════════
// GRIMOIRO LIBRE — Hub de práctica libre por tema
// ═══════════════════════════════════════════════════════════
//
// Muestra los 3 modos de práctica para un tema dado:
//  1. 🔥 Entrenamiento con Orión (flash cards, match, fill blank, order)
//  2. ⚔️  Combate Libre (barra dual, sin timer, sin fin)
//  3. 💀 Duelo de Conocimiento (El Gran Oráculo, sistema 8/10)
//
// Args:
//  unitNumber : int   — número de la unit (1-9)
//  unitTitle  : String — "People", "My bedroom", etc.
//  unitEmoji  : String — emoji descriptivo
//  jsonAsset  : String — ruta al JSON de ejercicios
// ═══════════════════════════════════════════════════════════

class GrimoiroLibreScreen extends StatelessWidget {
  final int unitNumber;
  final String unitTitle;
  final String unitEmoji;
  final String jsonAsset;

  const GrimoiroLibreScreen({
    super.key,
    required this.unitNumber,
    required this.unitTitle,
    required this.unitEmoji,
    required this.jsonAsset,
  });

  // ── Paleta por unit (colores BABEL) ──────────────────────
  static const List<Color> _unitColors = [
    Color(0xFF0F766E), // 1 - teal
    Color(0xFF1E40AF), // 2 - navy
    Color(0xFF065F46), // 3 - forest
    Color(0xFFB45309), // 4 - amber
    Color(0xFF1E40AF), // 5 - navy
    Color(0xFF7C3AED), // 6 - violet ← current
    Color(0xFF0E7490), // 7 - cyan
    Color(0xFF15803D), // 8 - green
    Color(0xFFB91C1C), // 9 - red
  ];

  Color get _color => unitNumber >= 1 && unitNumber <= 9
      ? _unitColors[unitNumber - 1]
      : const Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(particleCount: 20, color: _color),
          SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white54),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '📖 GRIMOIRO LIBRE',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: ArcanaColors.textMuted,
                          letterSpacing: 2,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Title block ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(unitEmoji, style: const TextStyle(fontSize: 52)),
                      const SizedBox(height: 8),
                      Text(
                        'UNIT $unitNumber',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: _color,
                          letterSpacing: 4,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unitTitle.toUpperCase(),
                        style: ArcanaTextStyles.heroTitle.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── 3 Mode cards ─────────────────────────────
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _ModeCard(
                        emoji: '🔥',
                        title: 'Entrenamiento con Orión',
                        subtitle: 'Infinito · Flash cards · Racha',
                        color: const Color(0xFFF97316),
                        locked: false,
                        onTap: () {
                          // TODO: navigate to OrionTrainingScreen (Phase 3)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Próximamente: Entrenamiento con Orión 🔥'),
                              backgroundColor: Color(0xFF1E293B),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      _ModeCard(
                        emoji: '⚔️',
                        title: 'Combate Libre',
                        subtitle: 'Barra dual · Sin timer · Sin fin',
                        color: _color,
                        locked: false,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const EnglishBattleScreen(),
                          ));
                        },
                      ),
                      const SizedBox(height: 14),
                      _ModeCard(
                        emoji: '💀',
                        title: 'Duelo de Conocimiento',
                        subtitle: 'El Gran Oráculo te reta · 8 vs 10',
                        color: const Color(0xFFDC2626),
                        locked: false,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => OracleDuelScreen(
                              unitNumber: unitNumber,
                              unitTitle: unitTitle,
                              jsonAsset: jsonAsset,
                              accentColor: _color,
                            ),
                          ));
                        },
                      ),
                      const SizedBox(height: 32),

                      // Record banner
                      _RecordBanner(unitNumber: unitNumber),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Mode Card
// ══════════════════════════════════════════════
class _ModeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final bool locked;
  final VoidCallback onTap;

  const _ModeCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: locked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: locked ? Colors.white12 : color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: locked ? Colors.white38 : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: ArcanaTextStyles.caption.copyWith(
                      color: locked ? Colors.white24 : color.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              locked ? Icons.lock_outline : Icons.chevron_right,
              color: locked ? Colors.white24 : color,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Record Banner
// ══════════════════════════════════════════════
class _RecordBanner extends StatelessWidget {
  final int unitNumber;
  const _RecordBanner({required this.unitNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Mejor racha', value: '—', emoji: '🔥'),
          _StatItem(label: 'Duelos ganados', value: '—', emoji: '⚔️'),
          _StatItem(label: 'Récord Oráculo', value: '—', emoji: '💀'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  const _StatItem({required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: ArcanaTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: ArcanaTextStyles.caption.copyWith(
            color: Colors.white38,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
