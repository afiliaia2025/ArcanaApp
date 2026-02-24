# 11 · Pantallas del Juego
> **Última actualización**: 2026-02-24
> **Fuente de verdad** para: flujo de navegación, definición de cada pantalla, estado de implementación.
> Complementa: `03_MECANICAS.md` (mecánicas), `04_NARRATIVA.md` (narrativa), `06_TORRE_DEL_ARCHIMAGO.md` (sistema escolar).

---

## Mapa de Navegación

```
PADRE  → ParentalGate → ChildSetup
            ↓
NIÑO   → AvatarCreator → Prologue → OrionIntro → FirstBattleTutorial
            ↓
         TitleScreen → MapScreen
                          ├── GemZone → ChapterIntro → Chapter → ChapterResult
                          │                                ↓
                          │                    VSScreen → Combat → BossIntro → Boss → BossResult
                          ├── TrainingHub → TrainingSession → Mini-exam
                          └── 🏰 TORRE (si hay profe vinculado)
                                  └── TowerLobby → Mission (varios modos)
                                            └── [Modo Aula] → ClassroomWaiting → ClassroomBattle → ClassroomResult
         ─────────────────────────────────────────────────────
         Profile / Achievements / OrionChat / DailyRewards
         ─────────────────────────────────────────────────────
PADRE  → ParentDashboard → ExamDateConfig
PROFE  → TeacherDashboard → MissionCreator → ClassroomLauncher
```

---

## Estado de implementación

| Símbolo | Significado |
|---|---|
| ✅ | Implementada y funcional |
| 🔨 | Existe pero necesita mejoras |
| ❌ | No implementada todavía |

---

## BLOQUE 0 — Onboarding del Adulto

> El padre/madre siempre crea la cuenta primero. El niño nunca introduce datos personales directamente.

### `ParentalGateScreen` ❌
**Quién la ve**: El padre/madre, la primera vez.
**Qué hace**: Verifica que es un adulto mediante una operación matemática que un niño no puede resolver rápido (COPPA compliance). A continuación, email + contraseña del padre.
**Regla**: Si ya tiene cuenta → login directo → `ChildSetupScreen`.
**Transición**: → `ChildSetupScreen`

### `ChildSetupScreen` ❌
**Quién la ve**: El padre/madre, la primera vez.
**Qué hace**: El padre introduce los datos del niño:
- Nick/nombre visible en el juego (nunca nombre real para otros jugadores)
- Curso (2º o 3º Primaria)
- Comunidad Autónoma (ajusta el currículo al plan de estudios real)

**Transición**: → `AvatarCreatorScreen` (el niño toma el control aquí)

---

## BLOQUE 1 — Prólogo y Tutorial (Primera vez — Niño)

### `AvatarCreatorScreen` ✅
**Quién la ve**: El niño, la primera vez.
**Qué hace**: Personaliza su Aprendiz:
- Silueta base: Niño o Niña (proporciones distintas, mismas opciones de ropa)
- Tono de piel (6 opciones)
- Pelo (8 estilos × 6 colores)
- Ojos (4 formas)
- Gafas (sí/no, 3 estilos)
- Ropa inicial (3 opciones de calle)

Orión aparece en esquina y reacciona a cada cambio con frases cortas.
**Regla**: Todas las opciones de personalización son neutrales de género — no hay prendas "solo de niño" o "solo de niña".
**Transición**: → `PrologueScreen`

### `PrologueScreen` ❌ ⭐ CRÍTICA
**Quién la ve**: El niño, la primera vez.
**Qué hace**: La escena más importante del juego. En 30 segundos, sin texto largo:
1. La carta dorada aparece en la pantalla — *"¿Quieres abrirla?"* (primer tap)
2. Teletransporte a Numeralia (animación)
3. Noctus irrumpe → roba las 4 gemas → el mundo se oscurece (3 ilustraciones)
4. Fundido a negro

El niño debe salir de esta pantalla sabiendo exactamente: **quién es el malo, qué robó, qué tiene que hacer**.
**Regla**: Iconografía pura. Cero párrafos. Máximo 3 frases cortas de Orión en audio/burbuja.
**Transición**: → `OrionIntroScreen`

### `OrionIntroScreen` ❌
**Quién la ve**: El niño, la primera vez.
**Qué hace**: Orión aparece en pantalla completa y habla directamente al jugador usando su nick:
> *"¡[Nick]! ¡Por fin llegas! ¡Noctus robó las 4 gemas y Numeralia está olvidando todo el conocimiento! Tú eres la única esperanza..."*

