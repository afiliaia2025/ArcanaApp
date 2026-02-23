import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// BOSS FINAL IGNIS: "Noctus en la Torre"
/// Tema: TODO el año de mates (repaso general)
/// ═══════════════════════════════════════════════════════════════
final bossFinalIgnis = StoryChapter(
  id: 'ignis_boss_final',
  number: 16,
  title: 'Noctus en la Torre',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Boss Final: Repaso de todo el año',
  startNodeId: 'bf_intro',
  nodes: {
    'bf_intro': const StoryNode(
      id: 'bf_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⚡',
      text: 'Has subido hasta la cima de la Torre de Cristal. Arriba, '
          'entre rayos y nubes negras, Noctus te espera. La Gema Ignis '
          'brilla en su mano izquierda, prisionera.\n\n'
          '«¡Aprendiz! Has llegado lejos… para un niño. Pero los números '
          'me pertenecen. ¡TODO el conocimiento será MÍO!»\n\n'
          'Orión abre las alas: «¡No le escuches! ¡Tú sabes más de lo que '
          'crees! ¡Demuéstraselo!»',
      nextNode: 'bf_ex1',
    ),
    'bf_ex1': const StoryNode(
      id: 'bf_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'Noctus lanza un rayo negro. Dentro brilla un número: 847.\n\n'
          '«¡Dime su valor posicional o caerás!»',
      question: '¿Cuántas CENTENAS, DECENAS y UNIDADES tiene 847?',
      options: [
        '8 centenas, 4 decenas, 7 unidades',
        '7 centenas, 4 decenas, 8 unidades',
        '4 centenas, 8 decenas, 7 unidades',
        '84 centenas y 7 unidades',
      ],
      correctIndex: 0,
      hint: '847: el 8 = centenas, el 4 = decenas, el 7 = unidades.',
      onCorrect: 'bf_ok1',
      onIncorrect: 'bf_fail1',
    ),
    'bf_ok1': const StoryNode(
      id: 'bf_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡La Gema Ignis parpadea en la mano de Noctus! Tu respuesta '
          'correcta la debilita. Noctus gruñe: «¡Suerte!»\n\n'
          'Orión: «¡Sigue así!»',
      nextNode: 'bf_ex2',
    ),
    'bf_fail1': const StoryNode(
      id: 'bf_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«8 centenas, 4 decenas, 7 unidades. ¡C-D-U!»',
      nextNode: 'bf_ex2',
    ),
    'bf_ex2': const StoryNode(
      id: 'bf_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'Noctus golpea el suelo y una trampa se abre bajo tus pies. '
          'Para cerrarla necesitas multiplicar.',
      question: '¿Cuánto es 5 × 9?',
      options: ['40', '45', '50', '54'],
      correctIndex: 1,
      hint: 'Tabla del 5: 5,10,15,20,25,30,35,40,45.',
      onCorrect: 'bf_ok2',
      onIncorrect: 'bf_fail2',
    ),
    'bf_ok2': const StoryNode(
      id: 'bf_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡45! La trampa se cierra. Noctus retrocede un paso. La gema '
          'brilla con más fuerza: está intentando liberarse.',
      nextNode: 'bf_ex3',
    ),
    'bf_fail2': const StoryNode(
      id: 'bf_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«45. 5×9=45. ¡Tabla del 5!»',
      nextNode: 'bf_ex3',
    ),
    'bf_ex3': const StoryNode(
      id: 'bf_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Noctus lanza otro hechizo. Necesitas un contra-hechizo '
          'rápido: ¡una suma con llevada!',
      question: '¿Cuánto es 467 + 385?',
      options: ['842', '852', '862', '752'],
      correctIndex: 1,
      hint: '7+5=12 (llevas 1), 6+8+1=15 (llevas 1), 4+3+1=8. → 852.',
      onCorrect: 'bf_ok3',
      onIncorrect: 'bf_fail3',
    ),
    'bf_ok3': const StoryNode(
      id: 'bf_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡852! ¡El contra-hechizo impacta a Noctus! Su capa se '
          'agrieta como si fuera de cristal. La gema se sacude en su mano.',
      nextNode: 'bf_ex4',
    ),
    'bf_fail3': const StoryNode(
      id: 'bf_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«852. Doble llevada: 7+5=12, 6+8+1=15, 4+3+1=8.»',
      nextNode: 'bf_ex4',
    ),
    'bf_ex4': const StoryNode(
      id: 'bf_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'Noctus intenta comprar tu lealtad: «¡Te daré 100 monedas '
          'de oro si me dejas ir!» Pero tú sabes calcular bien.',
      question: 'Si un hechizo cuesta 35€ y pagas con un billete de 50€, '
          '¿cuánto te devuelven?',
      options: ['5€', '10€', '15€', '25€'],
      correctIndex: 2,
      hint: '50 - 35 = 15.',
      onCorrect: 'bf_ok4',
      onIncorrect: 'bf_fail4',
    ),
    'bf_ok4': const StoryNode(
      id: 'bf_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡15€! «¡No me engañarás, Noctus!» El mago oscuro pierde '
          'el equilibrio. La gema se desplaza hacia el borde de su mano.',
      nextNode: 'bf_ex5',
    ),
    'bf_fail4': const StoryNode(
      id: 'bf_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«15€. 50-35=15. ¡No caigas en sus trampas!»',
      nextNode: 'bf_ex5',
    ),
    'bf_ex5': const StoryNode(
      id: 'bf_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Noctus, desesperado, dibuja figuras en el aire como último '
          'intento de confundirte.',
      question: '¿Cuántos LADOS tiene un RECTÁNGULO?',
      options: ['3', '4', '5', '6'],
      correctIndex: 1,
      hint: 'Un rectángulo y un cuadrado tienen 4 lados.',
      onCorrect: 'bf_ok5',
      onIncorrect: 'bf_fail5',
    ),
    'bf_ok5': const StoryNode(
      id: 'bf_ok5',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡4! Las figuras explotan en destellos de luz. Noctus cae '
          'de rodillas. La gema SALE VOLANDO de su mano. ¡Dos pruebas más!',
      nextNode: 'bf_ex6',
    ),
    'bf_fail5': const StoryNode(
      id: 'bf_fail5',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«4 lados. Como un cuadrado pero con lados de distinto largo.»',
      nextNode: 'bf_ex6',
    ),
    'bf_ex6': const StoryNode(
      id: 'bf_ex6',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'Noctus proyecta un gráfico de barras en el aire:\n'
          '🟥🟥🟥🟥🟥🟥 Fuego = 6\n'
          '🟦🟦🟦🟦🟦🟦🟦🟦🟦 Agua = 9\n'
          '🟩🟩🟩 Tierra = 3\n\n'
          '«¿Puedes leer ESTO, aprendiz?»',
      question: '¿Cuántos hechizos de AGUA hay según el gráfico?',
      options: ['3', '6', '9', '18'],
      correctIndex: 2,
      hint: 'Cuenta los cuadraditos azules de la barra Agua.',
      onCorrect: 'bf_ok6',
      onIncorrect: 'bf_fail6',
    ),
    'bf_ok6': const StoryNode(
      id: 'bf_ok6',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡9! El gráfico estalla en chispas. Noctus está de rodillas, '
          'derrotado. Solo queda una última pregunta.',
      nextNode: 'bf_ex7',
    ),
    'bf_fail6': const StoryNode(
      id: 'bf_fail6',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«9 hechizos de agua. Lee la barra azul.»',
      nextNode: 'bf_ex7',
    ),
    'bf_ex7': const StoryNode(
      id: 'bf_ex7',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'LA PREGUNTA FINAL. Noctus, con voz rota, susurra:\n'
          '«Si eres tan listo… ¿cuál es la MITAD de 100?»',
      question: '¿Cuál es la MITAD de 100?',
      options: ['25', '40', '50', '75'],
      correctIndex: 2,
      hint: '100 ÷ 2 = 50.',
      onCorrect: 'bf_victoria',
      onIncorrect: 'bf_fail_final',
    ),
    'bf_victoria': const StoryNode(
      id: 'bf_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '«¡¡¡CINCUENTA!!!»\n\n'
          '¡¡¡BOOOOOOOM!!! Una explosión de LUZ AZUL inunda la cima de '
          'la Torre. Noctus se cubre los ojos. Su capa se deshace '
          'como cenizas.\n\n'
          'La Gema Ignis brilla con una intensidad cegadora. Los tres '
          'fragmentos se unen en el aire, girando, fusionándose… ¡LA GEMA '
          'IGNIS ESTÁ COMPLETA!\n\n'
          'La gema vuela hacia ti y se posa en tus manos. Sientes el '
          'poder de todos los números que has aprendido durante el año '
          'fluyendo a través de ella.\n\n'
          'Noctus HUYE entre las sombras, derrotado: «¡Volveré, aprendiz! '
          '¡Aún quedan más gemas!»\n\n'
          'Orión llora de alegría (dice que es el viento): «¡Lo has '
          'conseguido! ¡La Gema de los Números es nuestra! La Torre de '
          'Cristal vuelve a brillar.»',
      nextNode: 'bf_ending',
    ),
    'bf_fail_final': const StoryNode(
      id: 'bf_fail_final',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡50! La mitad de 100 es 50.»\n\n'
          'La luz explota igualmente. ¡Noctus está derrotado!',
      nextNode: 'bf_victoria',
    ),
    'bf_ending': const StoryNode(
      id: 'bf_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡¡¡BOSS FINAL DERROTADO!!!\n\n'
          'Has usado TODO lo aprendido en matemáticas para vencer '
          'a Noctus y recuperar la Gema Ignis:\n\n'
          '• Valor posicional • Multiplicación\n'
          '• Sumas con llevada • Monedas y billetes\n'
          '• Geometría • Gráficos de barras\n'
          '• Dobles y mitades\n\n'
          '🔥 Recompensa: GEMA IGNIS COMPLETA · +500 XP\n\n'
          '¿Preparado para las siguientes gemas? La aventura continúa…',
    ),
  },
);
