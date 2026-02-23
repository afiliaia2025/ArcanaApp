import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

/// Servicio de IA (Gemini) para Arcana — OPTIMIZADO EN COSTES
///
/// Estrategias de ahorro:
/// 1. System instructions: prompts de sistema reutilizados (no se cobran por repetición en sesión)
/// 2. Modelos baratos: gemini-2.0-flash (más barato que 2.5) para tareas simples
/// 3. maxOutputTokens: limita la longitud de respuesta (menos tokens = menos coste)
/// 4. Caché local: arcos/viñetas se guardan en Firestore y no se regeneran
/// 5. Generación lazy: viñetas/imágenes se generan capítulo a capítulo, no todo de golpe
/// 6. Explicaciones cortas: máximo 80 palabras
/// 7. Imágenes solo bajo demanda: no se pre-generan
///
/// Coste estimado por alumno/mes (uso moderado ~20 sesiones):
///   - generateArc: 1 vez/trimestre → ~$0.003
///   - generateVignettes: ~10 caps/mes × 6 viñetas → ~$0.02
///   - generateExplanation: ~15/mes → ~$0.005
///   - generateVignetteImage: ~5/mes → ~$0.05
///   - analyzeMaterial + miméticos: ~2/mes → ~$0.01
///   TOTAL: ~$0.09/alumno/mes (~0.08€)
class GeminiService {
  late final GenerativeModel _textModel;
  late final GenerativeModel _visionModel;
  late final GenerativeModel _imageModel;
  late final GenerativeModel _lightModel; // modelo ligero para tareas simples

  // Singleton
  static GeminiService? _instance;
  static GeminiService get instance => _instance ??= GeminiService._();

  GeminiService._() {
    // ── Modelo PRINCIPAL: texto complejo (arcos, viñetas) ──
    // gemini-2.0-flash: ~$0.10/1M input, ~$0.40/1M output
    // Mucho más barato que 2.5-flash ($0.15/$0.60)
    _textModel = FirebaseAI.vertexAI().generativeModel(
      model: 'gemini-2.0-flash',
      systemInstruction: Content.system(_systemPromptNarrative),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json', // fuerza JSON directo, sin parsear
        maxOutputTokens: 2048, // limita respuesta (~1500 palabras max)
        temperature: 0.8, // creatividad controlada
      ),
    );

    // ── Modelo LIGERO: tareas cortas (explicaciones, ejercicios) ──
    _lightModel = FirebaseAI.vertexAI().generativeModel(
      model: 'gemini-2.0-flash',
      systemInstruction: Content.system(_systemPromptTutor),
      generationConfig: GenerationConfig(
        maxOutputTokens: 512, // explicaciones cortas
        temperature: 0.6,
      ),
    );

