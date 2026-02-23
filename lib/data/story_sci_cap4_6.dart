import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// CAP 4 SYLVA: "El Laboratorio del Alquimista"
/// Tema: Materials — properties (hard, soft, waterproof, transparent)
/// ═══════════════════════════════════════════════════════════════
final chapter4Sylva = StoryChapter(
  id: 'sylva_c04',
  number: 4,
  title: 'El Laboratorio del Alquimista',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'Materials and their properties',
  startNodeId: 'sv4_intro',
  nodes: {
    'sv4_intro': const StoryNode(
      id: 'sv4_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'Al otro lado del laberinto hay un laboratorio subterráneo '
          'lleno de materiales extraños: madera, cristal, metal, goma, '
          'lana...\n\n'
          'Un alquimista de barba verde te saluda: «¡Ah, el aprendiz! '
          'Noctus ha mezclado todos mis materiales. Necesito que me '
          'ayudes a clasificarlos por sus propiedades.»',
      nextNode: 'sv4_ex1',
    ),
    'sv4_ex1': const StoryNode(
      id: 'sv4_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪵',
      text: 'El alquimista señala un trozo de madera.',
      question: 'Wood comes from ___.',
      options: ['Rocks', 'Trees', 'Water', 'Metal'],
      correctIndex: 1,
      hint: 'Wood = madera. It comes from trees!',
      onCorrect: 'sv4_ok1',
      onIncorrect: 'sv4_fail1',
    ),
    'sv4_ok1': const StoryNode(
      id: 'sv4_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Trees! La madera vuelve a su estante correcto.',
      nextNode: 'sv4_ex2',
    ),
    'sv4_fail1': const StoryNode(
      id: 'sv4_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Trees. Wood comes from trees.»',
      nextNode: 'sv4_ex2',
    ),
    'sv4_ex2': const StoryNode(
      id: 'sv4_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪟',
      text: 'Un cristal brilla en la mesa del alquimista.',
      question: 'Glass is transparent. True or false?',
      options: ['True', 'False'],
      correctIndex: 0,
      hint: 'You can see through glass → transparent!',
      onCorrect: 'sv4_ok2',
      onIncorrect: 'sv4_fail2',
    ),
    'sv4_ok2': const StoryNode(
      id: 'sv4_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💎',
      text: 'True! El cristal brilla con la luz que lo atraviesa.',
      nextNode: 'sv4_ex3',
    ),
    'sv4_fail2': const StoryNode(
      id: 'sv4_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«True. Glass is transparent — light goes through it.»',
      nextNode: 'sv4_ex3',
    ),
    'sv4_ex3': const StoryNode(
      id: 'sv4_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧤',
      text: 'El alquimista muestra papel, plástico y algodón mojados.',
      question: 'Which is waterproof? Paper, plastic, or cotton?',
      options: ['Paper', 'Cotton', 'Plastic'],
      correctIndex: 2,
      hint: 'Plastic does not let water through → waterproof!',
      onCorrect: 'sv4_ok3',
      onIncorrect: 'sv4_fail3',
    ),
    'sv4_ok3': const StoryNode(
      id: 'sv4_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🛡️',
      text: 'Plastic! El plástico rebota las gotas de agua mágica.',
      nextNode: 'sv4_ex4',
    ),
    'sv4_fail3': const StoryNode(
      id: 'sv4_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Plastic. It is waterproof — water cannot pass through.»',
      nextNode: 'sv4_ex4',
    ),
    'sv4_ex4': const StoryNode(
      id: 'sv4_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Última prueba del laboratorio.',
      question: 'Wool comes from ___.',
      options: ['Trees', 'Sheep', 'Rocks', 'Fish'],
      correctIndex: 1,
      hint: 'Wool = lana. It comes from sheep!',
      onCorrect: 'sv4_final_ok',
      onIncorrect: 'sv4_final_fail',
    ),
    'sv4_final_ok': const StoryNode(
      id: 'sv4_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐑',
      text: 'Sheep! El alquimista te da un abrazo de lana: «¡Todos mis '
          'materiales están ordenados! Toma esto.» Te entrega un frasco '
          'con polvo de cristal.',
      nextNode: 'sv4_ending',
    ),
    'sv4_final_fail': const StoryNode(
      id: 'sv4_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Sheep. Wool comes from sheep.»',
      nextNode: 'sv4_ending',
    ),
    'sv4_ending': const StoryNode(
      id: 'sv4_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 4 de Sylva completado!\n\n'
          'Conoces los materiales y sus propiedades.\n\n'
          '🧪 Recompensa: Polvo de Cristal',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 5 SYLVA: "La Cueva Sombría"
/// Tema: States of water (solid, liquid, gas)
/// ═══════════════════════════════════════════════════════════════
final chapter5Sylva = StoryChapter(
  id: 'sylva_c05',
  number: 5,
  title: 'La Cueva Sombría',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'States of water: solid, liquid, gas',
  startNodeId: 'sv5_intro',
  nodes: {
    'sv5_intro': const StoryNode(
      id: 'sv5_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧊',
      text: 'Bajo el laboratorio hay una cueva donde el agua cambia '
          'de forma: hielo en las paredes, ríos en el suelo y vapor '
          'saliendo del techo.\n\n'
          'Orión: «El agua tiene TRES estados. Aquí los verás todos a '
          'la vez. Noctus los ha mezclado.»',
      nextNode: 'sv5_ex1',
    ),
    'sv5_ex1': const StoryNode(
      id: 'sv5_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧊',
      text: 'Un bloque de hielo brilla con una pregunta dentro.',
      question: 'Ice is water in ___ state.',
      options: ['Liquid', 'Gas', 'Solid'],
      correctIndex: 2,
      hint: 'Ice is hard and cold. It is water in SOLID state.',
      onCorrect: 'sv5_ok1',
      onIncorrect: 'sv5_fail1',
    ),
    'sv5_ok1': const StoryNode(
      id: 'sv5_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Solid! El hielo brilla azulado y se queda en su sitio.',
      nextNode: 'sv5_ex2',
    ),
    'sv5_fail1': const StoryNode(
      id: 'sv5_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Solid. Ice = water in solid state.»',
      nextNode: 'sv5_ex2',
    ),
    'sv5_ex2': const StoryNode(
      id: 'sv5_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '♨️',
      text: 'Vapor sale del techo de la cueva.',
      question: 'Steam is water in ___ state.',
      options: ['Solid', 'Liquid', 'Gas'],
      correctIndex: 2,
      hint: 'Steam = vapor. It floats in the air → gas state.',
      onCorrect: 'sv5_ok2',
      onIncorrect: 'sv5_fail2',
    ),
    'sv5_ok2': const StoryNode(
      id: 'sv5_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '☁️',
      text: 'Gas! El vapor sube y forma una nube dentro de la cueva.',
      nextNode: 'sv5_ex3',
    ),
    'sv5_fail2': const StoryNode(
      id: 'sv5_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Gas. Steam is water in gas state.»',
      nextNode: 'sv5_ex3',
    ),
    'sv5_ex3': const StoryNode(
      id: 'sv5_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '❄️',
      text: 'Una cascada de la cueva te pregunta en voz de agua.',
      question: 'When water freezes, it becomes ___.',
      options: ['Steam', 'Ice', 'Rain', 'Cloud'],
      correctIndex: 1,
      hint: 'Freeze = congelar. Water at 0°C becomes ice.',
      onCorrect: 'sv5_ok3',
      onIncorrect: 'sv5_fail3',
    ),
    'sv5_ok3': const StoryNode(
      id: 'sv5_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧊',
      text: 'Ice! La cascada se congela creando un puente de hielo.',
      nextNode: 'sv5_ex4',
    ),
    'sv5_fail3': const StoryNode(
      id: 'sv5_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Ice. When water freezes at 0°C, it becomes ice.»',
      nextNode: 'sv5_ex4',
    ),
    'sv5_ex4': const StoryNode(
      id: 'sv5_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Para salir de la cueva, la puerta de cristal te pregunta.',
      question: 'When water boils (100°C), it becomes ___.',
      options: ['Ice', 'Steam', 'Snow', 'Mud'],
      correctIndex: 1,
      hint: 'Boil = hervir. At 100°C water becomes steam (gas).',
      onCorrect: 'sv5_final_ok',
      onIncorrect: 'sv5_final_fail',
    ),
    'sv5_final_ok': const StoryNode(
      id: 'sv5_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '♨️',
      text: 'Steam! La puerta de cristal se empañó con vapor y se '
          'abre suavemente.\n\n'
          'Orión: «Solid ↔ liquid ↔ gas. The water cycle is yours!»',
      nextNode: 'sv5_ending',
    ),
    'sv5_final_fail': const StoryNode(
      id: 'sv5_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Steam. At 100°C, water boils and becomes steam.»',
      nextNode: 'sv5_ending',
    ),
    'sv5_ending': const StoryNode(
      id: 'sv5_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 5 de Sylva completado!\n\n'
          'Dominas los tres estados del agua.\n\n'
          '🧊 Recompensa: Cristal de Hielo',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 6 SYLVA: "La Torre del Sol"
/// Tema: The human body — senses, bones, organs
/// ═══════════════════════════════════════════════════════════════
final chapter6Sylva = StoryChapter(
  id: 'sylva_c06',
  number: 6,
  title: 'La Torre del Sol',
  gemName: 'Sylva',
  subject: 'Science',
  topic: 'The human body: senses and organs',
  startNodeId: 'sv6_intro',
  nodes: {
    'sv6_intro': const StoryNode(
      id: 'sv6_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏰',
      text: 'La cueva te lleva a una torre bañada por la luz del sol. '
          'En las paredes hay un enorme dibujo del cuerpo humano: '
          'huesos, músculos y órganos.\n\n'
          'Orión: «La Gema Sylva no solo controla la naturaleza, '
          'también el cuerpo. Los sentidos, los huesos, los órganos… '
          '¡todo lo que eres por dentro!»',
      nextNode: 'sv6_ex1',
    ),
    'sv6_ex1': const StoryNode(
      id: 'sv6_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '👁️',
      text: 'El dibujo del cuerpo brilla en los cinco sentidos.',
      question: 'How many senses do we have?',
      options: ['3', '4', '5', '6'],
      correctIndex: 2,
      hint: 'Sight, hearing, smell, taste, touch = 5 senses.',
      onCorrect: 'sv6_ok1',
      onIncorrect: 'sv6_fail1',
    ),
    'sv6_ok1': const StoryNode(
      id: 'sv6_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '5! Los cinco sentidos brillan en el dibujo: ojos, oídos, '
          'nariz, lengua, piel.',
      nextNode: 'sv6_ex2',
    ),
    'sv6_fail1': const StoryNode(
      id: 'sv6_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«5 senses: sight, hearing, smell, taste, touch.»',
      nextNode: 'sv6_ex2',
    ),
    'sv6_ex2': const StoryNode(
      id: 'sv6_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '👅',
      text: 'Una parte del dibujo parpadea.',
      question: 'We taste with our ___.',
      options: ['Eyes', 'Ears', 'Tongue', 'Nose'],
      correctIndex: 2,
      hint: 'Tongue = lengua. We use it to taste food.',
      onCorrect: 'sv6_ok2',
      onIncorrect: 'sv6_fail2',
    ),
    'sv6_ok2': const StoryNode(
      id: 'sv6_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '😋',
      text: 'Tongue! El sentido del gusto se activa en el dibujo.',
      nextNode: 'sv6_ex3',
    ),
    'sv6_fail2': const StoryNode(
      id: 'sv6_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Tongue. We taste with our tongue.»',
      nextNode: 'sv6_ex3',
    ),
    'sv6_ex3': const StoryNode(
      id: 'sv6_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🦴',
      text: 'El esqueleto del dibujo se mueve.',
      question: 'The skeleton is made of ___.',
      options: ['Muscles', 'Bones', 'Skin', 'Hair'],
      correctIndex: 1,
      hint: 'Skeleton = esqueleto. It is made of bones.',
      onCorrect: 'sv6_ok3',
      onIncorrect: 'sv6_fail3',
    ),
    'sv6_ok3': const StoryNode(
      id: 'sv6_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💀',
      text: 'Bones! El esqueleto hace un bailecito de felicidad.',
      nextNode: 'sv6_ex4',
    ),
    'sv6_fail3': const StoryNode(
      id: 'sv6_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Bones. The skeleton is made of bones.»',
      nextNode: 'sv6_ex4',
    ),
    'sv6_ex4': const StoryNode(
      id: 'sv6_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Último reto de la torre.',
      question: 'The heart pumps ___.',
      options: ['Air', 'Water', 'Blood', 'Food'],
      correctIndex: 2,
      hint: 'The heart pumps blood through our body.',
      onCorrect: 'sv6_final_ok',
      onIncorrect: 'sv6_final_fail',
    ),
    'sv6_final_ok': const StoryNode(
      id: 'sv6_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '❤️',
      text: 'Blood! El corazón del dibujo late con un ritmo suave.\n\n'
          'Orión: «Senses, bones, organs… you know your body!»',
      nextNode: 'sv6_ending',
    ),
    'sv6_final_fail': const StoryNode(
      id: 'sv6_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Blood. The heart pumps blood.»',
      nextNode: 'sv6_ending',
    ),
    'sv6_ending': const StoryNode(
      id: 'sv6_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 6 de Sylva completado!\n\n'
          'Conoces los sentidos, huesos y órganos del cuerpo.\n\n'
          '🏰 Recompensa: Escudo del Cuerpo',
    ),
  },
);
