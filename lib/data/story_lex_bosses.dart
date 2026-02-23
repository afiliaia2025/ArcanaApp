import '../models/story_models.dart';

/// ═══════════════════════════════════════════════════════════════
/// BOSS 2 LEXIS: "El Escriba Oscuro"
/// Tema: Repaso U6-U10
/// ═══════════════════════════════════════════════════════════════
final boss2Lexis = StoryChapter(
  id: 'lexis_boss2',
  number: 12,
  title: 'El Escriba Oscuro',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Boss: Repaso U6-U10',
  startNodeId: 'lb2_intro',
  nodes: {
    'lb2_intro': const StoryNode(
      id: 'lb2_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🖋️',
      text: 'Siguiendo el mapa llegas a una torre de pergaminos apilados. '
          'En la cima, un escriba de tinta negra te espera: es el ESCRIBA '
          'OSCURO, segundo General de Noctus en el reino de las Palabras.\n\n'
          '«Tus palabras son débiles, aprendiz. ¡Mis errores te atraparán!»\n\n'
          'Orión: «¡Usa todo lo que has aprendido!»',
      nextNode: 'lb2_ex1',
    ),
    'lb2_ex1': const StoryNode(
      id: 'lb2_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'El Escriba lanza una onda de puntuación rota.',
      question: '¿Qué signos necesita "_Cuidado_"?',
      options: ['¿Cuidado?', '¡Cuidado!', 'Cuidado.', '"Cuidado"'],
      correctIndex: 1,
      hint: 'Es una exclamación de alarma → ¡...!',
      onCorrect: 'lb2_ok1',
      onIncorrect: 'lb2_fail1',
    ),
    'lb2_ok1': const StoryNode(
      id: 'lb2_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Cuidado! Los signos impactan al Escriba. Su pluma se rompe.',
      nextNode: 'lb2_ex2',
    ),
    'lb2_fail1': const StoryNode(
      id: 'lb2_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«¡Cuidado! Exclamación = ¡...!»',
      nextNode: 'lb2_ex2',
    ),
    'lb2_ex2': const StoryNode(
      id: 'lb2_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'El Escriba lanza verbos desordenados.',
      question: '"Ayer jugué al fútbol." ¿Es pasado, presente o futuro?',
      options: ['Pasado', 'Presente', 'Futuro'],
      correctIndex: 0,
      hint: '"Ayer" + "jugué" = ya ocurrió = pasado.',
      onCorrect: 'lb2_ok2',
      onIncorrect: 'lb2_fail2',
    ),
    'lb2_ok2': const StoryNode(
      id: 'lb2_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Pasado! El escudo temporal del Escriba se resquebraja.',
      nextNode: 'lb2_ex3',
    ),
    'lb2_fail2': const StoryNode(
      id: 'lb2_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Pasado. "Ayer" = ya pasó.»',
      nextNode: 'lb2_ex3',
    ),
    'lb2_ex3': const StoryNode(
      id: 'lb2_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'El Escriba escupe letras confusas.',
      question: '¿Cuál es correcta: "cigüeña" o "cigueña"?',
      options: ['cigueña', 'cigüeña'],
      correctIndex: 1,
      hint: 'La U suena → diéresis: cigüeña.',
      onCorrect: 'lb2_ok3',
      onIncorrect: 'lb2_fail3',
    ),
    'lb2_ok3': const StoryNode(
      id: 'lb2_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Cigüeña con diéresis! El Escriba pierde su capa de tinta.',
      nextNode: 'lb2_ex4',
    ),
    'lb2_fail3': const StoryNode(
      id: 'lb2_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Cigüeña. Diéresis porque la U suena.»',
      nextNode: 'lb2_ex4',
    ),
    'lb2_ex4': const StoryNode(
      id: 'lb2_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'El antónimo es su debilidad.',
      question: '¿Cuál es el antónimo de "frío"?',
      options: ['Helado', 'Caliente', 'Tibio', 'Fresco'],
      correctIndex: 1,
      hint: 'Frío ↔ caliente.',
      onCorrect: 'lb2_ok4',
      onIncorrect: 'lb2_fail4',
    ),
    'lb2_ok4': const StoryNode(
      id: 'lb2_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Caliente! El Escriba empieza a derretirse. Último reto.',
      nextNode: 'lb2_ex5',
    ),
    'lb2_fail4': const StoryNode(
      id: 'lb2_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Caliente. Frío ↔ caliente.»',
      nextNode: 'lb2_ex5',
    ),
    'lb2_ex5': const StoryNode(
      id: 'lb2_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🚪',
      text: 'RETO FINAL. El Escriba, casi derretido, susurra...',
      question: 'Corrige: "noctus quiere robar las gemas"',
      options: [
        'noctus quiere robar las gemas',
        'Noctus quiere robar las gemas',
        'Noctus Quiere Robar Las Gemas',
        'NOCTUS quiere robar las gemas',
      ],
      correctIndex: 1,
      hint: 'Noctus es nombre propio → mayúscula. Inicio de oración → mayúscula.',
      onCorrect: 'lb2_victoria',
      onIncorrect: 'lb2_fail5',
    ),
    'lb2_victoria': const StoryNode(
      id: 'lb2_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💎',
      text: '¡Noctus con mayúscula! ¡SPLASHH! El Escriba Oscuro se '
          'convierte en un charco de tinta. Entre la tinta brilla '
          'el SEGUNDO FRAGMENTO de la Gema Lexis.\n\n'
          'Orión: «¡Dos de tres! ¡Las palabras nos obedecen!»',
      nextNode: 'lb2_ending',
    ),
    'lb2_fail5': const StoryNode(
      id: 'lb2_fail5',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Noctus con N mayúscula. Es nombre propio.»',
      nextNode: 'lb2_ending',
    ),
    'lb2_ending': const StoryNode(
      id: 'lb2_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡BOSS DERROTADO!\n\n'
          'Has combinado puntuación, verbos, ortografía, antónimos '
          'y mayúsculas para vencer al Escriba Oscuro.\n\n'
          '💎 Recompensa: Fragmento de Gema Lexis (2/3) · +200 XP',
    ),
  },
);

