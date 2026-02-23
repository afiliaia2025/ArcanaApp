import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// PRÓLOGO: "El Sobre que se Tragó al Aprendiz"
/// ═══════════════════════════════════════════════════════════════
///
/// El niño abre un sobre mágico y es ABSORBIDO dentro, apareciendo
/// en un bosque oscuro de Numeralia. Debe LEER inscripciones, carteles
/// y mensajes tallados en piedra para decidir por dónde ir.
/// Si no entiende lo que lee → elige mal → consecuencia narrativa:
///   - cae en la gruta de un monstruo
///   - un túnel le devuelve al inicio
///   - se pierde en la niebla
/// Pero NUNCA hay game-over: siempre hay un camino de vuelta.
///
/// La comprensión lectora no es un "examen" — es SUPERVIVENCIA.
StoryChapter get storyPrologue => StoryChapter(
  id: 'prologue',
  number: 0,
  title: 'El Sobre que se Tragó al Aprendiz',
  gemName: 'Prólogo',
  subject: 'Comprensión Lectora',
  topic: 'Introducción al mundo y los personajes',
  startNodeId: 'sobre_1',
  nodes: {

    // ═══════════════════════════════════════
    // ACTO 1: EL SOBRE MÁGICO
    // ═══════════════════════════════════════

    'sobre_1': const StoryNode(
      id: 'sobre_1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✉️',
      text: 'Al fondo de tu mochila hay algo que antes no estaba: un sobre '
          'dorado que brilla como si tuviera fuego dentro. Pesa más de lo '
          'normal. Y está caliente.\n\n'
          'Lo abres.',
      nextNode: 'sobre_2',
    ),

    'sobre_2': const StoryNode(
      id: 'sobre_2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌀',
      text: 'Un remolino de luz dorada EXPLOTA del sobre. Las letras salen '
          'volando como mariposas luminosas. El suelo desaparece bajo tus '
          'pies. Caes. Giras. El mundo se deshace en colores.\n\n'
          'Y de golpe… silencio.\n\n'
          'Estás tumbado sobre hierba húmeda. Huele a musgo y a tormenta. '
          'Cuando abres los ojos, ves árboles enormes con troncos retorcidos '
          'que se pierden en la niebla. No es tu cuarto. No es el cole.\n\n'
          'Es un bosque que nunca has visto en tu vida.',
      nextNode: 'bosque_1',
    ),

    'bosque_1': const StoryNode(
      id: 'bosque_1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌲',
      text: 'Te levantas temblando. El sobre dorado sigue en tu mano, '
          'pero ahora sólo queda un trozo de pergamino dentro. Tiene algo '
          'escrito con tinta que brilla:\n\n'
          '«Estás en el Bosque de la Entrada, al borde de Numeralia. '
          'Los Bruminos patrullan este bosque cuando cae la noche. '
          'No te quedes quieto. Busca el camino de la derecha, marcado '
          'con tres piedras blancas. El de la izquierda lleva a la Gruta '
          'del Roncador. Corre. — O.»',
      nextNode: 'decision_gruta',
    ),

    // ═══════════════════════════════════════
    // DECISIÓN 1: ¿Has leído bien?
    // ═══════════════════════════════════════

    'decision_gruta': const StoryNode(
      id: 'decision_gruta',
      type: StoryNodeType.decision,
      text: 'Delante de ti, el bosque se divide en dos caminos. '
          'A la izquierda, un sendero oscuro baja hacia una cueva de la que '
          'sale un ronquido profundo. A la derecha, un camino con tres '
          'piedras blancas a la entrada.\n\n'
          '¿Por dónde vas?',
      choiceA: '➡️ El camino de las tres piedras blancas',
      choiceB: '⬅️ El sendero que baja a la cueva',
      onChoiceA: 'camino_correcto_1',
      onChoiceB: 'gruta_roncador',
    ),

    // ── CAMINO CORRECTO ─────────────────
    'camino_correcto_1': const StoryNode(
      id: 'camino_correcto_1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Bien leído! Sigues las tres piedras blancas. El camino '
          'serpentea entre los árboles. Los ronquidos de la cueva se alejan '
          'a tu espalda.\n\n'
          'A los pocos metros, una luciérnaga enorme — ¿o es un ojo? '
          '— aparece flotando delante de ti.',
      nextNode: 'orion_aparece',
    ),

    // ── GRUTA DEL RONCADOR (fallo) ──────
    'gruta_roncador': const StoryNode(
      id: 'gruta_roncador',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '👹',
      text: 'Bajas por el sendero oscuro. Los ronquidos se hacen más fuertes. '
          'Más fuertes. MÁS FUERTES.\n\n'
          'Dentro de la cueva, la luz de tu sobre ilumina algo grande y '
          'peludo. Una criatura del tamaño de un oso con cuatro ojos '
          'cerrados y una boca enormous. Es un Roncador — un monstruo de '
          'Numeralia que duerme de día.\n\n'
          'Uno de sus ojos se abre.\n\n'
          '«GRRUUUUUMPF», gruñe.',
      nextNode: 'escape_roncador',
    ),

    'escape_roncador': const StoryNode(
      id: 'escape_roncador',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💨',
      text: '¡Sales corriendo! El Roncador intenta levantarse pero es '
          'tan grande que se atasca en la puerta de su cueva.\n\n'
          'Vuelves al cruce. El pergamino DECÍA: «Busca el camino de la '
          'DERECHA, marcado con TRES PIEDRAS BLANCAS». ¡Tenías que leer '
          'con más atención!\n\n'
          'Esta vez sigues las piedras blancas. Te prometes a ti mismo: '
          '«Voy a leer TODO con cuidado.»',
      nextNode: 'orion_aparece',
    ),

    // ═══════════════════════════════════════
    // ACTO 2: ORIÓN APARECE
    // ═══════════════════════════════════════

    'orion_aparece': const StoryNode(
      id: 'orion_aparece',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🦉',
      text: 'La luciérnaga resulta ser un búho. Un búho plateado con ojos '
          'como dos lunas llenas, un sombrero torcido y unas gafas que se '
          'le resbalan por el pico.\n\n'
          'Se posa en una rama delante de ti y habla.\n\n'
          '«¡POR FIN! Llevo tres días esperándote, aprendiz. Me caí de '
          'esta rama dos veces, me picó una abeja mágica y casi me come un '
          'Brumino. Pero aquí estoy. Me llamo Orión, y soy tu guía.\n\n'
          'Sé que estás asustado. Pero te necesitamos. El mago Noctus ha '
          'robado las cuatro Gemas del Conocimiento y sin ellas Numeralia '
          'se APAGA. Literalmente. Mira.»',
      nextNode: 'numeralia_oscura',
    ),

    'numeralia_oscura': const StoryNode(
      id: 'numeralia_oscura',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌑',
      text: 'Orión señala con un ala hacia el horizonte. Más allá del '
          'bosque, se ven cuatro torres a lo lejos. Pero tres de ellas '
          'están completamente a oscuras. Solo una conserva un brillo '
          'débil, parpadeante, como una vela a punto de apagarse.\n\n'
          '«Cuatro torres, cuatro gemas», dice Orión. '
          '«🔥 Ignis controla los Números. 📜 Lexis controla las Palabras. '
          '🌿 Sylva controla la Naturaleza. 🌀 Babel controla las Lenguas. '
          'Noctus las ha robado TODAS. Los Bruminos — sus criaturas de '
          'niebla — vigilan cada zona. '
          'Y sus cuatro Generales guardan los fragmentos.»',
      nextNode: 'orion_pergamino',
    ),

    'orion_pergamino': const StoryNode(
      id: 'orion_pergamino',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Necesito saber si puedo confiar en ti. En Numeralia, el arma '
          'más poderosa no es la magia… es ENTENDER lo que lees. Cada '
          'inscripción, cada cartel, cada pergamino tiene información que '
          'puede salvarte o perderte.\n\n'
          'Mira ese tronco de ahí.»\n\n'
          'Señala un árbol enorme. En la corteza hay letras talladas que '
          'brillan con luz verde:\n\n'
          '«Cuando escuches pasos en la niebla, no corras. Los Bruminos '
          'perciben el movimiento. Quédate quieto y contendrán el aliento '
          'durante diez latidos. Después, camina despacio hacia la luz '
          'más cercana.»',
      nextNode: 'comprension_bruminos',
    ),

    // ═══════════════════════════════════════
    // COMPRENSIÓN 1: Bruminos
    // ═══════════════════════════════════════

    'comprension_bruminos': const StoryNode(
      id: 'comprension_bruminos',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🌫️',
      text: 'De repente, una niebla espesa empieza a avanzar entre los '
          'árboles. Dentro se oyen pasos lentos. Orión te mira con los '
          'ojos muy abiertos y susurra: «¡Bruminos! ¿Qué decía la '
          'inscripción?»',
      question: 'Hay Bruminos en la niebla. ¿Qué debes hacer?',
      options: [
        'Correr lo más rápido posible',
        'Quedarte quieto y luego caminar despacio hacia la luz',
        'Gritar para asustarlos',
        'Esconderte dentro de la cueva del Roncador',
      ],
      correctIndex: 1,
      hint: 'Lee otra vez la inscripción del tronco: ¿qué perciben los '
          'Bruminos? ¿Qué debes hacer PRIMERO y DESPUÉS?',
      onCorrect: 'bruminos_bien',
      onIncorrect: 'bruminos_mal',
    ),

    'bruminos_bien': const StoryNode(
      id: 'bruminos_bien',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '😮‍💨',
      text: 'Te quedas completamente quieto. La niebla te envuelve. '
          'Sientes algo frío que te roza la cara — como dedos de humo. '
          'Una forma oscura pasa a un metro de ti. Dos ojos blancos te '
          'miran… y siguen de largo.\n\n'
          'Uno… dos… tres… diez latidos.\n\n'
          'Caminas despacio hacia una luz entre los árboles. Los Bruminos '
          'se pierden en la niebla sin volver.\n\n'
          'Orión exhala: «Perfecto. Has leído y has entendido. '
          'Eso te salvará muchas veces aquí.»',
      nextNode: 'puente_inscripcion',
    ),

    'bruminos_mal': const StoryNode(
      id: 'bruminos_mal',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '😱',
      text: '¡Sales corriendo! Los Bruminos te detectan al instante. '
          'Tres sombras de niebla se lanzan hacia ti. Una te atrapa del '
          'tobillo — frío gelido — y…\n\n'
          '¡FLASH! Una ráfaga de luz dorada. Orión ha lanzado un destello '
          'mágico que dispersa a los Bruminos.\n\n'
          '«¡La inscripción decía QUIETO!», jadea Orión. '
          '«Perciben el movimiento. Tenías que quedarte quieto y después '
          'caminar despacio. ¡Lee con atención, aprendiz! '
          'De esto depende tu piel aquí.»',
      nextNode: 'puente_inscripcion',
    ),

    // ═══════════════════════════════════════
    // ACTO 3: EL PUENTE Y LAS INSCRIPCIONES
    // ═══════════════════════════════════════

    'puente_inscripcion': const StoryNode(
      id: 'puente_inscripcion',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌉',
      text: 'El camino lleva a un barranco. Un viejo puente de cuerdas '
          'cruza al otro lado, donde los árboles brillan con luz cálida.\n\n'
          'Pero hay un problema. En la entrada del puente hay un poste de '
          'piedra con dos señales:\n\n'
          '⬅️ Señal izquierda: «Atajo rápido. Camino sin parar.»\n\n'
          '➡️ Señal derecha: «Puente viejo. Solo aguanta a quien cruce '
          'despacio, pisando SOLO las tablas marcadas con un punto azul. '
          'Las otras se rompen.»\n\n'
          'Debajo, en letras pequeñas, alguien ha escrito con carbón:\n'
          '«Vi a tres personas caer por el atajo. No es un atajo. Es una '
          'trampa de Noctus. —O.»',
      nextNode: 'decision_puente',
    ),

    'decision_puente': const StoryNode(
      id: 'decision_puente',
      type: StoryNodeType.decision,
      text: 'Dos opciones ante el barranco.\n\n'
          'Las señales, el aviso de Orión en carbón… '
          '¿has leído TODO bien?',
      choiceA: '➡️ Cruzar el puente viejo despacio, pisando solo las tablas con punto azul',
      choiceB: '⬅️ Tomar el atajo rápido',
      onChoiceA: 'puente_bien',
      onChoiceB: 'trampa_noctus',
    ),

    'puente_bien': const StoryNode(
      id: 'puente_bien',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: 'Pisas solo las tablas con punto azul. El puente cruje, se '
          'balancea… pero aguanta. Una tabla sin punto se rompe al lado '
          'tuyo y cae al vacío. Tardas un minuto de puro terror, pero '
          'llegas al otro lado.\n\n'
          'Orión te espera con las alas abiertas: «¡Lo has conseguido! '
          'Has leído las dos señales Y el aviso de abajo. La lectura '
          'te ha salvado del vacío.»',
      nextNode: 'claro_final',
    ),

    'trampa_noctus': const StoryNode(
      id: 'trampa_noctus',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🕳️',
      text: 'Tomas el atajo. El camino parece normal durante cinco pasos… '
          'y de repente el suelo se hunde. ¡Es una trampa!\n\n'
          'CAES por un túnel mágico que da vueltas y vueltas. '
          'Sales disparado… y aterrizas en la hierba.\n\n'
          'Espera. Es la MISMA hierba húmeda del principio, junto al poste '
          'de señales. ¡La trampa te ha devuelto al inicio del puente!\n\n'
          'Orión aparece volando: «Alguien escribió con carbón que el atajo '
          'es una trampa. Si hubieras leído la nota de abajo… Ahora, '
          'lee TODO esta vez.»',
      nextNode: 'decision_puente_2',
    ),

    // Segunda oportunidad
    'decision_puente_2': const StoryNode(
      id: 'decision_puente_2',
      type: StoryNodeType.decision,
      text: 'Estás otra vez frente al poste. Las señales siguen ahí. '
          'Y abajo, en carbón: «El atajo es una trampa de Noctus.»\n\n'
          '¿Lo has entendido esta vez?',
      choiceA: '➡️ Cruzar el puente despacio, solo tablas azules',
      choiceB: '⬅️ Probar el atajo otra vez',
      onChoiceA: 'puente_bien',
      onChoiceB: 'trampa_2',
    ),

    'trampa_2': const StoryNode(
      id: 'trampa_2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '¡Otra vez! El suelo se hunde, vuelves a dar vueltas por el '
          'túnel y aterrizas de vuelta en el inicio.\n\n'
          '«¡Aprendiz!», dice Orión con cara de circunstancias. '
          '«¡El aviso dice TRAMPA! ¡T-R-A-M-P-A! '
          'El puente viejo es el bueno. Despacio. Tablas azules. ¡Vamos!»\n\n'
          'Esta vez te agarra del hombro con una garra y te lleva directo '
          'al puente.',
      nextNode: 'puente_bien',
    ),

    // ═══════════════════════════════════════
    // ACTO 4: EL CLARO — NOCTUS, LAS GEMAS
    // ═══════════════════════════════════════

    'claro_final': const StoryNode(
      id: 'claro_final',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏔️',
      text: 'Al otro lado del puente se abre un claro en el bosque. '
          'ES ENORME. Y desde aquí se ve todo Numeralia.\n\n'
          'Cuatro territorios diferentes, cada uno con una torre:\n'
          '• 🔥 A la derecha, una torre de cristal oscuro. La Torre Ignis.\n'
          '• 📜 Un bosque dorado con árboles de hojas-letra. Bosque Lexis.\n'
          '• 🌿 Un jardín salvaje lleno de criaturas. Jardín Sylva.\n'
          '• 🌀 Portales flotantes de colores. Portal Babel.\n\n'
          'Pero todo está apagado. Las torres no brillan. Los portales '
          'están cerrados. El jardín se marchita.',
      nextNode: 'noctus_vision',
    ),

    'noctus_vision': const StoryNode(
      id: 'noctus_vision',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⚡',
      text: 'Un relámpago negro cruza el cielo. Por un segundo, '
          'ves una silueta recortada contra las nubes: una capa raída, '
          'un sombrero puntiagudo, dos ojos que brillan con luz fría.\n\n'
          'Noctus.\n\n'
          'Una voz grave retumba como un trueno:\n'
          '«Otro aprendiz… Qué aburrido. La magia del conocimiento ahora es '
          'MÍA. Mis Bruminos vigilan cada camino. Mis Generales guardan '
          'cada fragmento. Y tú… tú eres solo un niño con un búho torpe.»\n\n'
          'El relámpago desaparece. La oscuridad vuelve.',
      nextNode: 'orion_anima',
    ),

    'orion_anima': const StoryNode(
      id: 'orion_anima',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«No le hagas caso. Ese es su truco: quiere que tengas miedo '
          'y que dejes de intentarlo.\n\n'
          'Escucha bien, aprendiz. Noctus tiene todo el poder mágico, sí. '
          'Pero hay algo que no puede hacer: '
          'no puede APRENDER. Se quedó atrapado en lo que ya sabe. '
          'Tú, en cambio, puedes crecer. '
          'Cada vez que lees, calculas, entiendes… te haces más fuerte.\n\n'
          'Eso le aterra.\n\n'
          '¿Ves ese muro de piedra? Tiene instrucciones '
          'para activar el mapa mágico. Si consigues leerlas y entenderlas, '
          'podremos empezar la misión de verdad.»',
      nextNode: 'muro_final',
    ),

    // ═══════════════════════════════════════
    // COMPRENSIÓN FINAL: El Muro
    // ═══════════════════════════════════════

    'muro_final': const StoryNode(
      id: 'muro_final',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧱',
      text: 'Hay un muro de piedra antiguo cubierto de musgo. Las letras '
          'están talladas con cuidado:\n\n'
          '«Para activar el Mapa de Numeralia, coloca la mano sobre la '
          'PRIMERA gema, que controla los números. Su nombre empieza por '
          'la misma letra que la palabra FUEGO.\n\n'
          'NO toques la gema verde — está conectada a una alarma '
          'de los Bruminos.\n\n'
          'NO toques la gema violeta — abre un portal que '
          'no puedes controlar aún.»',
      nextNode: 'decision_gema',
    ),

    'decision_gema': const StoryNode(
      id: 'decision_gema',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '💎',
      text: 'Delante del muro hay cuatro huecos con gemas de colores:\n'
          '🔥 Roja   🌿 Verde   📜 Dorada   🌀 Violeta\n\n'
          'Orión susurra: «Lee el muro otra vez con cuidado. '
          '¿Cuál debes tocar?»',
      question: '¿Qué gema debes tocar para activar el mapa?',
      options: [
        '🌿 La verde — la gema de la naturaleza',
        '🌀 La violeta — la gema de los portales',
        '🔥 La roja — Ignis, que empieza como FUEGO',
        '📜 La dorada — la gema de las palabras',
      ],
      correctIndex: 2,
      hint: 'El muro dice: «la PRIMERA gema, que controla los números». '
          '«Su nombre empieza por la misma letra que FUEGO.» '
          'F de Fuego, F de… ¿qué gema empieza por esa letra?',
      onCorrect: 'gema_correcta',
      onIncorrect: 'gema_incorrecta',
    ),

    'gema_correcta': const StoryNode(
      id: 'gema_correcta',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🗺️',
      text: 'Tocas la gema roja. ¡IGNIS! El muro vibra. Las letras '
          'se iluminan como brasas. El suelo tiembla bajo tus pies.\n\n'
          'De las grietas del muro emerge un mapa de luz que se '
          'proyecta en el aire: montañas, ríos, bosques, cuatro '
          'torres, caminos que brillan.\n\n'
          '«¡El Mapa de Numeralia!», exclama Orión revoloteando de alegría. '
          '«¡Has leído las instrucciones perfectamente! '
          'La primera gema era Ignis — I de Ignis, como F de Fuego. '
          '¡Empezamos por la Torre de Cristal!»',
      nextNode: 'mision_go',
    ),

    'gema_incorrecta': const StoryNode(
      id: 'gema_incorrecta',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⚠️',
      text: '¡BZZZT! La gema suelta una descarga de chispas. Retiras la '
          'mano rápidamente.\n\n'
          '«¡Esa no!», grita Orión. «El muro dice que la primera gema '
          'controla los NÚMEROS y su nombre empieza como FUEGO. '
          'F como Fuego… esa es la gema IGNIS. ¡La roja!»\n\n'
          'Tocas la gema roja. '
          'El muro vibra y de las grietas emerge un mapa de luz.',
      nextNode: 'mision_go',
    ),

    // ═══════════════════════════════════════
    // FINAL: MISIÓN ACEPTADA
    // ═══════════════════════════════════════

    'mision_go': const StoryNode(
      id: 'mision_go',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Aprendiz, has cruzado el bosque, escapado de los Bruminos, '
          'pasado el puente y activado el mapa. Y todo porque has LEÍDO '
          'y ENTENDIDO.\n\n'
          'Eso es tu superpoder aquí. Noctus tiene magia. Tiene monstruos. '
          'Tiene trampas. Pero no puede quitarte una cosa: lo que aprendes.\n\n'
          'Cada vez que entiendas algo nuevo, tu poder crece. '
          'Cada ejercicio resuelto restaura un trozo de gema. '
          'Cada capítulo completado debilita a Noctus.\n\n'
          '¿Listo para empezar la aventura de verdad?»',
      nextNode: 'ending',
    ),

    'ending': const StoryNode(
      id: 'ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🗺️',
      text: '¡Prólogo completado!\n\n'
          'Ya conoces Numeralia, a Orión y a Noctus.\n'
          'El Mapa te espera. La Torre Ignis brilla a lo lejos.\n\n'
          '🔥 Primera misión: recuperar la Gema de los Números.',
    ),
  },
);