3 burbujas de diálogo. El niño toca para avanzar cada una.
**Regla**: Orión menciona el nick del jugador al menos una vez. Primera aparición del personaje — debe caer bien y ser gracioso.
**Transición**: → `FirstBattleTutorialScreen`

### `FirstBattleTutorialScreen` ❌
**Quién la ve**: El niño, la primera vez.
**Qué hace**: Tutorial de 90 segundos. Orión explica:
1. Cómo leer el ejercicio
2. Cómo pulsar la respuesta
3. Qué pasa si aciertas / si fallas

1 ejercicio de práctica con **respuesta siempre correcta garantizada** (el juego acepta la primera opción que toque como correcta) para que el primer combate siempre se gane. El niño debe sentir poder inmediato.
**Regla**: El tutorial NUNCA puede terminar en derrota.
**Transición**: → `TitleScreen` (o directamente → `MapScreen`)

---

## BLOQUE 2 — Loop Principal

### `TitleScreen` ✅
**Quién la ve**: El niño, en sesiones recurrentes (no en la primera).
**Qué hace**: Pantalla de bienvenida. Muestra:
- Racha de días actual 🔥
- Último capítulo jugado
- Botón principal: *"¡Continuar aventura!"*

**Transición**: → `MapScreen`

### `MapScreen` 🔨
**Quién la ve**: El niño, en cada sesión.
**Qué hace**: El corazón del juego. El mundo de Numeralia con:
- Los 4 reinos (Ignis🔴, Lexis🟡, Sylva🟢, Babel⚪)
- Solo Ignis desbloqueado; los otros 3 visibles con candado (crean deseo)
- Orión flotante con mensaje aleatorio del día
- El bastón del jugador **brilla** si hay misiones pendientes del Archimago
- Accesos directos a módulos activos (combate, práctica, boss)
- Navegación inferior: Mapa / Torre / Orión / Perfil / Logros

**Transición**: → `GemZoneScreen` (reino) / → `TowerMapScreen` (bastón brillante) / → módulos directos

---

## BLOQUE 3 — Modo Historia

### `GemZoneScreen` ✅ 🔨
**Quién la ve**: El niño al pulsar un reino.
**Qué hace**: Zoom al mapa interior del reino. Capítulos como nodos en un camino:
- ⭐ Completado (con estrellas obtenidas)
- ► En progreso
- 🔒 Bloqueado (próximo a desbloquear)
- ⚔️ Mini-boss / Boss (icono especial)

**Transición**: → `ChapterIntroScreen`

### `ChapterIntroScreen` ✅
**Quién la ve**: El niño al iniciar un capítulo.
**Qué hace**: Muestra el título del capítulo con nombre del lore (ej: *"Cap. 6 — La Ventisca de Noctus"*), el reino al que pertenece, y un extracto narrativo de 2-3 líneas. Orión da el objetivo del capítulo en 1 frase. Botón ► para empezar.

**Transición**: → `ChapterScreen`

### `ChapterScreen` ✅
**Quién la ve**: El niño durante un capítulo.
**Qué hace**: El motor del capítulo. Alterna secuencialmente:
1. **Micro-lectura**: Ilustración de fondo + texto superpuesto (máx 60 palabras) + tap para avanzar
2. **Ejercicio**: El tipo varía (opción múltiple, drag & drop, ordenar, etc.)
3. **Respiro**: Orión reacciona al resultado (frase corta, 15-25 palabras)

**Regla**: Nunca 2 ejercicios seguidos sin respiro de Orión.
**Regla**: Máximo 3 acciones por capítulo.
**Transición**: → `ChapterResultScreen`

### `ChapterResultScreen` ✅
**Quién la ve**: El niño al terminar un capítulo.
**Qué hace**: Muestra estrellas ganadas (1-3), XP obtenido, objeto coleccionado. Orión celebra (o anima si no fue al 100%). Botones: *"Siguiente capítulo"* o *"Volver al mapa"*.

**Transición**: → `ChapterScreen` (next) / → `MapScreen`

---

## BLOQUE 4 — Combate Contra Enemigos

### `StoryIntroScreen` ✅ 🔨
**Quién la ve**: El niño al entrar al combate de esbirros.
**Qué hace**: Noctus envía a sus esbirros con diálogo épico. Orión reacciona con `OrionBubble` animada. Botón *"¡Al combate!"*.

