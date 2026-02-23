import 'package:cloud_functions/cloud_functions.dart';

/// Servicio para llamar a Cloud Functions de ArcanaApp.
///
/// Funciones disponibles:
/// - [updateStreak]: Actualiza la racha diaria del usuario
/// - [getLeaderboard]: Obtiene el ranking global (top 50)
class CloudFunctionsService {
  static final _functions = FirebaseFunctions.instanceFor(region: 'europe-west1');

  /// Actualiza la racha diaria del usuario.
  ///
  /// Retorna un mapa con:
  /// - `streak`: racha actual
  /// - `bestStreak`: mejor racha
  /// - `gemsEarned`: gemas ganadas por hitos (7 días, 30 días)
  /// - `alreadyUpdated`: true si ya jugó hoy
  static Future<Map<String, dynamic>> updateStreak() async {
    try {
      final result = await _functions.httpsCallable('updateStreak').call();
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Error actualizando racha: ${e.message}');
    }
  }

  /// Obtiene el leaderboard (top 50).
  ///
  /// Retorna un mapa con:
  /// - `entries`: lista de usuarios con rank, displayName, avatar, xp, level, streak
  /// - `userRank`: posición del usuario actual (null si no está en top 50)
  static Future<Map<String, dynamic>> getLeaderboard() async {
    try {
      final result = await _functions.httpsCallable('getLeaderboard').call();
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Error obteniendo leaderboard: ${e.message}');
    }
  }
}
