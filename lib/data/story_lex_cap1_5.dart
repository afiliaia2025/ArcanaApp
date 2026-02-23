import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// CAP 1 LEXIS: "La Carta Misteriosa"
/// Tema: Abecedario, orden alfabético, vocales/consonantes (U1)
/// ═══════════════════════════════════════════════════════════════
final chapter1Lexis = StoryChapter(
  id: 'lexis_c01',
  number: 1,
  title: 'La Carta Misteriosa',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Abecedario, vocales y consonantes',
  startNodeId: 'lx1_intro',
  nodes: {
    'lx1_intro': const StoryNode(
      id: 'lx1_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📜',
      text: 'Tras recuperar tu primera gema, el mapa te guía hacia el '
          'Bosque Lexis: un lugar donde los árboles tienen hojas con '
          'forma de letras. Al entrar, una carta sellada cae de una rama.\n\n'
          'Orión la inspecciona: «Es una carta cifrada. Solo podrás leerla '
          'si dominas las letras. La Gema Lexis controla el poder de las '
          'Palabras… sin ella, los textos se deshacen como humo.»',
      nextNode: 'lx1_ex1',
    ),
    'lx1_ex1': const StoryNode(
      id: 'lx1_ex1',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🔤',
      text: '«La carta necesita que ordenes las palabras para descifrar '
          'el primer fragmento.»',
      question: 'Ordena alfabéticamente: gato, ala, ratón',
      options: [
        'gato, ala, ratón',
        'ala, gato, ratón',
        'ratón, gato, ala',
        'ala, ratón, gato',
      ],
      correctIndex: 1,
      hint: 'La A va antes que la G, y la G antes que la R.',
      onCorrect: 'lx1_ok1',
      onIncorrect: 'lx1_fail1',
    ),
    'lx1_ok1': const StoryNode(
      id: 'lx1_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Ala, gato, ratón! Las letras de la carta brillan y forman '
          'una frase: «Busca al Guardián del Alfabeto en el Árbol Central.»',
      nextNode: 'lx1_ex2',
    ),
    'lx1_fail1': const StoryNode(
      id: 'lx1_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Ala, gato, ratón. El abecedario: A va primero, G después, '
          'R al final.»',
      nextNode: 'lx1_ex2',
    ),
    'lx1_ex2': const StoryNode(
      id: 'lx1_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🌲',
      text: 'Llegas al Árbol Central. Sus hojas son letras que caen como '
          'confeti. Una rama brilla con un acertijo.',
      question: '¿La P es vocal o consonante?',
      options: ['Vocal', 'Consonante'],
      correctIndex: 1,
      hint: 'Las vocales son A, E, I, O, U. Todo lo demás son consonantes.',
      onCorrect: 'lx1_ok2',
      onIncorrect: 'lx1_fail2',
    ),
    'lx1_ok2': const StoryNode(
      id: 'lx1_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🍃',
      text: '¡Consonante! La hoja-P se ilumina de verde y abre un hueco '
          'en el tronco. Dentro hay más pistas.',
      nextNode: 'lx1_ex3',
    ),
    'lx1_fail2': const StoryNode(
      id: 'lx1_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Consonante. Las vocales son A, E, I, O, U. La P no está.»',
      nextNode: 'lx1_ex3',
    ),
    'lx1_ex3': const StoryNode(
      id: 'lx1_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '📖',
      text: '«Dentro del tronco hay un pergamino que pone: MURCIÉLAGO. '
          'Es la única palabra en español con las 5 vocales.»',
      question: '¿Cuántas VOCALES tiene "murciélago"?',
      options: ['3', '4', '5', '6'],
      correctIndex: 2,
      hint: 'Cuenta: u-i-é-a-o → 5 vocales.',
      onCorrect: 'lx1_ok3',
      onIncorrect: 'lx1_fail3',
    ),
    'lx1_ok3': const StoryNode(
      id: 'lx1_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔓',
      text: '¡5 vocales! El pergamino se despliega mostrando una contraseña '
          'para la puerta del guardián: una palabra incompleta.',
      nextNode: 'lx1_ex4',
    ),
    'lx1_fail3': const StoryNode(
      id: 'lx1_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«5 vocales: U, I, É, A, O. ¡Las tiene TODAS!»',
      nextNode: 'lx1_ex4',
    ),
    'lx1_ex4': const StoryNode(
      id: 'lx1_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'La puerta del guardián tiene letras faltantes:\n'
          '«_str_ll_» (brilla en el cielo)',
      question: '¿Qué palabra es "_str_ll_"? (brilla en el cielo)',
      options: ['Estrella', 'Castillo', 'Establo', 'Estufa'],
      correctIndex: 0,
      hint: 'Brilla en el cielo + las vocales completan e-s-t-r-e-l-l-a.',
      onCorrect: 'lx1_final_ok',
      onIncorrect: 'lx1_final_fail',
    ),
    'lx1_final_ok': const StoryNode(
      id: 'lx1_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '¡ESTRELLA! La puerta se abre y una lluvia de letras doradas '
          'cae sobre ti. Has entrado al Bosque Lexis.\n\n'
          'Orión: «El primer paso siempre es conocer las letras. '
          '¡Ahora las dominas!»',
      nextNode: 'lx1_ending',
    ),
    'lx1_final_fail': const StoryNode(
      id: 'lx1_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Estrella. E-S-T-R-E-L-L-A. ¡Brilla en el cielo!»',
      nextNode: 'lx1_ending',
    ),
    'lx1_ending': const StoryNode(
      id: 'lx1_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 1 de Lexis completado!\n\n'
          'Has dominado el abecedario, vocales y consonantes.\n\n'
          '📜 Recompensa: Pluma del Alfabeto',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 2 LEXIS: "La Biblioteca Revuelta"
/// Tema: Sílabas, separación, mono/bi/trisílaba (U2)
/// ═══════════════════════════════════════════════════════════════
final chapter2Lexis = StoryChapter(
  id: 'lexis_c02',
  number: 2,
  title: 'La Biblioteca Revuelta',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Sílabas y separación silábica',
  startNodeId: 'lx2_intro',
  nodes: {
    'lx2_intro': const StoryNode(
      id: 'lx2_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📚',
      text: 'Dentro del Bosque Lexis hay una biblioteca gigante al aire '
          'libre: los libros están atados a las ramas de los árboles. '
          'Pero Noctus ha soltado un hechizo que ha MEZCLADO todas las '
          'sílabas de los libros.\n\n'
          'Las palabras están partidas y los libros no se pueden leer.\n\n'
          'Orión: «Si no las unimos, perderemos las historias para siempre.»',
      nextNode: 'lx2_ex1',
    ),
    'lx2_ex1': const StoryNode(
      id: 'lx2_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📖',
      text: 'Un libro abierto muestra la palabra "mariposa" separada '
          'en trozos. Necesitas verificar que esté bien.',
      question: '¿Cómo se separa "mariposa" en sílabas?',
      options: [
        'mar-ip-os-a',
        'ma-ri-po-sa',
        'mari-po-sa',
        'ma-rip-osa',
      ],
      correctIndex: 1,
      hint: 'Da palmadas: MA-RI-PO-SA. 4 golpes = 4 sílabas.',
      onCorrect: 'lx2_ok1',
      onIncorrect: 'lx2_fail1',
    ),
    'lx2_ok1': const StoryNode(
      id: 'lx2_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Ma-ri-po-sa! Las sílabas se unen en el aire y la palabra '
          'vuelve al libro. Una mariposa de tinta sale volando de la página.',
      nextNode: 'lx2_ex2',
    ),
    'lx2_fail1': const StoryNode(
      id: 'lx2_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Ma-ri-po-sa. Da palmadas: MA (1), RI (2), PO (3), SA (4).»',
      nextNode: 'lx2_ex2',
    ),
    'lx2_ex2': const StoryNode(
      id: 'lx2_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🗝️',
      text: '«Otro libro necesita ayuda. ¿Cuántas sílabas tiene?»',
      question: '¿Cuántas sílabas tiene "sol"?',
      options: ['1', '2', '3', '4'],
      correctIndex: 0,
      hint: 'SOL. Un solo golpe de palmada = monosílaba.',
      onCorrect: 'lx2_ok2',
      onIncorrect: 'lx2_fail2',
    ),
    'lx2_ok2': const StoryNode(
      id: 'lx2_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '☀️',
      text: '¡1 sílaba! La palabra SOL brilla como un pequeño sol '
          'en la página del libro.',
      nextNode: 'lx2_ex3',
    ),
    'lx2_fail2': const StoryNode(
      id: 'lx2_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«1 sílaba. SOL es monosílaba: un solo golpe.»',
      nextNode: 'lx2_ex3',
    ),
    'lx2_ex3': const StoryNode(
      id: 'lx2_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📖',
      text: 'El último libro de la estantería más alta necesita tu ayuda.',
      question: '"Casa" es monosílaba, bisílaba o trisílaba?',
      options: ['Monosílaba (1)', 'Bisílaba (2)', 'Trisílaba (3)', 'Polisílaba (4+)'],
      correctIndex: 1,
      hint: 'CA-SA. Dos sílabas = bisílaba.',
      onCorrect: 'lx2_ok3',
      onIncorrect: 'lx2_fail3',
    ),
    'lx2_ok3': const StoryNode(
      id: 'lx2_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏠',
      text: '¡Bisílaba! CA-SA vuelve al libro. Todo el estante vuelve '
          'a la normalidad. Los libros respiran aliviados.',
      nextNode: 'lx2_ex4',
    ),
    'lx2_fail3': const StoryNode(
      id: 'lx2_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Bisílaba. CA-SA = 2 sílabas.»',
      nextNode: 'lx2_ex4',
    ),
    'lx2_ex4': const StoryNode(
      id: 'lx2_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Para salir de la biblioteca necesitas un pase. '
          'La bibliotecaria (un hada-libro) te pide una última prueba.',
      question: '¿Cómo se separa "elefante" en sílabas?',
      options: [
        'e-le-fan-te',
        'el-e-fan-te',
        'ele-fan-te',
        'e-le-fa-nte',
      ],
      correctIndex: 0,
      hint: 'E-LE-FAN-TE. 4 sílabas.',
      onCorrect: 'lx2_final_ok',
      onIncorrect: 'lx2_final_fail',
    ),
    'lx2_final_ok': const StoryNode(
      id: 'lx2_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧚',
      text: '¡E-le-fan-te! El hada-libro te entrega un sello mágico: '
          '«Con esto podrás entrar en cualquier biblioteca de Numeralia. '
          'Las sílabas ya no te detendrán.»',
      nextNode: 'lx2_ending',
    ),
    'lx2_final_fail': const StoryNode(
      id: 'lx2_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«E-le-fan-te. 4 sílabas: da 4 palmadas.»',
      nextNode: 'lx2_ending',
    ),
    'lx2_ending': const StoryNode(
      id: 'lx2_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 2 de Lexis completado!\n\n'
          'Dominas las sílabas y sabes separar palabras.\n\n'
          '📚 Recompensa: Sello de la Biblioteca',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 3 LEXIS: "El Mensaje del Río"
/// Tema: Sustantivos (común/propio), singular/plural, masc/fem (U3)
/// ═══════════════════════════════════════════════════════════════
final chapter3Lexis = StoryChapter(
  id: 'lexis_c03',
  number: 3,
  title: 'El Mensaje del Río',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Sustantivos, género y número',
  startNodeId: 'lx3_intro',
  nodes: {
    'lx3_intro': const StoryNode(
      id: 'lx3_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏞️',
      text: 'El camino te lleva a un río de tinta azul llamado el '
          'Río de las Palabras. En la orilla hay botellas flotando con '
          'mensajes dentro. Orión atrapa una con el pico.\n\n'
          '«Este mensaje dice que los sustantivos del río están '
          'desordenados. Los comunes se mezclan con los propios.»',
      nextNode: 'lx3_ex1',
    ),
    'lx3_ex1': const StoryNode(
      id: 'lx3_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🏷️',
      text: 'Una botella tiene un nombre escrito: "Madrid".',
      question: '¿"Madrid" es un sustantivo común o propio?',
      options: ['Común', 'Propio'],
      correctIndex: 1,
      hint: 'Los nombres de ciudades, personas y países son propios '
          'y van con MAYÚSCULA.',
      onCorrect: 'lx3_ok1',
      onIncorrect: 'lx3_fail1',
    ),
    'lx3_ok1': const StoryNode(
      id: 'lx3_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Propio! La botella brilla y sale volando río abajo '
          'hasta el cajón de los nombres propios.',
      nextNode: 'lx3_ex2',
    ),
    'lx3_fail1': const StoryNode(
      id: 'lx3_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Propio. Madrid es un nombre de ciudad, va con mayúscula.»',
      nextNode: 'lx3_ex2',
    ),
    'lx3_ex2': const StoryNode(
      id: 'lx3_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '📜',
      text: '«Un pez saltarín trae otra botella. Dentro dice "pez".»',
      question: '¿Cuál es el PLURAL de "pez"?',
      options: ['Pezes', 'Peces', 'Pez', 'Peceses'],
      correctIndex: 1,
      hint: 'Las palabras que terminan en Z hacen el plural en CES: '
          'pez → peces.',
      onCorrect: 'lx3_ok2',
      onIncorrect: 'lx3_fail2',
    ),
    'lx3_ok2': const StoryNode(
      id: 'lx3_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐟',
      text: '¡Peces! Tres peces de tinta saltan del río celebrando '
          'que han recuperado su plural.',
      nextNode: 'lx3_ex3',
    ),
    'lx3_fail2': const StoryNode(
      id: 'lx3_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Peces. Pez → peces. La Z se convierte en CES.»',
      nextNode: 'lx3_ex3',
    ),
    'lx3_ex3': const StoryNode(
      id: 'lx3_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🏷️',
      text: 'Una rana del río canta un acertijo sobre género.',
      question: '¿Cuál es el femenino de "león"?',
      options: ['Leona', 'Leonia', 'León hembra', 'Leonesa'],
      correctIndex: 0,
      hint: 'León → leona. Se cambia la terminación.',
      onCorrect: 'lx3_ok3',
      onIncorrect: 'lx3_fail3',
    ),
    'lx3_ok3': const StoryNode(
      id: 'lx3_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🦁',
      text: '¡Leona! La rana aplaude (con sus patitas) y te deja pasar '
          'al puente del río.',
      nextNode: 'lx3_ex4',
    ),
    'lx3_fail3': const StoryNode(
      id: 'lx3_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Leona. León → leona.»',
      nextNode: 'lx3_ex4',
    ),
    'lx3_ex4': const StoryNode(
      id: 'lx3_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'Para cruzar el puente, el guardián-garza te pide una '
          'última respuesta.',
      question: '¿"La mesa" es masculino o femenino?',
      options: ['Masculino', 'Femenino'],
      correctIndex: 1,
      hint: 'LA mesa. El artículo "la" indica femenino.',
      onCorrect: 'lx3_final_ok',
      onIncorrect: 'lx3_final_fail',
    ),
    'lx3_final_ok': const StoryNode(
      id: 'lx3_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌉',
      text: '¡Femenino! La garza inclina la cabeza y te deja cruzar. '
          'Al otro lado del río, los árboles de letras son más densos.',
      nextNode: 'lx3_ending',
    ),
    'lx3_final_fail': const StoryNode(
      id: 'lx3_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Femenino. LA mesa = artículo femenino.»',
      nextNode: 'lx3_ending',
    ),
    'lx3_ending': const StoryNode(
      id: 'lx3_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 3 de Lexis completado!\n\n'
          'Dominas sustantivos, género y número.\n\n'
          '🐟 Recompensa: Botella Parlante del Río',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 4 LEXIS: "La Receta Maldita"
/// Tema: Ortografía C/Q, Z/C (U4)
/// ═══════════════════════════════════════════════════════════════
final chapter4Lexis = StoryChapter(
  id: 'lexis_c04',
  number: 4,
  title: 'La Receta Maldita',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Ortografía: C/Q y Z/C',
  startNodeId: 'lx4_intro',
  nodes: {
    'lx4_intro': const StoryNode(
      id: 'lx4_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'En lo profundo del bosque encuentras una cabaña con un '
          'caldero burbujeante. Una bruja amigable (la Bruja Ortográfica) '
          'está desesperada.\n\n'
          '«¡Noctus ha maldecido mi recetario! Todas las palabras tienen '
          'las letras cambiadas. Si cocino con la receta maldita, ¡la '
          'poción explotará!»\n\n'
          'Orión: «Necesita ayuda con la ortografía. ¡Es tu momento!»',
      nextNode: 'lx4_ex1',
    ),
    'lx4_ex1': const StoryNode(
      id: 'lx4_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'La receta pide un ingrediente, pero está mal escrito.',
      question: '¿Cuál es la forma correcta: "queso" o "keso"?',
      options: ['keso', 'queso'],
      correctIndex: 1,
      hint: 'Con QU antes de E/I: queso, quince. Con C antes de A/O/U.',
      onCorrect: 'lx4_ok1',
      onIncorrect: 'lx4_fail1',
    ),
    'lx4_ok1': const StoryNode(
      id: 'lx4_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧀',
      text: '¡Queso! La palabra se corrige en el recetario. Un queso '
          'dorado aparece flotando y cae en el caldero. ¡GLUP!',
      nextNode: 'lx4_ex2',
    ),
    'lx4_fail1': const StoryNode(
      id: 'lx4_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Queso. Antes de E e I se escribe QU, no K.»',
      nextNode: 'lx4_ex2',
    ),
    'lx4_ex2': const StoryNode(
      id: 'lx4_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📖',
      text: 'El siguiente ingrediente también está corrupto.',
      question: '¿Cuál es correcto: "zapato" o "sapato"?',
      options: ['sapato', 'zapato'],
      correctIndex: 1,
      hint: 'Za, zo, zu se escriben con Z. Ce, ci se escriben con C.',
      onCorrect: 'lx4_ok2',
      onIncorrect: 'lx4_fail2',
    ),
    'lx4_ok2': const StoryNode(
      id: 'lx4_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '👟',
      text: '¡Zapato! La bruja aplaude: «¡Esa estaba difícil!»\n'
          'Un zapato mágico sale del caldero y da un par de saltos.',
      nextNode: 'lx4_ex3',
    ),
    'lx4_fail2': const StoryNode(
      id: 'lx4_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Zapato. ZA se escribe con Z.»',
      nextNode: 'lx4_ex3',
    ),
    'lx4_ex3': const StoryNode(
      id: 'lx4_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'La bruja lee el tercer ingrediente con los ojos entrecerrados.',
      question: '¿Cuál es correcto: "parque" o "parce"?',
      options: ['parce', 'parque'],
      correctIndex: 1,
      hint: 'Antes de E se escribe QUE: parque, bosque, tanque.',
      onCorrect: 'lx4_ok3',
      onIncorrect: 'lx4_fail3',
    ),
    'lx4_ok3': const StoryNode(
      id: 'lx4_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌳',
      text: '¡Parque! Unas hojas verdes caen dentro del caldero. '
          'La poción empieza a brillar de color esmeralda.',
      nextNode: 'lx4_ex4',
    ),
    'lx4_fail3': const StoryNode(
      id: 'lx4_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Parque. QUE antes de E.»',
      nextNode: 'lx4_ex4',
    ),
    'lx4_ex4': const StoryNode(
      id: 'lx4_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: '«¡Último ingrediente!», dice la bruja emocionada.',
      question: '¿Cuál es correcto: "cielo" o "zielo"?',
      options: ['zielo', 'cielo'],
      correctIndex: 1,
      hint: 'CI se escribe con C: cielo, cine, ciudad.',
      onCorrect: 'lx4_final_ok',
      onIncorrect: 'lx4_final_fail',
    ),
    'lx4_final_ok': const StoryNode(
      id: 'lx4_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💫',
      text: '¡Cielo! La poción explota en un arcoíris de colores. La bruja '
          'te abraza: «¡Lo has conseguido! Esta poción protegerá el bosque '
          'durante un tiempo. Toma, te la has ganado.»\n\n'
          'Te da un frasco brillante.',
      nextNode: 'lx4_ending',
    ),
    'lx4_final_fail': const StoryNode(
      id: 'lx4_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Cielo. CI se escribe con C.»',
      nextNode: 'lx4_ending',
    ),
    'lx4_ending': const StoryNode(
      id: 'lx4_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 4 de Lexis completado!\n\n'
          'Has dominado la ortografía de C/Q y Z/C.\n\n'
          '🧪 Recompensa: Poción de Ortografía',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 5 LEXIS: "Los Nombres Perdidos"
/// Tema: Adjetivos, antónimos y sinónimos (U5)
/// ═══════════════════════════════════════════════════════════════
final chapter5Lexis = StoryChapter(
  id: 'lexis_c05',
  number: 5,
  title: 'Los Nombres Perdidos',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Adjetivos, antónimos y sinónimos',
  startNodeId: 'lx5_intro',
  nodes: {
    'lx5_intro': const StoryNode(
      id: 'lx5_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏘️',
      text: 'Más allá de la cabaña de la bruja llegas a un pueblo donde '
          'todos los carteles están vacíos. Los habitantes no recuerdan '
          'los adjetivos de las cosas.\n\n'
          '«¿El bosque era… qué? ¿Grande? ¿Verde? ¿Oscuro? ¡No me acuerdo!», '
          'llora un habitante.\n\n'
          'Orión: «Noctus les ha robado los adjetivos. Sin ellos, no pueden '
          'describir nada.»',
      nextNode: 'lx5_ex1',
    ),
    'lx5_ex1': const StoryNode(
      id: 'lx5_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🏷️',
      text: 'Un cartel dice: "el gato ___". Necesita su adjetivo.',
      question: 'En "el gato negro", ¿cuál es el adjetivo?',
      options: ['el', 'gato', 'negro'],
      correctIndex: 2,
      hint: 'El adjetivo DESCRIBE cómo es algo. ¿Qué palabra dice cómo es el gato?',
      onCorrect: 'lx5_ok1',
      onIncorrect: 'lx5_fail1',
    ),
    'lx5_ok1': const StoryNode(
      id: 'lx5_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🐈‍⬛',
      text: '¡Negro! La palabra aparece en el cartel con letras de colores. '
          'Un gato negro sale de ninguna parte y se frota contra tu pierna, '
          'ronroneando feliz.',
      nextNode: 'lx5_ex2',
    ),
    'lx5_fail1': const StoryNode(
      id: 'lx5_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Negro. El adjetivo dice CÓMO ES el gato.»',
      nextNode: 'lx5_ex2',
    ),
    'lx5_ex2': const StoryNode(
      id: 'lx5_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🔄',
      text: '«Los habitantes también necesitan recordar los opuestos. '
          'Ayúdales.»',
      question: '¿Cuál es el ANTÓNIMO (contrario) de "grande"?',
      options: ['Enorme', 'Pequeño', 'Bonito', 'Largo'],
      correctIndex: 1,
      hint: 'Antónimo = lo opuesto. ¿Qué es lo contrario de grande?',
      onCorrect: 'lx5_ok2',
      onIncorrect: 'lx5_fail2',
    ),
    'lx5_ok2': const StoryNode(
      id: 'lx5_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '↔️',
      text: '¡Pequeño! Los carteles del pueblo empiezan a llenarse '
          'de palabras. Los habitantes recuperan los recuerdos.',
      nextNode: 'lx5_ex3',
    ),
    'lx5_fail2': const StoryNode(
      id: 'lx5_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Pequeño. Grande ↔ pequeño, son contrarios.»',
      nextNode: 'lx5_ex3',
    ),
    'lx5_ex3': const StoryNode(
      id: 'lx5_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🤝',
      text: 'El alcalde te pide otra cosa: «Necesito la palabra que '
          'SIGNIFICA LO MISMO que "bonito".»',
      question: '¿Cuál es un SINÓNIMO de "bonito"?',
      options: ['Feo', 'Hermoso', 'Alto', 'Triste'],
      correctIndex: 1,
      hint: 'Sinónimo = significa lo mismo. Bonito = hermoso.',
      onCorrect: 'lx5_ok3',
      onIncorrect: 'lx5_fail3',
    ),
    'lx5_ok3': const StoryNode(
      id: 'lx5_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌸',
      text: '¡Hermoso! Las flores del pueblo recuperan color y belleza. '
          'El alcalde sonríe por primera vez en días.',
      nextNode: 'lx5_ex4',
    ),
    'lx5_fail3': const StoryNode(
      id: 'lx5_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Hermoso. Bonito y hermoso significan lo mismo: sinónimos.»',
      nextNode: 'lx5_ex4',
    ),
    'lx5_ex4': const StoryNode(
      id: 'lx5_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El último cartel antes de la salida del pueblo está vacío. '
          'Necesitas completar la frase del letrero.',
      question: '¿Cuál NO es un adjetivo: triste, alegre o saltar?',
      options: ['Triste', 'Alegre', 'Saltar'],
      correctIndex: 2,
      hint: 'Saltar es una ACCIÓN (verbo), no describe cómo es algo.',
      onCorrect: 'lx5_final_ok',
      onIncorrect: 'lx5_final_fail',
    ),
    'lx5_final_ok': const StoryNode(
      id: 'lx5_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🎉',
      text: '¡Saltar es un verbo, no un adjetivo! El cartel se completa '
          'y todo el pueblo estalla en aplausos. Los adjetivos han vuelto '
          'y con ellos, los colores y las descripciones.\n\n'
          '«¡Gracias, aprendiz!», dice el alcalde. «Te debemos una.»',
      nextNode: 'lx5_ending',
    ),
    'lx5_final_fail': const StoryNode(
      id: 'lx5_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Saltar. Es un verbo (acción). Triste y alegre son adjetivos.»',
      nextNode: 'lx5_ending',
    ),
    'lx5_ending': const StoryNode(
      id: 'lx5_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 5 de Lexis completado!\n\n'
          'Dominas adjetivos, antónimos y sinónimos.\n\n'
          '🏘️ Recompensa: Medalla del Pueblo',
    ),
  },
);
