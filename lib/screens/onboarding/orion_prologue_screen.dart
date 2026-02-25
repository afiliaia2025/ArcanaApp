import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/arcana_colors.dart';
import '../../theme/arcana_text_styles.dart';
import '../../widgets/magical_particles.dart';
import '../title_screen.dart';

/// Pantalla de prólogo — Orión presenta la misión al jugador.
/// Layout 2 columnas: Izq = Orión hablando, Der = ilustración.
class OrionPrologueScreen extends StatefulWidget {
  final String playerName;

  const OrionPrologueScreen({super.key, required this.playerName});

  @override
  State<OrionPrologueScreen> createState() => _OrionPrologueScreenState();
}

class _OrionPrologueScreenState extends State<OrionPrologueScreen>
    with SingleTickerProviderStateMixin {
  int _currentDialogue = 0;
  late AnimationController _fadeCtrl;

  late final List<_DialogueLine> _dialogues;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _dialogues = [
      _DialogueLine(
        speaker: '🦉 Orión',
        text: '¡${widget.playerName}! Al fin te encuentro...\n\n'
            'Soy Orión, el búho guardián del Saber Antiguo. '
            'He viajado a través de las estrellas buscando a alguien con tu potencial.',
        emoji: '🦉',
        illustration: '🌟',
      ),
      _DialogueLine(
        speaker: '🦉 Orión',
        text: 'El mundo de Arcana está en peligro. Las 7 Gemas del Saber han sido corrompidas '
            'por la Sombra del Olvido. Solo un verdadero aprendiz puede restaurarlas.',
        emoji: '🦉',
        illustration: '💎',
      ),
      _DialogueLine(
        speaker: '🦉 Orión',
        text: 'Cada gema guardaba el conocimiento de una materia:\n\n'
            '🔴 Ignis — Matemáticas\n'
            '🔵 Babel — Inglés\n'
            '🟢 Terra — Ciencias\n'
            '🟡 Lux — Lengua\n'
            '🟣 Mystica — Historia\n'
            '⚪ Aether — Arte\n'
            '🟠 Chrono — Tecnología',
        emoji: '🦉',
        illustration: '🗺️',
      ),
      _DialogueLine(
        speaker: '🦉 Orión',
        text: 'Para restaurar cada gema, deberás superar pruebas de conocimiento, '
            'derrotar a los guardianes corruptos y demostrar que mereces su poder.\n\n'
            '¿Estás listo para la aventura, ${widget.playerName}?',
        emoji: '🦉',
        illustration: '⚔️',
      ),
    ];
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _nextDialogue() {
    if (_currentDialogue < _dialogues.length - 1) {
      _fadeCtrl.forward(from: 0);
      setState(() => _currentDialogue++);
    } else {
      _finishPrologue();
    }
  }

  Future<void> _finishPrologue() async {
    // Marcar onboarding como completado
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, b) => const TitleScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogue = _dialogues[_currentDialogue];
    final isLast = _currentDialogue == _dialogues.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF050310),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A0820), Color(0xFF150A30), Color(0xFF050310)],
              ),
            ),
          ),

          // Partículas
          const MagicalParticles(particleCount: 30, color: ArcanaColors.turquoise, maxSize: 2),

          // Contenido
          SafeArea(
            child: Column(
              children: [
                // Header con progreso
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      const Text('🦉', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(
                        'Prólogo',
                        style: ArcanaTextStyles.cardTitle.copyWith(color: ArcanaColors.turquoise),
                      ),
                      const Spacer(),
                      // Progreso
                      ...List.generate(_dialogues.length, (i) => Container(
                        width: 8, height: 8,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i <= _currentDialogue
                              ? ArcanaColors.turquoise
                              : ArcanaColors.surfaceBorder,
                        ),
                      )),
                    ],
                  ),
                ),

                // 2 columnas
                Expanded(
                  child: FadeTransition(
                    opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── COL IZQ: Orión habla ──
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8, bottom: 8),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: ArcanaColors.surface.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: ArcanaColors.turquoise.withValues(alpha: 0.2)),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Speaker badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: ArcanaColors.turquoise.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        dialogue.speaker,
                                        style: ArcanaTextStyles.caption.copyWith(
                                          color: ArcanaColors.turquoise,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Texto
                                    Text(
                                      dialogue.text,
                                      style: ArcanaTextStyles.bodyMedium.copyWith(
                                        color: ArcanaColors.textPrimary,
                                        height: 1.7,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ── COL DER: Ilustración ──
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: ArcanaColors.turquoise.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: ArcanaColors.turquoise.withValues(alpha: 0.12)),
                              ),
                              child: Center(
                                child: Text(
                                  dialogue.illustration,
                                  style: const TextStyle(fontSize: 80),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Botón continuar
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 4, 32, 16),
                  child: GestureDetector(
                    onTap: _nextDialogue,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: isLast
                            ? ArcanaColors.goldGradient
                            : LinearGradient(
                                colors: [
                                  ArcanaColors.turquoise.withValues(alpha: 0.8),
                                  ArcanaColors.turquoise,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: (isLast ? ArcanaColors.gold : ArcanaColors.turquoise)
                                .withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        isLast ? '⚔️ ¡EMPEZAR LA AVENTURA!' : 'Continuar →',
                        style: ArcanaTextStyles.cardTitle.copyWith(
                          color: isLast ? const Color(0xFF1A1130) : Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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

class _DialogueLine {
  final String speaker;
  final String text;
  final String emoji;
  final String illustration;

  const _DialogueLine({
    required this.speaker,
    required this.text,
    required this.emoji,
    required this.illustration,
  });
}
