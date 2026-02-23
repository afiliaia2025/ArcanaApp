# 03 · Mecánicas de Juego
> **Última actualización**: 2026-02-21

---

## Calendario Escolar (Estructura del Juego)

El juego sigue el curso escolar real (Sep→Jun). Los 4 reinos avanzan en paralelo.

```
TRIMESTRE 1 (Sep-Dic)           TRIMESTRE 2 (Ene-Mar)          TRIMESTRE 3 (Abr-Jun)
15 semanas                      12 semanas                     10 semanas
──────────────────────          ──────────────────────         ──────────────────────
Caps varían por reino           Caps varían por reino          Caps varían por reino
(Ignis 5, Lexis 3,             (Ignis 4, Lexis 3,             (Ignis 4, Lexis 4,
 Sylva 1, Babel 4)              Sylva 2, Babel 3)              Sylva 3, Babel 3)
       ↓                               ↓                              ↓
  MINI-BOSSES por tema           MINI-BOSSES por tema          MINI-BOSSES por tema
  (parciales: 5/5, 20s)         (parciales: 5/5, 20s)         (parciales: 5/5, 20s)
       ↓                               ↓                              ↓
  4 BOSSES TRIMESTRALES          4 BOSSES TRIMESTRALES         4 BOSSES TRIMESTRALES
  (1/asignatura: 10/10)         (1/asignatura: 10/10)         (1/asignatura: 10/10)
       ↓                               ↓                              ↓
  🎽 Ropa (A→B)                 🎽 Ropa (B→C)                🎽 Ropa (C→D)
                                                                      ↓
                                                               BOSS FINAL: NOCTUS
                                                               (5 fases, 10/10 cada una)
```

**Total**: 39 caps + 16 mini-bosses + 12 bosses trimestrales + 1 boss final = **68 sesiones**
*(+ 12 caps estacionales = 80 sesiones totales)*
**Ritmo**: ~2 sesiones/semana · **Límite diario**: 2 capítulos nuevos (práctica ilimitada)

---

## Estructura de un Capítulo (~10 min)

```
📖 LECTURA (con pista escondida, máx 60 palabras)
      ↓
🎮 ACCIÓN 1 (depende de la pista del texto)
      ↓
🎉 CELEBRACIÓN (Orión reacciona)
      ↓
📖 LECTURA (nueva pista)
      ↓
🎮 ACCIÓN 2
      ↓
🎉 CELEBRACIÓN + RECOMPENSA (XP + objeto)
```

**Reglas**: Máx 2 acciones por lectura · Nunca más de 60 palabras · Celebración obligatoria tras cada acierto.

---

## 7 Tipos de Prueba

| Tipo | Presentación | Ejemplo |
|---|---|---|
| ⚔️ **Batalla** | Criatura bloquea el paso | "347 + 258 = ?" |
| 🪤 **Trampa** | Caes, resolver para escapar | "Calcula el peso para equilibrar" |
| 🚪 **Puerta** | Puerta cerrada con acertijo | "La cerradura: _ C _ D _ U" |
| ✨ **Hechizo** | Lanzar conjuro = ejercicio | "Para crear el puente: 5 × 10 = ?" |
| 🧪 **Poción** | Mezclar ingredientes correctos | "3/4 de agua + 1/4 de polvo" |
| 🗝️ **Acertijo** | Enigma de un NPC | "3 lados, ninguno curvo. ¿Qué soy?" |
| 📜 **Descifrar** | Mensaje codificado o roto | "Reordena: L-O-S-A-R-I-G → ?" |

---

## 6 Mecánicas Interactivas

| # | Gesto | Input | Regla |
|---|---|---|---|
| 1️⃣ | **ARRASTRAR** | Mover objeto de A a B | Máx 3 gestos por capítulo |
| 2️⃣ | **TOCAR** | Pulsar el correcto | Tutorial la 1ª vez |
| 3️⃣ | **GIRAR** | Rotar un elemento | Nunca teclear texto libre |
| 4️⃣ | **FROTAR** | Deslizar sobre elemento | Nunca teclear números |
| 5️⃣ | **CONSTRUIR** | Ensamblar en orden | Nunca responder con voz |
| 6️⃣ | **DESLIZAR** | Pasar objeto sobre superficie | |

