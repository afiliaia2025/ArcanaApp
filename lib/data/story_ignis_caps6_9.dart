import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// CAP 6: "La Ventisca de Noctus"
/// Tema: Números hasta 399, restas (U5: Muñecos de nieve)
/// ═══════════════════════════════════════════════════════════════
final chapter6Ignis = StoryChapter(
  id: 'ignis_c6',
  number: 7, // posición tras boss1
  title: 'La Ventisca de Noctus',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Números hasta 399 y restas',
  startNodeId: 'c6_intro',
  nodes: {
    'c6_intro': const StoryNode(
      id: 'c6_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '❄️',
      text: 'Sales de la Torre de Cristal. El mundo exterior debería ser '
          'un bosque, pero está todo CUBIERTO DE NIEVE MÁGICA. Una '
          'ventisca furiosa sopla desde las montañas.\n\n'
          'Orión se acurruca bajo tu capa: «Noctus congeló el camino. '
          'Para avanzar, vas a necesitar RESTAR la nieve mágica.»',
      nextNode: 'c6_ex1',
    ),
    'c6_ex1': const StoryNode(
      id: 'c6_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: '¡PLOF! Hundes las piernas en la nieve hasta la cintura. '
          'No puedes moverte. Un cartel medio enterrado dice:\n'
          '«Para liberarte, resta la nieve.»',
      question: '¿Cuánto es 356 - 123?',
      options: ['233', '223', '243', '213'],
      correctIndex: 0,
      hint: '6-3=3, 5-2=3, 3-1=2. Resultado: 233.',
      onCorrect: 'c6_acierto1',
      onIncorrect: 'c6_fallo1',
    ),
    'c6_acierto1': const StoryNode(
      id: 'c6_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡233! La nieve a tu alrededor se derrite como si un sol '
          'invisible la calentara. ¡Puedes caminar de nuevo!',
      nextNode: 'c6_ex2',
    ),
    'c6_fallo1': const StoryNode(
      id: 'c6_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Resta columna a columna: 6-3=3, 5-2=3, 3-1=2. ¡233!»\n'
          'Orión sopla calor con las alas y la nieve cede.',
      nextNode: 'c6_ex2',
    ),
    'c6_ex2': const StoryNode(
      id: 'c6_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Un hechizo de calor necesita una temperatura exacta '
          'para funcionar sin quemar nada.»',
      question: '¿Cuánto es 245 - 118?',
      options: ['137', '127', '133', '117'],
      correctIndex: 1,
      hint: '5-8 no se puede… Pido prestado: 15-8=7, 3-1=2, 2-1=1. → 127.',
      onCorrect: 'c6_acierto2',
      onIncorrect: 'c6_fallo2',
    ),
    'c6_acierto2': const StoryNode(
      id: 'c6_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔥',
      text: '¡127 grados de hechizo! Una onda de calor sale de tus manos '
          'y derrite un camino despejado entre la nieve. Avanzas entre '
          'montañas blancas. Orión tiembla pero sonríe.',
      nextNode: 'c6_decision',
    ),
    'c6_fallo2': const StoryNode(
      id: 'c6_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«127. Cuidado: 5-8 no se puede, así que pides prestada '
          'una decena. 15-8=7. Luego 3-1=2, y 2-1=1.»',
      nextNode: 'c6_decision',
    ),
    'c6_decision': const StoryNode(
      id: 'c6_decision',
      type: StoryNodeType.decision,
      text: 'Entre la ventisca ves dos caminos. Un letrero medio cubierto '
          'de escarcha dice:\n\n'
          '«REFUGIO ➡️ por el camino de la derecha (500 metros).\n'
          'ATAJO ⬅️ por la izquierda, pero cuidado: hay muñecos de nieve '
          'vigilando. Los hizo Noctus.»\n\n'
          '¿Por dónde vas?',
      choiceA: '➡️ Ir al refugio (seguro pero más largo)',
      choiceB: '⬅️ Tomar el atajo con muñecos de nieve',
      onChoiceA: 'c6_refugio',
      onChoiceB: 'c6_muneco',
    ),
    'c6_refugio': const StoryNode(
      id: 'c6_refugio',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏠',
      text: 'El refugio es una cabaña caliente con una chimenea encendida. '
          'Dentro, un viejo guardián te ofrece sopa caliente y te señala '
          'la salida: «La puerta del otro lado te lleva al camino seguro.»',
      nextNode: 'c6_ex3',
    ),
    'c6_muneco': const StoryNode(
      id: 'c6_muneco',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⛄',
      text: '¡Un muñeco de nieve COBRA VIDA! Tiene ojos de carbón y '
          'brazos de ramas. Es un esbirro de Noctus. Te bloquea el paso '
          'con un acertijo numérico.',
      nextNode: 'c6_ex3',
    ),
    'c6_ex3': const StoryNode(
      id: 'c6_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'El muñeco de nieve (o el guardián del refugio) te plantea '
          'un reto para seguir avanzando.',
      question: '¿Cuánto es 399 - 250?',
      options: ['149', '159', '139', '249'],
      correctIndex: 0,
      hint: '9-0=9, 9-5=4, 3-2=1. Resultado: 149.',
      onCorrect: 'c6_acierto3',
      onIncorrect: 'c6_fallo3',
    ),
    'c6_acierto3': const StoryNode(
      id: 'c6_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💨',
      text: '¡149! El muñeco de nieve se derrite en un charco humeante. '
          'El camino hacia el refugio queda libre.',
      nextNode: 'c6_ex4',
    ),
    'c6_fallo3': const StoryNode(
      id: 'c6_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«149. 9-0=9, 9-5=4, 3-2=1.» Orión sopla y el muñeco se '
          'deshace.',
      nextNode: 'c6_ex4',
    ),
    'c6_ex4': const StoryNode(
      id: 'c6_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'La puerta del refugio tiene una cerradura de hielo. '
          'Un acertijo brilla en escarcha:',
      question: '¿Qué número es 100 MENOS que 350?',
      options: ['350', '300', '250', '150'],
      correctIndex: 2,
      hint: '350 - 100 = …',
      onCorrect: 'c6_final_ok',
      onIncorrect: 'c6_final_fail',
    ),
    'c6_final_ok': const StoryNode(
      id: 'c6_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌤️',
      text: '¡250! La cerradura de hielo se rompe y la puerta se abre '
          'a un claro donde la ventisca no llega. El sol brilla '
          'débilmente a través de las nubes.\n\n'
          '«Lo peor de la ventisca ha pasado», dice Orión, ya sin '
          'temblar.',
      nextNode: 'c6_ending',
    ),
    'c6_final_fail': const StoryNode(
      id: 'c6_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«250. 350 - 100 = 250. Simplemente quitas 1 centena.»',
      nextNode: 'c6_ending',
    ),
    'c6_ending': const StoryNode(
      id: 'c6_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 6 completado!\n\n'
          'Has aprendido a restar con y sin llevada.\n\n'
          '🧣 Recompensa: Bufanda de Orión\n\n'
          'Un mensaje escrito con hielo aparece en la pared: «Para salir '
          'de aquí… necesitarás SUMAR FUERZAS». Orión: «Sumar FUERZAS… '
          'o sumar NÚMEROS. Quizá las dos cosas.»',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 7: "Las Cometas Mensajeras"
/// Tema: Números hasta 599, sumas de 3 sumandos (U6: Las cometas)
/// ═══════════════════════════════════════════════════════════════
final chapter7Ignis = StoryChapter(
  id: 'ignis_c7',
  number: 8,
  title: 'Las Cometas Mensajeras',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Números hasta 599, sumas de 3 sumandos',
  startNodeId: 'c7_intro',
  nodes: {
    'c7_intro': const StoryNode(
      id: 'c7_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🪁',
      text: 'Más allá de la nieve encuentras un campo abierto. Un mensajero '
          'lanza cometas al cielo para enviar cartas a los pueblos de '
          'Numeralia. Pero Noctus ha cortado las cuerdas.\n\n'
          '«¡Necesito ayuda!», grita el mensajero. «Sin las cometas, '
          'los pueblos no recibirán el aviso de que Noctus se acerca.»',
      nextNode: 'c7_ex1',
    ),
    'c7_ex1': const StoryNode(
      id: 'c7_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'El mensajero necesita calcular el largo total de cuerda '
          'para reparar tres cometas.',
      question: 'Suma 3 cuerdas: 120 + 230 + 150 = ?',
      options: ['400', '500', '450', '550'],
      correctIndex: 1,
      hint: '120 + 230 = 350. Luego 350 + 150 = 500.',
      onCorrect: 'c7_acierto1',
      onIncorrect: 'c7_fallo1',
    ),
    'c7_acierto1': const StoryNode(
      id: 'c7_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡500 metros de cuerda! Las cometas se remontan en el cielo '
          'como pájaros de colores. El mensajero aplaude: «¡Perfecto! '
          'Ahora a hacer volar los mensajes.»',
      nextNode: 'c7_ex2',
    ),
    'c7_fallo1': const StoryNode(
      id: 'c7_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Suma de tres: 120+230=350, y 350+150=500.»\n'
          'Las cometas vuelan igualmente.',
      nextNode: 'c7_ex2',
    ),
    'c7_ex2': const StoryNode(
      id: 'c7_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Para que la cometa más grande vuele, necesita un hechizo '
          'de vuelo.»',
      question: '¿Cuánto es 345 + 156?',
      options: ['491', '501', '511', '401'],
      correctIndex: 1,
      hint: '5+6=11 (llevas 1). 4+5+1=10 (llevas 1). 3+1+1=5. → 501.',
      onCorrect: 'c7_acierto2',
      onIncorrect: 'c7_fallo2',
    ),
    'c7_acierto2': const StoryNode(
      id: 'c7_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🪁',
      text: '¡501! La cometa gigante se eleva como un dragón de papel, '
          'arrastrando un mensaje enorme: «¡PELIGRO! ¡NOCTUS SE ACERCA!»',
      nextNode: 'c7_ex3',
    ),
    'c7_fallo2': const StoryNode(
      id: 'c7_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«501. Cuidado con las dobles llevadas: 5+6=11, 4+5+1=10, '
          '3+1+1=5.»',
      nextNode: 'c7_ex3',
    ),
    'c7_ex3': const StoryNode(
      id: 'c7_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'Una cometa trae un mensaje de respuesta de un pueblo lejano, '
          'pero el número está escrito en letras.',
      question: '¿Qué número es "quinientos cuarenta y tres"?',
      options: ['534', '543', '453', '345'],
      correctIndex: 1,
      hint: 'Quinientos = 500. Cuarenta = 40. Tres = 3.',
      onCorrect: 'c7_acierto3',
      onIncorrect: 'c7_fallo3',
    ),
    'c7_acierto3': const StoryNode(
      id: 'c7_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📖',
      text: '¡543! El mensaje dice: «543 personas están preparadas para '
          'defender el pueblo.» ¡Hay esperanza!\n\n'
          'Pero Orión señala al cielo: un Brumino volador se acerca.',
      nextNode: 'c7_ex4',
    ),
    'c7_fallo3': const StoryNode(
      id: 'c7_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«543: quinientos (500) + cuarenta (40) + tres (3).»',
      nextNode: 'c7_ex4',
    ),
    'c7_ex4': const StoryNode(
      id: 'c7_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'Un Brumino volador intercepta una cometa. Para espantarlo, '
          'debes responder rápido.',
      question: '¿Qué es más: 489 o 498?',
      options: ['489', '498', 'Son iguales', '948'],
      correctIndex: 1,
      hint: 'Misma centena (4). Compara decenas: 8 vs 9.',
      onCorrect: 'c7_final_ok',
      onIncorrect: 'c7_final_fail',
    ),
    'c7_final_ok': const StoryNode(
      id: 'c7_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💨',
      text: '¡498! El destello de tu respuesta correcta ciega al Brumino '
          'volador, que huye entre las nubes. La cometa aterriza a salvo '
          'en el pueblo.\n\n'
          'El mensajero te abraza: «¡Gracias! Los pueblos estarán avisados.»',
      nextNode: 'c7_ending',
    ),
    'c7_final_fail': const StoryNode(
      id: 'c7_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«498 > 489. La decena 9 es mayor que 8.» Orión dispersa '
          'al Brumino.',
      nextNode: 'c7_ending',
    ),
    'c7_ending': const StoryNode(
      id: 'c7_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 7 completado!\n\n'
          'Has aprendido a sumar 3 sumandos, escribir números en letras '
          'y comparar números hasta 599.\n\n'
          '🪶 Recompensa: Pluma de Cometa\n\n'
          'Una cometa regresa con una RESPUESTA: «Gracias, aprendiz. '
          'Pero cuidado: el siguiente piso tiene un BOSQUE dentro de '
          'la torre. Y los árboles… multiplican.» Orión: «¿Los árboles '
          'multiplican? Esto se pone interesante.»',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 8: "El Huerto Encantado"
/// Tema: Multiplicar ×2, ×5, ×10 (U7: Racimos de fruta)
/// ═══════════════════════════════════════════════════════════════
final chapter8Ignis = StoryChapter(
  id: 'ignis_c8',
  number: 9,
  title: 'El Huerto Encantado',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Multiplicar ×2, ×5, ×10',
  startNodeId: 'c8_intro',
  nodes: {
    'c8_intro': const StoryNode(
      id: 'c8_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🍎',
      text: 'Llegas a un huerto mágico donde los árboles dan fruta que '
          'brilla. Pero el granjero está desesperado: «Sin saber contar '
          'los racimos, no puedo cosechar. Y sin fruta, Orión no puede '
          'hacer su poción de fuerza.»\n\n'
          'Orión salta de tu hombro: «¡Necesito esa poción!»',
      nextNode: 'c8_ex1',
    ),
    'c8_ex1': const StoryNode(
      id: 'c8_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'Para la poción de Orión necesitas fruta. Hay 5 racimos '
          'y cada racimo tiene 2 frutas.',
      question: '5 racimos × 2 frutas = ¿cuántas frutas en total?',
      options: ['7', '10', '12', '52'],
      correctIndex: 1,
      hint: '5 × 2 = sumar 2 cinco veces: 2+2+2+2+2 = 10.',
      onCorrect: 'c8_acierto1',
      onIncorrect: 'c8_fallo1',
    ),
    'c8_acierto1': const StoryNode(
      id: 'c8_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡10 frutas! El granjero las recoge rápidamente. Orión ya '
          'está saboreando la poción mentalmente.\n\n'
          '«Pero necesitamos más para que crezcan nuevas plantas», '
          'dice el granjero.',
      nextNode: 'c8_ex2',
    ),
    'c8_fallo1': const StoryNode(
      id: 'c8_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«5 × 2 = 10. Multiplicar es sumar muchas veces: '
          '2+2+2+2+2 = 10.»',
      nextNode: 'c8_ex2',
    ),
    'c8_ex2': const StoryNode(
      id: 'c8_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«El hechizo de crecimiento necesita plantar semillas. ¿Cuántas?»',
      question: '10 × 7 = ¿cuántas semillas?',
      options: ['17', '70', '107', '77'],
      correctIndex: 1,
      hint: 'Multiplicar por 10 es fácil: pon un 0 al final. 7 → 70.',
      onCorrect: 'c8_acierto2',
      onIncorrect: 'c8_fallo2',
    ),
    'c8_acierto2': const StoryNode(
      id: 'c8_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌱',
      text: '¡70 semillas! Las plantas al caer al suelo brote verde inmediato. '
          'El huerto se llena de brotes nuevos. ¡Es mágico!',
      nextNode: 'c8_ex3',
    ),
    'c8_fallo2': const StoryNode(
      id: 'c8_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«70. Multiplicar por 10: solo añade un 0. 7 × 10 = 70.»',
      nextNode: 'c8_ex3',
    ),
    'c8_ex3': const StoryNode(
      id: 'c8_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🗝️',
      text: 'El granjero te plantea un acertijo mientras prepara '
          'las cestas de manzanas.',
      question: 'Cada cesta tiene 5 manzanas. Hay 6 cestas. '
          '¿Cuántas manzanas hay en total?',
      options: ['11', '25', '30', '35'],
      correctIndex: 2,
      hint: '6 × 5 = sumar 5 seis veces. O tabla del 5: 5,10,15,20,25,30.',
      onCorrect: 'c8_acierto3',
      onIncorrect: 'c8_fallo3',
    ),
    'c8_acierto3': const StoryNode(
      id: 'c8_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🍏',
      text: '¡30 manzanas! El granjero te agradece con un abrazo: '
          '«¡Bravo! Con esto el huerto sobrevivirá al invierno de Noctus.»\n\n'
          'Te señala un atajo por la cerca del huerto.',
      nextNode: 'c8_ex4',
    ),
    'c8_fallo3': const StoryNode(
      id: 'c8_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«6 × 5 = 30. Tabla del 5: 5, 10, 15, 20, 25, 30.»',
      nextNode: 'c8_ex4',
    ),
    'c8_ex4': const StoryNode(
      id: 'c8_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'La cerca del atajo tiene huecos. Hay postes con números '
          'y un cartel:\n«Cada 2 postes hay un hueco.»',
      question: 'Si la cerca tiene 8 postes y HAY UN HUECO CADA 2 POSTES, '
          '¿cuántos huecos hay?',
      options: ['2', '4', '6', '8'],
      correctIndex: 1,
      hint: '8 postes ÷ 2 = 4 huecos. O cuenta: hueco-poste-hueco-poste…',
      onCorrect: 'c8_final_ok',
      onIncorrect: 'c8_final_fail',
    ),
    'c8_final_ok': const StoryNode(
      id: 'c8_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌾',
      text: '¡4 huecos! Saltas por cada hueco de la cerca y sales '
          'del huerto. El granjero te despide agitando su sombrero.\n\n'
          'Orión bebe su poción de fruta: «¡Ahora soy más fuerte!»\n'
          '(No parece más fuerte, pero no se lo digas.)',
      nextNode: 'c8_ending',
    ),
    'c8_final_fail': const StoryNode(
      id: 'c8_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«4 huecos. 8 postes con un hueco cada 2: 8 ÷ 2 = 4.»',
      nextNode: 'c8_ending',
    ),
    'c8_ending': const StoryNode(
      id: 'c8_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 8 completado!\n\n'
          'Has aprendido a multiplicar por 2, por 5 y por 10.\n\n'
          '🍎 Recompensa: Fruta Dorada\n\n'
          'La niebla sube por las escaleras como si tuviera vida propia. '
          'Orión abre mucho los ojos: «¿Hueles eso? La niebla de los '
          'Bruminos… están en el siguiente piso.»',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 9: "La Fuente Seca"
/// Tema: Capacidad, litro (U8: Zumo de naranja)
/// ═══════════════════════════════════════════════════════════════
final chapter9Ignis = StoryChapter(
  id: 'ignis_c9',
  number: 10,
  title: 'La Fuente Seca',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Capacidad y litros',
  startNodeId: 'c9_intro',
  nodes: {
    'c9_intro': const StoryNode(
      id: 'c9_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⛲',
      text: 'Llegas a un pueblo donde la fuente central está seca. '
          'Sin agua, los hechizos de protección del pueblo fallan y '
          'los Bruminos se acercan cada noche.\n\n'
          'La alcaldesa te recibe: «¡Aprendiz! Si no llenamos la fuente, '
          'el pueblo caerá antes del amanecer.»',
      nextNode: 'c9_ex1',
    ),
    'c9_ex1': const StoryNode(
      id: 'c9_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'La alcaldesa te da un cubo. «Caben 5 litros, pero ya '
          'tiene 2 litros dentro.»',
      question: '¿Cuántos litros FALTAN para llenar el cubo?',
      options: ['2', '3', '5', '7'],
      correctIndex: 1,
      hint: '5 - 2 = 3 litros.',
      onCorrect: 'c9_acierto1',
      onIncorrect: 'c9_fallo1',
    ),
    'c9_acierto1': const StoryNode(
      id: 'c9_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💧',
      text: '¡3 litros! Corres al pozo y llenas los 3 litros que faltan. '
          'El cubo pesa ahora mucho más.',
      nextNode: 'c9_ex2',
    ),
    'c9_fallo1': const StoryNode(
      id: 'c9_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«5 litros caben - 2 que ya tiene = 3 litros por llenar.»',
      nextNode: 'c9_ex2',
    ),
    'c9_ex2': const StoryNode(
      id: 'c9_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«¡Un hechizo de lluvia! Necesita exactamente 10 litros '
          'de agua mágica. Solo tenemos jarras de 2 litros.»',
      question: 'Si cada jarra tiene 2 litros y necesitas 10 litros, '
          '¿cuántas jarras necesitas?',
      options: ['3', '5', '8', '20'],
      correctIndex: 1,
      hint: '10 ÷ 2 = 5. O cuenta: 2, 4, 6, 8, 10 = 5 jarras.',
      onCorrect: 'c9_acierto2',
      onIncorrect: 'c9_fallo2',
    ),
    'c9_acierto2': const StoryNode(
      id: 'c9_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌧️',
      text: '¡5 jarras! Viertes las 5 jarras en el caldero del hechizo. '
          '¡FWOOSH! Una nube aparece sobre la fuente y empieza a llover. '
          '¡Lluvia mágica!',
      nextNode: 'c9_decision',
    ),
    'c9_fallo2': const StoryNode(
      id: 'c9_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«5 jarras. 2+2+2+2+2 = 10 litros.»',
      nextNode: 'c9_decision',
    ),
    'c9_decision': const StoryNode(
      id: 'c9_decision',
      type: StoryNodeType.decision,
      text: 'La fuente se llena lentamente. Pero un aldeano grita:\n\n'
          '«¡El agua sube demasiado rápido por un lado! Hay un tubo '
          'roto que pierde agua. ¡Tenemos que arreglarlo antes de '
          'que inunde la plaza!»\n\n'
          'Un cartel junto al tubo dice: «Para cerrarlo, gira la llave '
          'a la DERECHA. NO a la izquierda o el agua saldrá más fuerte.»',
      choiceA: '🔧 Girar la llave a la DERECHA (como dice el cartel)',
      choiceB: '🔧 Girar la llave a la IZQUIERDA',
      onChoiceA: 'c9_bien',
      onChoiceB: 'c9_mal',
    ),
    'c9_bien': const StoryNode(
      id: 'c9_bien',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✅',
      text: '¡Giras a la derecha y el tubo se cierra! El agua deja de '
          'salir por el agujero. «¡Bien leído!», aplaude la alcaldesa.',
      nextNode: 'c9_ex3',
    ),
    'c9_mal': const StoryNode(
      id: 'c9_mal',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💦',
      text: '¡SPLASH! El agua sale a CHORROS por el tubo, empapándote '
          'de pies a cabeza. Orión se ríe: «¡El cartel decía DERECHA! '
          '¡Hay que leer los avisos!»\n\n'
          'Giras a la derecha y el tubo se cierra.',
      nextNode: 'c9_ex3',
    ),
    'c9_ex3': const StoryNode(
      id: 'c9_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'La alcaldesa te hace una última prueba antes de darte '
          'su agradecimiento oficial.',
      question: '¿Qué tiene más agua: un cubo de 1 litro LLENO o '
          'una botella de MEDIO litro llena?',
      options: [
        'La botella (medio litro)',
        'El cubo (1 litro)',
        'Tienen lo mismo',
        'No se puede saber',
      ],
      correctIndex: 1,
      hint: '1 litro > medio litro. 1 > 0.5.',
      onCorrect: 'c9_final_ok',
      onIncorrect: 'c9_final_fail',
    ),
    'c9_final_ok': const StoryNode(
      id: 'c9_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⛲',
      text: '¡El cubo de 1 litro! La alcaldesa sonríe: «Has salvado '
          'nuestro pueblo. La fuente vuelve a funcionar. Los Bruminos '
          'no podrán acercarse esta noche.»\n\n'
          'El pueblo celebra con una fiesta. Orión come demasiados '
          'pasteles.',
      nextNode: 'c9_ending',
    ),
    'c9_final_fail': const StoryNode(
      id: 'c9_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡El cubo! 1 litro es más que medio litro.»',
      nextNode: 'c9_ending',
    ),
    'c9_ending': const StoryNode(
      id: 'c9_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 9 completado!\n\n'
          'Has aprendido a medir con litros y medio litro.\n\n'
          '💧 Recompensa: Gota de Cristal\n\n'
          'El suelo empieza a temblar. FUERTE. Las paredes crujen. '
          'Orión: «¿Sientes eso? El segundo general de Noctus está '
          'cerca. Puedo oír la LAVA.»',
    ),
  },
);
