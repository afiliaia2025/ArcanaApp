import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// CAP 6 LEXIS: "El Cuento Roto"
/// Tema: Signos de puntuación y ordenar oraciones (U6)
/// ═══════════════════════════════════════════════════════════════
final chapter6Lexis = StoryChapter(
  id: 'lexis_c06',
  number: 7,
  title: 'El Cuento Roto',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Signos de puntuación y orden de oraciones',
  startNodeId: 'lx6_intro',
  nodes: {
    'lx6_intro': const StoryNode(
      id: 'lx6_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📕',
      text: 'Más allá de los restos del Letrón encuentras el Claro de '
          'los Cuentistas: un lugar donde las historias cobran vida al '
          'ser leídas en voz alta. Pero los cuentos están ROTOS.\n\n'
          'Un anciano narrador te mira con los ojos llorosos: «Noctus '
          'arrancó los signos de puntuación. Sin puntos, comas, '
          'interrogaciones y exclamaciones, las historias no tienen '
          'sentido. ¡Ayúdame a repararlas!»',
      nextNode: 'lx6_ex1',
    ),
    'lx6_ex1': const StoryNode(
      id: 'lx6_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '❓',
      text: 'El primer cuento roto dice: "_Dónde vives_" sin signos.',
      question: '¿Qué signos necesita "_Dónde vives_"?',
      options: [
        '¡Dónde vives!',
        '¿Dónde vives?',
        'Dónde vives.',
        '"Dónde vives"',
      ],
      correctIndex: 1,
      hint: 'Es una pregunta. Las preguntas llevan ¿...? (apertura y cierre).',
      onCorrect: 'lx6_ok1',
      onIncorrect: 'lx6_fail1',
    ),
    'lx6_ok1': const StoryNode(
      id: 'lx6_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡¿Dónde vives?! Los signos de interrogación aparecen en el '
          'libro con un destello azul. El cuento empieza a moverse: '
          'un personaje de tinta sale de la página y pregunta a otro.',
      nextNode: 'lx6_ex2',
    ),
    'lx6_fail1': const StoryNode(
      id: 'lx6_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¿Dónde vives? Es una pregunta, lleva ¿...?»',
      nextNode: 'lx6_ex2',
    ),
    'lx6_ex2': const StoryNode(
      id: 'lx6_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '❗',
      text: 'Otro cuento dice: "_Qué sorpresa_" sin signos.',
      question: '¿Qué signos necesita "_Qué sorpresa_"?',
      options: [
        '¿Qué sorpresa?',
        'Qué sorpresa.',
        '¡Qué sorpresa!',
        '"Qué sorpresa"',
      ],
      correctIndex: 2,
      hint: 'Expresa emoción. Las exclamaciones llevan ¡...!',
      onCorrect: 'lx6_ok2',
      onIncorrect: 'lx6_fail2',
    ),
    'lx6_ok2': const StoryNode(
      id: 'lx6_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🎭',
      text: '¡Qué sorpresa! Los signos de exclamación explotan en fuegos '
          'artificiales de tinta. Un personaje de cuento salta de la página '
          'con cara de asombro.',
      nextNode: 'lx6_ex3',
    ),
    'lx6_fail2': const StoryNode(
      id: 'lx6_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡Qué sorpresa! Es una emoción, lleva ¡...!»',
      nextNode: 'lx6_ex3',
    ),
    'lx6_ex3': const StoryNode(
      id: 'lx6_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🔀',
      text: 'El tercer cuento tiene las palabras desordenadas.',
      question: 'Ordena la frase: "come / gato / El / pescado"',
      options: [
        'Gato El come pescado',
        'Come El gato pescado',
        'El gato come pescado',
        'Pescado come El gato',
      ],
      correctIndex: 2,
      hint: 'Sujeto + verbo + complemento: El gato come pescado.',
      onCorrect: 'lx6_ok3',
      onIncorrect: 'lx6_fail3',
    ),
    'lx6_ok3': const StoryNode(
      id: 'lx6_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐱',
      text: '¡El gato come pescado! Un gato de tinta aparece comiendo '
          'un pescado de tinta. Los cuentos están volviendo a la vida.',
      nextNode: 'lx6_ex4',
    ),
    'lx6_fail3': const StoryNode(
      id: 'lx6_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«El gato come pescado. Sujeto + verbo + complemento.»',
      nextNode: 'lx6_ex4',
    ),
    'lx6_ex4': const StoryNode(
      id: 'lx6_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El último cuento, el más importante, necesita una frase bien '
          'ordenada para completar el final.',
      question: 'Ordena: "vuela / búho / El / alto / muy"',
      options: [
        'Búho El vuela muy alto',
        'El alto búho muy vuela',
        'El búho vuela muy alto',
        'Muy alto vuela El búho',
      ],
      correctIndex: 2,
      hint: 'El búho (sujeto) + vuela (verbo) + muy alto (complemento).',
      onCorrect: 'lx6_final_ok',
      onIncorrect: 'lx6_final_fail',
    ),
    'lx6_final_ok': const StoryNode(
      id: 'lx6_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📖',
      text: '¡El búho vuela muy alto! Orión se ve reflejado en las páginas '
          'del cuento y se sonroja. El narrador te abraza.\n\n'
          '«¡Los cuentos están vivos otra vez! ¡Gracias, aprendiz!»',
      nextNode: 'lx6_ending',
    ),
    'lx6_final_fail': const StoryNode(
      id: 'lx6_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«El búho vuela muy alto. ¡Ese soy yo!»',
      nextNode: 'lx6_ending',
    ),
    'lx6_ending': const StoryNode(
      id: 'lx6_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 6 de Lexis completado!\n\n'
          'Dominas signos de puntuación y orden de oraciones.\n\n'
          '📕 Recompensa: Pluma del Narrador',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 7 LEXIS: "Los Verbos del Tiempo"
/// Tema: Pasado, presente, futuro y conjugación básica (U7)
/// ═══════════════════════════════════════════════════════════════
final chapter7Lexis = StoryChapter(
  id: 'lexis_c07',
  number: 8,
  title: 'Los Verbos del Tiempo',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Verbos: pasado, presente y futuro',
  startNodeId: 'lx7_intro',
  nodes: {
    'lx7_intro': const StoryNode(
      id: 'lx7_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⏳',
      text: 'El camino te lleva a un reloj de arena gigante que está '
          'PARADO. Un ermitaño con barba de palabras vigila el reloj.\n\n'
          '«El reloj del Bosque Lexis controla los tiempos verbales: '
          'pasado, presente y futuro. Noctus lo detuvo. Sin él, todo '
          'ocurre a la vez y nadie sabe si algo YA pasó, ESTÁ pasando '
          'o VA A pasar.»',
      nextNode: 'lx7_ex1',
    ),
    'lx7_ex1': const StoryNode(
      id: 'lx7_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⏪',
      text: 'Para reiniciar el reloj, debes clasificar acciones.',
      question: '"Ayer comí pizza." ¿Es pasado, presente o futuro?',
      options: ['Pasado', 'Presente', 'Futuro'],
      correctIndex: 0,
      hint: '"Ayer" = ya ocurrió. "Comí" es verbo en pasado.',
      onCorrect: 'lx7_ok1',
      onIncorrect: 'lx7_fail1',
    ),
    'lx7_ok1': const StoryNode(
      id: 'lx7_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Pasado! La arena del reloj empieza a caer hacia atrás. '
          'El pasado se activa.',
      nextNode: 'lx7_ex2',
    ),
    'lx7_fail1': const StoryNode(
      id: 'lx7_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Pasado. "Ayer" + "comí" = ya ocurrió.»',
      nextNode: 'lx7_ex2',
    ),
    'lx7_ex2': const StoryNode(
      id: 'lx7_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⏺️',
      text: 'Ahora necesitas activar el presente.',
      question: '"Ahora estudio." ¿Es pasado, presente o futuro?',
      options: ['Pasado', 'Presente', 'Futuro'],
      correctIndex: 1,
      hint: '"Ahora" = en este momento. "Estudio" es presente.',
      onCorrect: 'lx7_ok2',
      onIncorrect: 'lx7_fail2',
    ),
    'lx7_ok2': const StoryNode(
      id: 'lx7_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⏳',
      text: '¡Presente! La arena fluye normal. El presente funciona.',
      nextNode: 'lx7_ex3',
    ),
    'lx7_fail2': const StoryNode(
      id: 'lx7_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Presente. "Ahora" + "estudio" = está ocurriendo.»',
      nextNode: 'lx7_ex3',
    ),
    'lx7_ex3': const StoryNode(
      id: 'lx7_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⏩',
      text: 'Por último, el futuro.',
      question: '"Mañana iré al parque." ¿Es pasado, presente o futuro?',
      options: ['Pasado', 'Presente', 'Futuro'],
      correctIndex: 2,
      hint: '"Mañana" = no ha ocurrido. "Iré" es futuro.',
      onCorrect: 'lx7_ok3',
      onIncorrect: 'lx7_fail3',
    ),
    'lx7_ok3': const StoryNode(
      id: 'lx7_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '¡Futuro! La arena brilla dorada. ¡El reloj funciona otra vez!',
      nextNode: 'lx7_ex4',
    ),
    'lx7_fail3': const StoryNode(
      id: 'lx7_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Futuro. "Mañana" + "iré" = va a ocurrir.»',
      nextNode: 'lx7_ex4',
    ),
    'lx7_ex4': const StoryNode(
      id: 'lx7_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'El ermitaño sonríe: «Una última prueba. Conjugar un verbo.»',
      question: '"Yo ___ (cantar, presente)". ¿Qué va en el hueco?',
      options: ['canté', 'canto', 'cantaré', 'cantaba'],
      correctIndex: 1,
      hint: 'Yo + cantar en presente = yo canto.',
      onCorrect: 'lx7_final_ok',
      onIncorrect: 'lx7_final_fail',
    ),
    'lx7_final_ok': const StoryNode(
      id: 'lx7_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⏳',
      text: '¡Yo canto! El reloj de arena se llena de luz. El ermitaño '
          'te entrega una llave hecha de arena dorada.\n\n'
          '«Con esto puedes viajar entre los tiempos verbales sin perderte.»',
      nextNode: 'lx7_ending',
    ),
    'lx7_final_fail': const StoryNode(
      id: 'lx7_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Canto. Yo canto, tú cantas, él canta.»',
      nextNode: 'lx7_ending',
    ),
    'lx7_ending': const StoryNode(
      id: 'lx7_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 7 de Lexis completado!\n\n'
          'Dominas los tiempos verbales y conjugación básica.\n\n'
          '⏳ Recompensa: Llave del Tiempo',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 8 LEXIS: "El Poema de la Puerta"
/// Tema: Ortografía ga/gue/gui/güe/güi y J/G (U8)
/// ═══════════════════════════════════════════════════════════════
final chapter8Lexis = StoryChapter(
  id: 'lexis_c08',
  number: 9,
  title: 'El Poema de la Puerta',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Ortografía: G/GU/GÜ y J',
  startNodeId: 'lx8_intro',
  nodes: {
    'lx8_intro': const StoryNode(
      id: 'lx8_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El reloj del tiempo señala una puerta escondida entre dos '
          'árboles. La puerta tiene un poema tallado, pero algunas '
          'palabras están borrosas.\n\n'
          '«Este poema es la contraseña», dice Orión. «Pero las letras G '
          'y J se han mezclado por culpa del hechizo de Noctus.»',
      nextNode: 'lx8_ex1',
    ),
    'lx8_ex1': const StoryNode(
      id: 'lx8_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📝',
      text: 'El primer verso del poema dice: "La ___ toca melodías".',
      question: '¿Cuál es correcta: "guitarra" o "gitarra"?',
      options: ['gitarra', 'guitarra'],
      correctIndex: 1,
      hint: 'Antes de I se escribe GUI: guitarra, guisante, águila.',
      onCorrect: 'lx8_ok1',
      onIncorrect: 'lx8_fail1',
    ),
    'lx8_ok1': const StoryNode(
      id: 'lx8_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🎸',
      text: '¡Guitarra! La palabra aparece brillante en el poema. '
          'Se oye una melodía suave desde detrás de la puerta.',
      nextNode: 'lx8_ex2',
    ),
    'lx8_fail1': const StoryNode(
      id: 'lx8_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Guitarra. GUI antes de I para sonido "g" suave.»',
      nextNode: 'lx8_ex2',
    ),
    'lx8_ex2': const StoryNode(
      id: 'lx8_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📝',
      text: 'El segundo verso: "El ___ vive en el hielo".',
      question: '¿Cuál es correcta: "pingüino" o "pinguino"?',
      options: ['pinguino', 'pingüino'],
      correctIndex: 1,
      hint: 'Cuando la U SÍ suena después de G antes de I/E, '
          'lleva diéresis: pingüino, cigüeña.',
      onCorrect: 'lx8_ok2',
      onIncorrect: 'lx8_fail2',
    ),
    'lx8_ok2': const StoryNode(
      id: 'lx8_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐧',
      text: '¡Pingüino! Con diéresis. Un pingüino de tinta sale del '
          'poema y hace una reverencia.',
      nextNode: 'lx8_ex3',
    ),
    'lx8_fail2': const StoryNode(
      id: 'lx8_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Pingüino. Si la U suena, lleva diéresis (¨).»',
      nextNode: 'lx8_ex3',
    ),
    'lx8_ex3': const StoryNode(
      id: 'lx8_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📝',
      text: 'El tercer verso: "El ___ del cuento tiene poderes".',
      question: '¿Cuál es correcta: "genio" o "jenio"?',
      options: ['jenio', 'genio'],
      correctIndex: 1,
      hint: 'GE se escribe con G: genio, gente, general.',
      onCorrect: 'lx8_ok3',
      onIncorrect: 'lx8_fail3',
    ),
    'lx8_ok3': const StoryNode(
      id: 'lx8_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧞',
      text: '¡Genio! La puerta empieza a vibrar. Solo falta un verso.',
      nextNode: 'lx8_ex4',
    ),
    'lx8_fail3': const StoryNode(
      id: 'lx8_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Genio. GE con G.»',
      nextNode: 'lx8_ex4',
    ),
    'lx8_ex4': const StoryNode(
      id: 'lx8_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El último verso: "El ___ lanza agua por su boca".',
      question: '¿Cuál es correcta: "guerrero" o "gerrero"?',
      options: ['gerrero', 'guerrero'],
      correctIndex: 1,
      hint: 'GUE antes de E: guerrero, guerra, manguera.',
      onCorrect: 'lx8_final_ok',
      onIncorrect: 'lx8_final_fail',
    ),
    'lx8_final_ok': const StoryNode(
      id: 'lx8_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '¡Guerrero! El poema está completo. La puerta se abre con '
          'un sonido de campanillas. Al otro lado, un jardín secreto '
          'lleno de flores con forma de letras.\n\n'
          'Orión: «¡Has dominado las letras más traicioneras!»',
      nextNode: 'lx8_ending',
    ),
    'lx8_final_fail': const StoryNode(
      id: 'lx8_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Guerrero. GUE antes de E.»',
      nextNode: 'lx8_ending',
    ),
    'lx8_ending': const StoryNode(
      id: 'lx8_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 8 de Lexis completado!\n\n'
          'Dominas G/GU/GÜ y la ortografía de J/G.\n\n'
          '🚪 Recompensa: Pergamino del Poema',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 9 LEXIS: "La Carta a Numeralia"
/// Tema: Comprensión lectora (U9)
/// ═══════════════════════════════════════════════════════════════
final chapter9Lexis = StoryChapter(
  id: 'lexis_c09',
  number: 10,
  title: 'La Carta a Numeralia',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Comprensión lectora',
  startNodeId: 'lx9_intro',
  nodes: {
    'lx9_intro': const StoryNode(
      id: 'lx9_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✉️',
      text: 'En el jardín secreto encuentras una paloma mensajera con '
          'una carta atada a la pata. Es una carta urgente que alguien '
          'de Numeralia envió pidiendo ayuda.\n\n'
          'Orión: «Necesitamos leer y ENTENDER exactamente qué dice '
          'para poder ayudar. La comprensión lectora es clave.»',
      nextNode: 'lx9_ex1',
    ),
    'lx9_ex1': const StoryNode(
      id: 'lx9_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'La carta dice: "El gato subió al árbol porque el perro '
          'lo perseguía."',
      question: '¿Por qué subió el gato al árbol?',
      options: [
        'Porque tenía hambre',
        'Porque el perro lo perseguía',
        'Porque quería dormir',
        'Porque llovía',
      ],
      correctIndex: 1,
      hint: 'Lee otra vez: "…porque el PERRO lo perseguía."',
      onCorrect: 'lx9_ok1',
      onIncorrect: 'lx9_fail1',
    ),
    'lx9_ok1': const StoryNode(
      id: 'lx9_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Correcto! El gato huía del perro. La primera parte de '
          'la carta está descifrada. Sigue contienda más mensajes.',
      nextNode: 'lx9_ex2',
    ),
    'lx9_fail1': const StoryNode(
      id: 'lx9_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Porque el perro lo perseguía. La respuesta está en el texto.»',
      nextNode: 'lx9_ex2',
    ),
    'lx9_ex2': const StoryNode(
      id: 'lx9_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'Otra parte de la carta: "María compró 3 manzanas y '
          '2 plátanos."',
      question: '¿Cuántas FRUTAS compró María en total?',
      options: ['3', '5', '2', '6'],
      correctIndex: 1,
      hint: '3 manzanas + 2 plátanos = 5 frutas.',
      onCorrect: 'lx9_ok2',
      onIncorrect: 'lx9_fail2',
    ),
    'lx9_ok2': const StoryNode(
      id: 'lx9_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🍎',
      text: '¡5 frutas! La carta se despliega más. Hay un mensaje importante '
          'sobre los Bruminos.',
      nextNode: 'lx9_ex3',
    ),
    'lx9_fail2': const StoryNode(
      id: 'lx9_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«5. 3 manzanas + 2 plátanos = 5.»',
      nextNode: 'lx9_ex3',
    ),
    'lx9_ex3': const StoryNode(
      id: 'lx9_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'La carta dice: "Primero desayunó, luego se lavó '
          'los dientes."',
      question: '¿Qué hizo PRIMERO?',
      options: ['Se lavó los dientes', 'Desayunó', 'Se vistió', 'Jugó'],
      correctIndex: 1,
      hint: '"Primero desayunó" = desayunar va antes.',
      onCorrect: 'lx9_ok3',
      onIncorrect: 'lx9_fail3',
    ),
    'lx9_ok3': const StoryNode(
      id: 'lx9_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📋',
      text: '¡Desayunó primero! Entiendes el orden de los eventos. '
          'La carta revela su mensaje final.',
      nextNode: 'lx9_ex4',
    ),
    'lx9_fail3': const StoryNode(
      id: 'lx9_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Desayunó. "PRIMERO desayunó" = es lo que hizo antes.»',
      nextNode: 'lx9_ex4',
    ),
    'lx9_ex4': const StoryNode(
      id: 'lx9_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El mensaje final de la carta: "Noctus robó las gemas '
          'porque quería ser el más poderoso."',
      question: '¿Por qué Noctus robó las gemas?',
      options: [
        'Porque estaba aburrido',
        'Porque quería ser el más poderoso',
        'Porque le gustan los cristales',
        'Porque se lo pidieron',
      ],
      correctIndex: 1,
      hint: '"…porque quería ser el más poderoso."',
      onCorrect: 'lx9_final_ok',
      onIncorrect: 'lx9_final_fail',
    ),
    'lx9_final_ok': const StoryNode(
      id: 'lx9_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '¡Porque quería ser poderoso! Ahora entiendes la motivación '
          'de Noctus. Conocer las razones del enemigo te hace más fuerte.\n\n'
          'Orión: «Leer y entender salva vidas en Numeralia.»',
      nextNode: 'lx9_ending',
    ),
    'lx9_final_fail': const StoryNode(
      id: 'lx9_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Porque quería ser el más poderoso. Eso dice el texto.»',
      nextNode: 'lx9_ending',
    ),
    'lx9_ending': const StoryNode(
      id: 'lx9_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 9 de Lexis completado!\n\n'
          'Tu comprensión lectora es ahora una herramienta poderosa.\n\n'
          '✉️ Recompensa: Paloma Mensajera',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 10 LEXIS: "El Mapa del Tesoro"
/// Tema: Mayúsculas y reglas de escritura (U10)
/// ═══════════════════════════════════════════════════════════════
final chapter10Lexis = StoryChapter(
  id: 'lexis_c10',
  number: 11,
  title: 'El Mapa del Tesoro',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Mayúsculas y reglas de escritura',
  startNodeId: 'lx10_intro',
  nodes: {
    'lx10_intro': const StoryNode(
      id: 'lx10_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🗺️',
      text: 'La paloma mensajera trae un mapa del tesoro, ¡pero está '
          'escrito TODO en minúsculas! Los nombres de ciudades, personas '
          'y lugares no tienen mayúsculas.\n\n'
          'Orión: «Sin mayúsculas, el mapa es inútil. No podemos saber '
          'qué es un nombre propio y qué no. ¡Corrigelo!»',
      nextNode: 'lx10_ex1',
    ),
    'lx10_ex1': const StoryNode(
      id: 'lx10_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📝',
      text: 'El mapa dice: "juan vive en madrid". Algo está mal.',
      question: 'Corrige: "juan vive en madrid"',
      options: [
        'Juan vive en madrid',
        'juan vive en Madrid',
        'Juan vive en Madrid',
        'JUAN VIVE EN MADRID',
      ],
      correctIndex: 2,
      hint: 'Los nombres de persona y ciudad van con mayúscula: '
          'Juan y Madrid.',
      onCorrect: 'lx10_ok1',
      onIncorrect: 'lx10_fail1',
    ),
    'lx10_ok1': const StoryNode(
      id: 'lx10_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Juan vive en Madrid! El nombre se ilumina en el mapa '
          'y aparece un punto brillante marcando la ciudad.',
      nextNode: 'lx10_ex2',
    ),
    'lx10_fail1': const StoryNode(
      id: 'lx10_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Juan vive en Madrid. Los dos son nombres propios.»',
      nextNode: 'lx10_ex2',
    ),
    'lx10_ex2': const StoryNode(
      id: 'lx10_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📝',
      text: 'Otro lugar en el mapa: "españa es un país de europa".',
      question: 'Corrige: "españa es un país de europa"',
      options: [
        'España es un País de Europa',
        'españa es un país de Europa',
        'España es un país de Europa',
        'España Es Un País De Europa',
      ],
      correctIndex: 2,
      hint: 'España y Europa son nombres propios. "País" es común.',
      onCorrect: 'lx10_ok2',
      onIncorrect: 'lx10_fail2',
    ),
    'lx10_ok2': const StoryNode(
      id: 'lx10_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🗺️',
      text: '¡España y Europa! Dos puntos más aparecen en el mapa, '
          'conectados por líneas doradas.',
      nextNode: 'lx10_ex3',
    ),
    'lx10_fail2': const StoryNode(
      id: 'lx10_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«España es un país de Europa. Solo los nombres propios '
          'van en mayúscula.»',
      nextNode: 'lx10_ex3',
    ),
    'lx10_ex3': const StoryNode(
      id: 'lx10_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Una regla importante: ¿qué pasa después de un punto?»',
      question: '¿"Hoy es lunes. mañana es martes" está bien escrito?',
      options: [
        'Sí, está correcto',
        'No, "mañana" va con mayúscula después del punto',
        'No, "lunes" va con mayúscula',
        'No, todo va en mayúsculas',
      ],
      correctIndex: 1,
      hint: 'Después de un punto SIEMPRE va mayúscula.',
      onCorrect: 'lx10_ok3',
      onIncorrect: 'lx10_fail3',
    ),
    'lx10_ok3': const StoryNode(
      id: 'lx10_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📏',
      text: '¡Correcto! Después del punto siempre va mayúscula. '
          'El mapa se corrige automáticamente: "...martes. Miércoles..."',
      nextNode: 'lx10_ex4',
    ),
    'lx10_fail3': const StoryNode(
      id: 'lx10_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Después de punto → MAYÚSCULA. Siempre.»',
      nextNode: 'lx10_ex4',
    ),
    'lx10_ex4': const StoryNode(
      id: 'lx10_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El mapa casi está completo. La última instrucción: '
          '"mi amiga laura vive en barcelona".',
      question: 'Corrige: "mi amiga laura vive en barcelona"',
      options: [
        'Mi Amiga Laura Vive En Barcelona',
        'Mi amiga Laura vive en Barcelona',
        'mi amiga Laura vive en Barcelona',
        'Mi amiga laura vive en barcelona',
      ],
      correctIndex: 1,
      hint: 'Laura y Barcelona son propios. "Mi" es inicio de oración.',
      onCorrect: 'lx10_final_ok',
      onIncorrect: 'lx10_final_fail',
    ),
    'lx10_final_ok': const StoryNode(
      id: 'lx10_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🗺️',
      text: '¡Mi amiga Laura vive en Barcelona! El mapa está COMPLETO. '
          'Todos los nombres brillan con letras doradas. El camino '
          'hacia el tesoro de Lexis está ahora claro.\n\n'
          'Orión: «Las mayúsculas dan sentido al mapa. ¡Al tesoro!»',
      nextNode: 'lx10_ending',
    ),
    'lx10_final_fail': const StoryNode(
      id: 'lx10_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Mi amiga Laura vive en Barcelona. Solo propios + inicio.»',
      nextNode: 'lx10_ending',
    ),
    'lx10_ending': const StoryNode(
      id: 'lx10_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 10 de Lexis completado!\n\n'
          'Dominas las reglas de las mayúsculas.\n\n'
          '🗺️ Recompensa: Mapa del Tesoro Corregido',
    ),
  },
);