---

## Sistema de Fallos

| Intento | Qué pasa | Coste |
|---|---|---|
| **Fallo 1** | Orión da una **pista** (no la respuesta) | Gratis |
| **Fallo 2** | Orión muestra **respuesta + explicación**. La historia avanza | −15 XP bonus |

**La historia NUNCA se bloquea.** El fallo resta XP bonus, nunca XP base.

---

## Sistema de Runas (Poderes)

| Runa | Poder | Cómo se obtiene |
|---|---|---|
| 🔥 Fuego | Elimina 1 opción incorrecta | Puzzle oculto en Ignis |
| 💧 Agua | +10 seg en bosses | Puzzle oculto en Lexis |
| 🌿 Tierra | 2º intento gratis | Puzzle oculto en Sylva |
| 🌀 Viento | Pista visual (parpadea) | Puzzle oculto en Babel |
| 🌑 Sombra | Revela puzzle oculto | Desafío Extra completado |

**Inicio**: 2 runas (1 Fuego + 1 Tierra) · **Máximo**: 9 activas · Se activan ANTES del ejercicio · NO se pierden al fallar.

---

## ⚔️ Sistema de Combate

### El Concepto Central

> **Los combates en ArcanaApp NO son peleas**. Son **ejercicios académicos disfrazados de batallas épicas**.

El niño cree que está luchando contra un monstruo. En realidad, está resolviendo sumas, completando frases o clasificando animales. El "daño" que inflige al enemigo es proporcional a la velocidad y precisión de sus respuestas.

### Mecánica de un Combate Normal (dentro de capítulo)

```
┌──────────────────────────────────────────┐
│  🐉 CRIATURA (barra de vida)             │
│  ████████████░░░░░░░  HP: 3/3            │
│                                          │
│  ┌─────────────────────────┐             │
│  │  "347 + 258 = ?"        │  ⏱️ 20s     │
│  └─────────────────────────┘             │
│                                          │
│  [505]  [605]  [595]  [615]              │
│                                          │
│  🧒 Aprendiz    🦉 Orión                │
│  ⬛⬛⬛ Runas disponibles                │
└──────────────────────────────────────────┘
```

| Elemento | Función |
|---|---|
| **Barra de vida del enemigo** | Se reduce con cada acierto. El enemigo "se debilita" |
| **Timer (20s)** | Cuenta atrás individual por pregunta. Si se agota → fallo |
| **Opciones (3-4)** | Respuestas posibles. Solo 1 es correcta |
| **Runas** | Se activan ANTES de responder (eliminar opción, +10s, etc.) |
| **Acierto** | Animación de ataque + flash. Orión celebra. Siguiente pregunta |
| **Fallo** | Orión da pista (1er fallo) o muestra respuesta (2º fallo) |

---

## 🏆 Bosses = Exámenes Encubiertos

### La Gran Idea

> **Un boss NO es un combate: es una AUDITORÍA ESCOLAR encubierta.**

- Para el niño: "¡Voy a derrotar al Guardián de Fuego!"
- Para el padre/profe: "Va a hacer un examen de todo el tema de sumas con llevada."

El niño NO sabe que está haciendo un examen. Cree que es una pelea épica. Esta es la **mecánica más importante** de ArcanaApp.

### Reglas de un Boss

| Regla | Valor | Por qué |
|---|---|---|
| **Puntuación requerida** | **10/10** (perfecto) | Valida dominio real del tema |
| **Timer por pregunta** | **20 segundos** | Mide fluidez, no solo conocimiento |
| **Reintentos** | Ilimitados | El niño puede volver a intentarlo |
| **Pistas/Runas** | ✅ Disponibles | Pero el acierto CON pista no cuenta como "limpio" |
| **Acierto limpio** | Sin pista, sin runa, dentro de 20s | Solo estos cuentan para el 10/10 |