/// ═══════════════════════════════════════════════════════════════
/// BOSS FINAL LEXIS: "El Guardián de las Palabras"
/// Tema: TODO Lengua (repaso general)
/// ═══════════════════════════════════════════════════════════════
final bossFinalLexis = StoryChapter(
  id: 'lexis_boss_final',
  number: 13,
  title: 'El Guardián de las Palabras',
  gemName: 'Lexis',
  subject: 'Lengua',
  topic: 'Boss Final: Repaso de todo el año',
  startNodeId: 'lbf_intro',
  nodes: {
    'lbf_intro': const StoryNode(
      id: 'lbf_intro',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '📖',
      text: 'El mapa te lleva al corazón del Bosque Lexis: el Gran '
          'Árbol de las Palabras. Su tronco es una biblioteca viva. '
          'Y en sus raíces, un DRAGÓN de papel custodia la gema.\n\n'
          '«SOY EL GUARDIÁN DE LAS PALABRAS. Solo quien domine TODO '
          'el lenguaje podrá pasar.»\n\n'
          'Orión traga saliva: «Es el boss final de Lexis. ¡Todo o nada!»',
      nextNode: 'lbf_ex1',
    ),
    'lbf_ex1': const StoryNode(
      id: 'lbf_ex1',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '⚔️',
      text: 'El Guardián ruge y las sílabas tiemblan.',
      question: '¿Cómo se separa "cocodrilo" en sílabas?',
      options: ['co-co-dri-lo', 'coco-dri-lo', 'co-cod-ri-lo', 'coc-o-dri-lo'],
      correctIndex: 0,
      hint: 'CO-CO-DRI-LO. 4 sílabas.',
      onCorrect: 'lbf_ok1',
      onIncorrect: 'lbf_fail1',
    ),
    'lbf_ok1': const StoryNode(
      id: 'lbf_ok1',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Co-co-dri-lo! Una escama del Guardián cae.',
      nextNode: 'lbf_ex2',
    ),
    'lbf_fail1': const StoryNode(
      id: 'lbf_fail1',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Co-co-dri-lo. 4 sílabas.»',
      nextNode: 'lbf_ex2',
    ),
    'lbf_ex2': const StoryNode(
      id: 'lbf_ex2',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🔥',
      text: 'El Guardián sopla fuego de letras.',
      question: '¿Cuál es el plural de "luz"?',
      options: ['Luzs', 'Luzes', 'Luces', 'Luz'],
      correctIndex: 2,
      hint: 'Luz → luces. La Z se convierte en CES.',
      onCorrect: 'lbf_ok2',
      onIncorrect: 'lbf_fail2',
    ),
    'lbf_ok2': const StoryNode(
      id: 'lbf_ok2',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Luces! El fuego se apaga. Otra escama cae.',
      nextNode: 'lbf_ex3',
    ),
    'lbf_fail2': const StoryNode(
      id: 'lbf_fail2',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Luces. Z → CES.»',
      nextNode: 'lbf_ex3',
    ),
    'lbf_ex3': const StoryNode(
      id: 'lbf_ex3',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '✨',
      text: 'El Guardián lanza una pregunta de sinónimos.',
      question: '¿Cuál es un sinónimo de "contento"?',
      options: ['Triste', 'Alegre', 'Enfadado', 'Asustado'],
      correctIndex: 1,
      hint: 'Contento = alegre. Significan lo mismo.',
      onCorrect: 'lbf_ok3',
      onIncorrect: 'lbf_fail3',
    ),
    'lbf_ok3': const StoryNode(
      id: 'lbf_ok3',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Alegre! El Guardián retrocede. La gema brilla en su pecho.',
      nextNode: 'lbf_ex4',
    ),
    'lbf_fail3': const StoryNode(
      id: 'lbf_fail3',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Alegre. Contento = alegre.»',
      nextNode: 'lbf_ex4',
    ),
    'lbf_ex4': const StoryNode(
      id: 'lbf_ex4',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🪤',
      text: 'El Guardián conjuga verbos en el aire.',
      question: '"Ella ___ (estudiar, pasado)". ¿Qué va en el hueco?',
      options: ['estudia', 'estudió', 'estudiará', 'estudiando'],
      correctIndex: 1,
      hint: 'Ella + estudiar en pasado = ella estudió.',
      onCorrect: 'lbf_ok4',
      onIncorrect: 'lbf_fail4',
    ),
    'lbf_ok4': const StoryNode(
      id: 'lbf_ok4',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '💥',
      text: '¡Estudió! La armadura del Guardián se agrieta.',
      nextNode: 'lbf_ex5',
    ),
    'lbf_fail4': const StoryNode(
      id: 'lbf_fail4',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Estudió. Ella estudió = pasado.»',
      nextNode: 'lbf_ex5',
    ),
    'lbf_ex5': const StoryNode(
      id: 'lbf_ex5',
      type: StoryNodeType.exercise,
      speaker: 'narrator',
      emoji: '🗝️',
      text: 'PREGUNTA FINAL. El Guardián te mira fijamente.',
      question: '¿Cuál es el femenino de "príncipe"?',
      options: ['Principa', 'Princesa', 'Príncipa', 'Princía'],
      correctIndex: 1,
      hint: 'Príncipe → princesa. Caso especial.',
      onCorrect: 'lbf_victoria',
      onIncorrect: 'lbf_fail5',
    ),
    'lbf_victoria': const StoryNode(
      id: 'lbf_victoria',
      type: StoryNodeType.narrative,
      speaker: 'narrator',
      emoji: '🌟',
      text: '«¡¡¡PRINCESA!!!»\n\n'
          '¡¡¡CRASHHH!!! El Guardián de las Palabras explota en una '
          'cascada de letras doradas. Miles de palabras vuelan por el '
          'aire como confeti.\n\n'
          'La Gema Lexis, completa y brillante, desciende suavemente '
          'hasta tus manos. Es de color dorado profundo y dentro puedes '
          'ver TODAS las palabras que has aprendido girando.\n\n'
          'Orión LLORA (esta vez no dice que es el viento): «¡La Gema '
          'de las Palabras es nuestra! ¡Dos gemas recuperadas!»\n\n'
          'El Bosque Lexis estalla en luz. Los árboles de letras florecen. '
          'Los cuentos cobran vida. Las palabras bailan.',
      nextNode: 'lbf_ending',
    ),
    'lbf_fail5': const StoryNode(
      id: 'lbf_fail5',
      type: StoryNodeType.narrative,
      speaker: 'orion',
      emoji: '🦉',
      text: '«Princesa. Príncipe → princesa.»',
      nextNode: 'lbf_victoria',
    ),
    'lbf_ending': const StoryNode(
      id: 'lbf_ending',
      type: StoryNodeType.ending,
      speaker: 'narrator',
      emoji: '🏆',
      text: '¡¡¡BOSS FINAL DERROTADO!!!\n\n'
          'Has usado TODO lo aprendido en Lengua para vencer '
          'al Guardián de las Palabras:\n\n'
          '• Sílabas • Plural/singular\n'
          '• Sinónimos • Verbos\n'
          '• Género • Ortografía\n\n'
          '📜 Recompensa: GEMA LEXIS COMPLETA · +500 XP\n\n'
          '¡Dos gemas recuperadas! La aventura continúa…',
    ),
  },
);
