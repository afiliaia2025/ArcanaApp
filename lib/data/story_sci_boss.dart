import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// BOSS SYLVA: "El Guardián de las Enredaderas"
/// Tema: Repaso caps 1-3 (living/non-living, plants, animals)
/// ═══════════════════════════════════════════════════════════════
final boss1Sylva = StoryChapter(
  id: 'sylva_boss1',
  number: 7,
  title: 'El Guardián de las Enredaderas',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'Boss: Living things, plants and animals',
  startNodeId: 'sb1_intro',
  nodes: {
    'sb1_intro': const StoryNode(
      id: 'sb1_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌿',
      text: 'Al salir de la torre, unas enredaderas gigantes te atrapan '
          'los pies. Un monstruo de lianas y hojas se levanta del suelo: '
          'es el GUARDIÁN DE LAS ENREDADERAS.\n\n'
          '«NADIE PASA SIN DEMOSTRAR QUE CONOCE LA NATURALEZA», '
          'ruge con voz de trueno vegetal.\n\n'
          'Orión: «¡Es un boss de Sylva! Usa la ciencia contra él.»',
      nextNode: 'sb1_ex1',
    ),
    'sb1_ex1': const StoryNode(
      id: 'sb1_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'Las enredaderas te aprietan. ¡Responde rápido!',
      question: 'Is a tree living or non-living?',
      options: ['Non-living', 'Living'],
      correctIndex: 1,
      hint: 'Trees grow, need water and sunlight → living!',
      onCorrect: 'sb1_ok1',
      onIncorrect: 'sb1_fail1',
    ),
    'sb1_ok1': const StoryNode(
      id: 'sb1_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Living! Una enredadera se suelta.',
      nextNode: 'sb1_ex2',
    ),
    'sb1_fail1': const StoryNode(
      id: 'sb1_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Living. Trees grow, need water and sunlight.»',
      nextNode: 'sb1_ex2',
    ),
    'sb1_ex2': const StoryNode(
      id: 'sb1_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'El Guardián lanza esporas con preguntas.',
      question: 'Which part of a plant makes seeds?',
      options: ['Root', 'Stem', 'Leaf', 'Flower'],
      correctIndex: 3,
      hint: 'Flowers produce seeds that become new plants.',
      onCorrect: 'sb1_ok2',
      onIncorrect: 'sb1_fail2',
    ),
    'sb1_ok2': const StoryNode(
      id: 'sb1_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Flower! La flor del Guardián se marchita. Pierde fuerza.',
      nextNode: 'sb1_ex3',
    ),
    'sb1_fail2': const StoryNode(
      id: 'sb1_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Flower. Flowers make seeds.»',
      nextNode: 'sb1_ex3',
    ),
    'sb1_ex3': const StoryNode(
      id: 'sb1_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'RETO FINAL del Guardián.',
      question: 'Reptiles have dry, scaly skin. True or false?',
      options: ['True', 'False'],
      correctIndex: 0,
      hint: 'Reptiles (snakes, lizards, crocodiles) have dry, scaly skin.',
      onCorrect: 'sb1_victoria',
      onIncorrect: 'sb1_fail3',
    ),
    'sb1_victoria': const StoryNode(
      id: 'sb1_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💎',
      text: 'True! ¡CRASHH! Las enredaderas se secan y caen. '
          'El Guardián se desmorona en un montón de hojas secas.\n\n'
          'Entre ellas brilla un FRAGMENTO de la Gema Sylva.\n\n'
          'Orión: «¡Primer fragmento de la gema de la Naturaleza!»',
      nextNode: 'sb1_ending',
    ),
    'sb1_fail3': const StoryNode(
      id: 'sb1_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«True. Reptiles have dry, scaly skin.»',
      nextNode: 'sb1_ending',
    ),
    'sb1_ending': const StoryNode(
      id: 'sb1_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡BOSS DERROTADO!\n\n'
          'Has combinado tus conocimientos de seres vivos, plantas '
          'y animales para vencer al Guardián.\n\n'
          '💎 Recompensa: Fragmento de Gema Sylva (1/2) · +200 XP',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// BOSS FINAL SYLVA: "El Dragón de la Naturaleza"
/// Tema: TODO Science (repaso general)
/// ═══════════════════════════════════════════════════════════════
final bossFinalSylva = StoryChapter(
  id: 'sylva_boss_final',
  number: 8,
  title: 'El Dragón de la Naturaleza',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'Boss Final: Repaso de toda la ciencia',
  startNodeId: 'sbf_intro',
  nodes: {
    'sbf_intro': const StoryNode(
      id: 'sbf_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐉',
      text: 'En la cima del Bosque Sylva, un volcán dormido despierta. '
          'De su cráter emerge un DRAGÓN de cristal y ramas: el Dragón '
          'de la Naturaleza.\n\n'
          'Su cuerpo está hecho de agua líquida, su aliento es vapor, '
          'y sus escamas son hielo.\n\n'
          '«PRUEBA TU CONOCIMIENTO DE LA NATURALEZA… O ARDEE», '
          'ruge el dragón.\n\n'
          'Orión (temblando): «Es… es enorme. ¡Pero la ciencia es más '
          'grande! ¡Usa TODO lo que sabes!»',
      nextNode: 'sbf_ex1',
    ),
    'sbf_ex1': const StoryNode(
      id: 'sbf_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'El Dragón sopla una onda de frío.',
      question: 'At 0°C, water becomes ___.',
      options: ['Steam', 'Ice', 'Rain', 'Mud'],
      correctIndex: 1,
      hint: '0°C = freezing point. Water becomes ice.',
      onCorrect: 'sbf_ok1',
      onIncorrect: 'sbf_fail1',
    ),
    'sbf_ok1': const StoryNode(
      id: 'sbf_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Ice! El aliento helado del dragón se congela en el aire. '
          'Una escama cae.',
      nextNode: 'sbf_ex2',
    ),
    'sbf_fail1': const StoryNode(
      id: 'sbf_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Ice. At 0°C, water freezes.»',
      nextNode: 'sbf_ex2',
    ),
    'sbf_ex2': const StoryNode(
      id: 'sbf_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🔥',
      text: 'El Dragón lanza fuego de preguntas.',
      question: 'Plants need ___ to make food.',
      options: ['Darkness', 'Sunlight', 'Metal', 'Ice'],
      correctIndex: 1,
      hint: 'Plants use sunlight for photosynthesis.',
      onCorrect: 'sbf_ok2',
      onIncorrect: 'sbf_fail2',
    ),
    'sbf_ok2': const StoryNode(
      id: 'sbf_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Sunlight! Las ramas del Dragón se iluminan y se secan.',
      nextNode: 'sbf_ex3',
    ),
    'sbf_fail2': const StoryNode(
      id: 'sbf_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Sunlight. Plants need sunlight to make food.»',
      nextNode: 'sbf_ex3',
    ),
    'sbf_ex3': const StoryNode(
      id: 'sbf_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'El Dragón grita una pregunta sobre animales.',
      question: 'Is a dolphin a fish or a mammal?',
      options: ['Fish', 'Mammal'],
      correctIndex: 1,
      hint: 'Dolphins breathe air and feed babies milk → mammal.',
      onCorrect: 'sbf_ok3',
      onIncorrect: 'sbf_fail3',
    ),
    'sbf_ok3': const StoryNode(
      id: 'sbf_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Mammal! Una aleta de cristal de dragón se rompe.',
      nextNode: 'sbf_ex4',
    ),
    'sbf_fail3': const StoryNode(
      id: 'sbf_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Mammal. Dolphins breathe air and nurse babies.»',
      nextNode: 'sbf_ex4',
    ),
    'sbf_ex4': const StoryNode(
      id: 'sbf_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'El Dragón escupe bolas de lodo con acertijos.',
      question: 'Bones protect our ___.',
      options: ['Hair', 'Organs', 'Shoes', 'Food'],
      correctIndex: 1,
      hint: 'The skeleton protects our organs (brain, heart, lungs).',
      onCorrect: 'sbf_ok4',
      onIncorrect: 'sbf_fail4',
    ),
    'sbf_ok4': const StoryNode(
      id: 'sbf_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Organs! La coraza de ramas del Dragón se agrieta.',
      nextNode: 'sbf_ex5',
    ),
    'sbf_fail4': const StoryNode(
      id: 'sbf_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Organs. Bones protect our organs.»',
      nextNode: 'sbf_ex5',
    ),
    'sbf_ex5': const StoryNode(
      id: 'sbf_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'PREGUNTA FINAL. El Dragón te mira con sus ojos de hielo.',
      question: 'Insects have ___ legs.',
      options: ['4', '6', '8', '10'],
      correctIndex: 1,
      hint: 'All insects have 6 legs (ants, bees, butterflies…).',
      onCorrect: 'sbf_victoria',
      onIncorrect: 'sbf_fail5',
    ),
    'sbf_victoria': const StoryNode(
      id: 'sbf_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '«¡¡¡6 LEGS!!!»\n\n'
          '¡¡¡BOOOM!!! El Dragón de la Naturaleza EXPLOTA en una '
          'tormenta de cristales, hojas y agua. La naturaleza entera '
          'celebra: árboles florecen, animales cantan.\n\n'
          'La Gema Sylva desciende del cielo como una lágrima de cristal '
          'verde. Al tocarla, sientes la conexión con TODA la naturaleza: '
          'plantas, animales, agua, el cuerpo humano.\n\n'
          'Orión (limpiándose de barro): «¡¡TRES gemas!! La ciencia '
          'nos ha dado poder sobre la naturaleza. ¡Solo falta UNA!»',
      nextNode: 'sbf_ending',
    ),
    'sbf_fail5': const StoryNode(
      id: 'sbf_fail5',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«6. All insects have 6 legs.»',
      nextNode: 'sbf_victoria',
    ),
    'sbf_ending': const StoryNode(
      id: 'sbf_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡¡¡BOSS FINAL DERROTADO!!!\n\n'
          'Has usado TODO lo aprendido en Science:\n\n'
          '• Living/Non-living • Parts of plants\n'
          '• Vertebrates/Invertebrates • Materials\n'
          '• States of water • Human body\n\n'
          '🌿 Recompensa: GEMA SYLVA COMPLETA · +500 XP\n\n'
          '¡TRES gemas recuperadas! Solo queda una…',
    ),
  },
);
