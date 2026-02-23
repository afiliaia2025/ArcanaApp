import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// BOSS 2 BABEL: "El Maestro de las Rimas"
/// Tema: Repaso caps 5-8
/// ═══════════════════════════════════════════════════════════════
final boss2Babel = StoryChapter(
  id: 'babel_boss2',
  number: 10,
  title: 'El Maestro de las Rimas',
  gemName: 'Babel',
  subject: 'English',
  topic: 'Boss: Food, this/that, continuous, can',
  startNodeId: 'bboss2_intro',
  nodes: {
    'bboss2_intro': const StoryNode(
      id: 'bboss2_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🎭',
      text: 'Un actor enmascarado aparece en el escenario de Babel: '
          'es el MAESTRO DE LAS RIMAS, segundo General de Noctus.\n\n'
          '«Your English is weak, apprentice! Let me show you what '
          'REAL English sounds like!», se burla.\n\n'
          'Orión: «¡No le hagas caso! ¡Tu inglés es fuerte!»',
      nextNode: 'bboss2_ex1',
    ),
    'bboss2_ex1': const StoryNode(
      id: 'bboss2_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'El Maestro lanza una pregunta sobre comida.',
      question: 'There ___ some apples. (is/are)',
      options: ['is', 'are'],
      correctIndex: 1,
      hint: 'Apples = plural → there ARE.',
      onCorrect: 'bboss2_ok1',
      onIncorrect: 'bboss2_fail1',
    ),
    'bboss2_ok1': const StoryNode(
      id: 'bboss2_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Are! La máscara del Maestro se agrieta.',
      nextNode: 'bboss2_ex2',
    ),
    'bboss2_fail1': const StoryNode(
      id: 'bboss2_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Are. There ARE some apples (plural).»',
      nextNode: 'bboss2_ex2',
    ),
    'bboss2_ex2': const StoryNode(
      id: 'bboss2_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'El Maestro señala algo lejos.',
      question: '___ are those shoes. (These/Those — far)',
      options: ['These', 'Those'],
      correctIndex: 1,
      hint: 'Far + plural → THOSE.',
      onCorrect: 'bboss2_ok2',
      onIncorrect: 'bboss2_fail2',
    ),
    'bboss2_ok2': const StoryNode(
      id: 'bboss2_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Those! La capa del Maestro se rasga.',
      nextNode: 'bboss2_ex3',
    ),
    'bboss2_fail2': const StoryNode(
      id: 'bboss2_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Those. Far + plural = THOSE.»',
      nextNode: 'bboss2_ex3',
    ),
    'bboss2_ex3': const StoryNode(
      id: 'bboss2_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'El Maestro conjura una acción.',
      question: 'He is ___ football. (play)',
      options: ['plays', 'played', 'playing', 'play'],
      correctIndex: 2,
      hint: 'Is + verb + ING: he is playING.',
      onCorrect: 'bboss2_ok3',
      onIncorrect: 'bboss2_fail3',
    ),
    'bboss2_ok3': const StoryNode(
      id: 'bboss2_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Playing! El Maestro pierde su sombrero.',
      nextNode: 'bboss2_ex4',
    ),
    'bboss2_fail3': const StoryNode(
      id: 'bboss2_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Playing. He is playING.»',
      nextNode: 'bboss2_ex4',
    ),
    'bboss2_ex4': const StoryNode(
      id: 'bboss2_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'RETO FINAL del Maestro.',
      question: 'Can birds fly? Yes, they ___.',
      options: ['can\'t', 'do', 'can', 'are'],
      correctIndex: 2,
      hint: 'Yes, they CAN fly!',
      onCorrect: 'bboss2_victoria',
      onIncorrect: 'bboss2_fail4',
    ),
    'bboss2_victoria': const StoryNode(
      id: 'bboss2_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💎',
      text: 'Can! ¡CRASH! La máscara del Maestro se rompe y se ve '
          'que era solo una marioneta de Noctus.\n\n'
          'Entre los restos brilla el SEGUNDO FRAGMENTO de la Gema Babel.\n\n'
          'Orión: «Second fragment! One more to go!»',
      nextNode: 'bboss2_ending',
    ),
    'bboss2_fail4': const StoryNode(
      id: 'bboss2_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Can. Yes, they CAN fly.»',
      nextNode: 'bboss2_ending',
    ),
    'bboss2_ending': const StoryNode(
      id: 'bboss2_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡BOSS DERROTADO!\n\n'
          'Has combinado food, demonstratives, continuous y can.\n\n'
          '💎 Recompensa: Fragmento de Gema Babel (2/2) · +200 XP',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// BOSS FINAL BABEL: "Noctus Eterno"
/// Tema: TODO English + cierre de la aventura
/// ═══════════════════════════════════════════════════════════════
final bossFinalBabel = StoryChapter(
  id: 'babel_boss_final',
  number: 11,
  title: 'Noctus Eterno',
  gemName: 'Babel',
  subject: 'English',
  topic: 'Boss Final: Repaso de todo el año + cierre',
  startNodeId: 'bbf_intro',
  nodes: {
    'bbf_intro': const StoryNode(
      id: 'bbf_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌑',
      text: 'La Ciudad de Babel tiembla. El cielo se oscurece. Una torre '
          'negra emerge del suelo: es la Torre de Noctus.\n\n'
          'Con las tres gemas brillando (Ignis, Lexis, Sylva), subes '
          'los escalones de la torre definitiva. La cuarta gema, BABEL, '
          'está custodiada por el ÚLTIMO guardián.\n\n'
          'Pero no es un guardián cualquiera. Es una SOMBRA de Noctus: '
          'una copia manchada del villano que habla solo en inglés.\n\n'
          '«YOU WILL NEVER COMPLETE THE FOUR GEMS», ruge Noctus Eterno.\n\n'
          'Orión: «Este es el momento. ¡TODO tu inglés del curso! '
          '¡Last battle!»',
      nextNode: 'bbf_ex1',
    ),
    'bbf_ex1': const StoryNode(
      id: 'bbf_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'Noctus Eterno lanza una onda oscura.',
      question: 'What colour is snow?',
      options: ['Black', 'Blue', 'White', 'Yellow'],
      correctIndex: 2,
      hint: 'Snow is white!',
      onCorrect: 'bbf_ok1',
      onIncorrect: 'bbf_fail1',
    ),
    'bbf_ok1': const StoryNode(
      id: 'bbf_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'White! La luz blanca destroza la primera capa de oscuridad.',
      nextNode: 'bbf_ex2',
    ),
    'bbf_fail1': const StoryNode(
      id: 'bbf_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«White. Snow is white!»',
      nextNode: 'bbf_ex2',
    ),
    'bbf_ex2': const StoryNode(
      id: 'bbf_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🔥',
      text: 'Noctus ataca con verbos.',
      question: 'She is ___ a book. (read)',
      options: ['reads', 'readed', 'reading', 'read'],
      correctIndex: 2,
      hint: 'Is + verb + ING: she is readING.',
      onCorrect: 'bbf_ok2',
      onIncorrect: 'bbf_fail2',
    ),
    'bbf_ok2': const StoryNode(
      id: 'bbf_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Reading! El escudo verbal de Noctus se rompe.',
      nextNode: 'bbf_ex3',
    ),
    'bbf_fail2': const StoryNode(
      id: 'bbf_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Reading. She is readING.»',
      nextNode: 'bbf_ex3',
    ),
    'bbf_ex3': const StoryNode(
      id: 'bbf_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Noctus intenta confundirte con preposiciones.',
      question: 'The cat is ___ the table. (under)',
      options: ['on', 'in', 'under', 'behind'],
      correctIndex: 2,
      hint: 'Under = debajo de.',
      onCorrect: 'bbf_ok3',
      onIncorrect: 'bbf_fail3',
    ),
    'bbf_ok3': const StoryNode(
      id: 'bbf_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Under! La armadura oscura de Noctus se agrieta.',
      nextNode: 'bbf_ex4',
    ),
    'bbf_fail3': const StoryNode(
      id: 'bbf_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Under. Under the table.»',
      nextNode: 'bbf_ex4',
    ),
    'bbf_ex4': const StoryNode(
      id: 'bbf_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'Noctus grita una pregunta sobre gustos.',
      question: 'I like ___ tennis. (play)',
      options: ['play', 'plays', 'playing', 'played'],
      correctIndex: 2,
      hint: 'Like + verb + ING: I like playING.',
      onCorrect: 'bbf_ok4',
      onIncorrect: 'bbf_fail4',
    ),
    'bbf_ok4': const StoryNode(
      id: 'bbf_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Playing! El cuerpo de sombra de Noctus se disuelve.',
      nextNode: 'bbf_ex5',
    ),
    'bbf_fail4': const StoryNode(
      id: 'bbf_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Playing. Like + playING.»',
      nextNode: 'bbf_ex5',
    ),
    'bbf_ex5': const StoryNode(
      id: 'bbf_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'PREGUNTA FINAL. Noctus, casi derrotado, susurra su último reto.',
      question: 'Can you swim? Yes, I ___.',
      options: ['can\'t', 'am', 'do', 'can'],
      correctIndex: 3,
      hint: 'Yes, I CAN!',
      onCorrect: 'bbf_victoria',
      onIncorrect: 'bbf_fail5',
    ),
    'bbf_victoria': const StoryNode(
      id: 'bbf_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '«YES, I CAN!!!»\n\n'
          '¡¡¡BOOOOOOM!!!\n\n'
          'Noctus Eterno EXPLOTA en una tormenta de sombras que se '
          'convierten en mariposas de luz. La oscuridad se disipa.\n\n'
          'La cuarta y última Gema, BABEL, cae del cielo como una '
          'estrella fugaz. Es de color plateado y dentro danzan '
          'palabras en todos los idiomas del mundo.\n\n'
          'Al tocarla, las CUATRO GEMAS se unen:\n'
          '🔴 Ignis (Matemáticas)\n'
          '🟡 Lexis (Lengua)\n'
          '🟢 Sylva (Ciencias)\n'
          '⚪ Babel (Inglés)\n\n'
          'El mapa brilla con toda su fuerza. La tierra de Numeralia '
          'vuelve a la vida. Los Bruminos celebran. Los bosques florecen. '
          'Los ríos cantan.\n\n'
          'Orión LLORA (y esta vez lo admite): «Lo has conseguido, '
          'aprendiz. Has recuperado las cuatro gemas del conocimiento. '
          'Numeralia está a salvo… GRACIAS A TI.»\n\n'
          'La sombra de Noctus se aleja derrotada, pero susurra: '
          '«Volveré el año que viene…»\n\n'
          'Orión guiña un ojo: «Y nosotros estaremos esperando. '
          '¿Verdad, aprendiz?»',
      nextNode: 'bbf_ending',
    ),
    'bbf_fail5': const StoryNode(
      id: 'bbf_fail5',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Can! Yes, I CAN!»',
      nextNode: 'bbf_victoria',
    ),
    'bbf_ending': const StoryNode(
      id: 'bbf_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡¡¡BOSS FINAL DERROTADO!!!\n'
          '¡¡¡AVENTURA COMPLETADA!!!\n\n'
          'Has usado TODO lo aprendido en todos los idiomas:\n\n'
          '🔴 Matemáticas · 🟡 Lengua · 🟢 Ciencias · ⚪ Inglés\n\n'
          '⭐ Recompensa: LAS CUATRO GEMAS · TÍTULO DE MAGO ARCANO\n\n'
          '«Noctus ha sido derrotado. Numeralia está a salvo.\n'
          'Pero el conocimiento nunca termina…\n'
          '¿Listo para 3º de Primaria?»\n\n'
          '🎉 FIN DE LA TEMPORADA 1 🎉',
    ),
  },
);