### ¿Qué pasa si NO saca 10/10?

El boss NO se derrota. Pero **la historia NO se bloquea**:

```
Intento 1: 7/10 → "¡Casi! El guardián se tambalea pero resiste."
            → Orión: "Necesitas más entrenamiento. ¡Practiquemos!"
            → Se abre Modo Práctica con los 3 temas que falló
            
Intento 2: 9/10 → "¡Le falta UN golpe! Estás TAN cerca..."
            → Orión: "¡UNO más! ¡Tú puedes!"

Intento 3: 10/10 → "¡¡¡LO HAS DERROTADO!!!"
            → Celebración épica + XP + Gema cristaliza
```

---

## Jerarquía de Bosses

### 3 niveles de boss

```
Nivel 1: MINI-BOSSES (parciales por tema)
         → 1 por cada tema principal completado (NO 1 por capítulo)
         → Valida UN solo tema (ej: "sumas con llevada")
         → 5 preguntas, 20s cada una, necesita 5/5

Nivel 2: BOSSES TRIMESTRALES (examen de asignatura)
         → 1 por asignatura por trimestre = 4 por trimestre
         → Valida TODO el trimestre de esa asignatura
         → 10 preguntas, 20s cada una, necesita 10/10

Nivel 3: BOSS FINAL (Noctus)
         → 1 único al final del juego
         → Valida las 4 asignaturas completas
         → 5 fases (1 por asignatura + 1 combinada)
```

### Tabla completa de bosses del juego

#### Mini-Bosses (Parciales — 1 por tema principal)

| # | Reino | Trimestre | Boss | Tema que evalúa | Preguntas |
|---|---|---|---|---|---|
| 1 | 🔴 Ignis | T1 | Golem de Piedra | Números 0-99, U/D | 5/5 |
| 2 | 🔴 Ignis | T1 | Serpiente de Fuego | Sumas sin llevada | 5/5 |
| 3 | 🔴 Ignis | T2 | Troll del Puente | Sumas/restas con llevada | 5/5 |
| 4 | 🔴 Ignis | T2 | Araña Mecánica | Tablas ×2, ×5, ×10 | 5/5 |
| 5 | 🔴 Ignis | T3 | Fénix de Cristal | Números hasta 999, monedas | 5/5 |
| 6 | 🟡 Lexis | T1 | Lobo de Tinta | Lectura comprensiva | 5/5 |
| 7 | 🟡 Lexis | T1 | Espíritu del Diccionario | Vocabulario, sinónimos | 5/5 |
| 8 | 🟡 Lexis | T2 | Sombra Ortográfica | ca/co/cu, que/qui, ga/gu | 5/5 |
| 9 | 🟡 Lexis | T2 | Guardián de los Nombres | Sustantivos, género/número | 5/5 |
| 10 | 🟡 Lexis | T3 | Reloj de Arena Verbal | Verbos: presente/pasado/futuro | 5/5 |
| 11 | 🟢 Sylva | T1 | Enredadera Salvaje | Living/non-living, vertebrates | 5/5 |
| 12 | 🟢 Sylva | T2 | Alquimista Corrupto | Solids, liquids, materials | 5/5 |
| 13 | 🟢 Sylva | T3 | The Nature Dragon | Light, shadows, Earth/Sun | 5/5 |
| 14 | ⚪ Babel | T1 | Muralla de Babel | Classroom, daily routines | 5/5 |
| 15 | ⚪ Babel | T2 | Esfinge Parlante | Food, rooms, descriptions | 5/5 |
| 16 | ⚪ Babel | T3 | Espejo de Idiomas | Travel, sports, can/requests | 5/5 |

#### Bosses Trimestrales (Examen por asignatura — 10/10 obligatorio)