### `VSScreen` ✅
**Quién la ve**: El niño antes de cada ronda.
**Qué hace**: Pantalla estilo Street Fighter. El Aprendiz vs el enemigo actual. Música dramática. Nombre/poder del enemigo. Timer 3-2-1 → combat.

### `CombatScreen` ✅
**Quién la ve**: El niño durante el combate.
**Qué hace**: El ejercicio académico disfrazado de batalla:
- Barra de vida dual (jugador vs enemigo)
- Ejercicio en el centro de la pantalla
- Timer por pregunta
- Runas activables antes de responder
- Orión en esquina con reacción tras cada respuesta (`OrionBubble` auto-hide)
- Acierto: animación de ataque + destello verde
- Fallo: screen shake + destello rojo

### `RoundResultScreen` ✅
**Quién la ve**: El niño tras cada ronda.
**Qué hace**: Victoria/Derrota de la ronda. Resultado (X-Y). Orión reacciona. Si hay más rondas → siguiente. Si es la última → `FinalResultScreen`.

### `FinalResultScreen` ✅
**Quién la ve**: El niño al terminar la batalla.
**Qué hace**: Resultado global: rondas ganadas, enemigos derrotados, XP ganado. Botones: *"Repetir"* o *"Volver al mapa"*.

---

## BLOQUE 5 — Bosses (Exámenes Encubiertos)

> **Principio**: Para el niño → "¡Voy a derrotar al Guardián!". Para el padre/profe → "Está haciendo un examen de todo el trimestre".

### `BossIntroScreen` ✅ 🔨
**Quién la ve**: El niño al entrar al boss.
**Qué hace**: Intro más épica que el StoryIntro. Noctus presenta al guardián del reino. Música especial. `NoctusIntroOverlay` disponible como widget.

### `BossScreen` ✅
**Quién la ve**: El niño durante el boss.
**Qué hace**: Igual que `CombatScreen` pero con reglas de boss:
- 10 preguntas (mini-boss: 5)
- 20 segundos por pregunta
- Necesita 10/10 para derrotar al boss
- Runas disponibles (pero el acierto con runa no cuenta como "limpio")
- Sin pistas automáticas de Orión
- Reintentos ilimitados

### `BossResultScreen` ✅ 🔨
**Quién la ve**: El niño al terminar un boss.
**Qué hace**:
- **Si saca 10/10** → Celebración épica. Gema cristaliza (animación). Orión llora (*"¡NO estoy llorando!"*). +XP masivo. Cambio de ropa si aplica (trigger: boss trimestral).
- **Si no llega** → El boss "se tambalea pero resiste". Orión ofrece práctica específica de los 3 temas con más fallos. El boss queda "herido" (barra parcial) → progreso guardado.
- **Pantalla para padres**: Equivalente a nota escolar visible en `ParentDashboardScreen`.
**Regla**: La historia NUNCA se bloquea por no derrotar al boss. El jugador siempre puede avanzar.

---

## BLOQUE 6 — Práctica Libre (Modo Entrenamiento)

### `TrainingHubScreen` ✅ 🔨
**Quién la ve**: El niño al entrar al dojo/entrenamiento de una asignatura.
**Qué hace**: Centro de práctica libre. El jugador elige:
- **Rango de tablas / tema** a practicar
- **Modo**:
  - 📖 **Aprender** → Orión explica el concepto con ejemplos visuales
  - ⚔️ **Entrenar** → Ejercicios ilimitados, sin timer, XP reducido (+5/ejercicio)
  - 🎯 **Examinar** → Mini-boss de 5 preguntas. Autoevaluación directa: *"¿Estoy listo para el examen del cole?"*

### `TrainingSessionScreen` ✅ 🔨
**Quién la ve**: El niño en modo Entrenar.
**Qué hace**: Sesión de práctica. Sin narrativa. Sin timer (opcional en configuración). Orión da feedback tras cada respuesta. La dificultad sube/baja adaptativamente.

---

## BLOQUE 7 — Torre del Archimago 🏰

> Solo aparece si hay un profesor vinculado mediante código ARCANA-XXXX. Para el niño: un lugar más del mapa. Para el proyecto: la funcionalidad B2B.

### `TowerMapScreen` ❌
**Quién la ve**: El niño cuando el bastón brilla.
**Qué hace**: La Torre Celeste aparece en el mapa entre los 4 reinos. El bastón del Aprendiz brilla indicando misiones pendientes. Al tocar → animación de teletransporte → `TowerLobbyScreen`.

