# 06 · Torre del Archimago (Sistema Escolar)
> **Última actualización**: 2026-02-21
> **Fuente de verdad** para: rol del profesor, IA Gemini para ejercicios, copyright, deberes, Modo Aula.

---

## El Concepto

La Torre del Archimago es el **puente entre el colegio real y el mundo de Arcana**. Para el niño, es un lugar más del mapa. Para el proyecto, es la funcionalidad B2B que permite a los colegios usar ArcanaApp como herramienta educativa.

| Realidad | En el juego |
|---|---|
| El Profesor | El Archimago |
| El Colegio / La Clase | La Torre Celeste |
| Los Deberes | Las Misiones del Archimago |
| La Conexión | El Bastón Mágico brilla → teletransporte |

---

## Flujo del Alumno

```
El niño abre la app un miércoles por la tarde:

1. Si quiere jugar la historia:
   Mapa → Elige reino → Modo Aventura (capítulo del currículo)

2. Si el profe mandó deberes:
   El Bastón BRILLA ✨ → Lo toca →
   Animación de teletransporte →
   Aparece en la TORRE DEL ARCHIMAGO →
   Resuelve los ejercicios del profe →
   Gana XP + Polvo Estelar →
   Vuelve al mapa
```

---

## Flujo del Profesor

### 1. Registro y Onboarding

```
El profesor crea su cuenta →
Elige avatar del Archimago (6 opciones mágicas) →
Crea su "clase" (genera código) →
Comparte código con los padres →
Los padres vinculan al niño →
El Archimago aparece en el mapa del niño
```

### 2. Subida de Ejercicios

```
El profesor tiene ejercicios propios →
Los sube como PDF o foto (cámara/galería) →
Gemini AI analiza el documento →
Extrae: tema, tipo, dificultad →
Traduce a formato JSON de ArcanaApp →
El ejercicio aparece como "misión del Archimago" para los alumnos
```

### 3. Dashboard del Profesor

```
┌─────────────────────────────────────┐
│  📊 Mi Clase de Aventureros         │
│                                     │
│  Aventureros activos hoy: 18/25    │
│  Capítulo medio: 7 de 12           │
│  Tema actual: Sumas con llevada     │
│                                     │
│  🏆 Ranking:                        │
│  1. Luna_Star ⭐ 1,240 XP          │
│  2. DragonMax ⭐ 1,100 XP          │
│                                     │
│  ⚠️ Necesitan ayuda:               │
│  • Marc — 3 fallos seguidos en T3  │
│  • Sara — no entra desde hace 3d   │
│                                     │
│  [📩 Enviar misión]                │
│  [📚 Ver progreso detallado]       │
└─────────────────────────────────────┘
```

---

## Reglas de la IA (Gemini)

### Regla de Copyright

| ✅ PERMITIDO | ❌ PROHIBIDO |
|---|---|
| El profesor sube su propia documentación en PDF | Fotografiar libros de texto de editoriales |
| El profesor sube fichas que él mismo ha creado | Escanear páginas de libros con copyright |
| El profesor sube ejercicios de la pizarra | Usar contenido de terceros sin permiso |

### ¿Qué hace la IA?

1. Lee el PDF/foto del profesor
2. Extrae los ejercicios y los identifica (tipo, tema, dificultad)
3. Los traduce al formato JSON del `ExerciseService` de ArcanaApp
4. Les pone título, los decora con el estilo narrativo de Arcana
5. **Opcionalmente**: genera ejercicios SIMILARES adicionales basándose en el patrón

### ¿Qué NO hace la IA?

- ❌ NO genera contenido para el Modo Aventura (la historia es pre-creada)
- ❌ NO modifica los capítulos narrativos
- ❌ NO escribe diálogos del Archimago (son predefinidos)
- ❌ NO interactúa directamente con el niño

---

## La Pared de Fuego (Regla de Oro)

> Los ejercicios del profesor NUNCA entran en el Modo Aventura.

| Modo Aventura | Torre del Archimago |
|---|---|
| Campaña cerrada, pre-creada | Ejercicios personalizados del profe |
| Controlada por el equipo de diseño | Controlada por el profesor |
| Sigue el currículo autonómico | Sigue lo que el profe decida |
| Calidad garantizada | Validación automática por IA |
| Progresión narrativa | Solo mecánica (sin historia) |

---

## Modo Aula (Torre Síncrona)

Cuando el profesor activa el "Modo Aula" desde su dashboard:

1. **En la pantalla del profe**: Se abre una sesión de entrenamiento grupal
2. **En la app de los niños**: El bastón brilla → teletransporte automático a la Torre
3. **Mecánica**: El profe proyecta ejercicios en la pizarra digital, los niños responden desde sus dispositivos
4. **Competición**: Equipos o individual, con ranking en tiempo real
5. **Estilo**: Similar a Kahoot/Blooket pero dentro del universo de Arcana

