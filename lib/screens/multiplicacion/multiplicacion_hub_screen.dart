import 'package:flutter/material.dart';
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';
import 'multiplicacion_aprender_screen.dart';
import 'multiplicacion_battle_screen.dart';

class MultiplicacionHubScreen extends StatefulWidget {
  const MultiplicacionHubScreen({super.key});

  @override
  State<MultiplicacionHubScreen> createState() => _MultiplicacionHubScreenState();
}

class _MultiplicacionHubScreenState extends State<MultiplicacionHubScreen> {
  int _minTable = 0;
  int _maxTable = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Dojo de Multiplicar',
          style: ArcanaTextStyles.screenTitle.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Selector de Rango
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ArcanaColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Rango de Tablas',
                      style: ArcanaTextStyles.cardTitle.copyWith(color: ArcanaColors.gold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¿Qué tablas quieres repasar hoy?',
                      style: ArcanaTextStyles.bodyMedium.copyWith(color: ArcanaColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTableSelector('Desde', _minTable, (val) {
                          setState(() {
                            if (val <= _maxTable) _minTable = val;
                          });
                        }),
                        const Text(' — ', style: TextStyle(color: Colors.white54, fontSize: 24)),
                        _buildTableSelector('Hasta', _maxTable, (val) {
                          setState(() {
                            if (val >= _minTable) _maxTable = val;
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 2. Modos de Juego
              Expanded(
                child: ListView(
                  children: [
                    _buildModeCard(
                      context,
                      title: '📚 1. Aprender',
                      description: 'Repasa las tablas a tu ritmo, sin presión.',
                      color: const Color(0xFF60A5FA),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MultiplicacionAprenderScreen(
                            minTable: _minTable, maxTable: _maxTable,
                          ),
                        ));
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModeCard(
                      context,
                      title: '🥊 2. Entrenar',
                      description: 'Pon a prueba tus reflejos contra elementales de fuego. ¡Con pistas y combos!',
                      color: const Color(0xFF34D399),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MultiplicacionBattleScreen(
                            isBoss: false,
                            minTable: _minTable, maxTable: _maxTable,
                          ),
                        ));
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModeCard(
                      context,
                      title: '👹 3. Examen (El Boss)',
                      description: '¡Derrota a Cristalia! Mezcla de tablas contra el reloj. Sin pistas.',
                      color: const Color(0xFFFF1744),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MultiplicacionBattleScreen(
                            isBoss: true,
                            minTable: _minTable, maxTable: _maxTable,
                          ),
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableSelector(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: ArcanaTextStyles.caption.copyWith(color: ArcanaColors.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.white54),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ArcanaColors.gold.withValues(alpha: 0.5)),
              ),
              child: Text(
                '$value',
                style: ArcanaTextStyles.heroTitle.copyWith(color: Colors.white, fontSize: 24),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white54),
              onPressed: value < 10 ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard(BuildContext context, {required String title, required String description, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ArcanaTextStyles.cardTitle.copyWith(color: color),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: ArcanaTextStyles.bodyMedium.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