### `TowerLobbyScreen` ❌
**Quién la ve**: El niño dentro de la Torre.
**Qué hace**: El Archimago (avatar del profesor) recibe al jugador:
> *"¡[Nick]! Te invoco a la Torre Celeste. Hoy entrenaremos duro."*

Muestra las misiones pendientes como **pergaminos sellados** con el símbolo de la asignatura. El jugador elige cuál completar primero.

### `MissionScreen` ❌ — Varios modos

**Quién la ve**: El niño al abrir un pergamino.
**Qué hace**: Los ejercicios del profesor, transformados narrativamente:

| El profe crea... | El niño ve... |
|---|---|
| Ficha PDF de ejercicios | 📜 Pergamino del Archimago |
| Foto de la pizarra | 📜 Prueba del reino |
| Mensaje motivador | 🕊️ Paloma mensajera del Archimago |

**Modos de misión** (el profesor elige al crear):
- **📜 Pergamino** — Ejercicios tipo examen, sin timer, sin presión. Para repasar en casa.
- **⚔️ Combate** — Los ejercicios del profe con mecánica de batalla (timer, barra de vida). Para practicar con motivación.
- **🏆 Desafío** — Todos los alumnos de la clase compiten simultáneamente. Ranking en tiempo real. Para usar en el aula.

**Regla**: Los ejercicios del profesor NUNCA entran en el Modo Aventura (La Pared de Fuego — ver `06_TORRE_DEL_ARCHIMAGO.md`).

### `MissionResultScreen` ❌
**Quién la ve**: El niño al completar una misión.
**Qué hace**: XP + Polvo Estelar (moneda exclusiva de la Torre). El Archimago reacciona con frase predefinida (ver catálogo en `06_TORRE_DEL_ARCHIMAGO.md`).

---

## BLOQUE 8 — Modo Aula (Síncrono — En el Colegio)

> El profesor activa desde su dashboard. Similar a Kahoot/Blooket pero dentro del universo de Arcana.

### `ClassroomWaitingScreen` ❌
**Quién la ve**: El niño cuando el profe activa el Modo Aula.
**Qué hace**: El bastón del niño brilla y parpadea → notificación push → al entrar: sala de espera. Muestra los avatares de los compañeros que ya están conectados. El Archimago aparece en pantalla.
> *"¡Aventureros! Os he reunido en la Torre Celeste para un entrenamiento especial."*

### `ClassroomBattleScreen` ❌
**Quién la ve**: El niño durante la sesión síncrona.
**Qué hace**: El ejercicio que el profe proyecta en la pizarra aparece simultáneamente en el dispositivo del niño. Todos responden a la vez. Dos modos:
- **Individual**: Ranking personal en tiempo real
- **Equipos**: El aula dividida en grupos, puntuación por equipo

### `ClassroomResultScreen` ❌
**Quién la ve**: El niño al terminar la sesión.
**Qué hace**: Ranking final. El Archimago cierra la sesión:
> *"¡Excelente trabajo, aventureros! Estáis listos para lo que viene."*
XP + Polvo Estelar repartidos. Resumen enviado al dashboard del profesor.

---

## BLOQUE 9 — Meta y Social

### `PlayerProfileScreen` ✅
**Quién la ve**: El niño.
**Qué hace**: Avatar del jugador con su fase actual (Niño → Aprendiz → Explorador → Mago Arcano), XP total, gemas coleccionadas, racha de días, logros desbloqueados. Historial de bosses.

### `AchievementsScreen` ✅
**Quién la ve**: El niño.
**Qué hace**: 25 logros en 7 categorías (ver `03_MECANICAS.md`). Orión tiene una frase única por cada logro desbloqueado.

### `OrionChatScreen` ✅
**Quién la ve**: El niño.
**Qué hace**: El jugador puede preguntar cosas a Orión sobre el contenido estudiado. Orión responde con humor + conocimiento real. La "enciclopedia viva" del juego.

### `DailyRewardsScreen` ✅
**Quién la ve**: El niño al tocar el cofre diario en el mapa.
**Qué hace**: Animación de apertura del cofre. Recompensa según racha de días consecutivos. Ver escala de recompensas en `09_ECONOMIA.md`.

---

## BLOQUE 10 — Dashboards de Adultos

### `ParentDashboardScreen` ❌
**Quién la ve**: El padre/madre (fuera del flujo del niño).
**Qué hace**: Progreso del niño resumido:
- Sesiones esta semana, tiempo total, racha actual
- Barras de progreso por asignatura (las 4 gemas)
- ⚠️ **Áreas a reforzar**: detectadas automáticamente (3+ fallos en un tema)
- Logros recientes del niño
- Control parental: límite diario de tiempo, notificaciones
- **Cuenta atrás al próximo examen del cole** (configurable)
- Reporte semanal automático via email/push (cada viernes)

