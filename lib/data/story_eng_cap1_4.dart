import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// CAP 1 BABEL: "El Portal se Abre"
/// Tema: Greetings, numbers 1-20, colours
/// ═══════════════════════════════════════════════════════════════
final chapter1Babel = StoryChapter(
  id: 'babel_c01',
  number: 1,
  title: 'El Portal se Abre',
  gemName: 'Babel',
  subject: 'English',
  topic: 'Greetings, numbers and colours',
  startNodeId: 'bb1_intro',
  nodes: {
    'bb1_intro': const StoryNode(
      id: 'bb1_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌀',
      text: 'Tres gemas brillan en tu mochila. El mapa revela el último '
          'reino: BABEL, la Ciudad de las Lenguas. Aquí todos hablan '
          'en INGLÉS.\n\n'
          'Un portal de cristal se abre frente a ti. Una voz dice: '
          '«Hello, apprentice. Welcome to Babel. To enter, you must '
          'speak our language.»\n\n'
          'Orión: «Es el momento de usar tu inglés. ¡Puedes hacerlo!»',
      nextNode: 'bb1_ex1',
    ),
    'bb1_ex1': const StoryNode(
      id: 'bb1_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '👋',
      text: 'El portal te saluda.',
      question: 'How do you say "Hola" in English?',
      options: ['Goodbye', 'Hello', 'Thanks', 'Sorry'],
      correctIndex: 1,
      hint: 'Hello = Hola. It is a greeting!',
      onCorrect: 'bb1_ok1',
      onIncorrect: 'bb1_fail1',
    ),
    'bb1_ok1': const StoryNode(
      id: 'bb1_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Hello! El portal brilla más fuerte.',
      nextNode: 'bb1_ex2',
    ),
    'bb1_fail1': const StoryNode(
      id: 'bb1_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Hello. Hola = Hello!»',
      nextNode: 'bb1_ex2',
    ),
    'bb1_ex2': const StoryNode(
      id: 'bb1_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🔢',
      text: 'El portal muestra el número 15.',
      question: 'Spell the number 15 in English.',
      options: ['Fifty', 'Fifteen', 'Five', 'Fiveteen'],
      correctIndex: 1,
      hint: '15 = fifteen (not fifty, which is 50).',
      onCorrect: 'bb1_ok2',
      onIncorrect: 'bb1_fail2',
    ),
    'bb1_ok2': const StoryNode(
      id: 'bb1_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💫',
      text: 'Fifteen! 15 estrellas aparecen en el portal.',
      nextNode: 'bb1_ex3',
    ),
    'bb1_fail2': const StoryNode(
      id: 'bb1_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Fifteen. 15 = fifteen.»',
      nextNode: 'bb1_ex3',
    ),
    'bb1_ex3': const StoryNode(
      id: 'bb1_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🎨',
      text: 'El portal cambia de color.',
      question: 'What colour is the sky?',
      options: ['Red', 'Green', 'Blue', 'Yellow'],
      correctIndex: 2,
      hint: 'The sky is blue! (el cielo es azul)',
      onCorrect: 'bb1_ok3',
      onIncorrect: 'bb1_fail3',
    ),
    'bb1_ok3': const StoryNode(
      id: 'bb1_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔵',
      text: 'Blue! El portal se tiñe de azul cielo.',
      nextNode: 'bb1_ex4',
    ),
    'bb1_fail3': const StoryNode(
      id: 'bb1_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Blue. The sky is blue.»',
      nextNode: 'bb1_ex4',
    ),
    'bb1_ex4': const StoryNode(
      id: 'bb1_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Última prueba antes de cruzar.',
      question: 'What colour is a banana?',
      options: ['Red', 'Blue', 'Yellow', 'Green'],
      correctIndex: 2,
      hint: 'Bananas are yellow!',
      onCorrect: 'bb1_final_ok',
      onIncorrect: 'bb1_final_fail',
    ),
    'bb1_final_ok': const StoryNode(
      id: 'bb1_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌀',
      text: 'Yellow! ¡El portal se abre completamente! Cruzas a la '
          'Ciudad de Babel. Todo está escrito en inglés: las calles, '
          'los carteles, los edificios.\n\n'
          'Orión: «Welcome to Babel! Here we speak English.»',
      nextNode: 'bb1_ending',
    ),
    'bb1_final_fail': const StoryNode(
      id: 'bb1_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Yellow. Bananas are yellow!»',
      nextNode: 'bb1_ending',
    ),
    'bb1_ending': const StoryNode(
      id: 'bb1_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 1 de Babel completado!\n\n'
          'Dominas saludos, números y colores en inglés.\n\n'
          '🌀 Recompensa: Llave del Portal',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 2 BABEL: "Un Día en Babel"
/// Tema: Daily routines, time (o'clock, half past)
/// ═══════════════════════════════════════════════════════════════
final chapter2Babel = StoryChapter(
  id: 'babel_c02',
  number: 2,
  title: 'Un Día en Babel',
  gemName: 'Babel',
  subject: 'English',
  topic: 'Daily routines and telling time',
  startNodeId: 'bb2_intro',
  nodes: {
    'bb2_intro': const StoryNode(
      id: 'bb2_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏘️',
      text: 'La Ciudad de Babel despierta con el sonido de campanas. '
          'Los habitantes siguen rutinas muy estrictas: desayunan a las '
          '8, van al colegio a las 9, almuerzan a la 1…\n\n'
          'Pero el reloj de la torre está roto. Nadie sabe la hora.\n\n'
          'Orión: «Sin el reloj, Babel está en caos. ¡Arréglalo!»',
      nextNode: 'bb2_ex1',
    ),
    'bb2_ex1': const StoryNode(
      id: 'bb2_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⏰',
      text: 'El reloj marca las 3:00. ¿Cómo se dice?',
      question: '3:00 → It\'s ___ o\'clock.',
      options: ['two', 'three', 'four', 'five'],
      correctIndex: 1,
      hint: '3:00 = three o\'clock.',
      onCorrect: 'bb2_ok1',
      onIncorrect: 'bb2_fail1',
    ),
    'bb2_ok1': const StoryNode(
      id: 'bb2_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Three o\'clock! Las manecillas del reloj se mueven.',
      nextNode: 'bb2_ex2',
    ),
    'bb2_fail1': const StoryNode(
      id: 'bb2_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Three. 3:00 = three o\'clock.»',
      nextNode: 'bb2_ex2',
    ),
    'bb2_ex2': const StoryNode(
      id: 'bb2_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🕤',
      text: 'Ahora muestra 7:30.',
      question: '7:30 → It\'s half past ___.',
      options: ['six', 'seven', 'eight', 'nine'],
      correctIndex: 1,
      hint: '7:30 = half past seven.',
      onCorrect: 'bb2_ok2',
      onIncorrect: 'bb2_fail2',
    ),
    'bb2_ok2': const StoryNode(
      id: 'bb2_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⏰',
      text: 'Half past seven! El reloj ya marca la hora correcta.',
      nextNode: 'bb2_ex3',
    ),
    'bb2_fail2': const StoryNode(
      id: 'bb2_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Seven. 7:30 = half past seven.»',
      nextNode: 'bb2_ex3',
    ),
    'bb2_ex3': const StoryNode(
      id: 'bb2_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🍽️',
      text: 'Un habitante de Babel te pregunta sobre tu rutina.',
      question: 'I have ___ at 8 o\'clock (morning meal).',
      options: ['dinner', 'lunch', 'breakfast', 'snack'],
      correctIndex: 2,
      hint: 'The morning meal = breakfast (desayuno).',
      onCorrect: 'bb2_ok3',
      onIncorrect: 'bb2_fail3',
    ),
    'bb2_ok3': const StoryNode(
      id: 'bb2_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🥐',
      text: 'Breakfast! El habitante te invita a desayunar.',
      nextNode: 'bb2_ex4',
    ),
    'bb2_fail3': const StoryNode(
      id: 'bb2_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Breakfast. Morning meal = breakfast.»',
      nextNode: 'bb2_ex4',
    ),
    'bb2_ex4': const StoryNode(
      id: 'bb2_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Última rutina para arreglar.',
      question: 'I brush my ___ before bed.',
      options: ['hair', 'teeth', 'shoes', 'books'],
      correctIndex: 1,
      hint: 'Before bed, you brush your teeth (dientes).',
      onCorrect: 'bb2_final_ok',
      onIncorrect: 'bb2_final_fail',
    ),
    'bb2_final_ok': const StoryNode(
      id: 'bb2_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🦷',
      text: 'Teeth! ¡El reloj de Babel está reparado! Las campanas '
          'suenan y los habitantes celebran.\n\n'
          'Orión: «You know the daily routine! Well done!»',
      nextNode: 'bb2_ending',
    ),
    'bb2_final_fail': const StoryNode(
      id: 'bb2_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Teeth. I brush my teeth before bed.»',
      nextNode: 'bb2_ending',
    ),
    'bb2_ending': const StoryNode(
      id: 'bb2_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 2 de Babel completado!\n\n'
          'Dominas rutinas diarias y cómo decir la hora.\n\n'
          '⏰ Recompensa: Reloj de Babel',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 3 BABEL: "El Mercado de Criaturas"
/// Tema: Animals — have got / has got
/// ═══════════════════════════════════════════════════════════════
final chapter3Babel = StoryChapter(
  id: 'babel_c03',
  number: 3,
  title: 'El Mercado de Criaturas',
  gemName: 'Babel',
  subject: 'English',
  topic: 'Animals: have got / has got',
  startNodeId: 'bb3_intro',
  nodes: {
    'bb3_intro': const StoryNode(
      id: 'bb3_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🦜',
      text: 'En el centro de Babel hay un mercado donde venden criaturas '
          'mágicas. Un vendedor necesita describir los animales en inglés '
          'para poder venderlos.\n\n'
          '«I need help! I forgot how to describe the animals!», dice.\n\n'
          'Orión: «Has got / have got. Para describir qué TIENEN.»',
      nextNode: 'bb3_ex1',
    ),
    'bb3_ex1': const StoryNode(
      id: 'bb3_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🐕',
      text: 'Un perro mueve la cola en el mercado.',
      question: 'A cat ___ got four legs. (has/have)',
      options: ['have', 'has'],
      correctIndex: 1,
      hint: 'He/she/it + HAS got. A cat = it → has got.',
      onCorrect: 'bb3_ok1',
      onIncorrect: 'bb3_fail1',
    ),
    'bb3_ok1': const StoryNode(
      id: 'bb3_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Has! A cat has got four legs. El vendedor sonríe.',
      nextNode: 'bb3_ex2',
    ),
    'bb3_fail1': const StoryNode(
      id: 'bb3_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Has. A cat HAS got four legs. (it = has)»',
      nextNode: 'bb3_ex2',
    ),
    'bb3_ex2': const StoryNode(
      id: 'bb3_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🐦',
      text: 'Unas aves revolotean sobre el mercado.',
      question: 'Birds ___ got wings. (has/have)',
      options: ['has', 'have'],
      correctIndex: 1,
      hint: 'They + HAVE got. Birds = they → have got.',
      onCorrect: 'bb3_ok2',
      onIncorrect: 'bb3_fail2',
    ),
    'bb3_ok2': const StoryNode(
      id: 'bb3_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🦅',
      text: 'Have! Birds have got wings. Las aves baten las alas.',
      nextNode: 'bb3_ex3',
    ),
    'bb3_fail2': const StoryNode(
      id: 'bb3_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Have. Birds (they) HAVE got wings.»',
      nextNode: 'bb3_ex3',
    ),
    'bb3_ex3': const StoryNode(
      id: 'bb3_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🐍',
      text: 'Una serpiente se desliza entre las jaulas.',
      question: 'Has a snake got legs?',
      options: ['Yes, it has', 'No, it hasn\'t'],
      correctIndex: 1,
      hint: 'Snakes have no legs → No, it hasn\'t.',
      onCorrect: 'bb3_ok3',
      onIncorrect: 'bb3_fail3',
    ),
    'bb3_ok3': const StoryNode(
      id: 'bb3_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐍',
      text: 'No, it hasn\'t! La serpiente asiente con la cabeza.',
      nextNode: 'bb3_ex4',
    ),
    'bb3_fail3': const StoryNode(
      id: 'bb3_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«No, it hasn\'t. Snakes haven\'t got legs.»',
      nextNode: 'bb3_ex4',
    ),
    'bb3_ex4': const StoryNode(
      id: 'bb3_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El vendedor te muestra un elefante.',
      question: 'Has an elephant got a trunk?',
      options: ['No, it hasn\'t', 'Yes, it has'],
      correctIndex: 1,
      hint: 'Elephants have a trunk (trompa) → Yes, it has.',
      onCorrect: 'bb3_final_ok',
      onIncorrect: 'bb3_final_fail',
    ),
    'bb3_final_ok': const StoryNode(
      id: 'bb3_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐘',
      text: 'Yes, it has! El elefante trompetea feliz y el vendedor '
          'te regala un amuleto.\n\n'
          'Orión: «Has got, have got, hasn\'t got. Perfect!»',
      nextNode: 'bb3_ending',
    ),
    'bb3_final_fail': const StoryNode(
      id: 'bb3_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Yes, it has. An elephant has got a trunk.»',
      nextNode: 'bb3_ending',
    ),
    'bb3_ending': const StoryNode(
      id: 'bb3_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 3 de Babel completado!\n\n'
          'Describes animales con have got / has got.\n\n'
          '🦜 Recompensa: Amuleto del Mercado',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 4 BABEL: "El Pueblo Perdido"
/// Tema: Prepositions of place (in, on, under, next to, behind)
/// ═══════════════════════════════════════════════════════════════
final chapter4Babel = StoryChapter(
  id: 'babel_c04',
  number: 4,
  title: 'El Pueblo Perdido',
  gemName: 'Babel',
  subject: 'English',
  topic: 'Prepositions of place',
  startNodeId: 'bb4_intro',
  nodes: {
    'bb4_intro': const StoryNode(
      id: 'bb4_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏘️',
      text: 'Más allá del mercado hay un pueblo abandonado. Los objetos '
          'están en lugares equivocados: el gato está DEBAJO de la mesa '
          'en vez de encima, el libro está EN la estantería correcta '
          'pero los demás están en el suelo.\n\n'
          'Orión: «Noctus cambió las posiciones de TODO. Necesitas usar '
          'prepositions: in, on, under, next to, behind.»',
      nextNode: 'bb4_ex1',
    ),
    'bb4_ex1': const StoryNode(
      id: 'bb4_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🐱',
      text: 'Un gato está debajo de la mesa.',
      question: 'The cat is ___ the table.',
      options: ['on', 'in', 'under', 'behind'],
      correctIndex: 2,
      hint: 'Under = debajo de. The cat is UNDER the table.',
      onCorrect: 'bb4_ok1',
      onIncorrect: 'bb4_fail1',
    ),
    'bb4_ok1': const StoryNode(
      id: 'bb4_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Under! El gato maúlla satisfecho desde debajo de la mesa.',
      nextNode: 'bb4_ex2',
    ),
    'bb4_fail1': const StoryNode(
      id: 'bb4_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Under. The cat is under the table.»',
      nextNode: 'bb4_ex2',
    ),
    'bb4_ex2': const StoryNode(
      id: 'bb4_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📕',
      text: 'Un libro está encima de la estantería.',
      question: 'The book is ___ the shelf.',
      options: ['under', 'in', 'on', 'behind'],
      correctIndex: 2,
      hint: 'On = encima de / sobre. The book is ON the shelf.',
      onCorrect: 'bb4_ok2',
      onIncorrect: 'bb4_fail2',
    ),
    'bb4_ok2': const StoryNode(
      id: 'bb4_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📚',
      text: 'On! El libro vuelve a su lugar correcto.',
      nextNode: 'bb4_ex3',
    ),
    'bb4_fail2': const StoryNode(
      id: 'bb4_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«On. The book is on the shelf.»',
      nextNode: 'bb4_ex3',
    ),
    'bb4_ex3': const StoryNode(
      id: 'bb4_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚽',
      text: 'Una pelota está dentro de una caja.',
      question: 'The ball is ___ the box.',
      options: ['on', 'in', 'under', 'next to'],
      correctIndex: 1,
      hint: 'In = dentro de. The ball is IN the box.',
      onCorrect: 'bb4_ok3',
      onIncorrect: 'bb4_fail3',
    ),
    'bb4_ok3': const StoryNode(
      id: 'bb4_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📦',
      text: 'In! La pelota rueda dentro de la caja, donde debe estar.',
      nextNode: 'bb4_ex4',
    ),
    'bb4_fail3': const StoryNode(
      id: 'bb4_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«In. The ball is in the box.»',
      nextNode: 'bb4_ex4',
    ),
    'bb4_ex4': const StoryNode(
      id: 'bb4_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Un perro está al lado de un árbol.',
      question: 'The dog is ___ the tree.',
      options: ['under', 'in', 'on', 'next to'],
      correctIndex: 3,
      hint: 'Next to = al lado de.',
      onCorrect: 'bb4_final_ok',
      onIncorrect: 'bb4_final_fail',
    ),
    'bb4_final_ok': const StoryNode(
      id: 'bb4_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐕',
      text: 'Next to! Todo el pueblo vuelve a la normalidad. Los objetos '
          'regresan a sus posiciones correctas.\n\n'
          'Orión: «In, on, under, next to, behind. You fixed the town!»',
      nextNode: 'bb4_ending',
    ),
    'bb4_final_fail': const StoryNode(
      id: 'bb4_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Next to. The dog is next to the tree.»',
      nextNode: 'bb4_ending',
    ),
    'bb4_ending': const StoryNode(
      id: 'bb4_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 4 de Babel completado!\n\n'
          'Dominas las preposiciones de lugar.\n\n'
          '🏘️ Recompensa: Brújula de Babel',
    ),
  },
);
