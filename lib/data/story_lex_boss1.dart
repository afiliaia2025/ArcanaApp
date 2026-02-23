import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// BOSS 1 LEXIS: "El Letrón"
/// Tema: Repaso U1-U5 (abecedario, sílabas, sustantivos, ortografía, adjetivos)
/// ═══════════════════════════════════════════════════════════════
final boss1Lexis = StoryChapter(
  id: 'lexis_boss1',
  number: 6,
  title: 'El Letrón',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Boss: Repaso U1-U5',
  startNodeId: 'lb1_intro',
  nodes: {
    'lb1_intro': const StoryNode(
      id: 'lb1_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🤖',
      text: 'A la salida del pueblo, un monstruo de papel y tinta te '
          'bloquea el camino. Es el LETRÓN: un golem hecho de páginas '
          'arrugadas y letras rotas. Tiene dos ojos de tinta roja.\n\n'
          '«NADIE PASA SIN RESOLVER MIS ACERTIJOS», ruge con voz de '
          'papel rasgado.\n\n'
          'Orión: «Es el primer boss de Lexis. ¡Usa todo lo que has '
          'aprendido de Lengua!»',
      nextNode: 'lb1_ex1',
    ),
    'lb1_ex1': const StoryNode(
      id: 'lb1_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'El Letrón lanza una ráfaga de letras.',
      question: 'Ordena alfabéticamente: zapato, mesa, árbol',
      options: [
        'zapato, mesa, árbol',
        'mesa, árbol, zapato',
        'árbol, mesa, zapato',
        'árbol, zapato, mesa',
      ],
      correctIndex: 2,
      hint: 'A antes que M, M antes que Z.',
      onCorrect: 'lb1_ok1',
      onIncorrect: 'lb1_fail1',
    ),
    'lb1_ok1': const StoryNode(
      id: 'lb1_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Árbol, mesa, zapato! Un trozo de papel se desprende del '
          'Letrón. Pierde una mano.',
      nextNode: 'lb1_ex2',
    ),
    'lb1_fail1': const StoryNode(
      id: 'lb1_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Árbol, mesa, zapato. A-M-Z en el abecedario.»',
      nextNode: 'lb1_ex2',
    ),
    'lb1_ex2': const StoryNode(
      id: 'lb1_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'El Letrón escupe sílabas al aire.',
      question: '¿Cuántas sílabas tiene "pelota"?',
      options: ['2', '3', '4', '5'],
      correctIndex: 1,
      hint: 'PE-LO-TA. 3 palmadas.',
      onCorrect: 'lb1_ok2',
      onIncorrect: 'lb1_fail2',
    ),
    'lb1_ok2': const StoryNode(
      id: 'lb1_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡3! Otro trozo cae. El Letrón se tambalea.',
      nextNode: 'lb1_ex3',
    ),
    'lb1_fail2': const StoryNode(
      id: 'lb1_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«3 sílabas: PE-LO-TA.»',
      nextNode: 'lb1_ex3',
    ),
    'lb1_ex3': const StoryNode(
      id: 'lb1_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'El Letrón grita un nombre.',
      question: '¿"Luna" es sustantivo común o propio?',
      options: ['Común', 'Propio'],
      correctIndex: 0,
      hint: 'Luna (el astro) es común. Solo es propio si es un nombre de persona.',
      onCorrect: 'lb1_ok3',
      onIncorrect: 'lb1_fail3',
    ),
    'lb1_ok3': const StoryNode(
      id: 'lb1_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Común! La luna dibujada en el pecho del Letrón se apaga.',
      nextNode: 'lb1_ex4',
    ),
    'lb1_fail3': const StoryNode(
      id: 'lb1_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Común. Es la luna del cielo, no el nombre de una persona.»',
      nextNode: 'lb1_ex4',
    ),
    'lb1_ex4': const StoryNode(
      id: 'lb1_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'El Letrón, sin brazos, dispara letras con los ojos.',
      question: '¿Cuál es correcta: "máquina" o "mácina"?',
      options: ['mácina', 'máquina'],
      correctIndex: 1,
      hint: 'Antes de I se escribe QUI: máquina.',
      onCorrect: 'lb1_ok4',
      onIncorrect: 'lb1_fail4',
    ),
    'lb1_ok4': const StoryNode(
      id: 'lb1_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Máquina! Los ojos del Letrón se apagan. Una última prueba.',
      nextNode: 'lb1_ex5',
    ),
    'lb1_fail4': const StoryNode(
      id: 'lb1_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Máquina. QUI antes de I.»',
      nextNode: 'lb1_ex5',
    ),
    'lb1_ex5': const StoryNode(
      id: 'lb1_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'RETO FINAL. El Letrón susurra su última pregunta.',
      question: '¿Cuál es el femenino de "rey"?',
      options: ['Reya', 'Reina', 'Reina', 'Reyina'],
      correctIndex: 1,
      hint: 'Rey → reina. Es un caso especial.',
      onCorrect: 'lb1_victoria',
      onIncorrect: 'lb1_fail5',
    ),
    'lb1_victoria': const StoryNode(
      id: 'lb1_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💎',
      text: '¡REINA! ¡CRASHHH! El Letrón explota en una lluvia de '
          'confeti de papel. Entre los restos brilla un FRAGMENTO de '
          'la Gema Lexis.\n\n'
          'Orión: «¡Primer fragmento! Las palabras nos obedecen.»',
      nextNode: 'lb1_ending',
    ),
    'lb1_fail5': const StoryNode(
      id: 'lb1_fail5',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Reina. Rey → reina.»',
      nextNode: 'lb1_ending',
    ),
    'lb1_ending': const StoryNode(
      id: 'lb1_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡BOSS DERROTADO!\n\n'
          'Has combinado abecedario, sílabas, sustantivos, ortografía y '
          'género para vencer al Letrón.\n\n'
          '💎 Recompensa: Fragmento de Gema Lexis (1/3) · +200 XP',
    ),
  },
);