    // ── Modelo VISIÓN: OCR ──
    _visionModel = FirebaseAI.vertexAI().generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        maxOutputTokens: 1024,
      ),
    );

    // ── Modelo IMAGEN: viñetas (el único que necesita gemini-2.0-flash-exp) ──
    _imageModel = FirebaseAI.vertexAI().generativeModel(
      model: 'gemini-2.0-flash-exp',
      generationConfig: GenerationConfig(
        responseModalities: [ResponseModalities.image, ResponseModalities.text],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // SYSTEM PROMPTS (se envían UNA VEZ por sesión)
  // ═══════════════════════════════════════════

  static const _systemPromptNarrative = '''
Eres un escritor de aventuras interactivas educativas para niños.
Normas:
- Devuelve SIEMPRE JSON válido, sin markdown ni bloques de código.
- NUNCA menciones que el contenido es educativo. Es UNA AVENTURA.
- Los ejercicios son parte natural de la historia (puzzles, acertijos, pruebas).
- Fallar un ejercicio NO es game over, es descubrimiento narrativo.
- Usa los gustos del niño como elementos narrativos naturales.
- Sé conciso: títulos cortos, resúmenes de 2 frases máximo.
''';

  static const _systemPromptTutor = '''
Eres un tutor amable que explica conceptos a niños.
Normas:
- Máximo 80 palabras por explicación.
- NO uses listas ni formato especial, escribe de forma natural.
- Adapta el tono a la edad del alumno.
- Si usas metáforas, relaciónalas con los gustos del niño.
''';

  // ═══════════════════════════════════════════
  // GENERACIÓN DE HISTORIA
  // ═══════════════════════════════════════════

  /// Genera el arco narrativo de un acto (trimestre)
  /// Se llama 1 vez/trimestre → coste despreciable
  Future<Map<String, dynamic>> generateArc({
    required String grade,
    required String subject,
    required int act,
    required List<String> topics,
    required String childName,
    required String avatarDescription,
    required List<String> interests,
    required String ageGroup,
    String? teacherName,
    String? teacherRole,
  }) async {
    // Prompt compacto (menos tokens de entrada = menos coste)
    final prompt = '''
Arco narrativo para "$subject" — Acto $act/3.
Protagonista: $childName ($avatarDescription), curso $grade.
Gustos: ${interests.join(', ')}. Franja: $ageGroup.
${teacherName != null ? 'Mentor: $teacherName ($teacherRole).' : ''}

Temas: ${topics.asMap().entries.map((e) => '${e.key + 1}.${ e.value}').join(', ')}

JSON: {"arc_title":"...","arc_summary":"2 frases","chapters":[{"id":"cap_N","topic":"...","title":"...","summary":"2 frases","hook":"cliffhanger","type":"normal|gate|boss","xp_reward":50}]}

Reglas narrativas ($ageGroup): ${_getNarrativeRulesCompact(ageGroup)}
''';

    final response = await _textModel.generateContent([Content.text(prompt)]);
    return _parseJson(response.text) as Map<String, dynamic>;
  }

  /// Genera viñetas de UN capítulo (lazy: solo cuando el jugador lo abre)
  /// ~6 viñetas × ~200 tokens c/u = ~1200 tokens output
  Future<List<Map<String, dynamic>>> generateVignettes({
    required String chapterTitle,
    required String topic,
    required String childName,
    required String avatarDescription,
    required List<String> interests,
    required String ageGroup,
    String? teacherName,
    int vignetteCount = 5, // reducido de 6 a 5 para ahorrar
  }) async {
    final prompt = '''
$vignetteCount viñetas para "$chapterTitle" (tema: $topic).
Protagonista: $childName ($avatarDescription). Gustos: ${interests.join(', ')}.
${teacherName != null ? 'Mentor: $teacherName.' : ''} Franja: $ageGroup.

JSON array: [{"text":"narrativa 2-3 frases","image_prompt":"prompt corto para ilustración","has_exercise":false,"exercise":null}]

Solo 2 viñetas con ejercicio: {"type":"multiple_choice|fill_blank|true_false","question":"...","options":[...],"correct":0,"explanation":"1 frase"}
Última viñeta: gancho/cliffhanger. El tema ($topic) se enseña sin parecer escolar.
''';

    final response = await _textModel.generateContent([Content.text(prompt)]);
    final parsed = _parseJson(response.text);
    if (parsed is List) {
      return parsed.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  // ═══════════════════════════════════════════
  // AVATAR FOTOGRÁFICO
  // ═══════════════════════════════════════════

  /// Genera un personaje dibujado a partir de una foto real
  /// La foto NUNCA se almacena — solo se usa en memoria
  /// Coste: ~$0.01/generación
  Future<Uint8List?> generateCharacterFromPhoto({
    required Uint8List photoBytes,
    required String stylePrompt,
    required String childName,
  }) async {
    final prompt = '''
Transform this photo into a character portrait in the following art style:
$stylePrompt

Rules:
- Create a FULL character portrait (head and upper body)
- Keep the person's key features (face shape, skin tone, hair) but stylized
- Make them look like a HERO or ADVENTURER in this art style
- NO text, NO watermarks, NO realistic photo — only the drawn character
- Background: simple, colorful, matching the art style
- The character should look friendly and confident
- Name: $childName
''';

    try {
      final response = await _imageModel.generateContent([
        Content.multi([
          TextPart(prompt),
          InlineDataPart('image/jpeg', photoBytes),
        ]),
      ]);
      for (final candidate in response.candidates) {
        for (final part in candidate.content.parts) {
          if (part is InlineDataPart) {
            return part.bytes;
          }
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  // ═══════════════════════════════════════════
  // IMÁGENES DE VIÑETAS
  // ═══════════════════════════════════════════

  /// Genera imagen de viñeta — SOLO cuando el usuario la ve
  /// Si hay characterRef, usa el personaje + estilo del avatar
  /// Coste: ~$0.01/imagen con gemini-2.0-flash-exp
  Future<Uint8List?> generateVignetteImage({
    required String sceneDescription,
    String? avatarDescription,
    String? ageGroup,
    Uint8List? characterRef,
    String? stylePrompt,
  }) async {
    // Si hay estilo del avatar, usarlo; sino fallback por edad
    final style = stylePrompt ?? switch (ageGroup ?? '') {
      'exploradores' => 'Children\'s watercolor, pastel, dreamy, magical',
      'aventureros' => 'Cartoon adventure, vibrant, semi-anime, dynamic',
      'guardianes' => 'Digital illustration, cinematic lighting, atmospheric',
      _ => 'Children\'s book illustration, whimsical',
    };

    final prompt = '''
$style illustration. Scene: $sceneDescription.
${avatarDescription != null ? 'Character: $avatarDescription.' : ''}
Keep the character consistent with the reference image if provided.
No text or letters in the image. Expressive, colorful, emotional.
''';

    try {
      final parts = <Part>[TextPart(prompt)];
      if (characterRef != null) {
        parts.add(InlineDataPart('image/png', characterRef));
      }
      final response = await _imageModel.generateContent([
        Content.multi(parts),
      ]);
      for (final candidate in response.candidates) {
        for (final part in candidate.content.parts) {
          if (part is InlineDataPart) {
            return part.bytes;
          }
        }
      }
    } catch (_) {
      return null; // la app muestra placeholder si falla
    }
    return null;
  }

  // ═══════════════════════════════════════════
  // OCR — ANÁLISIS DE MATERIAL
  // ═══════════════════════════════════════════

  /// Analiza foto de material escolar — bajo demanda
  Future<Map<String, dynamic>> analyzeMaterial(Uint8List imageBytes) async {
    // Prompt compacto
    final prompt = '''
Analiza esta foto de material escolar.
JSON: {"subject":"asignatura","topic":"tema","grade_estimate":"curso","exercise_format":"multiple_choice|fill_blank|develop|true_false|mixed","difficulty":"facil|medio|dificil","content_summary":"2 frases","key_concepts":["..."],"detected_exercises":[{"question":"...","type":"..."}]}
''';

    final response = await _visionModel.generateContent([
      Content.multi([
        TextPart(prompt),
        InlineDataPart('image/jpeg', imageBytes),
      ]),
    ]);

    return _parseJson(response.text) as Map<String, dynamic>;
  }

  /// Genera ejercicios miméticos — usa modelo ligero
  Future<List<Map<String, dynamic>>> generateMimeticExercises({
    required String topic,
    required String exerciseFormat,
    required String grade,
    required int count,
    List<Map<String, dynamic>>? detectedExercises,
  }) async {
    final prompt = '''
$count ejercicios sobre "$topic" para $grade. Formato: $exerciseFormat.
${detectedExercises != null ? 'Estilo: ${json.encode(detectedExercises)}' : ''}
JSON array: [{"question":"...","type":"$exerciseFormat","options":[...],"correct":0,"explanation":"1 frase","hint":"pista"}]
''';

    // Usa modelo con JSON forzado para ahorro
    final response = await _textModel.generateContent([Content.text(prompt)]);
    final parsed = _parseJson(response.text);
    if (parsed is List) {
      return parsed.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  // ═══════════════════════════════════════════
  // EXPLICACIONES ADAPTATIVAS
  // ═══════════════════════════════════════════

  /// Explicación adaptada — usa modelo ligero (512 tokens max)
  Future<String> generateExplanation({
    required String topic,
    required String question,
    required int failCount,
    required List<String> interests,
    required String ageGroup,
  }) async {
    final level = failCount.clamp(1, 3);

    final prompt = '''
Fallo $level/3 en: "$question" (tema: $topic, franja: $ageGroup).
${level == 1 ? 'Explicación estándar.' : level == 2 ? 'Simplificada, con ejemplos paso a paso.' : 'Usa metáforas con: ${interests.join(", ")}.'}
Máximo 80 palabras.
''';

    final response = await _lightModel.generateContent([Content.text(prompt)]);
    return response.text ?? 'No pude generar la explicación.';
  }

  // ═══════════════════════════════════════════
  // HELPERS PRIVADOS
  // ═══════════════════════════════════════════

  /// Parsea JSON limpiando posibles artefactos
  dynamic _parseJson(String? text) {
    if (text == null || text.isEmpty) return {};
    final clean = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    try {
      return json.decode(clean);
    } catch (_) {
      return {};
    }
  }

  /// Reglas narrativas compactas (menos tokens)
  String _getNarrativeRulesCompact(String ageGroup) {
    return switch (ageGroup) {
      'exploradores' =>
        'Frases cortas (12 palabras max), compañero animal, onomatopeyas, sin violencia, final esperanzador.',
      'aventureros' =>
        'Cliffhangers, humor, autonomía del protagonista, acción rápida, villano con motivaciones.',
      'guardianes' =>
        'Complejidad moral, personajes con profundidad, misterio gradual, sin condescendencia.',
      _ => '',
    };
  }
}