Ejemplo de reporte:
> *"Esta semana, [nick] ha entrenado 38 min. Su hechizo de sumas es un 20% más rápido, pero los ogros de la resta le están dando problemas. ¡Anímale a entrenar este fin de semana!"*

### `TeacherDashboardScreen` ❌
**Quién la ve**: El profesor (app separada o web).
**Qué hace**:
- Vista de la clase: aventureros activos hoy (X/25), capítulo medio del grupo
- Ranking por XP de la clase
- ⚠️ **Alumnos que necesitan atención**: errores repetidos en un tema, sin conectar N días
- **📩 Enviar misión**: sube PDF/foto → IA (Gemini) convierte al formato JSON de ArcanaApp → los alumnos lo reciben como pergamino
- **🎮 Activar Modo Aula**: lanza sesión síncrona de `ClassroomBattleScreen`
- Historial de sesiones y resultados de misiones

### `ExamDateScreen` ❌
**Quién la ve**: Padre o profesor desde su dashboard.
**Qué hace**: Configura las fechas de examen del colegio en el juego.
- Capa 1 (por defecto): fechas estándar por Comunidad Autónoma
- Capa 2 (padre): sobrescribe capa 1
- Capa 3 (profesor): sobrescribe capas 1 y 2

**Efecto en el juego**: 28 días antes del examen → cuenta atrás visible en el MapScreen. Los bosses se priorizan con temas del examen próximo.

---

## Tabla resumen de implementación

| # | Pantalla | Bloque | Estado |
|---|---|---|---|
| 1 | `ParentalGateScreen` | Onboarding adulto | ❌ |
| 2 | `ChildSetupScreen` | Onboarding adulto | ❌ |
| 3 | `AvatarCreatorScreen` | Prólogo | ✅ |
| 4 | `PrologueScreen` | Prólogo | ❌ |
| 5 | `OrionIntroScreen` | Prólogo | ❌ |
| 6 | `FirstBattleTutorialScreen` | Prólogo | ❌ |
| 7 | `TitleScreen` | Loop principal | ✅ |
| 8 | `MapScreen` | Loop principal | 🔨 |
| 9 | `GemZoneScreen` | Historia | ✅ 🔨 |
| 10 | `ChapterIntroScreen` | Historia | ✅ |
| 11 | `ChapterScreen` | Historia | ✅ |
| 12 | `ChapterResultScreen` | Historia | ✅ |
| 13 | `StoryIntroScreen` | Combate | ✅ 🔨 |
| 14 | `VSScreen` | Combate | ✅ |
| 15 | `CombatScreen` | Combate | ✅ |
| 16 | `RoundResultScreen` | Combate | ✅ |
| 17 | `FinalResultScreen` | Combate | ✅ |
| 18 | `BossIntroScreen` | Bosses | ✅ 🔨 |
| 19 | `BossScreen` | Bosses | ✅ |
| 20 | `BossResultScreen` | Bosses | ✅ 🔨 |
| 21 | `TrainingHubScreen` | Práctica | ✅ 🔨 |
| 22 | `TrainingSessionScreen` | Práctica | ✅ 🔨 |
| 23 | `TowerMapScreen` | Torre | ❌ |
| 24 | `TowerLobbyScreen` | Torre | ❌ |
| 25 | `MissionScreen` | Torre | ❌ |
| 26 | `MissionResultScreen` | Torre | ❌ |
| 27 | `ClassroomWaitingScreen` | Modo Aula | ❌ |
| 28 | `ClassroomBattleScreen` | Modo Aula | ❌ |
| 29 | `ClassroomResultScreen` | Modo Aula | ❌ |
| 30 | `PlayerProfileScreen` | Meta | ✅ |
| 31 | `AchievementsScreen` | Meta | ✅ |
| 32 | `OrionChatScreen` | Meta | ✅ |
| 33 | `DailyRewardsScreen` | Meta | ✅ |
| 34 | `ParentDashboardScreen` | Dashboards | ❌ |
| 35 | `TeacherDashboardScreen` | Dashboards | ❌ |
| 36 | `ExamDateScreen` | Dashboards | ❌ |

**Resumen**: 16 ✅ implementadas · 4 🔨 mejorar · 16 ❌ por implementar