| # | Trimestre | Boss | Asignaturas que evalúa | Preguntas |
|---|---|---|---|---|
| 17 | T1 | **La Forja de Cristal** | Mates T1 completo | 10/10 |
| 18 | T1 | **El Tribunal de las Palabras** | Lengua T1 completo | 10/10 |
| 19 | T1 | **The Nature Trial** | Science T1 completo | 10/10 |
| 20 | T1 | **The Babel Gate** | English T1 completo | 10/10 |
| 21 | T2 | **El Volcán Dormido** | Mates T2 completo | 10/10 |
| 22 | T2 | **La Biblioteca Viva** | Lengua T2 completo | 10/10 |
| 23 | T2 | **The Lab Guardian** | Science T2 completo | 10/10 |
| 24 | T2 | **The Word Serpent** | English T2 completo | 10/10 |
| 25 | T3 | **El Arquitecto de Fuego** | Mates T3 completo | 10/10 |
| 26 | T3 | **El Guardián de Palabras** | Lengua T3 completo | 10/10 |
| 27 | T3 | **The Nature Dragon** | Science T3 completo | 10/10 |
| 28 | T3 | **The English Dragon** | English T3 completo | 10/10 |

#### Boss Final: Noctus en la Fuente del Saber

| Fase | Gema | Tipo | Preguntas | Timer |
|---|---|---|---|---|
| 1 | — | Narrativa | — | — |
| 2 | 🔴 Números | Mezcla de todo Mates | 10/10 | 20s |
| 3 | 🟡 Letras | Mezcla de todo Lengua | 10/10 | 20s |
| 4 | 🟢 Science | All Science topics | 10/10 | 20s |
| 5 | ⚪ English | All English topics | 10/10 | 20s |
| 6 | MIX | Mezcla 4 asignaturas | 10/10 | 20s |
| 7 | — | Narrativa: Noctus cae | — | — |

**Total bosses en el juego**: 16 mini-bosses + 12 trimestrales + 1 final = **29 bosses**

### Runa de Agua: +10 seg en cualquier boss

---

## Gemas Orbitantes

Cada reino tiene una gema flotante que acompaña al personaje:

| Logro | Estado | Visual |
|---|---|---|
| Cap 1-4 completados | 🪨 Piedra opaca | Gris, sin brillo |
| **Mini-boss T1** | 💎 CRISTALIZA | Flash + sonido |
| **Mini-boss T2** | 💎✨ SE TALLA | Facetas de gema real |
| **Mini-boss T3** | 🌟 GEMA COMPLETA | Máximo brillo + partículas |

---

## Estrellas y Rejugabilidad

Cada capítulo tiene **3 estrellas**: ⭐ completar + ⭐ sin fallos + ⭐ desafío extra.

| Mecanismo | Descripción |
|---|---|
| ⭐ Estrellas | El mapa muestra ★★★. El niño quiere el 3/3 |
| 🎲 Ejercicios rotativos | Al repetir cap, preguntas diferentes (pool + IA) |
| 🏆 Tablas de récords | Tiempo en bosses, XP máximo |
| 🎭 Cosméticos | Skins del bastón al completar reinos con 3★ |

---

## Pergaminos Olvidados (Repaso Espaciado)

> Fuente: 10_PEDAGOGIA. Basado en investigación de spaced repetition (Ebbinghaus, Leitner).

| Aspecto | Detalle |
|---|---|
| **Quién los activa** | Orión, cada 3-5 días automáticamente |
| **Contenido** | 3-5 preguntas de repaso de temas pasados |
| **Priorización** | Temas donde el alumno tuvo errores previos |
| **Narrativa** | *"¡Aprendiz! Encontré estos pergaminos olvidados en mi nido. ¿Los recuerdas?"* |
| **XP** | +10 por ejercicio (como práctica) |
| **Obligatorio** | No. Aparece como sugerencia en el mapa |

---

## Distribución de Input (Tipos de Respuesta)

