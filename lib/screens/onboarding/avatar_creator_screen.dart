import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Creador de avatar por capas, estilo MumaBLUE
/// El niño construye su personaje combinando rasgos visuales
class AvatarCreatorScreen extends StatefulWidget {
  final Function(AvatarData) onComplete;

  const AvatarCreatorScreen({super.key, required this.onComplete});

  @override
  State<AvatarCreatorScreen> createState() => _AvatarCreatorScreenState();
}

class _AvatarCreatorScreenState extends State<AvatarCreatorScreen> {
  int _currentLayer = 0;
  
  // Selecciones del avatar
  int _skinTone = 2;
  int _hairStyle = 0;
  int _hairColor = 0;
  int _eyeColor = 0;
  int _glasses = 0;
  int _outfit = 0;
  int _accessory = 0;

  final _layers = [
    'Piel',
    'Pelo',
    'Color pelo',
    'Ojos',
    'Gafas',
    'Ropa',
    'Accesorio',
  ];

  // ═══════════════════════════════════════════
  // OPCIONES POR CAPA
  // ═══════════════════════════════════════════

  static const skinTones = [
    ('🏻', 'Claro', Color(0xFFFDE7C8)),
    ('🏼', 'Medio claro', Color(0xFFF5C99A)),
    ('🏽', 'Medio', Color(0xFFD4A76A)),
    ('🏾', 'Medio oscuro', Color(0xFFAA7B4A)),
    ('🏿', 'Oscuro', Color(0xFF6D4C2B)),
    ('🫶', 'Profundo', Color(0xFF4A3520)),
  ];

  static const hairStyles = [
    ('💇‍♂️', 'Corto'),
    ('💇‍♀️', 'Largo liso'),
    ('👩‍🦱', 'Rizado'),
    ('👨‍🦰', 'Ondulado'),
    ('🧑‍🦲', 'Rapado'),
    ('👩‍🦳', 'Trenzas'),
    ('🧑', 'Flequillo'),
    ('💁', 'Melena'),
    ('🙇', 'Moño'),
    ('💆', 'Afro'),
    ('🧜', 'Liso largo'),
    ('🫅', 'Cresta'),
  ];

  static const hairColors = [
    ('⬛', 'Negro', Color(0xFF1A1A1A)),
    ('🟤', 'Castaño', Color(0xFF6B3D2E)),
    ('🟡', 'Rubio', Color(0xFFDEB86C)),
    ('🔴', 'Pelirrojo', Color(0xFFC84B31)),
    ('🟠', 'Cobrizo', Color(0xFFD4752E)),
    ('⬜', 'Platino', Color(0xFFE8E0D4)),
    ('🔵', 'Azul ✨', Color(0xFF6366F1)),
    ('🟣', 'Morado ✨', Color(0xFF9333EA)),
  ];

  static const eyeColors = [
    ('🟤', 'Marrón', Color(0xFF6B3D2E)),
    ('🔵', 'Azul', Color(0xFF3B82F6)),
    ('🟢', 'Verde', Color(0xFF22C55E)),
    ('⬛', 'Negro', Color(0xFF1A1A1A)),
    ('🟡', 'Miel', Color(0xFFD4A020)),
  ];

  static const glassesOptions = [
    ('❌', 'Sin gafas'),
    ('👓', 'Redondas'),
    ('🕶️', 'Solares'),
    ('🥽', 'Explorador'),
    ('🤓', 'Cuadradas'),
  ];

  static const outfits = [
    ('👕', 'Camiseta'),
    ('🧥', 'Chaqueta'),
    ('👗', 'Vestido'),
    ('🦸', 'Héroe'),
    ('🧙', 'Mago'),
    ('🥷', 'Ninja'),
    ('🏴‍☠️', 'Pirata'),
    ('🧑‍🚀', 'Astronauta'),
    ('⚔️', 'Guerrero'),
    ('🧝', 'Elfo'),
  ];

