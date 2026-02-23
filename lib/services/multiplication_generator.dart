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

  /// Genera un ejercicio para la zona de Aprender/Entrenar, forzando una tabla específica
  static MultiplicationExercise generateSpecificTable(int table) {
    int otherFactor = _random.nextInt(11); // 0 a 10
    // Lógica para que a veces la tabla sea el primer factor y otras el segundo (enseñar conmutativa)
    bool tableFirst = _random.nextBool();
    
    int f1 = tableFirst ? table : otherFactor;
    int f2 = tableFirst ? otherFactor : table;
    int answer = f1 * f2;

    List<int> options = _generateOptions(f1, f2, answer);
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

  /// Genera un ejercicio para la zona Boss, mezclando tablas en el rango [minTable, maxTable]
  static MultiplicationExercise generateMixedRange(int minTable, int maxTable) {
    // Escoger una tabla al azar dentro del rango
    int targetTable = minTable + _random.nextInt((maxTable - minTable) + 1);
    return generateSpecificTable(targetTable);
  }

  static List<int> _generateOptions(int f1, int f2, int correct) {
    return generateOptionsFor(f1, f2, correct);
  }

  /// Genera opciones para uso externo (combo conmutativo)
  static List<int> generateOptionsFor(int f1, int f2, int correct) {
    Set<int> opts = {correct};
    
    // Añadir trampas comunes
    // 1. Confundir multiplicar con sumar
    if (f1 + f2 != correct) opts.add(f1 + f2);
    
    // 2. Se equivoca por un factor de +-1
    opts.add(correct + f1);
    if (correct - f1 >= 0) opts.add(correct - f1);
    opts.add(correct + f2);
    if (correct - f2 >= 0) opts.add(correct - f2);

    // Si aún faltan para 4 opciones, añadimos aleatorios parecidos
    while (opts.length < 4) {
      int variance = _random.nextInt(10) - 5;
      int fake = correct + variance;
      if (fake >= 0 && !opts.contains(fake)) {
        opts.add(fake);
      }
    }

    List<int> finalOptions = opts.toList()..shuffle(_random);
    return finalOptions.take(4).toList();
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