| Tipo | Proporción | Ejemplo |
|---|---|---|
| **Opción múltiple** | 60% | Elige la respuesta correcta |
| **Drag & Drop** | 25% | Arrastra la suma a su resultado |
| **Ordenar secuencia** | 10% | Ordena de menor a mayor |
| **Texto libre** | 5% (solo Babel T3) | Escribe la palabra en inglés |

> El texto libre solo aparece en Babel T3 (niños de ~8 años, ya saben escribir en inglés básico).

---

## Desafíos Extra (⭐)

| Elemento | Detalle |
|---|---|
| **Puzzle Oculto** 🔍 | Objeto escondido en la ilustración. Recompensa: Runa Sombra |
| **Pregunta Bonus** ⭐ | Aparece al final. Más difícil. Timer: 45s. Premio visible antes de responder |

---

## Modo Ayuda 🆘

Se activa automáticamente tras 3 fallos consecutivos o manualmente (botón siempre visible).

| Aspecto | Normal | Modo Ayuda |
|---|---|---|
| Timer | Activo en bosses | ❌ Desactivado |
| Intentos | 3 máx | ♾️ Ilimitados |
| Opciones | 3-4 | 2 (elimina distractores) |
| XP | Variable | +10 fijo |

> Filosofía: El niño SIEMPRE avanza. El Modo Ayuda NO es castigo.

---

## Eventos Estacionales (4 mini-arcos)

| Evento | Fecha | Caps | Boss de Evento |
|---|---|---|---|
| 🎃 Halloween | Última semana OCT | 3 | Espectro de las Letras |
| 🎄 Navidad | Última semana DIC | 3 | Hechicero de Hielo |
| 🎭 Carnaval | Última semana FEB | 3 | Bufón de los Reinos |
| 🐣 Semana Santa | Semana antes vacaciones | 3 | Guardián del Huevo Dorado |

> Se desbloquean por FECHA, no por progreso. Ajustan dificultad al nivel actual del niño.

---

## Logros (25 total)

7 categorías: Primeros Pasos (4) · Maestría (7) · Conocimiento (3) · Constancia (3) · Combate (4) · Archimago (2) · Secretos (2). Cada logro tiene reacción única de Orión + recompensa cosmética o título.
Detalle completo: ver `manual_diseno_arcana.md` L1121-1183.

---

## ⚔️ Combate de Restas — Implementación (v0.1.0)

> **Última actualización**: 22/02/2026

### Estructura General

El combate de restas es el **primer sistema de combate implementado** en ArcanaApp. Pertenece al reino de **Ignis** (🔴 Matemáticas), trimestre 2.

```
┌─────────────────────────────────────────┐
│         MAPA PRINCIPAL                  │
│                                         │
│  ⚔️ Combate de Restas (7 enemigos)     │
│  🔥 Dios de las Restas (boss final)    │
│  🧮 Gemas: Ignis (1/13), Lexis, etc.   │
│  🏆 Boss Final: Noctus                 │
└─────────────────────────────────────────┘
```

### 7 Enemigos — Uno por Sección Curricular

Cada enemigo mapea a una sección del JSON `restas_completo.json` (66 ejercicios totales):

| # | Enemigo | Emoji | Sección Curricular | Dificultad |
|---|---|---|---|---|
| 1 | **Murcigloom** | 🦇 | Restas sin llevada (repaso) | 1 |
| 2 | **Serpentix** | 🐍 | Con llevada 2 cifras | 2 |
| 3 | **Aragnox** | 🕷️ | Con llevada 3 cifras | 3 |
| 4 | **Fantasmor** | 👻 | Prueba de la resta | 4 |
| 5 | **Lobocuro** | 🐺 | Relación suma↔resta | 5 |
| 6 | **Incendius** | 🔥 | Problemas contextuales | 6 |
| 7 | **Escorpius** | 🦂 | Restas encadenadas | 7 |

### Mecánica del Combate Normal

