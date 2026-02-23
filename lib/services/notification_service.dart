import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Handler de mensajes en background (top-level function requerida por FCM)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No necesita lógica adicional: FCM muestra la notificación automáticamente
  debugPrint('📩 Notificación en background: ${message.notification?.title}');
}

/// Servicio de notificaciones push (FCM) para Arcana
///
/// Funcionalidades:
/// - Recordatorio de racha diaria (si no juega en 24h)
/// - Celebración de logros (nivel, racha, capítulo boss)
/// - Motivación personalizada (según intereses)
/// - Notificaciones para padres (progreso del hijo)
///
/// Las notificaciones se envían desde Cloud Functions (server-side).
/// Este servicio solo gestiona: permisos, token, y recepción.
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;
  NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Inicializar notificaciones (llamar en main.dart)
  Future<void> initialize() async {
    // 1. Pedir permisos
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('⚠️ Permisos de notificación denegados');
      return;
    }

    // 2. Obtener token FCM
    final token = await _messaging.getToken();
    debugPrint('🔔 FCM Token: $token');

    // 3. Escuchar cambios de token
    _messaging.onTokenRefresh.listen(_saveToken);

    // 4. Configurar handler de mensajes en foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 5. Handler cuando el usuario toca una notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 6. Verificar si la app se abrió desde una notificación
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // 7. Suscribir a topics globales
    await _subscribeToTopics();
  }

  /// Guardar token FCM en Firestore (para que Cloud Functions lo use)
  Future<void> saveTokenForUser(String uid) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _db.collection('users').doc(uid).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _saveToken(String token) {
    debugPrint('🔄 FCM Token actualizado: $token');
    // El token se guardará la próxima vez que el usuario abra la app
  }

  /// Maneja notificaciones cuando la app está en primer plano
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📬 Notificación en foreground: ${message.notification?.title}');

    // En foreground, FCM NO muestra la notificación automáticamente.
    // Podemos mostrar un snackbar o banner in-app.
    // Esto se conectará al UI a través de un callback.
    if (_onForegroundNotification != null) {
      _onForegroundNotification!(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        data: message.data,
      );
    }
  }

  /// Callback para mostrar notificaciones in-app
  void Function({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  })? _onForegroundNotification;

  /// Registrar callback para notificaciones in-app
  void setForegroundHandler(
    void Function({
      required String title,
      required String body,
      required Map<String, dynamic> data,
    }) handler,
  ) {
    _onForegroundNotification = handler;
  }

  /// Maneja tap en notificación (deep link)
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('👆 Notificación tocada: ${message.data}');

    // Navegación según tipo de notificación
    final type = message.data['type'] as String?;
    final route = switch (type) {
      'streak_reminder' => '/world-map',
      'achievement' => '/profile',
      'chapter_ready' => '/chapter/${message.data['chapterId']}',
      'friend_request' => '/friends',
      'shop_sale' => '/shop',
      'parent_report' => '/parent',
      'teacher_alert' => '/teacher',
      _ => null,
    };

    if (route != null && _onNotificationTap != null) {
      _onNotificationTap!(route);
    }
  }

  /// Callback para navegación desde notificación
  void Function(String route)? _onNotificationTap;

  /// Registrar callback de navegación
  void setNotificationTapHandler(void Function(String route) handler) {
    _onNotificationTap = handler;
  }

  /// Suscribirse a topics de FCM
  Future<void> _subscribeToTopics() async {
    // Topic global para todos los usuarios
    await _messaging.subscribeToTopic('arcana_all');
  }

  /// Suscribir usuario a topics según su rol
  Future<void> subscribeUserTopics({
    required String role,
    String? grade,
  }) async {
    // Rol
    await _messaging.subscribeToTopic('role_$role');

    // Curso (si es estudiante)
    if (grade != null) {
      final gradeSlug = grade.replaceAll(' ', '_').toLowerCase();
      await _messaging.subscribeToTopic('grade_$gradeSlug');
    }
  }

  /// Desuscribir de todos los topics (logout)
  Future<void> unsubscribeAll() async {
    await _messaging.unsubscribeFromTopic('arcana_all');
    // Los topics de rol/curso se limpian automáticamente al cambiar token
  }
}
