import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// CAP 1 SYLVA: "El Jardín Viviente"
/// Tema: Living vs. Non-living things (seres vivos vs inertes)
/// ═══════════════════════════════════════════════════════════════
final chapter1Sylva = StoryChapter(
  id: 'sylva_c01',
  number: 1,
  title: 'El Jardín Viviente',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'Living and non-living things',
  startNodeId: 'sv1_intro',
  nodes: {
    'sv1_intro': const StoryNode(
      id: 'sv1_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌿',
      text: 'Dos gemas recuperadas. El mapa señala un nuevo reino: '
          'el BOSQUE SYLVA, donde la naturaleza habla en inglés.\n\n'
          'Al cruzar la entrada, un jardín mágico despierta. Las flores '
          'abren los ojos, los hongos roncan y las piedras… no hacen nada.\n\n'
          'Orión: «En Sylva, la ciencia manda. Las criaturas vivas se '
          'mueven, crecen y respiran. Las inertes, no. Aprende a distinguirlas.»',
      nextNode: 'sv1_ex1',
    ),
    'sv1_ex1': const StoryNode(
      id: 'sv1_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🐕',
      text: 'Una piedra y un perro están frente a ti. '
          'Solo uno está VIVO.',
      question: 'Is a dog living or non-living?',
      options: ['Non-living', 'Living'],
      correctIndex: 1,
      hint: 'A dog breathes, eats, grows → it is LIVING.',
      onCorrect: 'sv1_ok1',
      onIncorrect: 'sv1_fail1',
    ),
    'sv1_ok1': const StoryNode(
      id: 'sv1_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Living! El perro ladra feliz y una flor brota a su lado.',
      nextNode: 'sv1_ex2',
    ),
    'sv1_fail1': const StoryNode(
      id: 'sv1_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Living. A dog can move, eat, and breathe. It is alive!»',
      nextNode: 'sv1_ex2',
    ),
    'sv1_ex2': const StoryNode(
      id: 'sv1_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪨',
      text: 'Una roca enorme bloquea el camino. El jardín te pregunta...',
      question: 'Is a rock living or non-living?',
      options: ['Living', 'Non-living'],
      correctIndex: 1,
      hint: 'A rock does not eat, breathe, or grow → non-living.',
      onCorrect: 'sv1_ok2',
      onIncorrect: 'sv1_fail2',
    ),
    'sv1_ok2': const StoryNode(
      id: 'sv1_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: 'Non-living! La roca se aparta. No está viva, así que '
          'no puede desobedecerte.',
      nextNode: 'sv1_ex3',
    ),
    'sv1_fail2': const StoryNode(
      id: 'sv1_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Non-living. Rocks don\'t grow or breathe.»',
      nextNode: 'sv1_ex3',
    ),
    'sv1_ex3': const StoryNode(
      id: 'sv1_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🌸',
      text: '«Tres cosas frente a ti: una flor, un lápiz y un cristal.»',
      question: 'Which is alive? A flower, a pencil, or a glass?',
      options: ['A pencil', 'A glass', 'A flower'],
      correctIndex: 2,
      hint: 'A flower grows, makes seeds, and needs water → living.',
      onCorrect: 'sv1_ok3',
      onIncorrect: 'sv1_fail3',
    ),
    'sv1_ok3': const StoryNode(
      id: 'sv1_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌺',
      text: 'A flower! La flor abre sus pétalos y lanza polen dorado.',
      nextNode: 'sv1_ex4',
    ),
    'sv1_fail3': const StoryNode(
      id: 'sv1_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«A flower. It grows, needs water and sunlight.»',
      nextNode: 'sv1_ex4',
    ),
    'sv1_ex4': const StoryNode(
      id: 'sv1_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Para salir del jardín, una última pregunta brilla en el suelo.',
      question: 'Living things can grow. True or false?',
      options: ['True', 'False'],
      correctIndex: 0,
      hint: 'All living things grow: plants, animals, humans!',
      onCorrect: 'sv1_final_ok',
      onIncorrect: 'sv1_final_fail',
    ),
    'sv1_final_ok': const StoryNode(
      id: 'sv1_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌱',
      text: 'True! Todo el jardín crece a tu alrededor: las flores '
          'se hacen enormes, los árboles tocan las nubes.\n\n'
          'Orión: «Living things grow, eat, breathe and reproduce. '
          'You have learned the first law of Sylva!»',
      nextNode: 'sv1_ending',
    ),
    'sv1_final_fail': const StoryNode(
      id: 'sv1_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«True! All living things grow.»',
      nextNode: 'sv1_ending',
    ),
    'sv1_ending': const StoryNode(
      id: 'sv1_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 1 de Sylva completado!\n\n'
          'Distingues seres vivos de inertes.\n\n'
          '🌿 Recompensa: Semilla del Jardín',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 2 SYLVA: "La Puerta del Clima"
/// Tema: Parts of a plant
/// ═══════════════════════════════════════════════════════════════
final chapter2Sylva = StoryChapter(
  id: 'sylva_c02',
  number: 2,
  title: 'La Puerta del Clima',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'Parts of a plant',
  startNodeId: 'sv2_intro',
  nodes: {
    'sv2_intro': const StoryNode(
      id: 'sv2_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌳',
      text: 'Un árbol gigante con una puerta en el tronco te bloquea '
          'el paso. Sus hojas, raíces, tallo y flores brillan con '
          'colores diferentes.\n\n'
          '«Solo quien conozca mis partes podrá entrar», susurra el árbol.\n\n'
          'Orión: «Es el Árbol de la Ciencia. Cada parte tiene una función.»',
      nextNode: 'sv2_ex1',
    ),
    'sv2_ex1': const StoryNode(
      id: 'sv2_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🌱',
      text: 'Las raíces del árbol brillan con un acertijo.',
      question: 'Which part of the plant takes in water?',
      options: ['Leaf', 'Root', 'Flower', 'Stem'],
      correctIndex: 1,
      hint: 'Roots go underground and absorb water and nutrients.',
      onCorrect: 'sv2_ok1',
      onIncorrect: 'sv2_fail1',
    ),
    'sv2_ok1': const StoryNode(
      id: 'sv2_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Root! Las raíces brillan de azul y se oye el agua fluyendo.',
      nextNode: 'sv2_ex2',
    ),
    'sv2_fail1': const StoryNode(
      id: 'sv2_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Root. Roots absorb water from the soil.»',
      nextNode: 'sv2_ex2',
    ),
    'sv2_ex2': const StoryNode(
      id: 'sv2_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🍃',
      text: 'Las hojas del árbol se iluminan de verde.',
      question: 'Which part of the plant makes food using sunlight?',
      options: ['Root', 'Stem', 'Leaf', 'Flower'],
      correctIndex: 2,
      hint: 'Leaves use sunlight to make food (photosynthesis).',
      onCorrect: 'sv2_ok2',
      onIncorrect: 'sv2_fail2',
    ),
    'sv2_ok2': const StoryNode(
      id: 'sv2_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '☀️',
      text: 'Leaf! Las hojas brillan intensamente absorbiendo la luz solar.',
      nextNode: 'sv2_ex3',
    ),
    'sv2_fail2': const StoryNode(
      id: 'sv2_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Leaf. Leaves make food using sunlight.»',
      nextNode: 'sv2_ex3',
    ),
    'sv2_ex3': const StoryNode(
      id: 'sv2_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🌿',
      text: 'El tronco del árbol vibra esperando tu respuesta.',
      question: 'What holds the plant up and carries water?',
      options: ['Root', 'Leaf', 'Stem', 'Flower'],
      correctIndex: 2,
      hint: 'The stem supports the plant and transports water upward.',
      onCorrect: 'sv2_ok3',
      onIncorrect: 'sv2_fail3',
    ),
    'sv2_ok3': const StoryNode(
      id: 'sv2_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏗️',
      text: 'Stem! El tronco se ilumina marrón dorado. ¡Casi lo tienes!',
      nextNode: 'sv2_ex4',
    ),
    'sv2_fail3': const StoryNode(
      id: 'sv2_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Stem. The stem holds the plant and carries water.»',
      nextNode: 'sv2_ex4',
    ),
    'sv2_ex4': const StoryNode(
      id: 'sv2_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'La flor del árbol brilla con luz rosa. Última pregunta.',
      question: 'Where are the seeds in a plant?',
      options: ['In the root', 'In the leaf', 'In the flower/fruit', 'In the stem'],
      correctIndex: 2,
      hint: 'Flowers become fruits, and fruits contain seeds.',
      onCorrect: 'sv2_final_ok',
      onIncorrect: 'sv2_final_fail',
    ),
    'sv2_final_ok': const StoryNode(
      id: 'sv2_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌸',
      text: 'In the flower! La flor se abre y libera semillas doradas. '
          'La puerta del tronco se abre de par en par.\n\n'
          'Orión: «Root, stem, leaf, flower. You know the four parts!»',
      nextNode: 'sv2_ending',
    ),
    'sv2_final_fail': const StoryNode(
      id: 'sv2_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«In the flower or fruit. Seeds grow inside them.»',
      nextNode: 'sv2_ending',
    ),
    'sv2_ending': const StoryNode(
      id: 'sv2_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 2 de Sylva completado!\n\n'
          'Conoces las 4 partes de una planta.\n\n'
          '🌳 Recompensa: Hoja del Árbol Sabio',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 3 SYLVA: "El Laberinto de Piedra"
/// Tema: Vertebrates vs. Invertebrates + Animal groups
/// ═══════════════════════════════════════════════════════════════
final chapter3Sylva = StoryChapter(
  id: 'sylva_c03',
  number: 3,
  title: 'El Laberinto de Piedra',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'Vertebrates, invertebrates, and animal groups',
  startNodeId: 'sv3_intro',
  nodes: {
    'sv3_intro': const StoryNode(
      id: 'sv3_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏛️',
      text: 'Dentro del árbol hay un laberinto de piedra. Las paredes '
          'están talladas con siluetas de animales: gatos, mariposas, '
          'peces, ranas.\n\n'
          '«Para avanzar debes clasificar los animales», dice una voz '
          'que sale de las paredes. «Vertebrados o invertebrados.»\n\n'
          'Orión: «Vertebrados tienen columna vertebral. Invertebrados, no.»',
      nextNode: 'sv3_ex1',
    ),
    'sv3_ex1': const StoryNode(
      id: 'sv3_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🐱',
      text: 'Una silueta de gato brilla en la pared.',
      question: 'Does a cat have a backbone? (vertebrate/invertebrate)',
      options: ['No — invertebrate', 'Yes — vertebrate'],
      correctIndex: 1,
      hint: 'Cats have bones and a backbone → vertebrate.',
      onCorrect: 'sv3_ok1',
      onIncorrect: 'sv3_fail1',
    ),
    'sv3_ok1': const StoryNode(
      id: 'sv3_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Vertebrate! El muro se abre y el gato de piedra cobra vida.',
      nextNode: 'sv3_ex2',
    ),
    'sv3_fail1': const StoryNode(
      id: 'sv3_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Yes, vertebrate. Cats have a backbone.»',
      nextNode: 'sv3_ex2',
    ),
    'sv3_ex2': const StoryNode(
      id: 'sv3_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🦋',
      text: 'Una mariposa de cristal revolotea entre las piedras.',
      question: 'Does a butterfly have a backbone?',
      options: ['Yes — vertebrate', 'No — invertebrate'],
      correctIndex: 1,
      hint: 'Insects like butterflies have no backbone → invertebrate.',
      onCorrect: 'sv3_ok2',
      onIncorrect: 'sv3_fail2',
    ),
    'sv3_ok2': const StoryNode(
      id: 'sv3_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🦋',
      text: 'Invertebrate! La mariposa se posa en tu hombro, agradecida.',
      nextNode: 'sv3_ex3',
    ),
    'sv3_fail2': const StoryNode(
      id: 'sv3_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«No — invertebrate. Butterflies have no backbone.»',
      nextNode: 'sv3_ex3',
    ),
    'sv3_ex3': const StoryNode(
      id: 'sv3_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🐬',
      text: 'Una fuente muestra un delfín saltando. La pared pregunta...',
      question: 'A dolphin is a mammal, fish, or bird?',
      options: ['Fish', 'Bird', 'Mammal'],
      correctIndex: 2,
      hint: 'Dolphins breathe air and feed babies with milk → mammal.',
      onCorrect: 'sv3_ok3',
      onIncorrect: 'sv3_fail3',
    ),
    'sv3_ok3': const StoryNode(
      id: 'sv3_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐬',
      text: 'Mammal! El delfín salta más alto, salpicando agua mágica.',
      nextNode: 'sv3_ex4',
    ),
    'sv3_fail3': const StoryNode(
      id: 'sv3_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Mammal. Dolphins breathe air and feed babies with milk.»',
      nextNode: 'sv3_ex4',
    ),
    'sv3_ex4': const StoryNode(
      id: 'sv3_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'La puerta final del laberinto necesita una respuesta más.',
      question: 'Fish breathe with ___.',
      options: ['Lungs', 'Gills', 'Skin', 'Wings'],
      correctIndex: 1,
      hint: 'Fish have gills to breathe underwater.',
      onCorrect: 'sv3_final_ok',
      onIncorrect: 'sv3_final_fail',
    ),
    'sv3_final_ok': const StoryNode(
      id: 'sv3_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐟',
      text: 'Gills! La puerta se abre con un sonido de cascada.\n\n'
          'Orión: «Mammals, birds, reptiles, amphibians, fish… '
          'and all the invertebrates. You know them all!»',
      nextNode: 'sv3_ending',
    ),
    'sv3_final_fail': const StoryNode(
      id: 'sv3_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Gills. Fish breathe with gills, not lungs.»',
      nextNode: 'sv3_ending',
    ),
    'sv3_ending': const StoryNode(
      id: 'sv3_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 3 de Sylva completado!\n\n'
          'Clasificas animales en vertebrados/invertebrados y sus grupos.\n\n'
          '🏛️ Recompensa: Medalla del Laberinto',
    ),
  },
);
