import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// CAP 1: "La Puerta de la Torre"
/// Tema: Números 0-99, Unidades y Decenas (U0: Vuelta al cole)
/// ═══════════════════════════════════════════════════════════════
final chapter1Ignis = StoryChapter(
  id: 'ignis_c1',
  number: 1,
  title: 'La Puerta de la Torre',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Números 0-99, Unidades y Decenas',
  startNodeId: 'c1_intro',
  nodes: {
    'c1_intro': const StoryNode(
      id: 'c1_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏰',
      text: 'La Torre de Cristal se alza ante ti como un dedo gigante '
          'señalando al cielo. Sus paredes son de cristal oscuro y en cada '
          'ladrillo hay un número grabado. La puerta de entrada tiene un '
          'panel con símbolos que brillan débilmente.\n\n'
          'Orión se posa en tu hombro: «Cada cristal vale según su '
          'posición, aprendiz. Los de la derecha son unidades. Los de la '
          'izquierda, decenas. Si entiendes eso, la puerta se abrirá.»',
      nextNode: 'c1_ex1',
    ),
    'c1_ex1': const StoryNode(
      id: 'c1_ex1',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🚪',
      text: 'La cerradura de la puerta brilla. Tiene el número 74 grabado '
          'y debajo una pregunta tallada en piedra.',
      question: '¿Cuántas DECENAS hay en el número 74?',
      options: ['4', '7', '74', '47'],
      correctIndex: 1,
      hint: 'Las decenas son la cifra de la izquierda. En 74, ¿cuál es?',
      onCorrect: 'c1_acierto1',
      onIncorrect: 'c1_fallo1',
    ),
    'c1_acierto1': const StoryNode(
      id: 'c1_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡CLIC! La cerradura emite un destello azul y la puerta de '
          'cristal se desliza hacia arriba. Dentro, las escaleras brillan '
          'con números que parpadean. Algunos están apagados.\n\n'
          '«¡Perfecto!», exclama Orión. «7 decenas = 70. Y le sumamos las '
          '4 unidades. 70 + 4 = 74. ¡Así funcionan los cristales de la Torre!»',
      nextNode: 'c1_narr2',
    ),
    'c1_fallo1': const StoryNode(
      id: 'c1_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡Espera! No es eso. Mira: el 74 tiene dos partes. '
          'El 7 está en la posición de las DECENAS (vale 70) y el 4 en la '
          'de las UNIDADES. Así que hay 7 decenas.»\n\n'
          'La puerta se abre con un chirrido. «Recuerda: la cifra de la '
          'izquierda son las decenas.»',
      nextNode: 'c1_narr2',
    ),
    'c1_narr2': const StoryNode(
      id: 'c1_narr2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔢',
      text: 'Dentro de la torre, las paredes están cubiertas de cristales '
          'con números. Una escalera de piedra sube en espiral, pero algunos '
          'escalones están apagados y el camino se bifurca.',
      nextNode: 'c1_ex2',
    ),
    'c1_ex2': const StoryNode(
      id: 'c1_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: 'Orión señala un panel en la pared: «Para encender los cristales '
          'apagados y ver el camino, ordena estos números.»',
      question: '¿Cuál es el orden correcto de MENOR A MAYOR?\n45, 23, 67, 12',
      options: [
        '67, 45, 23, 12',
        '12, 23, 45, 67',
        '23, 12, 67, 45',
        '12, 45, 23, 67',
      ],
      correctIndex: 1,
      hint: '¿Cuál es el más pequeño de todos? Empieza por ahí.',
      onCorrect: 'c1_acierto2',
      onIncorrect: 'c1_fallo2',
    ),
    'c1_acierto2': const StoryNode(
      id: 'c1_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💡',
      text: 'Los cristales se encienden uno a uno: 12… 23… 45… 67. '
          'La escalera se ilumina hacia arriba revelando el primer piso.\n\n'
          '«¡Brilla como el amanecer!», ríe Orión volando entre los destellos.',
      nextNode: 'c1_decision',
    ),
    'c1_fallo2': const StoryNode(
      id: 'c1_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«De menor a mayor: 12 es el más pequeño, luego 23, después 45, '
          'y 67 es el más grande. ¡Fíjate en las decenas!»\n\n'
          'Los cristales se encienden en orden correcto.',
      nextNode: 'c1_decision',
    ),
    'c1_decision': const StoryNode(
      id: 'c1_decision',
      type: StoryNodeType.decision,
      text: 'En el primer piso hay dos pasillos. En la pared hay un mensaje '
          'tallado:\n\n«El pasillo de la DERECHA lleva a la Sala del Mapa. '
          'El de la IZQUIERDA al almacén de cristales rotos. '
          'El almacén está cerrado por desplome.»\n\n'
          '¿Por dónde vas?',
      choiceA: '➡️ Pasillo de la derecha — la Sala del Mapa',
      choiceB: '⬅️ Pasillo de la izquierda — el almacén',
      onChoiceA: 'c1_mapa',
      onChoiceB: 'c1_almacen',
    ),
    'c1_almacen': const StoryNode(
      id: 'c1_almacen',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🪨',
      text: 'El pasillo se estrecha y de golpe… ¡un montón de escombros! '
          'Cristales rotos y piedras bloquean el paso. ¡Está cerrado por '
          'desplome, como decía el mensaje!\n\n'
          'Orión suspira: «Había que leer con atención, aprendiz. Vamos '
          'por el otro pasillo.»',
      nextNode: 'c1_mapa',
    ),
    'c1_mapa': const StoryNode(
      id: 'c1_mapa',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🗺️',
      text: 'La Sala del Mapa es enorme. Un mapa mágico de la Torre flota '
          'en el centro, con pisos brillando como estrellas. Pero necesitas '
          'un último código para activarlo.',
      nextNode: 'c1_ex3',
    ),
    'c1_ex3': const StoryNode(
      id: 'c1_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🗝️',
      text: 'Orión lee un acertijo grabado en el borde del mapa.',
      question: 'Soy un número que tiene 5 decenas y 3 unidades. ¿Quién soy?',
      options: ['35', '53', '83', '50'],
      correctIndex: 1,
      hint: '5 decenas = 50. Y le sumamos 3 unidades. 50 + 3 = …',
      onCorrect: 'c1_final_ok',
      onIncorrect: 'c1_final_fail',
    ),
    'c1_final_ok': const StoryNode(
      id: 'c1_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⚡',
      text: '¡53! El mapa cobra vida. Los pisos de la Torre se iluminan '
          'uno a uno. Puedes ver dónde están las trampas, los Bruminos y '
          'un brillo rojo en lo alto: ¡el fragmento de la Gema Ignis!\n\n'
          '«Tu primer capítulo completado», dice Orión con orgullo. '
          '«Ahora sabes cómo funcionan los números de la Torre.»',
      nextNode: 'c1_ending',
    ),
    'c1_final_fail': const StoryNode(
      id: 'c1_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡53! 5 decenas son 50, más 3 unidades = 53. '
          'No te preocupes, ya irás pillándole el truco.»\n\n'
          'El mapa se activa mostrando toda la Torre.',
      nextNode: 'c1_ending',
    ),
    'c1_ending': const StoryNode(
      id: 'c1_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 1 completado!\n\n'
          'Has aprendido a leer números, identificar decenas y unidades, '
          'y ordenar de menor a mayor.\n\n'
          '🔮 Recompensa: Cristal de Cuarzo\n\n'
          'Al cruzar la puerta, las escaleras del segundo piso se ven… '
          'rotas. Faltan tramos enteros. Orión: «Escaleras rotas… esto me '
          'huele a PATRÓN. Alguien las rompió a propósito.»',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 2: "Las Escaleras de Cristal"
/// Tema: Números hasta 199, series (U1: ¡Todos en fila!)
/// ═══════════════════════════════════════════════════════════════
final chapter2Ignis = StoryChapter(
  id: 'ignis_c2',
  number: 2,
  title: 'Las Escaleras de Cristal',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Números hasta 199 y series',
  startNodeId: 'c2_intro',
  nodes: {
    'c2_intro': const StoryNode(
      id: 'c2_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🪜',
      text: 'Para subir al segundo piso necesitas las Escaleras de Cristal. '
          'Pero Noctus ha borrado los números de varios escalones. Sin '
          'ellos, si pisas el escalón equivocado… ¡se rompe!\n\n'
          'Orión examina la escalera: «Los números siguen un patrón. Si '
          'descubres la serie, sabrás cuáles faltan.»',
      nextNode: 'c2_ex1',
    ),
    'c2_ex1': const StoryNode(
      id: 'c2_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: '¡El primer escalón se hunde bajo tu pie! Debajo, un vacío '
          'oscuro. Los escalones que quedan dicen: 110, 120, ___, 140, ___',
      question: '¿Qué números faltan en la serie?\n110, 120, ___, 140, ___',
      options: [
        '125 y 150',
        '130 y 150',
        '135 y 155',
        '130 y 145',
      ],
      correctIndex: 1,
      hint: 'La serie va de 10 en 10. Después de 120, ¿qué viene?',
      onCorrect: 'c2_acierto1',
      onIncorrect: 'c2_fallo1',
    ),
    'c2_acierto1': const StoryNode(
      id: 'c2_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡130 y 150! Los escalones se materializan bajo tus pies, '
          'brillando con luz azul. Cada uno es sólido y firme.\n\n'
          '«¡De 10 en 10!», celebra Orión. «Eso es una serie aritmética.»',
      nextNode: 'c2_narr2',
    ),
    'c2_fallo1': const StoryNode(
      id: 'c2_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Va de 10 en 10: 110, 120, 130, 140, 150. ¡Cada salto '
          'sube 10!» Los escalones se llenan igualmente. «Fíjate en '
          'cuánto salta entre un número y el siguiente.»',
      nextNode: 'c2_narr2',
    ),
    'c2_narr2': const StoryNode(
      id: 'c2_narr2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: 'Llegas a un rellano donde los cristales de las paredes '
          'muestran números desordenados. Para que se enciendan y veas '
          'el camino, hay que ordenarlos.',
      nextNode: 'c2_ex2',
    ),
    'c2_ex2': const StoryNode(
      id: 'c2_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Pon estos números en orden para encender los cristales.»',
      question: 'Ordena de MENOR A MAYOR:\n156, 142, 178, 165',
      options: [
        '178, 165, 156, 142',
        '142, 156, 165, 178',
        '142, 165, 156, 178',
        '156, 142, 178, 165',
      ],
      correctIndex: 1,
      hint: 'Compara las centenas primero. Si son iguales, mira las decenas.',
      onCorrect: 'c2_acierto2',
      onIncorrect: 'c2_fallo2',
    ),
    'c2_acierto2': const StoryNode(
      id: 'c2_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💡',
      text: '142 → 156 → 165 → 178. Los cristales se encienden en cascada '
          'iluminando un pasillo largo. ¡Pero al fondo hay un Brumino!',
      nextNode: 'c2_ex3',
    ),
    'c2_fallo2': const StoryNode(
      id: 'c2_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«142 es el menor, luego 156, 165, y 178 el mayor. '
          '¡Compara siempre las decenas!»',
      nextNode: 'c2_ex3',
    ),
    'c2_ex3': const StoryNode(
      id: 'c2_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'Un Brumino vigila el rellano. Te ha visto. Se acerca '
          'arrastrando su cuerpo de niebla. Con voz rasposa, gruñe: '
          '«¡No pasarás sin responder!»',
      question: '¿Qué número es MAYOR: 167 o 176?',
      options: ['167', '176', 'Son iguales', '116'],
      correctIndex: 1,
      hint: 'Ambos empiezan por 1. Compara la decena: ¿6 o 7?',
      onCorrect: 'c2_acierto3',
      onIncorrect: 'c2_fallo3',
    ),
    'c2_acierto3': const StoryNode(
      id: 'c2_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💨',
      text: '«¡176!» El Brumino se deshace en una nube de humo, '
          'derrotado por tu conocimiento. ¡El pasillo queda despejado!\n\n'
          'La puerta del segundo piso está al fondo.',
      nextNode: 'c2_ex4',
    ),
    'c2_fallo3': const StoryNode(
      id: 'c2_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«176 es mayor: tiene 7 decenas frente a las 6 de 167.»\n\n'
          'Orión lanza un destello que dispersa al Brumino.',
      nextNode: 'c2_ex4',
    ),
    'c2_ex4': const StoryNode(
      id: 'c2_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'La puerta del segundo piso tiene una cerradura con tres '
          'casillas: C D U (Centena, Decena, Unidad).',
      question: '¿Cuántas centenas, decenas y unidades tiene el 195?\n(Formato: C-D-U)',
      options: ['1-9-5', '9-1-5', '5-9-1', '1-5-9'],
      correctIndex: 0,
      hint: 'El 1 está en las centenas, el 9 en las decenas, el 5 en las unidades.',
      onCorrect: 'c2_final_ok',
      onIncorrect: 'c2_final_fail',
    ),
    'c2_final_ok': const StoryNode(
      id: 'c2_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔓',
      text: '¡1 centena, 9 decenas, 5 unidades! La puerta se abre '
          'con un chirrido metálico. El segundo piso de la Torre te espera.\n\n'
          '«Ya sabes leer números de tres cifras», sonríe Orión.',
      nextNode: 'c2_ending',
    ),
    'c2_final_fail': const StoryNode(
      id: 'c2_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«En el 195: el 1 es la Centena, el 9 la Decena, el 5 la Unidad. '
          '¡C-D-U!» La puerta se abre.',
      nextNode: 'c2_ending',
    ),
    'c2_ending': const StoryNode(
      id: 'c2_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 2 completado!\n\n'
          'Has dominado las series numéricas, el orden de números '
          'y las centenas, decenas y unidades.\n\n'
          '🔮 Recompensa: Llave de Bronce\n\n'
          'Al llegar al tercer piso, un anciano de barba plateada camina '
          'nervioso entre runas que chisporrotean. Orión: «Es el '
          'Coleccionista de Runas… parece que tiene un problema URGENTE.»',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 3: "El Coleccionista de Runas"
/// Tema: Sumas, descomposición aditiva (U2: Cromos repetidos)
/// ═══════════════════════════════════════════════════════════════
final chapter3Ignis = StoryChapter(
  id: 'ignis_c3',
  number: 3,
  title: 'El Coleccionista de Runas',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Sumas y descomposición aditiva',
  startNodeId: 'c3_intro',
  nodes: {
    'c3_intro': const StoryNode(
      id: 'c3_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🧙',
      text: 'En el segundo piso encuentras a un viejo mago sentado ante '
          'una mesa llena de runas brillantes. Le faltan varias.\n\n'
          '«¡Ah, un aprendiz! Si me ayudas a juntar las runas que me faltan, '
          'te daré una pista sobre Noctus. Necesito SUMAR para '
          'completar los hechizos de protección.»',
      nextNode: 'c3_ex1',
    ),
    'c3_ex1': const StoryNode(
      id: 'c3_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'El coleccionista mezcla dos grupos de runas y te pide el total.',
      question: '¿Cuánto es 45 + 37?',
      options: ['72', '82', '73', '83'],
      correctIndex: 1,
      hint: '5 + 7 = 12. Llevo 1. 4 + 3 + 1 = 8. Resultado: 82.',
      onCorrect: 'c3_acierto1',
      onIncorrect: 'c3_fallo1',
    ),
    'c3_acierto1': const StoryNode(
      id: 'c3_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡82 runas! El hechizo de protección se activa — un escudo '
          'dorado envuelve la mesa del coleccionista.\n\n'
          '«¡Llevas bien las cuentas!», dice el viejo mago sonriendo.',
      nextNode: 'c3_ex2',
    ),
    'c3_fallo1': const StoryNode(
      id: 'c3_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Cuidado con la llevada: 5 + 7 = 12. Escribes el 2 y te '
          'llevas 1. Luego 4 + 3 + 1 = 8. Resultado: 82.»\n\n'
          'El hechizo se activa igualmente.',
      nextNode: 'c3_ex2',
    ),
    'c3_ex2': const StoryNode(
      id: 'c3_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Ahora descompón un número para activar esta runa antigua.»',
      question: 'Descompón el 84: ¿cuántas decenas y cuántas unidades?',
      options: [
        '4 decenas y 8 unidades',
        '8 decenas y 4 unidades',
        '80 decenas y 4 unidades',
        '8 decenas y 40 unidades',
      ],
      correctIndex: 1,
      hint: '84 = 80 + 4. 80 son 8 decenas. 4 son 4 unidades.',
      onCorrect: 'c3_acierto2',
      onIncorrect: 'c3_fallo2',
    ),
    'c3_acierto2': const StoryNode(
      id: 'c3_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📖',
      text: 'La runa antigua brilla con luz púrpura. El coleccionista te '
          'cuenta: «Noctus pasó por aquí hace tres noches. Robó la runa '
          'maestra y subió al tercer piso.»',
      nextNode: 'c3_ex3',
    ),
    'c3_fallo2': const StoryNode(
      id: 'c3_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«84 = 80 + 4. O sea, 8 decenas y 4 unidades. ¡Recuerda que '
          'la decena vale 10!»',
      nextNode: 'c3_ex3',
    ),
    'c3_ex3': const StoryNode(
      id: 'c3_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'Un Numerox aparece entre las estanterías de runas. '
          'Tiene ojos como números rojos y bloquea la puerta.',
      question: '¿Cuánto es 67 + 28?',
      options: ['85', '95', '75', '96'],
      correctIndex: 1,
      hint: '7 + 8 = 15. Llevas 1. 6 + 2 + 1 = 9. Resultado: 95.',
      onCorrect: 'c3_acierto3',
      onIncorrect: 'c3_fallo3',
    ),
    'c3_acierto3': const StoryNode(
      id: 'c3_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡95! El Numerox se agrieta y cae en mil pedazos de cristal.',
      nextNode: 'c3_ex4',
    ),
    'c3_fallo3': const StoryNode(
      id: 'c3_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«95. La llevada otra vez: 7 + 8 = 15, llevas 1, luego '
          '6 + 2 + 1 = 9.» Orión dispersa al Numerox con un destello.',
      nextNode: 'c3_ex4',
    ),
    'c3_ex4': const StoryNode(
      id: 'c3_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'El coleccionista te da un último mensaje cifrado:\n\n'
          '«La pista está en el piso ___»',
      question: 'Suma para descifrar el piso: 30 + 20 + 10 = ?',
      options: ['50', '60', '51', '70'],
      correctIndex: 1,
      hint: '30 + 20 = 50. Y 50 + 10 = 60.',
      onCorrect: 'c3_final_ok',
      onIncorrect: 'c3_final_fail',
    ),
    'c3_final_ok': const StoryNode(
      id: 'c3_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔮',
      text: '«¡Piso 60!» Bueno, la torre no tiene 60 pisos, pero el '
          'coleccionista se ríe: «Es un código. Significa que la siguiente '
          'pista está en el reloj roto del tercer piso.»\n\n'
          '«Gracias, aprendiz. Toma esta runa como recuerdo.»',
      nextNode: 'c3_ending',
    ),
    'c3_final_fail': const StoryNode(
      id: 'c3_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«30 + 20 + 10 = 60. Es un código: la siguiente pista está '
          'en el reloj del piso 3.»',
      nextNode: 'c3_ending',
    ),
    'c3_ending': const StoryNode(
      id: 'c3_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 3 completado!\n\n'
          'Has aprendido a sumar con llevada y a descomponer números.\n\n'
          '🔮 Recompensa: Runa del Coleccionista\n\n'
          'Un viejo aparece entre las sombras. «Psst… aprendiz. ¿Quieres '
          'ver algo que Noctus NO quiere que veas?» Señala una puerta '
          'lateral con un reloj grabado. Orión: «¿Un reloj? Aquí no '
          'debería haber relojes…»',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 4: "El Reloj de la Torre"
/// Tema: Hora en punto, media hora (U3: La hora del baño)
/// ═══════════════════════════════════════════════════════════════
final chapter4Ignis = StoryChapter(
  id: 'ignis_c4',
  number: 4,
  title: 'El Reloj de la Torre',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Hora en punto y media hora',
  startNodeId: 'c4_intro',
  nodes: {
    'c4_intro': const StoryNode(
      id: 'c4_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⏰',
      text: 'El tercer piso de la Torre es el Salón del Reloj. Un reloj '
          'gigante ocupa toda una pared, pero sus agujas están paradas y '
          'giradas al revés. Sin él, los hechizos de la Academia se activan '
          'a destiempo: puertas que se abren solas, trampas que disparan '
          'antes de que nadie pase.\n\n'
          '«Noctus rompió el reloj», suspira Orión. «Hay que arreglarlo.»',
      nextNode: 'c4_ex1',
    ),
    'c4_ex1': const StoryNode(
      id: 'c4_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: '¡Un hechizo de sueño se activa! La boca se te abre en un '
          'bostezo enorme. Orión ya está dormido sobre tu hombro. '
          'En la pared, el reloj marca las 3:00.',
      question: 'Para desactivar el hechizo de sueño, señala la hora: '
          '¿dónde debe estar la aguja corta si son las 3 en punto?',
      options: [
        'En el 12',
        'En el 6',
        'En el 3',
        'En el 9',
      ],
      correctIndex: 2,
      hint: 'La aguja CORTA señala la hora. Si son las 3, apunta al… 3.',
      onCorrect: 'c4_acierto1',
      onIncorrect: 'c4_fallo1',
    ),
    'c4_acierto1': const StoryNode(
      id: 'c4_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Las 3 en punto! Las agujas se ponen en su sitio. El hechizo '
          'de sueño se rompe. Orión se despierta de golpe: «¿¡Qué!? ¡Estoy '
          'despierto! ¡Nunca me dormí!»\n\n'
          '(Sí que se durmió.)',
      nextNode: 'c4_ex2',
    ),
    'c4_fallo1': const StoryNode(
      id: 'c4_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«La aguja CORTA siempre señala la hora. Si son las 3, apunta '
          'al número 3. Y la LARGA al 12 (en punto).»\n\n'
          'El reloj se ajusta y el hechizo desaparece.',
      nextNode: 'c4_ex2',
    ),
    'c4_ex2': const StoryNode(
      id: 'c4_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: 'Orión señala otro reloj en la pared: «La aguja larga está '
          'en el 6 y la corta en el 8. ¿Qué hora es?»',
      question: '¿Qué hora marca el reloj?',
      options: ['Las 6 y media', 'Las 8 y media', 'Las 8 en punto', 'Las 6 en punto'],
      correctIndex: 1,
      hint: 'La aguja corta marca la hora (8). La larga en el 6 = y media.',
      onCorrect: 'c4_acierto2',
      onIncorrect: 'c4_fallo2',
    ),
    'c4_acierto2': const StoryNode(
      id: 'c4_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '⏰',
      text: '¡Las 8 y media! Otro engranaje del reloj encaja en su sitio '
          'con un CLIC satisfactorio. ¡El reloj empieza a hacer tic-tac!',
      nextNode: 'c4_ex3',
    ),
    'c4_fallo2': const StoryNode(
      id: 'c4_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡Las 8 y media! Aguja corta = la hora (8). Aguja larga en '
          'el 6 = y media.»',
      nextNode: 'c4_ex3',
    ),
    'c4_ex3': const StoryNode(
      id: 'c4_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🗝️',
      text: 'Un acertijo tallado en el mecanismo del reloj.',
      question: 'Me preparé para salir a las 7:00. '
          'Tardé MEDIA HORA. ¿A qué hora salí?',
      options: ['A las 7:30', 'A las 7:00', 'A las 8:00', 'A las 6:30'],
      correctIndex: 0,
      hint: 'Si empezaste a las 7:00 y tardaste MEDIA hora, ¿qué hora es media hora después de las 7?',
      onCorrect: 'c4_acierto3',
      onIncorrect: 'c4_fallo3',
    ),
    'c4_acierto3': const StoryNode(
      id: 'c4_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔧',
      text: '¡Las 7:30! El último engranaje encaja. El reloj de la Torre '
          'empieza a funcionar: DONG, DONG, DONG. Los hechizos de la '
          'Academia vuelven a sincronizarse. Las puertas se cierran, '
          'las trampas se desactivan.',
      nextNode: 'c4_ex4',
    ),
    'c4_fallo3': const StoryNode(
      id: 'c4_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Las 7:00 + media hora = 7:30. Media hora = 30 minutos.»\n\n'
          'El reloj se arregla con un DONG sonoro.',
      nextNode: 'c4_ex4',
    ),
    'c4_ex4': const StoryNode(
      id: 'c4_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'La puerta al cuarto piso tiene un temporizador: '
          '«Solo se abre a las ___ y media.» Un cartel dice: '
          '«La hora correcta tiene la aguja corta en el 5.»',
      question: '¿A qué hora se abre la puerta?',
      options: ['A las 5:00', 'A las 5:30', 'A las 12:30', 'A las 6:30'],
      correctIndex: 1,
      hint: 'La aguja corta en el 5 = las 5. «Y media» = las 5:30.',
      onCorrect: 'c4_final_ok',
      onIncorrect: 'c4_final_fail',
    ),
    'c4_final_ok': const StoryNode(
      id: 'c4_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🎉',
      text: '¡Las 5 y media! La puerta se abre justo cuando el reloj '
          'marca esa hora. ¡Perfecto timing!\n\n'
          '«El tiempo ya vuelve a estar de nuestro lado», guiña Orión.',
      nextNode: 'c4_ending',
    ),
    'c4_final_fail': const StoryNode(
      id: 'c4_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Las 5:30. Aguja corta en el 5, y media = la larga en el 6.»',
      nextNode: 'c4_ending',
    ),
    'c4_ending': const StoryNode(
      id: 'c4_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 4 completado!\n\n'
          'Has aprendido a leer la hora en punto y y media.\n\n'
          '🔮 Recompensa: Engranaje Mágico\n\n'
          'El reloj de bolsillo empieza a vibrar en la mochila. Su esfera '
          'muestra un número: 5. Orión: «Cinco… ¿cinco qué? ¿Pisos? '
          '¿Enemigos?» Un rugido lejano responde desde arriba. Orión '
          'traga saliva: «Creo que son… espectadores.»',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 5: "El Torneo de los Aprendices"
/// Tema: Números hasta 299, comparar y ordenar (U4: ¡Vamos a ganar!)
/// ═══════════════════════════════════════════════════════════════
final chapter5Ignis = StoryChapter(
  id: 'ignis_c5',
  number: 5,
  title: 'El Torneo de los Aprendices',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Números hasta 299, comparar y ordenar',
  startNodeId: 'c5_intro',
  nodes: {
    'c5_intro': const StoryNode(
      id: 'c5_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏟️',
      text: 'El cuarto piso es el Gran Salón del Torneo. Cada año, los '
          'aprendices de la Torre compiten en desafíos numéricos para ganar '
          'el derecho a subir más pisos.\n\n'
          '«Hoy compites TÚ», dice Orión. «Tres rondas. Si ganas, subes. '
          'Si pierdes… bueno, Orión siempre tiene un plan B.»',
      nextNode: 'c5_ex1',
    ),
    'c5_ex1': const StoryNode(
      id: 'c5_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'RONDA 1. Tu rival se llama Sombra. El marcador aparece '
          'flotando en el aire: Tú: 234 · Sombra: 243.',
      question: '¿Quién tiene más puntos?',
      options: ['Tú (234)', 'Sombra (243)', 'Empate', 'No se puede saber'],
      correctIndex: 1,
      hint: 'Ambos empiezan por 2. Compara las decenas: 3 vs 4. ¿Cuál gana?',
      onCorrect: 'c5_acierto1',
      onIncorrect: 'c5_fallo1',
    ),
    'c5_acierto1': const StoryNode(
      id: 'c5_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📊',
      text: '243 > 234. Sombra lleva ventaja en esta ronda, pero tú '
          'ganas puntos de sabiduría por acertar. ¡Pasas a la ronda 2!',
      nextNode: 'c5_ex2',
    ),
    'c5_fallo1': const StoryNode(
      id: 'c5_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«243 es mayor: 4 decenas > 3 decenas. Las centenas son iguales '
          '(2), así que miras las decenas.»',
      nextNode: 'c5_ex2',
    ),
    'c5_ex2': const StoryNode(
      id: 'c5_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'RONDA 2. Cuatro competidores. Sus puntuaciones brillan '
          'sobre sus cabezas.',
      question: 'Ordena de MENOR a MAYOR:\n189, 201, 175, 298',
      options: [
        '175, 189, 201, 298',
        '189, 175, 298, 201',
        '298, 201, 189, 175',
        '175, 201, 189, 298',
      ],
      correctIndex: 0,
      hint: 'El más pequeño tiene 1 centena (175). El más grande, 298.',
      onCorrect: 'c5_acierto2',
      onIncorrect: 'c5_fallo2',
    ),
    'c5_acierto2': const StoryNode(
      id: 'c5_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🎯',
      text: '¡175 → 189 → 201 → 298! El público aplaude. '
          'Llegas a la final contra Sombra.',
      nextNode: 'c5_narr_final',
    ),
    'c5_fallo2': const StoryNode(
      id: 'c5_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«175 es el menor, luego 189, 201, y 298 el mayor. '
          '¡Mira primero las centenas!»',
      nextNode: 'c5_narr_final',
    ),
    'c5_narr_final': const StoryNode(
      id: 'c5_narr_final',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '👁️',
      text: 'La final. Sombra te mira fijamente. Pero detrás de ella, '
          'en las gradas más altas, una silueta oscura observa: '
          'capa negra, ojos fríos. ¡Noctus está viendo el torneo!\n\n'
          'Orión te susurra: «Concéntrate. Demuéstrale lo que sabes.»',
      nextNode: 'c5_ex3',
    ),
    'c5_ex3': const StoryNode(
      id: 'c5_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'RONDA FINAL. Dos preguntas rápidas.',
      question: '¿Cuál es MAYOR: 256 o 265?',
      options: ['256', '265', 'Son iguales', '562'],
      correctIndex: 1,
      hint: 'Misma centena (2). Compara decenas: 5 vs 6.',
      onCorrect: 'c5_ex4',
      onIncorrect: 'c5_fallo3',
    ),
    'c5_fallo3': const StoryNode(
      id: 'c5_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«265 > 256. Decena 6 > decena 5.»',
      nextNode: 'c5_ex4',
    ),
    'c5_ex4': const StoryNode(
      id: 'c5_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'Última pregunta del torneo. El público contiene el aliento.',
      question: '¿Qué número viene JUSTO ANTES de 200?',
      options: ['201', '199', '198', '210'],
      correctIndex: 1,
      hint: '200 - 1 = …',
      onCorrect: 'c5_final_ok',
      onIncorrect: 'c5_final_fail',
    ),
    'c5_final_ok': const StoryNode(
      id: 'c5_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏅',
      text: '¡199! ¡HAS GANADO EL TORNEO! El público estalla en aplausos. '
          'Orión vuela en círculos de alegría (y se choca con una columna).\n\n'
          'Noctus desaparece de las gradas. No parece contento.\n\n'
          'El maestro del torneo te entrega la Medalla del Torneo y '
          'el permiso para subir al quinto piso.',
      nextNode: 'c5_ending',
    ),
    'c5_final_fail': const StoryNode(
      id: 'c5_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«199. Justo antes de 200 es 199. ¡Pero has llegado a la '
          'final! Eso ya es un logro.»',
      nextNode: 'c5_ending',
    ),
    'c5_ending': const StoryNode(
      id: 'c5_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 5 completado!\n\n'
          'Has aprendido a comparar y ordenar números hasta 299.\n\n'
          '🏅 Recompensa: Medalla del Torneo\n\n'
          'Orión mira hacia las gradas vacías con tristeza. «Hace mucho '
          'tiempo, en este mismo torneo, tuve otro aprendiz…» Se calla. '
          'Sacude la cabeza. Al salir, hay algo tallado en la pared con '
          'arañazos profundos: el número 186 y debajo: «PRIMERA PRUEBA». '
          'Orión: «El Guardián de este piso nos espera. Y ya sabe que '
          'venimos.»',
    ),
  },
);