### Narrativa del Modo Aula

```
🧙 "¡Aventureros! Os he reunido en la Torre Celeste
   para un entrenamiento especial. Noctus se acerca
   y necesito que TODOS estéis preparados."

[Los ejercicios aparecen como "pruebas del Archimago"]

🧙 "¡Excelente trabajo, aventureros! Estáis listos
   para lo que viene."
```

---

## Mensajes del Profesor (Transformación Narrativa)

El profesor escribe mensajes normales que el sistema transforma:

| El profe escribe... | El alumno ve... |
|---|---|
| "¡Buen trabajo esta semana!" | 📜 *Paloma del Archimago: "Buen trabajo, aventurero."* |
| "Repasad las sumas para el jueves" | 📜 *Pergamino urgente: "Una gran prueba se acerca..."* |
| "Pablo, intenta la misión extra" | 🗡️ *"El Archimago te busca: Hay una cueva que pocos se atreven a explorar..."* |

---

## Onboarding del Alumno (Primera Vez)

```
1. El PADRE descarga la app y crea la cuenta (email + contraseña)
   → Parental Gate: verifica que es un adulto (suma de verificación)

2. El padre introduce datos del niño:
   → Nombre/Nick (nunca nombre real visible para otros)
   → Curso (2º o 3º Primaria)
   → Comunidad Autónoma (para alinear currículo)

3. Se abre el CREADOR DE AVATAR (pantalla del niño):
   → Tono de piel (6 opciones)
   → Pelo (8 estilos × 6 colores)
   → Ojos (4 formas)
   → Gafas (sí/no, 3 estilos)
   → Ropa inicial (3 opciones de calle)

4. PRÓLOGO AUTOMÁTICO:
   → La carta dorada aparece en la pantalla
   → "¿Quieres abrirla?" (primer tap)
   → Teletransporte a Numeralia
   → Orión aparece: "¡Al fin llegas! Te estaba esperando..."
   → Tutorial: aprende a tocar, arrastrar y leer
   → Primer ejercicio de prueba (sin puntuación)
   → "¡Bienvenido a Numeralia, [nick]!"
```

### Vinculación con Profesor (Opcional)

```
El padre recibe un CÓDIGO del profesor (ej: ARCANA-7X2K)
→ Ajustes → "Vincular con clase"
→ Introduce el código
→ La Torre Celeste aparece en el mapa con animación
→ Orión: "¡Un nuevo Archimago ha llegado a Numeralia!"
```

---

## Dashboard de Padres

```
┌─────────────────────────────────────┐
│  🦉 Las Aventuras de [nick]         │
│                                     │
│  📊 Esta semana:                    │
│  • Sesiones: 4 (meta: 5)           │
│  • Tiempo total: 38 min            │
│  • Racha: 🔥 7 días                │
│                                     │
│  ┌────────────────────────────┐     │
│  │  🔴 Mates: ████████░ 78%  │     │
│  │  🟡 Lengua: ██████░░ 65%  │     │
│  │  🟢 Science: ███████░ 72% │     │
│  │  ⚪ English: █████░░░ 55% │     │
│  └────────────────────────────┘     │
│                                     │
│  ⚠️ Áreas a reforzar:              │
│  • Ortografía (ca/co/cu, que/qui)  │
│  • Telling time in English          │
│                                     │
│  🌟 Logros recientes:              │
│  • "Cuatro Caminos" ⭐             │
│  • Boss T1 Ignis derrotado 🎉      │
│                                     │
│  📩 Reporte semanal: [Activar]     │
│  ⏰ Límite diario: [30 min ▼]      │
│  🔔 Notificaciones: [Activadas]    │
└─────────────────────────────────────┘
```

### Reporte Semanal (Email/Push del viernes)

> *"Esta semana, [nick] ha entrenado 38 minutos. Su hechizo de sumas es un 20% más rápido, pero los ogros de la resta le están dando problemas. ¡Anímale a entrenar en el Modo Combate este fin de semana!"*

---

## Sistema de Fechas (Sincronización Escolar)

El juego se sincroniza con los exámenes reales:

| Capa | Quién configura | Prioridad |
|---|---|---|
| **Precargadas** | Sistema (por CC.AA.) | Base por defecto |
| **Padre/madre** | Ajustes → "Fechas examen" | Sobrescribe capa 1 |
| **Profesor** | Dashboard del profe | Sobrescribe capas 1 y 2 |

**28 días antes del examen** → Cuenta atrás en el mapa. Si el niño no llega a tiempo, el boss es más difícil (más fases), pero NUNCA se bloquea.
