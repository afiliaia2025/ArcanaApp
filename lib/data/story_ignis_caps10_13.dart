import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// BOSS 2: "El General de Piedra"
/// Tema: Todo de U5-U8 (restas, sumas 3 sum., multiplicar, capacidad)
/// ═══════════════════════════════════════════════════════════════
final boss2Ignis = StoryChapter(
  id: 'ignis_boss2',
  number: 11,
  title: 'El General de Piedra',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Boss: Repaso U5-U8',
  startNodeId: 'b2_intro',
  nodes: {
    'b2_intro': const StoryNode(
      id: 'b2_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🗿',
      text: 'El camino se estrecha entre dos montañas. De pronto, '
          'la tierra TIEMBLA. Un golem gigante hecho de piedra se alza '
          'ante ti. Tiene puños enormes y ojos de rubí.\n\n'
          '«SOY EL GENERAL DE PIEDRA. NADIE ME HA DERROTADO.»\n\n'
          'Orión: «Es el segundo boss. ¡Usa todo lo de los últimos capítulos!»',
      nextNode: 'b2_ex1',
    ),
    'b2_ex1': const StoryNode(
      id: 'b2_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'El General golpea el suelo. Una onda expansiva lleva un '
          'número grabado.',
      question: '¿Cuánto es 378 - 145?',
      options: ['233', '223', '243', '213'],
      correctIndex: 0,
      hint: '8-5=3, 7-4=3, 3-1=2. Resultado: 233.',
      onCorrect: 'b2_ok1',
      onIncorrect: 'b2_fail1',
    ),
    'b2_ok1': const StoryNode(
      id: 'b2_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡233! ¡CRACK! Un pedazo del brazo del General se desprende '
          'y cae al suelo. El golem ruge furioso.',
      nextNode: 'b2_ex2',
    ),
    'b2_fail1': const StoryNode(
      id: 'b2_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«233. Resta columna a columna: 8-5=3, 7-4=3, 3-1=2.»',
      nextNode: 'b2_ex2',
    ),
    'b2_ex2': const StoryNode(
      id: 'b2_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'El General levanta su otro puño. Un brillo de multiplicación.',
      question: '¿Cuánto es 5 × 8?',
      options: ['35', '40', '45', '58'],
      correctIndex: 1,
      hint: 'Tabla del 5: 5,10,15,20,25,30,35,40. O suma 5 ocho veces.',
      onCorrect: 'b2_ok2',
      onIncorrect: 'b2_fail2',
    ),
    'b2_ok2': const StoryNode(
      id: 'b2_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡40! El puño del General EXPLOTA en pedazos de roca. '
          'Ahora no tiene brazos. Pero aún puede pisar.',
      nextNode: 'b2_ex3',
    ),
    'b2_fail2': const StoryNode(
      id: 'b2_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«40. 5 × 8 = 40. Cuenta de 5 en 5 hasta la octava vez.»',
      nextNode: 'b2_ex3',
    ),
    'b2_ex3': const StoryNode(
      id: 'b2_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'El General pisa el suelo y se abre una grieta. Dentro hay '
          'agua que sube. Un cartel dice cuánta necesitas para sellarla.',
      question: 'Tienes jarras de 2 litros. ¿Cuántas necesitas '
          'para llenar un cubo de 8 litros?',
      options: ['2', '3', '4', '6'],
      correctIndex: 2,
      hint: '8 ÷ 2 = 4. O cuenta: 2, 4, 6, 8 = 4 jarras.',
      onCorrect: 'b2_ok3',
      onIncorrect: 'b2_fail3',
    ),
    'b2_ok3': const StoryNode(
      id: 'b2_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡4 jarras! La grieta se sella. El General pierde una pierna '
          'y cae de rodillas. Dos pruebas más.',
      nextNode: 'b2_ex4',
    ),
    'b2_fail3': const StoryNode(
      id: 'b2_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«4. 8 ÷ 2 = 4 jarras.»',
      nextNode: 'b2_ex4',
    ),
    'b2_ex4': const StoryNode(
      id: 'b2_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'El General lanza su última pierna al suelo. Caen tres rocas '
          'con números que necesitas sumar.',
      question: '¿Cuánto es 135 + 246 + 110?',
      options: ['481', '491', '501', '391'],
      correctIndex: 1,
      hint: '135+246=381. 381+110=491.',
      onCorrect: 'b2_ok4',
      onIncorrect: 'b2_fail4',
    ),
    'b2_ok4': const StoryNode(
      id: 'b2_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡491! La pierna se desmorona. El General es ya un tronco '
          'de roca balanceándose sin equilibrio.',
      nextNode: 'b2_ex5',
    ),
    'b2_fail4': const StoryNode(
      id: 'b2_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«491. 135+246=381, luego 381+110=491.»',
      nextNode: 'b2_ex5',
    ),
    'b2_ex5': const StoryNode(
      id: 'b2_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'PRUEBA FINAL. El General, casi destruido, murmura '
          'un último reto con voz de piedra rota.',
      question: '¿Cómo se escribe el número 580 en letras?',
      options: [
        'Quinientos ochenta',
        'Quinientos ocho',
        'Cincuenta y ocho',
        'Cinco ochenta',
      ],
      correctIndex: 0,
      hint: '580 = quinientos ( 500) + ochenta (80).',
      onCorrect: 'b2_final_ok',
      onIncorrect: 'b2_final_fail',
    ),
    'b2_final_ok': const StoryNode(
      id: 'b2_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💎',
      text: '«Quinientos ochenta.» ¡K-BOOM! El General de Piedra se '
          'desmorona en una avalancha de guijarros. Entre las piedras '
          'brilla el SEGUNDO FRAGMENTO de la Gema Ignis.\n\n'
          'Orión: «¡Dos de tres! ¡Ya queda menos para recuperar la gema!»',
      nextNode: 'b2_ending',
    ),
    'b2_final_fail': const StoryNode(
      id: 'b2_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Quinientos ochenta. 500 + 80.»\n'
          'El General cae igualmente.',
      nextNode: 'b2_ending',
    ),
    'b2_ending': const StoryNode(
      id: 'b2_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡BOSS DERROTADO!\n\n'
          'Has usado restas, multiplicación, capacidad y sumas '
          'de 3 sumandos para vencer al General de Piedra.\n\n'
          '💎 Recompensa: Fragmento de Gema Ignis (2/3) · +200 XP',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 10: "El Pergamino Cifrado"
/// Tema: Números hasta 999, valor posicional C/D/U (U9)
/// ═══════════════════════════════════════════════════════════════
final chapter10Ignis = StoryChapter(
  id: 'ignis_c10',
  number: 12,
  title: 'El Pergamino Cifrado',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Números hasta 999 y valor posicional',
  startNodeId: 'c10_intro',
  nodes: {
    'c10_intro': const StoryNode(
      id: 'c10_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📜',
      text: 'Entre los escombros del General encuentras un pergamino '
          'sellado con el símbolo de Noctus. Parece ser un mensaje '
          'cifrado con instrucciones secretas.\n\n'
          '«Si lo desciframos, sabremos su plan», dice Orión con los '
          'ojos muy abiertos.',
      nextNode: 'c10_ex1',
    ),
    'c10_ex1': const StoryNode(
      id: 'c10_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'El primer código del pergamino usa posiciones: 8C 3D 5U.',
      question: 'El código dice: 8C 3D 5U. ¿Qué número es?\n'
          '(C = Centenas, D = Decenas, U = Unidades)',
      options: ['385', '835', '538', '853'],
      correctIndex: 1,
      hint: '8 Centenas = 800. 3 Decenas = 30. 5 Unidades = 5. Total: 835.',
      onCorrect: 'c10_acierto1',
      onIncorrect: 'c10_fallo1',
    ),
    'c10_acierto1': const StoryNode(
      id: 'c10_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡835! La primera línea del pergamino se ilumina: «Enviar 835 '
          'Bruminos al valle del norte.» ¡Es el plan de ataque de Noctus!',
      nextNode: 'c10_ex2',
    ),
    'c10_fallo1': const StoryNode(
      id: 'c10_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«835. 8C=800, 3D=30, 5U=5. ¡800+30+5=835!»',
      nextNode: 'c10_ex2',
    ),
    'c10_ex2': const StoryNode(
      id: 'c10_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🗝️',
      text: 'Otro acertijo en el pergamino.',
      question: 'Soy un número de tres cifras. Mi centena es 7, '
          'mi decena es 0, mi unidad es 4. ¿Quién soy?',
      options: ['740', '704', '407', '470'],
      correctIndex: 1,
      hint: '7 centenas + 0 decenas + 4 unidades = 704.',
      onCorrect: 'c10_acierto2',
      onIncorrect: 'c10_fallo2',
    ),
    'c10_acierto2': const StoryNode(
      id: 'c10_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📖',
      text: '¡704! Otra línea se revela: «Objetivo 704: la Fuente del '
          'Saber.» ¡Noctus quiere la Fuente!\n\n'
          'Orión: «¡Hay que avisarselo a todos!»',
      nextNode: 'c10_ex3',
    ),
    'c10_fallo2': const StoryNode(
      id: 'c10_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«704. Centena 7, decena 0, unidad 4. ¡El cero también cuenta!»',
      nextNode: 'c10_ex3',
    ),
    'c10_ex3': const StoryNode(
      id: 'c10_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Para romper el sello final del pergamino necesito '
          'que me digas…»',
      question: '¿Cuántas CENTENAS tiene el número 602?',
      options: ['0', '2', '6', '60'],
      correctIndex: 2,
      hint: 'En 602, el 6 está en la posición de las centenas.',
      onCorrect: 'c10_acierto3',
      onIncorrect: 'c10_fallo3',
    ),
    'c10_acierto3': const StoryNode(
      id: 'c10_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔓',
      text: '¡6 centenas! El sello se rompe. El pergamino se despliega '
          'completamente revelando todo el plan de Noctus.\n\n'
          '«Ahora sabemos exactamente lo que planea», dice Orión serio. '
          '«Hay que llegar antes a la Fuente del Saber.»',
      nextNode: 'c10_ex4',
    ),
    'c10_fallo3': const StoryNode(
      id: 'c10_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«6. En 602, el 6 ocupa la posición de las CENTENAS.»',
      nextNode: 'c10_ex4',
    ),
    'c10_ex4': const StoryNode(
      id: 'c10_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'El último código del pergamino está escrito en letras. '
          'Necesitas convertirlo a número.',
      question: '¿Cuánto es "novecientos quince" en número?',
      options: ['905', '950', '915', '951'],
      correctIndex: 2,
      hint: 'Novecientos = 900. Quince = 15. 900 + 15 = 915.',
      onCorrect: 'c10_final_ok',
      onIncorrect: 'c10_final_fail',
    ),
    'c10_final_ok': const StoryNode(
      id: 'c10_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📋',
      text: '¡915! El pergamino completo ahora es tuyo. Sabes todo '
          'el plan de Noctus: enviar 835 Bruminos, atacar la Fuente '
          'del Saber (objetivo 704), y hacerlo a las 915 horas.\n\n'
          '«Con esto podemos prepararnos», sonríe Orión.',
      nextNode: 'c10_ending',
    ),
    'c10_final_fail': const StoryNode(
      id: 'c10_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«915. Novecientos (900) + quince (15).»',
      nextNode: 'c10_ending',
    ),
    'c10_ending': const StoryNode(
      id: 'c10_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 10 completado!\n\n'
          'Has dominado los números hasta 999 y el valor posicional.\n\n'
          '📜 Recompensa: Pergamino Descifrado',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 11: "El Mercado Oscuro"
/// Tema: Monedas y billetes (U10: El mago)
/// ═══════════════════════════════════════════════════════════════
final chapter11Ignis = StoryChapter(
  id: 'ignis_c11',
  number: 13,
  title: 'El Mercado Oscuro',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Monedas y billetes (€)',
  startNodeId: 'c11_intro',
  nodes: {
    'c11_intro': const StoryNode(
      id: 'c11_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🏪',
      text: 'Siguiendo las pistas del pergamino llegas a un mercado '
          'clandestino escondido entre callejones oscuros. Aquí venden '
          'objetos mágicos que necesitas para el hechizo de protección.\n\n'
          'Un vendedor con capucha te mira: «Aquí todo tiene precio, '
          'aprendiz. ¿Traes monedas?»',
      nextNode: 'c11_ex1',
    ),
    'c11_ex1': const StoryNode(
      id: 'c11_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'La poción que necesitas cuesta 13€. Solo tienes un billete '
          'de 20€.',
      question: 'Pagas con 20€ una poción de 13€. ¿Cuánto te devuelven?',
      options: ['5€', '7€', '8€', '3€'],
      correctIndex: 1,
      hint: '20 - 13 = 7. Te devuelven 7€.',
      onCorrect: 'c11_acierto1',
      onIncorrect: 'c11_fallo1',
    ),
    'c11_acierto1': const StoryNode(
      id: 'c11_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡7€ de vuelta! El vendedor intenta darte solo 5€, pero '
          'tú sabes que son 7. «Tienes buena cabeza para las cuentas, '
          'aprendiz», gruñe entregándote las 2€ que faltaban.',
      nextNode: 'c11_ex2',
    ),
    'c11_fallo1': const StoryNode(
      id: 'c11_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«7€. 20 - 13 = 7. ¡No dejes que te engañen!»',
      nextNode: 'c11_ex2',
    ),
    'c11_ex2': const StoryNode(
      id: 'c11_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'Otro vendedor te cobra por unas hierbas: «Son 2€ + 5€ + 1€. '
          'Total: 9€», dice muy seguro.',
      question: '¿El vendedor ha calculado bien? 2€ + 5€ + 1€ = ¿?',
      options: ['Sí, son 9€', 'No, son 8€', 'No, son 7€', 'No, son 10€'],
      correctIndex: 1,
      hint: '2 + 5 = 7. 7 + 1 = 8. ¡No son 9!',
      onCorrect: 'c11_acierto2',
      onIncorrect: 'c11_fallo2',
    ),
    'c11_acierto2': const StoryNode(
      id: 'c11_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '😤',
      text: '«¡Son 8€, no 9!» El vendedor se pone rojo: «Ehhh, sí, '
          'perdona, error de cálculo…» ¡Te intentaba engañar!\n\n'
          'Orión hincha el pecho: «Mi aprendiz no es tonto.»',
      nextNode: 'c11_ex3',
    ),
    'c11_fallo2': const StoryNode(
      id: 'c11_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡Son 8€! 2+5+1=8, no 9. Ese vendedor intentaba timarte.»',
      nextNode: 'c11_ex3',
    ),
    'c11_ex3': const StoryNode(
      id: 'c11_ex3',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Necesitamos comprar un cristal mágico. Cuesta 15€ y solo '
          'tenemos monedas de 2€.»',
      question: '¿Puedes pagar EXACTAMENTE 15€ con monedas de 2€?',
      options: [
        'Sí, 7 monedas y media',
        'No, porque 15 no es par',
        'Sí, 8 monedas',
        'Sí, 7 monedas',
      ],
      correctIndex: 1,
      hint: '15 ÷ 2 = 7.5. No puedes tener media moneda. 15 es impar.',
      onCorrect: 'c11_acierto3',
      onIncorrect: 'c11_fallo3',
    ),
    'c11_acierto3': const StoryNode(
      id: 'c11_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🪙',
      text: '«¡Correcto! No puedes pagar exacto.» Pero un viejo te ofrece '
          'cambio: te da monedas de 1€ a cambio de una de 2€. Ahora sí '
          'puedes pagar 15€ exactos: 7 monedas de 2€ + 1 moneda de 1€.',
      nextNode: 'c11_ex4',
    ),
    'c11_fallo3': const StoryNode(
      id: 'c11_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«No, 15 es impar. Con monedas de 2 solo haces pares: '
          '2,4,6,8,10,12,14,16… ¡15 no está!»',
      nextNode: 'c11_ex4',
    ),
    'c11_ex4': const StoryNode(
      id: 'c11_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'Antes de irte, un vendedor misterioso susurra:\n'
          '«Tengo información sobre Noctus. Pero… ¿podrás resolver '
          'mi acertijo?»',
      question: 'Tengo un billete de 50€. Compro algo de 35€. '
          '¿Me queda suficiente para comprar algo de 20€?',
      options: [
        'Sí, me quedan 15€ que son suficientes',
        'No, me quedan 15€ y no alcanzan para 20€',
        'Sí, me quedan 25€',
        'No, me quedan 5€',
      ],
      correctIndex: 1,
      hint: '50 - 35 = 15. ¿15 es suficiente para 20? No, porque 15 < 20.',
      onCorrect: 'c11_final_ok',
      onIncorrect: 'c11_final_fail',
    ),
    'c11_final_ok': const StoryNode(
      id: 'c11_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🤫',
      text: '«¡Correcto! No alcanza.» El vendedor sonríe bajo su capucha: '
          '«Noctus estuvo aquí ayer. Fue hacia el norte, buscando… espejos.»\n\n'
          '«¿Espejos?», pregunta Orión. «La Sala de los Espejos…»',
      nextNode: 'c11_ending',
    ),
    'c11_final_fail': const StoryNode(
      id: 'c11_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«No. 50-35=15, y 15 < 20. No alcanza.»',
      nextNode: 'c11_ending',
    ),
    'c11_ending': const StoryNode(
      id: 'c11_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 11 completado!\n\n'
          'Has aprendido a usar monedas, billetes y a calcular el cambio.\n\n'
          '🪙 Recompensa: Moneda de la Suerte',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 12: "La Sala de los Espejos"
/// Tema: Figuras 2D, longitud m/cm (U11)
/// ═══════════════════════════════════════════════════════════════
final chapter12Ignis = StoryChapter(
  id: 'ignis_c12',
  number: 14,
  title: 'La Sala de los Espejos',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Figuras geométricas 2D y longitud',
  startNodeId: 'c12_intro',
  nodes: {
    'c12_intro': const StoryNode(
      id: 'c12_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🪞',
      text: 'Siguiendo la pista, llegas a una sala secreta llena de espejos '
          'que reflejan formas geométricas. Cada espejo muestra un mundo '
          'diferente. Solo UNO muestra el camino real.\n\n'
          '«Las formas son la clave», dice Orión. «El espejo correcto '
          'tiene la forma correcta.»',
      nextNode: 'c12_ex1',
    ),
    'c12_ex1': const StoryNode(
      id: 'c12_ex1',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '🗝️',
      text: 'El primer espejo tiene un marco con 4 lados iguales y 4 esquinas.',
      question: '¿Qué forma tiene el marco del espejo?\n'
          '4 lados iguales y 4 esquinas (ángulos rectos)',
      options: ['Triángulo', 'Cuadrado', 'Círculo', 'Rectángulo'],
      correctIndex: 1,
      hint: 'Cuatro lados IGUALES + cuatro esquinas = cuadrado.',
      onCorrect: 'c12_acierto1',
      onIncorrect: 'c12_fallo1',
    ),
    'c12_acierto1': const StoryNode(
      id: 'c12_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '✨',
      text: '¡Cuadrado! El espejo se ilumina y muestra un pasillo largo. '
          'Pero es un espejismo — aún necesitas más pistas.',
      nextNode: 'c12_ex2',
    ),
    'c12_fallo1': const StoryNode(
      id: 'c12_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡Cuadrado! 4 lados iguales y 4 esquinas iguales.»',
      nextNode: 'c12_ex2',
    ),
    'c12_ex2': const StoryNode(
      id: 'c12_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«La puerta mide 2 metros. El espejo mide 150 centímetros.»',
      question: '¿Qué es más ALTO: la puerta o el espejo?',
      options: [
        'El espejo (150 cm)',
        'La puerta (2 metros)',
        'Son iguales',
        'No se puede comparar',
      ],
      correctIndex: 1,
      hint: '2 metros = 200 cm. Y 200 > 150.',
      onCorrect: 'c12_acierto2',
      onIncorrect: 'c12_fallo2',
    ),
    'c12_acierto2': const StoryNode(
      id: 'c12_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📏',
      text: '¡La puerta! 2 metros = 200 cm, que es más que 150 cm. '
          'Otro espejo descartado — vas acercándote al correcto.',
      nextNode: 'c12_ex3',
    ),
    'c12_fallo2': const StoryNode(
      id: 'c12_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«La puerta. 2 metros = 200 cm, y 200 > 150.»',
      nextNode: 'c12_ex3',
    ),
    'c12_ex3': const StoryNode(
      id: 'c12_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'El suelo de la sala tiene baldosas con formas. Necesitas '
          'pisar solo las triangulares para no caer.',
      question: '¿Cuántos LADOS tiene un triángulo?',
      options: ['2', '3', '4', '5'],
      correctIndex: 1,
      hint: 'TRI-ángulo. Tri = tres.',
      onCorrect: 'c12_acierto3',
      onIncorrect: 'c12_fallo3',
    ),
    'c12_acierto3': const StoryNode(
      id: 'c12_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔺',
      text: '¡3 lados! Pisas solo las baldosas triangulares y cruzas '
          'la sala sin problemas. Al fondo, el espejo correcto muestra '
          'una visión aterradora: Noctus preparando su ataque final.',
      nextNode: 'c12_ex4',
    ),
    'c12_fallo3': const StoryNode(
      id: 'c12_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«3 lados. Tri = tres. Triángulo = tres ángulos.»',
      nextNode: 'c12_ex4',
    ),
    'c12_ex4': const StoryNode(
      id: 'c12_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'La cerradura de la salida tiene forma de círculo. '
          'Un mensaje dice: «Responde bien y la puerta se abrirá.»',
      question: '¿Cuántos LADOS tiene un círculo?',
      options: ['1', '2', 'Ninguno (0)', '4'],
      correctIndex: 2,
      hint: 'Un círculo es una línea curva cerrada. No tiene lados rectos.',
      onCorrect: 'c12_final_ok',
      onIncorrect: 'c12_final_fail',
    ),
    'c12_final_ok': const StoryNode(
      id: 'c12_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🔮',
      text: '¡Ninguno! La cerradura gira y la puerta se abre. El espejo '
          'correcto te muestra la salida. Pero la visión de Noctus '
          'sigue en tu mente.\n\n'
          '«Ya falta poco», dice Orión. «La batalla final se acerca.»',
      nextNode: 'c12_ending',
    ),
    'c12_final_fail': const StoryNode(
      id: 'c12_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Ninguno. El círculo no tiene lados rectos, es todo curva.»',
      nextNode: 'c12_ending',
    ),
    'c12_ending': const StoryNode(
      id: 'c12_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 12 completado!\n\n'
          'Has aprendido figuras geométricas (triángulo, cuadrado, '
          'círculo) y a medir en metros y centímetros.\n\n'
          '🪞 Recompensa: Espejo de Bolsillo',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// CAP 13: "El Banquete Final"
/// Tema: Dobles, mitades, gráficos de barras (U12)
/// ═══════════════════════════════════════════════════════════════
final chapter13Ignis = StoryChapter(
  id: 'ignis_c13',
  number: 15,
  title: 'El Banquete Final',
  gemName: 'Ignis',
  subject: 'Matemáticas',
  topic: 'Dobles, mitades y gráficos de barras',
  startNodeId: 'c13_intro',
  nodes: {
    'c13_intro': const StoryNode(
      id: 'c13_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🍽️',
      text: 'Antes de ir a por Noctus, el pueblo organiza un gran '
          'banquete. Necesitan fuerzas para la batalla. Pero alguien '
          'tiene que organizar la comida.\n\n'
          '«Tú eres el más listo con los números», dice la alcaldesa. '
          '«Ayúdanos a calcular las raciones.»\n\n'
          'Orión ya está mirando los pasteles.',
      nextNode: 'c13_ex1',
    ),
    'c13_ex1': const StoryNode(
      id: 'c13_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🧪',
      text: 'La alcaldesa cuenta los invitados y la fruta disponible.',
      question: 'Cada invitado come MEDIA manzana. Hay 10 invitados. '
          '¿Cuántas manzanas necesitas?',
      options: ['10', '20', '5', '15'],
      correctIndex: 2,
      hint: 'Cada uno come media (1/2). 10 × 1/2 = 5 manzanas enteras.',
      onCorrect: 'c13_acierto1',
      onIncorrect: 'c13_fallo1',
    ),
    'c13_acierto1': const StoryNode(
      id: 'c13_acierto1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🍎',
      text: '¡5 manzanas! Cada una se corta por la mitad: 5 × 2 mitades '
          '= 10 medias manzanas, una para cada invitado. ¡Perfecto!',
      nextNode: 'c13_ex2',
    ),
    'c13_fallo1': const StoryNode(
      id: 'c13_fallo1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«5 manzanas. Si cada uno come media, dos invitados comparten '
          'una manzana. 10 ÷ 2 = 5.»',
      nextNode: 'c13_ex2',
    ),
    'c13_ex2': const StoryNode(
      id: 'c13_ex2',
      type: StoryNodeType.exercise,
      speaker: 'orion',
      emoji: '✨',
      text: '«Necesitamos el DOBLE de platos porque van a venir '
          'refuerzos de otros pueblos.»',
      question: '¿Cuál es el DOBLE de 36 platos?',
      options: ['62', '72', '66', '76'],
      correctIndex: 1,
      hint: 'Doble = × 2. 36 × 2: 6×2=12 (llevas 1), 3×2+1=7. → 72.',
      onCorrect: 'c13_acierto2',
      onIncorrect: 'c13_fallo2',
    ),
    'c13_acierto2': const StoryNode(
      id: 'c13_acierto2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🍽️',
      text: '¡72 platos! Los aldeanos corren a preparar la mesa. Es la '
          'mesa más larga que has visto jamás.',
      nextNode: 'c13_ex3',
    ),
    'c13_fallo2': const StoryNode(
      id: 'c13_fallo2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«72. Doble de 36: 6×2=12, llevas 1. 3×2=6+1=7. → 72.»',
      nextNode: 'c13_ex3',
    ),
    'c13_ex3': const StoryNode(
      id: 'c13_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '📜',
      text: 'La alcaldesa te muestra un gráfico de barras con las '
          'elecciones de comida de los aldeanos:\n'
          '🟦🟦🟦🟦🟦🟦🟦 Sopa = 7\n'
          '🟩🟩🟩🟩🟩 Ensalada = 5\n'
          '🟧🟧🟧🟧🟧🟧🟧🟧 Estofado = 8',
      question: '¿Cuántas personas eligieron SOPA?',
      options: ['5', '7', '8', '20'],
      correctIndex: 1,
      hint: 'Lee la barra de la Sopa: hay 7 cuadraditos.',
      onCorrect: 'c13_acierto3',
      onIncorrect: 'c13_fallo3',
    ),
    'c13_acierto3': const StoryNode(
      id: 'c13_acierto3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📊',
      text: '¡7 personas! El cocinero prepara 7 cazuelas de sopa. '
          'Orión se ofrece a «probarlas» (se come dos enteras).\n\n'
          'El banquete está casi listo.',
      nextNode: 'c13_ex4',
    ),
    'c13_fallo3': const StoryNode(
      id: 'c13_fallo3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«7 personas. Cuenta los cuadraditos azules de la barra.»',
      nextNode: 'c13_ex4',
    ),
    'c13_ex4': const StoryNode(
      id: 'c13_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'La fiesta está en su punto álgido cuando la alcaldesa '
          'dice: «Es tarde, la mitad de los invitados deben irse a '
          'descansar para mañana.»',
      question: 'La MITAD de 48 invitados se van. ¿Cuántos QUEDAN?',
      options: ['12', '20', '24', '28'],
      correctIndex: 2,
      hint: 'Mitad de 48: 48 ÷ 2 = 24. Se quedan 24.',
      onCorrect: 'c13_final_ok',
      onIncorrect: 'c13_final_fail',
    ),
    'c13_final_ok': const StoryNode(
      id: 'c13_final_ok',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌙',
      text: '¡24! La mitad se va a dormir. Los 24 que quedan brindan '
          'bajo las estrellas.\n\n'
          'Orión, con la barriga llena, se duerme en tu hombro. '
          '«Mañana será el gran día», susurras. La Torre de Cristal '
          'brilla tenuemente en el horizonte.\n\n'
          'Noctus está allí. Y tú irás a buscarle.',
      nextNode: 'c13_ending',
    ),
    'c13_final_fail': const StoryNode(
      id: 'c13_final_fail',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«24. La mitad de 48 es 24. 48 ÷ 2 = 24.»',
      nextNode: 'c13_ending',
    ),
    'c13_ending': const StoryNode(
      id: 'c13_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡Capítulo 13 completado!\n\n'
          'Has aprendido dobles, mitades y a leer gráficos de barras.\n\n'
          '🍖 Recompensa: Receta Mágica',
    ),
  },
);
