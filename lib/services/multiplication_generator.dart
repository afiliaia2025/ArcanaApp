import 'dart:math';

class MultiplicationExercise {
  final String question;
  final int factor1;
  final int factor2;
  final int correctAnswer;
  final List<int> options;
  final String hint;

  MultiplicationExercise({
    required this.question,
    required this.factor1,
    required this.factor2,
    required this.correctAnswer,
    required this.options,
    required this.hint,
  });
}

class MultiplicationGenerator {
  static final _random = Random();

  /// Genera un ejercicio para Aprender/Entrenar, forzando una tabla específica.
  static MultiplicationExercise generateSpecificTable(int table) {
    int otherFactor = _random.nextInt(11); // 0 a 10
    bool tableFirst = _random.nextBool();

    int f1 = tableFirst ? table : otherFactor;
    int f2 = tableFirst ? otherFactor : table;
    int answer = f1 * f2;

    List<int> options = generateOptionsFor(f1, f2, answer);
    String hint = _getHintForTable(table);

    return MultiplicationExercise(
      question: '$f1 × $f2 = ?',
      factor1: f1,
      factor2: f2,
      correctAnswer: answer,
      options: options,
      hint: hint,
    );
  }

  /// Genera el examen completo del Boss: 10 preguntas por cada tabla en [minTable..maxTable].
  /// Cubre los factores 1-10 (excluye ×0 para mayor dificultad).
  /// Devuelve la lista barajada, sin repeticiones.
  static List<MultiplicationExercise> generateBossExam(int minTable, int maxTable) {
    final effectiveMin = minTable < 1 ? 1 : minTable;
    final effectiveMax = maxTable < 1 ? 1 : maxTable;

    final exercises = <MultiplicationExercise>[];

    for (int table = effectiveMin; table <= effectiveMax; table++) {
      for (int other = 1; other <= 10; other++) {
        // Alternar orden para practicar conmutativa
        bool tableFirst = _random.nextBool();
        int f1 = tableFirst ? table : other;
        int f2 = tableFirst ? other : table;
        int answer = f1 * f2;

        exercises.add(MultiplicationExercise(
          question: '$f1 × $f2 = ?',
          factor1: f1,
          factor2: f2,
          correctAnswer: answer,
          options: generateOptionsFor(f1, f2, answer),
          hint: '', // Sin pistas en boss
        ));
      }
    }

    exercises.shuffle(_random);
    return exercises;
  }

  /// Genera un ejercicio suelto para boss (fallback/re-ask).
  static MultiplicationExercise generateMixedRange(int minTable, int maxTable) {
    int effectiveMin = minTable < 2 ? 2 : minTable;
    int effectiveMax = maxTable < 2 ? 2 : maxTable;

    int f1 = effectiveMin + _random.nextInt((effectiveMax - effectiveMin) + 1);
    int f2 = effectiveMin + _random.nextInt((effectiveMax - effectiveMin) + 1);

    if (effectiveMax - effectiveMin <= 2 && _random.nextDouble() < 0.4) {
      f2 = 2 + _random.nextInt(9); // 2 a 10
    }

    int answer = f1 * f2;
    List<int> options = generateOptionsFor(f1, f2, answer);

    return MultiplicationExercise(
      question: '$f1 × $f2 = ?',
      factor1: f1,
      factor2: f2,
      correctAnswer: answer,
      options: options,
      hint: '',
    );
  }

  /// Genera 4 opciones que SIEMPRE incluyen la respuesta correcta.
  static List<int> generateOptionsFor(int f1, int f2, int correct) {
    Set<int> wrong = {};

    // Confundir con suma
    _addWrong(wrong, f1 + f2, correct);
    // Error ±1 en un factor
    _addWrong(wrong, (f1 + 1) * f2, correct);
    _addWrong(wrong, (f1 - 1) * f2, correct);
    _addWrong(wrong, f1 * (f2 + 1), correct);
    _addWrong(wrong, f1 * (f2 - 1), correct);
    // Error ±2
    _addWrong(wrong, (f1 + 2) * f2, correct);
    _addWrong(wrong, f1 * (f2 + 2), correct);
    // Confundir con resta
    _addWrong(wrong, (f1 - f2).abs(), correct);

    // Relleno aleatorio
    int attempts = 0;
    while (wrong.length < 3 && attempts < 50) {
      int variance = _random.nextInt(12) - 6;
      int fake = correct + variance;
      _addWrong(wrong, fake, correct);
      attempts++;
    }

    List<int> wrongList = wrong.toList()..shuffle(_random);
    List<int> finalOptions = [correct, ...wrongList.take(3)];
    finalOptions.shuffle(_random);
    return finalOptions;
  }

  static void _addWrong(Set<int> wrong, int value, int correct) {
    if (value >= 0 && value != correct) {
      wrong.add(value);
    }
  }

  static String _getHintForTable(int table) {
    switch (table) {
      case 0: return "¡Todo multiplicado por 0 es 0!";
      case 1: return "¡Multiplicar por 1 deja el número igual!";
      case 2: return "¡Es lo mismo que sumar el número consigo mismo (el doble)!";
      case 3: return "¡Cuenta de 3 en 3: 3, 6, 9, 12, 15...!";
      case 4: return "¡Es el doble del doble! Primero x2 y luego otra vez x2.";
      case 5: return "¡Los resultados de la tabla del 5 siempre acaban en 0 o en 5!";
      case 6: return "¡Es como la tabla del 3, pero el doble!";
      case 7: return "¡56=7×8! Recuerda: 5, 6, 7, 8.";
      case 8: return "¡Doble de la tabla del 4! Calcula x4 y luego duplica.";
      case 9: return "¡Los dígitos del resultado siempre suman 9!";
      case 10: return "¡Solo tienes que añadir un 0 al final!";
      default: return "";
    }
  }
}
