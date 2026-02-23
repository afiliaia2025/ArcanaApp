# 08 · Arquitectura Técnica
> **Última actualización**: 2026-02-21

---

## Stack Tecnológico

| Capa | Tecnología |
|---|---|
| **Frontend** | Flutter (Android + iOS + Web) |
| **Backend** | Firebase (Authentication, Firestore, Cloud Functions, Storage) |
| **IA** | Gemini Flash (generación de ejercicios, análisis de PDFs) |
| **Assets** | Stable Diffusion (ilustraciones), Stable Audio (música) |

---

## Servicios Flutter

| Servicio | Responsabilidad | Estado |
|---|---|---|
| `ExerciseService` | CRUD de ejercicios, servir ejercicios por tema/dificultad | ✅ Implementado |
| `ChapterDataService` | Carga JSON del currículo, progresión narrativa | ✅ Implementado |
| `AchievementService` | Control de logros, desbloqueo, persistencia | ✅ Implementado |
| `UserProgressService` | XP, nivel, estrellas, capítulos completados | ✅ Implementado |
| `BossService` | Lógica de bosses (fases, timer, salud) | ✅ Implementado |
| `NarrativeService` | Motor de lectura, branching convergente | 🔲 Diseñado |
| `TeacherService` | Dashboard profe, envío de misiones, Modo Aula | 🔲 Diseñado |
| `GeminiService` | Análisis de PDFs, generación de ejercicios IA | 🔲 Diseñado |
| `AnalyticsService` | Telemetría del alumno, dashboards | 🔲 Diseñado |

---

## Modelos de Datos (Firestore)

### `/users/{uid}`
```json
{
  "nickname": "MagoDragon",
  "avatar": { "skin": 2, "hair": 3, "eyes": 1, "glasses": false },
  "xp": 1240,
  "level": 6,
  "currentPhase": 2,
  "gems": { "ignis": "TALLA", "lexis": "OPACA", "sylva": "CRISTAL", "babel": "OPACA" },
  "runes": { "fire": 2, "water": 1, "earth": 2, "wind": 0, "shadow": 1 },
  "helpMode": false,
  "streakDays": 7,
  "linkedTeacher": "prof_abc123",
  "achievements": ["aprendiz", "cuatro_caminos", "primera_runa"]
}
```

### `/users/{uid}/progress/{chapterId}`
```json
{
  "completed": true,
  "stars": 2,
  "bestTime": 340,
  "attempts": 2,
  "route": "A",
  "extraChallenge": false,
  "errors": [{ "exerciseId": "ex_301", "type": "suma_llevada", "timestamp": "..." }]
}
```

### `/teachers/{uid}`
```json
{
  "displayName": "María López",
  "archimageAvatar": 3,
  "classCode": "ARCANA-7X2K",
  "students": ["uid1", "uid2", "uid3"],
  "missions": [{ "id": "m1", "title": "Sumas especiales", "exercises": [...] }]
}
```

### `/curriculum/{subject}/{trimester}`
```json
{
  "chapters": [
    {
      "id": "ignis_t1_c1",
      "title": "La Puerta de la Torre",
      "topic": "Números 0-99, U/D",
      "scenes": [...],
      "exercises": [...],
      "extraChallenge": {...}
    }
  ]
}
```

---

## Pool de Ejercicios (Prioridad de Fuentes)

| Prioridad | Fuente | Disponibilidad |
|---|---|---|
| 1ª | Pool precargado (3-5 ejercicios/cap, curados) | ✅ Offline |
| 2ª | Ejercicios del profesor (misiones) | ⚠️ Requiere sync |
| 3ª | Banco del libro de texto (si configurado) | ⚠️ Descarga inicial |
| 4ª | IA generativa (Gemini) | ❌ Solo online |

**Regla**: NUNCA se bloquea el juego por falta de conexión. Si la IA no está disponible → pool precargado → si agotado → repetir en orden aleatorio.

---

## Telemetría: ExerciseEvent (Ojo de Orión)

> Modelo de datos para la detección pedagógica. Ver [10_PEDAGOGIA.md](10_PEDAGOGIA.md) para lógica de análisis.

### `exercises/{uid}/sessions/{sessionId}/events/{eventId}`
```json
{
  "timestamp": "2026-03-15T10:23:45Z",
  "responseTimeMs": 4200,
  "isCorrect": true,
  "exerciseType": "suma_llevada",
  "kingdom": "ignis",
  "trimester": 2,
  "errorType": null,
  "ttsUsed": false,
  "runeUsed": null,
  "exercisePosition": 3,
  "totalExercises": 7,
  "gestureType": "tap"
}
```

### `exercises/{uid}/sessions/{sessionId}`
```json
{
  "startTime": "2026-03-15T10:20:00Z",
  "endTime": "2026-03-15T10:30:15Z",
  "chaptersCompleted": 1,
  "mode": "adventure",
  "isClassroomMode": false
}
```

**Tamaño**: ~30 bytes/ejercicio · ~3 KB/semana/alumno · Cloud Function semanal para análisis.

---

## Estructura del Proyecto

```
ArcanaApp/
├── docs/
│   └── gdd/           ← Estás aquí: documentación de diseño
├── assets/
│   ├── curriculum/     ← JSONs del currículo por CC.AA.
│   ├── illustrations/  ← Fondos e ilustraciones
│   └── audio/          ← Música y SFX
├── lib/
│   ├── models/         ← Dart models (User, Exercise, Chapter, etc.)
│   ├── services/       ← Lógica de negocio
│   ├── screens/        ← Pantallas
│   └── widgets/        ← Componentes reutilizables
└── functions/          ← Cloud Functions (Node.js)
```

---

## Privacy & Compliance

| Requisito | Implementación |
|---|---|
| **COPPA** | Sin nombre real, sin fotos, sin ubicación, sin chat |
| **GDPR** | Datos mínimos, consentimiento parental, derecho al olvido |
| **Parental Gate** | Todas las funciones de adulto requieren verificación |
| **Sin anuncios** | Modelo freemium, nunca ads |
