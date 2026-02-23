import 'package:flutter/material.dart';
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';

class MultiplicacionAprenderScreen extends StatelessWidget {
  final int minTable;
  final int maxTable;

  const MultiplicacionAprenderScreen({
    super.key,
    required this.minTable,
    required this.maxTable,
  });

  @override
  Widget build(BuildContext context) {
    // Generar lista de tablas invertida o en orden. Mejor en orden.
    final tables = List.generate((maxTable - minTable) + 1, (index) => minTable + index);

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
          '📚 Zona de Aprender',
          style: ArcanaTextStyles.screenTitle.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: tables.length,
          itemBuilder: (context, index) {
            final currentTable = tables[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildTableCard(currentTable),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableCard(int table) {
    return Container(
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: const Color(0xFF60A5FA),
        title: Text(
          'Tabla del $table',
          style: ArcanaTextStyles.cardTitle.copyWith(color: const Color(0xFF60A5FA)),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: List.generate(11, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$table × $i',
                        style: ArcanaTextStyles.bodyMedium.copyWith(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '=',
                        style: ArcanaTextStyles.bodyMedium.copyWith(color: Colors.white54, fontSize: 18),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${table * i}',
                          style: ArcanaTextStyles.screenTitle.copyWith(color: const Color(0xFF34D399)),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