  static const accessories = [
    ('❌', 'Ninguno'),
    ('🧢', 'Gorra'),
    ('🎀', 'Lazo'),
    ('👑', 'Corona'),
    ('🎧', 'Auriculares'),
    ('⚡', 'Rayo'),
    ('🌟', 'Estrella'),
    ('🔥', 'Llama'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso por capas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(_layers.length, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: i <= _currentLayer
                            ? AppColors.primary
                            : AppColors.borderLight,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Título de la capa actual
            Text(
              _layers[_currentLayer],
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 8),

            // ── PREVIEW DEL AVATAR ──
            Expanded(
              flex: 2,
              child: Center(
                child: _AvatarPreview(
                  skinTone: skinTones[_skinTone].$3,
                  hairEmoji: hairStyles[_hairStyle].$1,
                  hairColor: hairColors[_hairColor].$3,
                  eyeColor: eyeColors[_eyeColor].$3,
                  glassesEmoji: glassesOptions[_glasses].$1,
                  outfitEmoji: outfits[_outfit].$1,
                  accessoryEmoji: accessories[_accessory].$1,
                ),
              ),
            ),

            // ── SELECTOR DE OPCIONES ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Opciones
                  SizedBox(
                    height: 80,
                    child: _buildLayerOptions(),
                  ),

                  const SizedBox(height: 16),

                  // Botones nav
                  Row(
                    children: [
                      if (_currentLayer > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentLayer--),
                            child: const Text('← Anterior'),
                          ),
                        ),
                      if (_currentLayer > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentLayer < _layers.length - 1
                              ? () => setState(() => _currentLayer++)
                              : () => _finish(),
                          child: Text(
                            _currentLayer < _layers.length - 1
                                ? 'Siguiente →'
                                : '¡Listo! ✨',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerOptions() {
    switch (_currentLayer) {
      case 0:
        return _buildColorGrid(
          skinTones.map((e) => e.$3).toList(),
          _skinTone,
          (i) => setState(() => _skinTone = i),
          isCircle: true,
        );
      case 1:
        return _buildEmojiGrid(
          hairStyles.map((e) => (e.$1, e.$2)).toList(),
          _hairStyle,
          (i) => setState(() => _hairStyle = i),
        );
      case 2:
        return _buildColorGrid(
          hairColors.map((e) => e.$3).toList(),
          _hairColor,
          (i) => setState(() => _hairColor = i),
          isCircle: true,
          labels: hairColors.map((e) => e.$1).toList(),
        );
      case 3:
        return _buildColorGrid(
          eyeColors.map((e) => e.$3).toList(),
          _eyeColor,
          (i) => setState(() => _eyeColor = i),
          isCircle: true,
        );
      case 4:
        return _buildEmojiGrid(
          glassesOptions.map((e) => (e.$1, e.$2)).toList(),
          _glasses,
          (i) => setState(() => _glasses = i),
        );
      case 5:
        return _buildEmojiGrid(
          outfits.map((e) => (e.$1, e.$2)).toList(),
          _outfit,
          (i) => setState(() => _outfit = i),
        );
      case 6:
        return _buildEmojiGrid(
          accessories.map((e) => (e.$1, e.$2)).toList(),
          _accessory,
          (i) => setState(() => _accessory = i),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildColorGrid(
    List<Color> colors,
    int selected,
    ValueChanged<int> onSelect, {
    bool isCircle = false,
    List<String>? labels,
  }) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: colors.length,
      itemBuilder: (context, i) {
        final isSelected = i == selected;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: colors[i],
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircle ? null : BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: labels != null
                ? Center(
                    child: Text(labels[i],
                        style: const TextStyle(fontSize: 20)))
                : null,
          ),
        );
      },
    );
  }

  Widget _buildEmojiGrid(
    List<(String, String)> items,
    int selected,
    ValueChanged<int> onSelect,
  ) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, i) {
        final isSelected = i == selected;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: Container(
            width: 64,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(items[i].$1, style: const TextStyle(fontSize: 28)),
                if (isSelected)
                  Text(
                    items[i].$2,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _finish() {
    final avatar = AvatarData(
      skinTone: skinTones[_skinTone].$2,
      skinColor: skinTones[_skinTone].$3,
      hairStyle: hairStyles[_hairStyle].$2,
      hairColor: hairColors[_hairColor].$2,
      eyeColor: eyeColors[_eyeColor].$2,
      glasses: glassesOptions[_glasses].$2,
      outfit: outfits[_outfit].$2,
      accessory: accessories[_accessory].$2,
      previewEmojis: _buildPreviewString(),
    );
    widget.onComplete(avatar);
  }

  String _buildPreviewString() {
    final parts = <String>[];
    if (accessories[_accessory].$1 != '❌') {
      parts.add(accessories[_accessory].$1);
    }
    parts.add(hairStyles[_hairStyle].$1);
    if (glassesOptions[_glasses].$1 != '❌') {
      parts.add(glassesOptions[_glasses].$1);
    }
    parts.add(outfits[_outfit].$1);
    return parts.join('');
  }
}

// ═══════════════════════════════════════════
// PREVIEW DEL AVATAR
// ═══════════════════════════════════════════

class _AvatarPreview extends StatelessWidget {
  final Color skinTone;
  final String hairEmoji;
  final Color hairColor;
  final Color eyeColor;
  final String glassesEmoji;
  final String outfitEmoji;
  final String accessoryEmoji;

  const _AvatarPreview({
    required this.skinTone,
    required this.hairEmoji,
    required this.hairColor,
    required this.eyeColor,
    required this.glassesEmoji,
    required this.outfitEmoji,
    required this.accessoryEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Título
        const Text(
          'Tu aventurero',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Avatar compuesto
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base: tono de piel
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: skinTone,
                  shape: BoxShape.circle,
                ),
              ),

              // Pelo
              Positioned(
                top: 10,
                child: Text(hairEmoji, style: const TextStyle(fontSize: 48)),
              ),

              // Ojos
              Positioned(
                top: 55,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Eye(color: eyeColor),
                    const SizedBox(width: 16),
                    _Eye(color: eyeColor),
                  ],
                ),
              ),

              // Gafas
              if (glassesEmoji != '❌')
                Positioned(
                  top: 50,
                  child: Text(glassesEmoji,
                      style: const TextStyle(fontSize: 32)),
                ),

              // Ropa
              Positioned(
                bottom: 8,
                child: Text(outfitEmoji, style: const TextStyle(fontSize: 36)),
              ),

              // Accesorio
              if (accessoryEmoji != '❌')
                Positioned(
                  top: 2,
                  right: 15,
                  child: Text(accessoryEmoji,
                      style: const TextStyle(fontSize: 24)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Descripción textual (para la IA)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _buildDescription(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _buildDescription() {
    final parts = <String>[];
    parts.add('Pelo ${hairEmoji.trim()}');
    if (glassesEmoji != '❌') parts.add('con $glassesEmoji');
    parts.add('viste $outfitEmoji');
    if (accessoryEmoji != '❌') parts.add('lleva $accessoryEmoji');
    return parts.join(' • ');
  }
}

class _Eye extends StatelessWidget {
  final Color color;
  const _Eye({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// MODELO DE DATOS DEL AVATAR
// ═══════════════════════════════════════════

class AvatarData {
  final String skinTone;
  final Color skinColor;
  final String hairStyle;
  final String hairColor;
  final String eyeColor;
  final String glasses;
  final String outfit;
  final String accessory;
  final String previewEmojis;

  const AvatarData({
    required this.skinTone,
    required this.skinColor,
    required this.hairStyle,
    required this.hairColor,
    required this.eyeColor,
    required this.glasses,
    required this.outfit,
    required this.accessory,
    required this.previewEmojis,
  });

  /// Descripción textual para el prompt de la IA
  String toNarrativeDescription() {
    final parts = <String>[];
    parts.add('piel $skinTone');
    parts.add('pelo $hairStyle $hairColor');
    parts.add('ojos $eyeColor');
    if (glasses != 'Sin gafas') parts.add('gafas $glasses');
    parts.add('vestimenta: $outfit');
    if (accessory != 'Ninguno') parts.add('accesorio: $accessory');
    return parts.join(', ');
  }
}
