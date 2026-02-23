import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/gemini_service.dart';
import '../services/notification_service.dart';

/// Estado del onboarding
class OnboardingState {
  final String role; // 'student' | 'parent'
  final String name;
  final String nick;
  final String avatar;
  final Map<String, dynamic> avatarData; // datos detallados del avatar creator
  final String grade;
  final List<String> subjects;
  final String hardestSubject;
  final List<String> interests;
  final String region;
  final bool isSaving;
  final String? error;

  const OnboardingState({
    this.role = '',
    this.name = '',
    this.nick = '',
    this.avatar = '🧑‍🚀',
    this.avatarData = const {},
    this.grade = '',
    this.subjects = const [],
    this.hardestSubject = '',
    this.interests = const [],
    this.region = '',
    this.isSaving = false,
    this.error,
  });

  OnboardingState copyWith({
    String? role,
    String? name,
    String? nick,
    String? avatar,
    Map<String, dynamic>? avatarData,
    String? grade,
    List<String>? subjects,
    String? hardestSubject,
    List<String>? interests,
    String? region,
    bool? isSaving,
    String? error,
  }) {
    return OnboardingState(
      role: role ?? this.role,
      name: name ?? this.name,
      nick: nick ?? this.nick,
      avatar: avatar ?? this.avatar,
      avatarData: avatarData ?? this.avatarData,
      grade: grade ?? this.grade,
      subjects: subjects ?? this.subjects,
      hardestSubject: hardestSubject ?? this.hardestSubject,
      interests: interests ?? this.interests,
      region: region ?? this.region,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  /// Determina el grupo de edad según el curso
  String get ageGroup {
    if (grade.contains('primaria')) {
      final num = int.tryParse(grade.split('_').first) ?? 3;
      return num <= 3 ? 'exploradores' : 'aventureros';
    }
    if (grade.contains('eso')) return 'aventureros';
    return 'guardianes'; // bach
  }

  /// Descripción del avatar para narrativa
  String get avatarDescription {
    if (avatarData.isNotEmpty) {
      return avatarData['narrativeDescription'] as String? ?? avatar;
    }
    return avatar;
  }
}

/// Notifier que gestiona el onboarding y lo guarda en Firebase
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final AuthService _auth;
  final FirestoreService _firestore;
  final GeminiService _gemini;

  OnboardingNotifier(this._auth, this._firestore, this._gemini)
      : super(const OnboardingState());

  void setRole(String role) => state = state.copyWith(role: role);
  void setName(String name) => state = state.copyWith(name: name);
  void setNick(String nick) => state = state.copyWith(nick: nick);
  void setAvatar(String avatar) => state = state.copyWith(avatar: avatar);
  void setAvatarData(Map<String, dynamic> data) =>
      state = state.copyWith(avatarData: data);
  void setGrade(String grade) => state = state.copyWith(grade: grade);
  void setHardestSubject(String s) =>
      state = state.copyWith(hardestSubject: s);
  void setRegion(String region) => state = state.copyWith(region: region);

  void toggleSubject(String subject) {
    final list = List<String>.from(state.subjects);
    if (list.contains(subject)) {
      list.remove(subject);
    } else {
      list.add(subject);
    }
    state = state.copyWith(subjects: list);
  }

  void toggleInterest(String interest) {
    final list = List<String>.from(state.interests);
    if (list.contains(interest)) {
      list.remove(interest);
    } else if (list.length < 6) {
      list.add(interest);
    }
    state = state.copyWith(interests: list);
  }

  /// Guardar onboarding en Firebase + generar primer arco
  Future<void> completeOnboarding() async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      // 1. Crear cuenta anónima (el hijo ya redeemed el código,
      //    o creamos una sesión temporal para el MVP)
      User? user = _auth.currentUser;
      if (user == null) {
        final cred = await FirebaseAuth.instance.signInAnonymously();
        user = cred.user;
      }
      if (user == null) throw Exception('No se pudo crear cuenta');

      // 2. Guardar perfil en Firestore
      await _firestore.updateProfile(user.uid, {
        'role': state.role,
        'displayName': state.name,
        'nickname': state.nick,
        'avatar': state.avatarData.isNotEmpty
            ? state.avatarData
            : {'emoji': state.avatar},
        'grade': state.grade,
        'subjects': state.subjects,
        'hardestSubject': state.hardestSubject,
        'interests': state.interests,
        'region': state.region,
        'ageGroup': state.ageGroup,
        'level': 1,
        'xp': 0,
        'streak': 0,
        'lives': 5,
        'gems': 0,
        'onboardingCompleted': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // 3. Generar primer arco narrativo (asignatura más difícil primero)
      final firstSubject = state.hardestSubject.isNotEmpty
          ? state.hardestSubject
          : state.subjects.first;

      // Temas de ejemplo (en producción vendrían del currículo LOMLOE)
      final topics = _getDefaultTopics(firstSubject, state.grade);

      final arc = await _gemini.generateArc(
        grade: state.grade,
        subject: firstSubject,
        act: 1,
        topics: topics,
        childName: state.name,
        avatarDescription: state.avatarDescription,
        interests: state.interests,
        ageGroup: state.ageGroup,
      );

      // 4. Guardar arco en Firestore
      await _firestore.saveArc(
        uid: user.uid,
        act: 1,
        arcData: {
          'subject': firstSubject,
          'generatedAt': DateTime.now().toIso8601String(),
          ...arc,
        },
      );

      // 5. Registrar token FCM y suscribir a topics
      await NotificationService.instance.saveTokenForUser(user.uid);
      await NotificationService.instance.subscribeUserTopics(
        role: state.role,
        grade: state.grade.isNotEmpty ? state.grade : null,
      );

      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }

  /// Temas por defecto para demo (en producción usa currículo)
  List<String> _getDefaultTopics(String subject, String grade) {
    return switch (subject) {
      'mates' => [
          'Números naturales y operaciones',
          'Fracciones y decimales',
          'Geometría: figuras planas',
          'Medidas y magnitudes',
          'Estadística y probabilidad',
          'Patrones y secuencias',
          'Resolución de problemas',
          'Cálculo mental',
          'Geometría: cuerpos 3D',
          'Repaso y misión final',
        ],
      'lengua' => [
          'Lectura comprensiva',
          'Gramática: sustantivos y adjetivos',
          'Ortografía: reglas básicas',
          'Escritura creativa',
          'Vocabulario y sinónimos',
          'Gramática: verbos',
          'Tipos de texto',
          'Expresión oral',
          'Literatura infantil',
          'Proyecto final de escritura',
        ],
      'ciencias' => [
          'Los seres vivos',
          'El cuerpo humano',
          'Los ecosistemas',
          'La materia y sus estados',
          'Fuerzas y movimiento',
          'La energía',
          'El agua y su ciclo',
          'El Sistema Solar',
          'Tecnología y inventos',
          'Proyecto de investigación',
        ],
      _ => [
          'Introducción al tema',
          'Conceptos fundamentales',
          'Profundización',
          'Aplicación práctica',
          'Investigación guiada',
          'Conexiones interdisciplinares',
          'Proyecto creativo',
          'Evaluación formativa',
          'Ampliación y retos',
          'Misión final',
        ],
    };
  }
}

/// Provider del onboarding
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(
    AuthService(),
    FirestoreService(),
    GeminiService.instance,
  );
});