- **Rondas**: 3 enemigos aleatorios por partida (se barajan de los 7)
- **Ejercicios por ronda**: 15 (pool filtrado por dificultad del enemigo)
- **Victoria**: 7 aciertos primero (el jugador o el enemigo)
- **Re-combate**: Los enemigos derrotados se pueden volver a enfrentar
- **Contador de victorias**: Badge verde sobre el emoji de cada enemigo en el mapa

### Dificultad Adaptativa

```
Cada enemigo tiene un techo de dificultad = sectionIndex + 2
                                                          
Murcigloom (sec 0): max diff = 2  ← solo sec 1-2
Serpentix  (sec 1): max diff = 3  ← sec 1-3
Aragnox    (sec 2): max diff = 4  ← sec 1-4
...
Escorpius  (sec 6): max diff = 7  ← todo el currículo

Dentro de cada ronda:
  ✅ Acierto → dificultad sube (+1)
  ❌ Fallo   → inyecta ejercicio más fácil
  ❌❌❌ 3 fallos seguidos → baja dificultad (-1, con suelo mínimo)
```

### Tipos de Ejercicio

| Tipo | Interacción | Representación |
|---|---|---|
| `multiple_choice` | Opciones A-D | Resta vertical + 4 botones |
| `fill_blank` | Teclear resultado | Resta vertical + cajitas + numpad |
| `true_false` | V/F | Resta vertical con resultado propuesto + ¿Es correcto? |

> Todos los tipos muestran la operación en **formato vertical** con columnas D/U/C cuando se puede parsear la resta del texto de la pregunta.

### 🐍 Dios de las Restas — Boss Evaluativo

El boss es un **examen encubierto de restas de 2º de Primaria**:

| Parámetro | Valor | Justificación |
|---|---|---|
| **Nombre** | Dios de las Restas | Épico para el niño |
| **Sprite** | Serpiente dorada (110px) | `assets/images/bosses/jefe_restas.png` |
| **Preguntas** | 10 | Suficiente para evaluar |
| **Umbral de aprobado** | **7/10** | Equivale a un 7 en la escala escolar |
| **Timer** | 30-55 seg (según dificultad) | Más generoso para que no sea estrés |
| **Reintentos** | Ilimitados | El niño puede practicar y volver |

#### Selección Equilibrada del Boss

El boss NO selecciona preguntas aleatoriamente. Usa una **selección equilibrada** de las 5 secciones core:

```
2 preguntas de: Restas sin llevada       (sec 1)
2 preguntas de: Con llevada 2 cifras     (sec 2)
2 preguntas de: Con llevada 3 cifras     (sec 3)
2 preguntas de: Prueba de la resta       (sec 4)
2 preguntas de: Relación suma↔resta      (sec 5)
─────────────────────────────────────────────────
= 10 preguntas que cubren TODO el currículo core
```

> **Excluye** Problemas contextuales (sec 6) y Restas encadenadas (sec 7) del boss, ya que esas secciones evalúan competencias transversales, no operaciones directas.

### Villano Narrativo: Noctus

El combate tiene una **intro narrativa** con Noctus (Señor de las Sombras) como villano principal:
- Diálogo amenazante pero divertido para niños
- "¡Envío a mis esbirros a robar tu sabiduría!"
- Los 7 enemigos son sus secuaces
- Derrotar al Dios de las Restas es el desafío final

### Representación Visual

- **Resta vertical**: Minuendo, sustraendo con signo −, línea divisoria dorada, etiquetas D/U/C
- **Barra de batalla dual**: Proporción jugador/enemigo
- **Sprites**: Mago 🧙‍♂️ (izq) vs enemigo (der) con rayo mágico entre ellos
- **Feedback**: Shake del sprite al fallar, ataque al acertar
- **Timer del boss**: Countdown numérico + barra verde que baja

### Persistencia

| Dato | Almacenamiento | Clave |
|---|---|---|
| Enemigos derrotados (set) | SharedPreferences | `restas_defeated_enemies` |
| Victorias por enemigo (map) | SharedPreferences | `restas_enemy_victories` |
