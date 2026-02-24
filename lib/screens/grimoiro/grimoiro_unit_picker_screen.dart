import 'package:flutter/material.dart';
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';
import '../../widgets/magical_particles.dart';
import 'grimoiro_libre_screen.dart';

// ═══════════════════════════════════════════════════════════
// GRIMOIRO UNIT PICKER
// ═══════════════════════════════════════════════════════════
//
// Muestra todas las unidades del Super Minds 2 como cards
// seleccionables. Al elegir una unidad, abre GrimoiroLibreScreen
// con los datos correctos.
// ═══════════════════════════════════════════════════════════

class _UnitData {
  final int number;
  final String title;
  final String emoji;
  final String subtitle; // grammar/vocab summary
  final String jsonAsset;
  final Color color;

  const _UnitData({
    required this.number,
    required this.title,
    required this.emoji,
    required this.subtitle,
    required this.jsonAsset,
    required this.color,
  });
}

const List<_UnitData> _allUnits = [
  _UnitData(
    number: 0,
    title: 'Back to School',
    emoji: '📚',
    subtitle: 'Classroom objects · Imperatives · a/an/some',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit0.json',
    color: Color(0xFF0F766E),
  ),
  _UnitData(
    number: 1,
    title: 'Daily Routines',
    emoji: '⏰',
    subtitle: '3rd person -s · Telling the time',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit1.json',
    color: Color(0xFF1E40AF),
  ),
  _UnitData(
    number: 2,
    title: 'Animals',
    emoji: '🐾',
    subtitle: 'Like/doesn\'t like · Questions',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit2.json',
    color: Color(0xFF065F46),
  ),
  _UnitData(
    number: 3,
    title: 'Our House',
    emoji: '🏠',
    subtitle: 'Places · Has got · Prepositions',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit3.json',
    color: Color(0xFFB45309),
  ),
  _UnitData(
    number: 4,
    title: 'Shopping',
    emoji: '🛍️',
    subtitle: 'Food vocab · Would you like · some/any',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit4.json',
    color: Color(0xFFDC2626),
  ),
  _UnitData(
    number: 5,
    title: 'My Bedroom',
    emoji: '🛏️',
    subtitle: 'There is/are · This/That · Whose',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit5.json',
    color: Color(0xFF1E40AF),
  ),
  _UnitData(
    number: 6,
    title: 'People',
    emoji: '🌙',
    subtitle: 'Months · Face · Am/Is/Are · Our/Their',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit6.json',
    color: Color(0xFF7C3AED),
  ),
  _UnitData(
    number: 7,
    title: 'Transport',
    emoji: '🚂',
    subtitle: 'I\'d like to · Verb -ing · Transport vocab',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit7.json',
    color: Color(0xFF0E7490),
  ),
  _UnitData(
    number: 8,
    title: 'Sport',
    emoji: '🏆',
    subtitle: 'Present continuous · Sports vocab',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit8.json',
    color: Color(0xFF15803D),
  ),
  _UnitData(
    number: 9,
    title: 'Holidays',
    emoji: '🌍',
    subtitle: 'Can/can\'t · Going to · Holidays vocab',
    jsonAsset: 'assets/curriculum/2_primaria/english_unit9.json',
    color: Color(0xFFB91C1C),
  ),
];

// ══════════════════════════════════════════════════════════
// Widget
// ══════════════════════════════════════════════════════════
class GrimoiroUnitPickerScreen extends StatelessWidget {
  const GrimoiroUnitPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0510),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MagicalParticles(
            particleCount: 20,
            color: const Color(0xFF7C3AED),
            maxSize: 2,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white54, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📖 GRIMOIRO LIBRE',
                            style: ArcanaTextStyles.caption.copyWith(
                              color: ArcanaColors.textMuted,
                              letterSpacing: 2,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Elige una unidad',
                            style: ArcanaTextStyles.cardTitle.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Orión banner ──────────────────────────
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '🧙 Orión: "Elige la unidad que quieres practicar. Puedes volver aquí en cualquier momento."',
                    style: ArcanaTextStyles.caption.copyWith(
                      color: ArcanaColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),

                // ── Unit list ─────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _allUnits.length,
                    itemBuilder: (context, i) {
                      final unit = _allUnits[i];
                      return _UnitCard(
                        unit: unit,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GrimoiroLibreScreen(
                              unitNumber: unit.number,
                              unitTitle: unit.title,
                              unitEmoji: unit.emoji,
                              jsonAsset: unit.jsonAsset,
                            ),
                          ),
                        ),
                      );
                    },
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
// Unit Card
// ══════════════════════════════════════════════
class _UnitCard extends StatelessWidget {
  final _UnitData unit;
  final VoidCallback onTap;

  const _UnitCard({required this.unit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Highlight unit 6 (Pablo's current unit)
    final isCurrent = unit.number == 6;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: unit.color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent
                ? unit.color.withValues(alpha: 0.8)
                : unit.color.withValues(alpha: 0.3),
            width: isCurrent ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Emoji badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: unit.color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
                border: Border.all(
                    color: unit.color.withValues(alpha: 0.35)),
              ),
              child: Center(
                child: Text(unit.emoji,
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Unit ${unit.number}',
                        style: ArcanaTextStyles.caption.copyWith(
                          color: unit.color,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: ArcanaColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: ArcanaColors.gold.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            '→ Ahora',
                            style: ArcanaTextStyles.caption.copyWith(
                              color: ArcanaColors.gold,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unit.title,
                    style: ArcanaTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unit.subtitle,
                    style: ArcanaTextStyles.caption.copyWith(
                      color: unit.color.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: unit.color.withValues(alpha: 0.6), size: 20),
          ],
        ),
      ),
    );
  }
}
