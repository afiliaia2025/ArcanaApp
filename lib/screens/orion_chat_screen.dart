import 'package:flutter/material.dart';
import '../theme/arcana_colors.dart';
import '../theme/arcana_text_styles.dart';

/// Pantalla de chat con Orión (tutor IA).
/// Interfaz de chat con burbujas estilo mensajería,
/// sugerencias rápidas y campo de entrada.
class OrionChatScreen extends StatefulWidget {
  const OrionChatScreen({super.key});

  @override
  State<OrionChatScreen> createState() => _OrionChatScreenState();
}

class _OrionChatScreenState extends State<OrionChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: '¡Hola, aprendiz! 🦉✨ Soy Orión, tu guía mágico. Puedo ayudarte con cualquier duda sobre tus estudios.',
      isOrion: true,
    ),
    _ChatMessage(
      text: '¿En qué necesitas ayuda hoy?',
      isOrion: true,
    ),
  ];

  final List<String> _quickSuggestions = [
    '¿Cómo multiplico por 2 cifras?',
    'Explícame las fracciones',
    'Ayúdame con inglés',
    '¿Qué hago ahora?',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isOrion: false));
      _textController.clear();
    });

    _scrollToBottom();

    // Simular respuesta de Orión
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: '¡Buena pregunta! 🌟 Déjame pensar... (Aquí Orión conectará con la IA para darte una respuesta personalizada basada en tu progreso)',
          isOrion: true,
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcanaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Mensajes
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),

            // Sugerencias rápidas
            if (_messages.length <= 3) _buildQuickSuggestions(),

            // Campo de entrada
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ArcanaColors.surface.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: ArcanaColors.turquoise.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ArcanaColors.surfaceBorder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, color: ArcanaColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar de Orión
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ArcanaColors.turquoise.withValues(alpha: 0.15),
              border: Border.all(color: ArcanaColors.turquoise.withValues(alpha: 0.5)),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/characters/orion.png',
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => const Icon(
                  Icons.auto_awesome,
                  color: ArcanaColors.turquoise,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orión',
                style: ArcanaTextStyles.cardTitle.copyWith(
                  color: ArcanaColors.turquoise,
                ),
              ),
              Text(
                'Tu guía mágico 🦉',
                style: ArcanaTextStyles.caption.copyWith(
                  color: ArcanaColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            message.isOrion ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isOrion) ...[
            // Avatar pequeño de Orión
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ArcanaColors.turquoise.withValues(alpha: 0.15),
              ),
              child: const Center(
                child: Text('🦉', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isOrion
                    ? ArcanaColors.surface
                    : ArcanaColors.turquoise.withValues(alpha: 0.15),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isOrion ? 4 : 16),
                  bottomRight: Radius.circular(message.isOrion ? 16 : 4),
                ),
                border: Border.all(
                  color: message.isOrion
                      ? ArcanaColors.surfaceBorder
                      : ArcanaColors.turquoise.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                message.text,
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: ArcanaColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _quickSuggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _sendMessage(_quickSuggestions[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ArcanaColors.turquoise.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ArcanaColors.turquoise.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _quickSuggestions[index],
                  style: ArcanaTextStyles.caption.copyWith(
                    color: ArcanaColors.turquoise,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ArcanaColors.surface,
        border: Border(
          top: BorderSide(color: ArcanaColors.surfaceBorder),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: ArcanaColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ArcanaColors.surfaceBorder),
              ),
              child: TextField(
                controller: _textController,
                style: ArcanaTextStyles.bodyMedium.copyWith(
                  color: ArcanaColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Pregúntale a Orión...',
                  hintStyle: ArcanaTextStyles.bodyMedium.copyWith(
                    color: ArcanaColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(_textController.text),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    ArcanaColors.turquoise.withValues(alpha: 0.8),
                    ArcanaColors.turquoise,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ArcanaColors.turquoise.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isOrion;

  _ChatMessage({required this.text, required this.isOrion});
}
