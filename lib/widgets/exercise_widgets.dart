import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

// ═══════════════════════════════════════════
// WIDGET: ORDENACIÓN (SORT) — Drag & Drop
// ═══════════════════════════════════════════

/// Widget interactivo para ejercicios de tipo "sort" (ordenar).
/// El usuario arrastra las fichas para reordenarlas.
class SortExerciseWidget extends StatefulWidget {
  final Exercise exercise;
  final bool answered;
  final ValueChanged<bool> onAnswer;

  const SortExerciseWidget({
    super.key,
    required this.exercise,
    required this.answered,
    required this.onAnswer,
  });

  @override
  State<SortExerciseWidget> createState() => _SortExerciseWidgetState();
}

class _SortExerciseWidgetState extends State<SortExerciseWidget> {
  late List<String> _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = List.from(widget.exercise.sortItems ?? widget.exercise.options);
  }

  @override
  void didUpdateWidget(SortExerciseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _currentOrder = List.from(widget.exercise.sortItems ?? widget.exercise.options);
    }
  }

  bool _checkAnswer() {
    final correctOrder = widget.exercise.sortAnswer ??
        widget.exercise.correctAnswer.split(', ');
    if (_currentOrder.length != correctOrder.length) return false;
    for (int i = 0; i < _currentOrder.length; i++) {
      if (_currentOrder[i].trim() != correctOrder[i].trim()) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instrucciones
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Text('☝️', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'Mantén pulsado y arrastra para ordenar',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Lista reordenable
        if (!widget.answered)
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _currentOrder.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _currentOrder.removeAt(oldIndex);
                _currentOrder.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) => _buildSortTile(index),
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) => Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                  child: child,
                ),
                child: child,
              );
            },
          )
        else
          ..._currentOrder.asMap().entries.map(
            (entry) => _buildResultTile(entry.key, entry.value),
          ),

        const SizedBox(height: 16),

        // Botón comprobar
        if (!widget.answered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final correct = _checkAnswer();
                widget.onAnswer(correct);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '🔍 Comprobar orden',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSortTile(int index) {
    return Container(
      key: ValueKey(_currentOrder[index]),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _currentOrder[index],
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.drag_handle, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildResultTile(int index, String value) {
    final correctOrder = widget.exercise.sortAnswer ??
        widget.exercise.correctAnswer.split(', ');
    final isCorrect =
        index < correctOrder.length && value.trim() == correctOrder[index].trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.lives.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.lives,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isCorrect ? AppColors.success : AppColors.lives,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              isCorrect ? '✓' : '${index + 1}',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            isCorrect ? '✅' : '❌',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// WIDGET: EMPAREJAMIENTO (MATCH) — Tap to Connect
// ═══════════════════════════════════════════

/// Widget interactivo para ejercicios de tipo "match" (unir pares).
/// El usuario selecciona un elemento de cada columna para formar pares.
class MatchExerciseWidget extends StatefulWidget {
  final Exercise exercise;
  final bool answered;
  final ValueChanged<bool> onAnswer;

  const MatchExerciseWidget({
    super.key,
    required this.exercise,
    required this.answered,
    required this.onAnswer,
  });

  @override
  State<MatchExerciseWidget> createState() => _MatchExerciseWidgetState();
}

class _MatchExerciseWidgetState extends State<MatchExerciseWidget> {
  // Pares correctos del ejercicio [[clave, valor], ...]
  late List<List<String>> _correctPairs;
  // Columna izquierda (claves) y derecha (valores) barajadas
  late List<String> _leftItems;
  late List<String> _rightItems;
  // Pares seleccionados por el usuario: {izquierda: derecha}
  final Map<String, String> _userPairs = {};
  // Selección actual (izquierda seleccionada esperando derecha)
  String? _selectedLeft;

  // Colores para pares emparejados
  static const _pairColors = [
    Color(0xFF6D28D9), // Violeta
    Color(0xFF0EA5E9), // Azul
    Color(0xFFF59E0B), // Ámbar
    Color(0xFF10B981), // Esmeralda
    Color(0xFFF43F5E), // Rosa
    Color(0xFF8B5CF6), // Púrpura
  ];

  @override
  void initState() {
    super.initState();
    _initPairs();
  }

  @override
  void didUpdateWidget(MatchExerciseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _userPairs.clear();
      _selectedLeft = null;
      _initPairs();
    }
  }

  void _initPairs() {
    _correctPairs = widget.exercise.pairs ?? [];
    _leftItems = _correctPairs.map((p) => p[0]).toList()..shuffle();
    _rightItems = _correctPairs.map((p) => p[1]).toList()..shuffle();
  }

  bool _checkAnswer() {
    if (_userPairs.length != _correctPairs.length) return false;
    for (final pair in _correctPairs) {
      if (_userPairs[pair[0]] != pair[1]) return false;
    }
    return true;
  }

  void _selectLeft(String item) {
    setState(() {
      _selectedLeft = item;
    });
  }

  void _selectRight(String item) {
    if (_selectedLeft == null) return;
    setState(() {
      // Si el item derecho ya está emparejado, desemparejar
      _userPairs.removeWhere((k, v) => v == item);
      // Emparejar
      _userPairs[_selectedLeft!] = item;
      _selectedLeft = null;
    });
  }

  int _getPairIndex(String leftItem) {
    final paired = _userPairs.entries.toList();
    for (int i = 0; i < paired.length; i++) {
      if (paired[i].key == leftItem) return i;
    }
    return -1;
  }

  int _getPairIndexRight(String rightItem) {
    final paired = _userPairs.entries.toList();
    for (int i = 0; i < paired.length; i++) {
      if (paired[i].value == rightItem) return i;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instrucciones
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Text('🔗', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Toca un elemento de cada columna para unirlos',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Columnas de emparejamiento
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda (claves)
            Expanded(
              child: Column(
                children: _leftItems.map((item) {
                  final isPaired = _userPairs.containsKey(item);
                  final isSelected = _selectedLeft == item;
                  final pairIdx = _getPairIndex(item);
                  final color = isPaired && pairIdx >= 0
                      ? _pairColors[pairIdx % _pairColors.length]
                      : null;

                  return _buildMatchTile(
                    item,
                    isLeft: true,
                    isSelected: isSelected,
                    isPaired: isPaired,
                    pairColor: color,
                    onTap: widget.answered ? null : () => _selectLeft(item),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 12),
            // Columna derecha (valores)
            Expanded(
              child: Column(
                children: _rightItems.map((item) {
                  final isPaired = _userPairs.containsValue(item);
                  final pairIdx = _getPairIndexRight(item);
                  final color = isPaired && pairIdx >= 0
                      ? _pairColors[pairIdx % _pairColors.length]
                      : null;

                  return _buildMatchTile(
                    item,
                    isLeft: false,
                    isSelected: false,
                    isPaired: isPaired,
                    pairColor: color,
                    onTap: widget.answered ? null : () => _selectRight(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Botón comprobar
        if (!widget.answered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _userPairs.length == _correctPairs.length
                  ? () {
                      final correct = _checkAnswer();
                      widget.onAnswer(correct);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _userPairs.length == _correctPairs.length
                    ? '🔍 Comprobar'
                    : 'Une todos los pares (${_userPairs.length}/${_correctPairs.length})',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

        // Resultado (mostrar enlaces correctos/incorrectos)
        if (widget.answered) ...[
          const SizedBox(height: 12),
          ..._correctPairs.map((pair) {
            final userAnswer = _userPairs[pair[0]];
            final isCorrect = userAnswer == pair[1];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.lives.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorrect ? AppColors.success : AppColors.lives,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    isCorrect ? '✅' : '❌',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${pair[0]}  ↔  ${pair[1]}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildMatchTile(
    String text, {
    required bool isLeft,
    required bool isSelected,
    required bool isPaired,
    Color? pairColor,
    VoidCallback? onTap,
  }) {
    Color bgColor;
    Color borderColor;
    if (isPaired && pairColor != null) {
      bgColor = pairColor.withValues(alpha: 0.12);
      borderColor = pairColor;
    } else if (isSelected) {
      bgColor = AppColors.primary.withValues(alpha: 0.15);
      borderColor = AppColors.primary;
    } else {
      bgColor = AppColors.surfaceVariant;
      borderColor = AppColors.borderLight;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isPaired && pairColor != null
                  ? pairColor
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// AnimatedBuilder helper (proxy decorator)
// ═══════════════════════════════════════════

class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) => builder(context, child);
}
