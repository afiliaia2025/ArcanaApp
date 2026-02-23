import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

/// Provider de amigos (stream reactivo)
final friendsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);
  return FirestoreService().friendsStream(user.uid);
});

/// Provider de solicitudes pendientes (stream reactivo)
final friendRequestsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);
  return FirestoreService().friendRequestsStream(user.uid);
});

/// Código de amigo del usuario actual
final myFriendCodeProvider = Provider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return '--------';
  return FirestoreService().getFriendCode(user.uid);
});
