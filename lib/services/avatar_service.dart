import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gemini_service.dart';

/// Estilos visuales inspirados en series/cómics
class AvatarStyle {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String prompt; // prompt para Gemini

  const AvatarStyle({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.prompt,
  });

  /// Los 6 estilos disponibles
  static const List<AvatarStyle> all = [
    AvatarStyle(
      id: 'shonen',
      name: 'Shōnen',
      emoji: '⚡',
      description: 'Dragon Ball / Naruto',
      prompt:
          'anime shonen character portrait, dynamic pose, spiky stylized hair, '
          'bold clean lines, vibrant energy aura, determined expression, '
          'colorful background with speed lines',
    ),
    AvatarStyle(
      id: 'adventure',
      name: 'Aventurero',
      emoji: '🏴‍☠️',
      description: 'One Piece / Gravity Falls',
      prompt:
          'adventure cartoon character portrait, expressive exaggerated features, '
          'warm color palette, whimsical style, fun proportions, '
          'explorer outfit, friendly adventurous expression',
    ),
    AvatarStyle(
      id: 'ghibli',
      name: 'Ghibli',
      emoji: '🌸',
      description: 'Totoro / El viaje de Chihiro',
      prompt:
          'studio ghibli style character portrait, soft watercolor texture, '
          'warm gentle lighting, expressive eyes, natural setting, '
          'peaceful serene expression, hand-painted look',
    ),
    AvatarStyle(
      id: 'superhero',
      name: 'Superhéroe',
      emoji: '🦸',
      description: 'Marvel / DC Comics',
      prompt:
          'comic book superhero character portrait, bold ink outlines, '
          'dramatic shading and lighting, heroic confident pose, '
          'vibrant costume colors, dynamic composition',
    ),
    AvatarStyle(
      id: 'cartoon',
      name: 'Cartoon',
      emoji: '🎮',
      description: 'Pokémon / Steven Universe',
      prompt:
          'cartoon network style character portrait, rounded friendly shapes, '
          'bright saturated colors, big expressive eyes, clean simple lines, '
          'cheerful warm expression, fun playful vibe',
    ),
    AvatarStyle(
      id: 'pixar',
      name: 'Pixar',
      emoji: '🚀',
      description: 'Toy Story / Coco',
      prompt:
          '3D pixar style character portrait, slightly exaggerated proportions, '
          'cinematic studio lighting, detailed texture and subsurface scattering, '
          'warm expressive eyes, charming smile',
    ),
  ];

  /// Buscar estilo por id
  static AvatarStyle findById(String id) {
    return all.firstWhere((s) => s.id == id, orElse: () => all[0]);
  }
}

/// Servicio de avatar fotográfico
/// Coordina: foto → Gemini → Storage → Firestore
class AvatarService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GeminiService _gemini = GeminiService.instance;

  /// Genera un personaje a partir de la foto y el estilo
  /// Retorna los bytes de la imagen generada, o null si falla
  /// La foto NUNCA se sube — solo se envía a Gemini en memoria
  Future<Uint8List?> generateCharacter({
    required Uint8List photoBytes,
    required AvatarStyle style,
    required String childName,
  }) async {
    return _gemini.generateCharacterFromPhoto(
      photoBytes: photoBytes,
      stylePrompt: style.prompt,
      childName: childName,
    );
  }

  /// Guarda el avatar generado en Storage y Firestore
  /// Retorna la URL pública del avatar
  Future<String?> saveAvatar({
    required String uid,
    required Uint8List avatarBytes,
    required AvatarStyle style,
  }) async {
    try {
      // 1. Subir dibujo a Storage
      final ref = _storage.ref('avatars/$uid/character.png');
      await ref.putData(
        avatarBytes,
        SettableMetadata(contentType: 'image/png'),
      );
      final url = await ref.getDownloadURL();

      // 2. Guardar metadata en Firestore
      await _db.collection('users').doc(uid).update({
        'avatar': {
          'imageUrl': url,
          'style': style.id,
          'styleName': style.name,
          'stylePrompt': style.prompt,
          'createdAt': FieldValue.serverTimestamp(),
        },
      });

      return url;
    } catch (e) {
      return null;
    }
  }

  /// Obtener datos del avatar actual
  Future<Map<String, dynamic>?> getAvatarData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) return null;
    return data['avatar'] as Map<String, dynamic>?;
  }
}
