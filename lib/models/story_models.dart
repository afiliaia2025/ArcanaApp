/// Modelos de datos para el motor de historia interactiva.
/// Cada capítulo es un grafo de nodos (viñetas + ejercicios)
/// conectados por decisiones del jugador.
library;

/// Un nodo en la historia — puede ser narrativa, ejercicio o decisión.
enum StoryNodeType { narrative, exercise, decision, ending }

/// Un único nodo de la historia.
class StoryNode {
  final String id;
  final StoryNodeType type;

  // Narrativa
  final String? text;
  final String? speaker;     // 'narrator', 'orion', 'noctus', nombre del NPC
  final String? emoji;       // Icono del hablante

  // Ejercicio
  final String? question;
  final List<String>? options;
  final int? correctIndex;
  final String? hint;

  // Decisión (elige tu aventura)
  final String? choiceA;
  final String? choiceB;

  // Navegación — a qué nodo va según el resultado
  final String? nextNode;         // Siguiente por defecto
  final String? onCorrect;        // Si acierta el ejercicio
  final String? onIncorrect;      // Si falla (ruta alternativa)
  final String? onChoiceA;        // Si elige opción A
  final String? onChoiceB;        // Si elige opción B

  // Visual
  final String? backgroundGradient; // 'tower', 'forest', 'cave', etc.

  const StoryNode({
    required this.id,
    required this.type,
    this.text,
    this.speaker,
    this.emoji,
    this.question,
    this.options,
    this.correctIndex,
    this.hint,
    this.choiceA,
    this.choiceB,
    this.nextNode,
    this.onCorrect,
    this.onIncorrect,
    this.onChoiceA,
    this.onChoiceB,
    this.backgroundGradient,
  });
}

/// Un capítulo completo con su grafo de nodos.
class StoryChapter {
  final String id;
  final int number;
  final String title;
  final String gemName;
  final String subject;
  final String topic;
  final String startNodeId;
  final Map<String, StoryNode> nodes;

  const StoryChapter({
    required this.id,
    required this.number,
    required this.title,
    required this.gemName,
    required this.subject,
    required this.topic,
    required this.startNodeId,
    required this.nodes,
  });
}
