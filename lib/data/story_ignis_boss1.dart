import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// BOSS 1: "El Numerox Guardián"
/// Tema: Todo de U0-U4 (números, series, sumas, hora, comparar)
/// ═══════════════════════════════════════════════════════════════
final boss1Ignis = StoryChapter(
  id: 'ignis_boss1',
  number: 6, // posición en la secuencia
  title: 'El Numerox Guardián',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Boss: Repaso U0-U4',
  startNodeId: 'b1_intro',
  nodes: {
    'b1_intro': const StoryNode(
      id: 'b1_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '👹',
      text: 'La salida del quinto piso está bloqueada por una criatura '
          'enorme: un Numerox Guardián. Tiene el cuerpo hecho de piedras '
          'con números grabados, ojos de cristal rojo y una voz que '
          'retumba como un trueno:\n\n'
          '«¡NADIE SALE DE LA TORRE SIN SUPERAR MIS 5 PRUEBAS!»\n\n'
          'Orión traga saliva: «Es un boss. Usa todo lo que hemos aprendido.»',
      nextNode: 'b1_ex1',
    ),
    'b1_ex1': const StoryNode(
      id: 'b1_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'PRUEBA 1 — Valor Posicional\nEl Numerox golpea el suelo. '
          'Un número aparece flotando: 186.',
      question: '¿Cuántas DECENAS tiene el número 186?',
      options: ['1', '8', '6', '18'],
      correctIndex: 1,
      hint: 'En 186: 1 centena, 8 decenas, 6 unidades.',
      onCorrect: 'b1_ok1',
      onIncorrect: 'b1_fail1',
    ),
    'b1_ok1': const StoryNode(
      id: 'b1_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡CRACK! Una grieta aparece en el brazo del Numerox. '
          '«¡Primera prueba superada!», ruge furioso.',
      nextNode: 'b1_ex2',
    ),
    'b1_fail1': const StoryNode(
      id: 'b1_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«8 decenas. En 186: el 1 es la centena, el 8 la decena, '
          'el 6 la unidad.» Orión lanza un destello que agrieta al Numerox.',
      nextNode: 'b1_ex2',
    ),
    'b1_ex2': const StoryNode(
      id: 'b1_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'PRUEBA 2 — Series\nEl suelo tiembla. Aparecen baldosas con '
          'números: 155, 160, ___, ___, 175.',
      question: '¿Qué números faltan?\n155, 160, ___, ___, 175',
      options: ['162, 168', '165, 170', '163, 171', '164, 170'],
      correctIndex: 1,
      hint: 'La serie va de 5 en 5: 155, 160, 165, 170, 175.',
      onCorrect: 'b1_ok2',
      onIncorrect: 'b1_fail2',
    ),
    'b1_ok2': const StoryNode(
      id: 'b1_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡165 y 170! ¡CRACK! Otra grieta en la pierna del Numerox. '
          'La criatura da un paso atrás, tambaleándose.',
      nextNode: 'b1_ex3',
    ),
    'b1_fail2': const StoryNode(
      id: 'b1_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«De 5 en 5: 155, 160, 165, 170, 175. ¡Fíjate en cuánto '
          'salta entre cada número!»',
      nextNode: 'b1_ex3',
    ),
    'b1_ex3': const StoryNode(
      id: 'b1_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'PRUEBA 3 — Suma con Llevada\nEl Numerox lanza una roca con '
          'una operación grabada.',
      question: '¿Cuánto es 78 + 56?',
      options: ['124', '134', '132', '144'],
      correctIndex: 1,
      hint: '8 + 6 = 14, escribes 4 y llevas 1. 7 + 5 + 1 = 13.',
      onCorrect: 'b1_ok3',
      onIncorrect: 'b1_fail3',
    ),
    'b1_ok3': const StoryNode(
      id: 'b1_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡134! La roca explota en mil pedazos. El Numerox pierde otro '
          'trozo de su cuerpo. ¡Dos pruebas más!',
      nextNode: 'b1_ex4',
    ),
    'b1_fail3': const StoryNode(
      id: 'b1_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«134. 8+6=14 (llevas 1), 7+5+1=13.»',
      nextNode: 'b1_ex4',
    ),
    'b1_ex4': const StoryNode(
      id: 'b1_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'PRUEBA 4 — La Hora\nUn reloj aparece flotando. La aguja corta '
          'está en el 10 y la larga en el 12.',
      question: '¿Qué hora marca este reloj?',
      options: ['Las 12:10', 'Las 10:00', 'Las 10:30', 'Las 12:00'],
      correctIndex: 1,
      hint: 'Aguja corta = la hora. En el 10 = las 10. Aguja larga en el 12 = en punto.',
      onCorrect: 'b1_ok4',
      onIncorrect: 'b1_fail4',
    ),
    'b1_ok4': const StoryNode(
      id: 'b1_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Las 10 en punto! ¡CRACK! El Numerox cae de rodillas. '
          'Solo queda UNA prueba más para destruirlo.',
      nextNode: 'b1_ex5',
    ),
    'b1_fail4': const StoryNode(
      id: 'b1_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Las 10:00. Aguja corta en el 10, larga en el 12 = en punto.»',
      nextNode: 'b1_ex5',
    ),
    'b1_ex5': const StoryNode(
      id: 'b1_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'PRUEBA FINAL — Comparar\nEl Numerox, temblando, hace una '
          'última pregunta con voz rota:',
      question: 'Ordena de MAYOR a MENOR:\n289, 198, 272, 245',
      options: [
        '198, 245, 272, 289',
        '289, 272, 245, 198',
        '289, 198, 272, 245',
        '272, 289, 198, 245',
      ],
      correctIndex: 1,
      hint: 'De mayor a menor: empieza por el más grande (289) y termina por el más pequeño (198).',
      onCorrect: 'b1_final_ok',
      onIncorrect: 'b1_final_fail',
    ),
    'b1_final_ok': const StoryNode(
      id: 'b1_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💎',
      text: '¡289 → 272 → 245 → 198!\n\n'
          '¡¡BOOOOM!! El Numerox Guardián EXPLOTA en una lluvia de cristales. '
          'Entre los escombros, algo brilla: ¡un FRAGMENTO de la Gema Ignis!\n\n'
          'Orión lo recoge con cuidado: «¡Es el primer fragmento! '
          'Necesitamos tres para completar la gema.»',
      nextNode: 'b1_ending',
    ),
    'b1_final_fail': const StoryNode(
      id: 'b1_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«289, 272, 245, 198. De mayor a menor.»\n\n'
          'El Numerox se derrumba dejando el primer fragmento de gema.',
      nextNode: 'b1_ending',
    ),
    'b1_ending': const StoryNode(
      id: 'b1_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡BOSS DERROTADO!\n\n'
          'Has superado las 5 pruebas del Numerox Guardián usando '
          'todo lo aprendido: valor posicional, series, sumas, '
          'la hora y comparar números.\n\n'
          '💎 Recompensa: Fragmento de Gema Ignis (1/3) · +150 XP\n\n'
          'El fragmento brilla en la mochila. Pero al pisar el sexto '
          'piso, hace un FRÍO que corta. Los cristales de las paredes '
          'están cubiertos de escarcha. Orión, temblando: «¡N-Noctus '
          'ha congelado este piso! ¡Necesitaremos restar la nieve!»',
    ),
  },
);
