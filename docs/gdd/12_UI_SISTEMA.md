# 12 · Sistema de UI — Biblia de Diseño
> **Última actualización**: 2026-02-24  
> **Fuente de verdad** para: layouts, componentes, mecánicas visuales, tono narrativo, tipografía, paleta de color.

---

## Principios Nintendo (no negociables)

1. **1 pantalla = 1 acción**. Un niño de 7 años sabe qué tocar en menos de 1 segundo.
2. **Máximo 5 elementos** por pantalla. La ilustración/atmósfera no cuenta.
3. **El ojo va al dorado**: todo elemento dorado es interactivo. Si es dorado, se toca.
4. **Botones ENORMES**: el botón principal ocupa mínimo el 20% del ancho.
5. **Sin texto escolar**: nunca "ejercicio", "tarea", "examen", "colegio". Siempre voz del personaje.
6. **Bloqueado = deseable**: los contenidos bloqueados muestran lo que podría ser, generando deseo.
7. **La pantalla respira**: partículas, animaciones suaves, mundo vivo.

---

## Los 3 Modos de Layout

### 1 · ARENA DE COMBATE (Estilo Street Fighter)

```
┌────────────────────────────────────────────────────────────────────────┐
│  APRENDIZ [▓▓▓▓▓▓▓░░░] Tú:4   │  Ronda 1/3  │  Ej.5/12  [░░░░▓▓▓] ENE │  ← BARRA DUAL
├──────────────┬──────────────────────────────────────────┬──────────────┤
│              │                                          │              │
│  [MAGO]      │   ╔════════════════════════╗             │  [ENEMIGO]   │
│  sprite      │   ║  74 − 38 = ?           ║             │  sprite      │
│  aura azul   │   ║                        ║             │  aura roja   │
│              │   ║  [  36  ]  [  46  ]    ║             │              │
│  shake si    │   ║  [  32  ]  [  42  ]    ║             │  shake al    │
│  le impactan │   ╚════════════════════════╝             │  recibir     │
│              │                                          │              │
└──────────────┴──────────────────────────────────────────┴──────────────┘
                ← ═════ RAYO MÁGICO viaja entre personajes ═════ →
```

**Mecánicas exactas (de `restas_battle_screen.dart`):**
- **Barra dual** (no corazones en combate normal): dorada izq = aciertos jugador, roja dcha = aciertos enemigo
- **Sin número fijo para ganar**: el combate dura los ejercicios del bloque. Quien tiene más al final gana la ronda.
- **Sin timer** en combate normal. Timer SOLO en Boss.
- **Rayo mágico** (`_MagicRayPainter`): viaja horizontalmente por el centro de la pantalla
  - ✅ Correcto → rayo azul/dorado izq→dcha → enemigo shake
  - ❌ Incorrecto → rayo rojo dcha→izq → jugador shake
  - Rayo dura 800ms, shake a los 600ms, avanza pregunta a los 1800ms
- **Dificultad adaptativa**: sube tras acierto, baja tras 3 errores seguidos
- **Ejercicio fácil inyectado** automáticamente tras error (mantiene motivación)
- **3 rondas** con enemigos distintos

**Batalla Boss (examen encubierto):**
- **Sin corazones, sin barra de vida visible** durante el combate
- El jugador responde N preguntas del bloque del boss
- **Timer activo** por pregunta — único modo con cuenta atrás. Se vuelve rojo <5s
- **Puntuación acumulada** (X/N) → NO visible durante el combate
- Al terminar → **pantalla de resultado separada** que muestra la nota
- Rayo mágico idéntico: correcto → boss shake / incorrecto → boss "lanza" al jugador
- Movimiento idle suave continuo del boss

---

### 2 · LIBRO ILUSTRADO (Historia y Comprensión)

Layout tipo libro ilustrado con imagen página izquierda, texto página derecha (intercambiable):

```
┌────────────────────────────────────────────────────────────────────────┐
│                  ILUSTRACIÓN FULL-BLEED (fondo bajo todo)              │
│   ┌────────────────────────────┬──────────────────────────────────┐    │
│   │    PÁGINA IZQUIERDA        │    PÁGINA DERECHA                │    │
│   │  (pergamino translúcido    │    (pergamino translúcido        │    │
│   │   rgba 0F0520 / 0.82)      │     rgba 0F0520 / 0.82)         │    │
│   │                            │                                  │    │
│   │  Ilustración o personaje   │  Texto narrativo (voz personaje) │    │
│   │  que habla                 │  máx 60-80 palabras por página   │    │
│   │                            │  frases de 12-18 palabras        │    │
│   │                            │                                  │    │
│   │                            │  [Acción / Siguiente ►]          │    │
│   └────────────────────────────┴──────────────────────────────────┘    │
│   ●●○○○  Cap.6                                    Orión: "¡Vamos!" 🦉   │
└────────────────────────────────────────────────────────────────────────┘
```

**Calibración de texto (de ejercicios reales 2º Primaria):**
| Contexto | Palabras |
|---|---|
| Ficha del cole (referencia) | 150-220 |
| Página del libro en juego | **máx 80** |
| Página narrativa corta | **40-60** |
| Longitud de frase | **12-18 palabras** |
> Si el texto supera 80 palabras → dividir en 2 páginas consecutivas. Nunca scroll.

**Mecánica de decisión — LEXIS (Comprensión lectora):**
El niño lee el texto y realiza una ACCIÓN en el mundo ilustrado (toca puerta/palanca/objeto). No escribe.
- Acción correcta → ha comprendido → historia avanza por el camino principal
- Acción incorrecta → **rama narrativa diferente** (no retry, no "has fallado")
  - Consecuencia dramática: trampa, monstruo, se pierde
  - Esa rama tiene su propio camino hasta el final del capítulo
  - Ambas ramas terminan siempre en un resultado — la incorrecta con mayor dificultad o menor recompensa
- **Nunca se muestra "vuelve atrás"** — siempre hay historia hacia adelante

**Variantes de página:**
- `SOLO IMAGEN`: ilustración full screen, texto mínimo en franja inferior (estilo cómic)
- `SOLO TEXTO`: Orión narra, fondo animado suave
- `DECISIÓN INTERACTIVA`: objetos/puertas tocables sobre la ilustración
- `DOS PÁGINAS EJERCICIO`: pregunta en pág izq, opciones visuales en pág dcha

---

### 3 · MAPA NARRATIVO

Mapa ilustrado overhead de Numeralia. Identifica los lugares de la historia:
- **Reino Ignis** (volcán, restas y matemáticas)
- **Reino Lexis** (biblioteca antigua, lengua)
- **Reino Sylva** (bosque encantado, ciencias)
- **Reino Babel** (ciudad de cristal, inglés)
- **Torre de Noctus**: visible al norte, oscura, imponente — meta final
- Caminos: sendero iluminado para el progreso, dim para el resto

---

## Paleta de Color

```
Fondos:
  arcanaDeep   #0A0510  →  fondo principal
  arcanaDark   #130B25  →  superficies, cards
  arcanaCard   rgba(15,5,32,0.82)  →  páginas del libro

Interactivo (DORADO = tocable):
  gold         #F4C025  →  todo interactivo
  goldDim      #A67C12  →  bloqueado deseable

Texto:
  textPrimary  #F1EDF8  →  texto principal
  textNarration #E8DFF5 →  narración en el libro (más sereno)
  textSecondary #9B8CB5 →  subtítulos, labels

Reinos (nunca mezclar):
  ignis        #DC2626  →  Matemáticas (rojo/fuego)
  lexis        #D97706  →  Lengua (ámbar)
  sylva        #16A34A  →  Ciencias (verde)
  babel        #0284C7  →  Inglés (azul hielo)

Feedback de combate:
  hitGreen     #22C55E  →  respuesta correcta
  hitRed       #EF4444  →  respuesta incorrecta
  timerWarn    #F97316  →  timer en naranja
  timerDanger  #DC2626  →  timer en rojo
```

---

## Tipografía (ya definida en `arcana_text_styles.dart`)

| Rol | Fuente | Tamaño mín | Peso |
|---|---|---|---|
| Títulos del juego | Cinzel | 28px | Bold |
| Texto narrativo / libro | Plus Jakarta Sans | 22px | Regular |
| UI botones, HUD | Cinzel | 20px | SemiBold |
| Preguntas de ejercicio | Plus Jakarta Sans | 26px | Bold |
| Botones de respuesta | Plus Jakarta Sans | 22px | Bold |
| Labels pequeños | Plus Jakarta Sans | 16px | Medium |
> **Regla**: si un niño de 7 años lo lee, mínimo 20px. Sin excepciones.

---

## Secuencia de Intro de Batalla

```
[1] NOCTUS — pantalla completa dramática
    Tormenta púrpura, trono, Noctus en pose teatral
    Diálogo en su voz: "¡Jajajá! ¡Mis esbirros te destruirán, Aprendiz!"
    → tap para continuar

[2] BOSS — primer plano intimidante
    Boss ocupa 60% pantalla, animación de entrada
    Diálogo del boss (personalidad propia):
    "¡Nadie me ha derrotado jamás! ¡Prepárate!"
    Orión en esquina: "¡No le escuches! ¡Tú puedes! 💪"
    → tap para continuar

[3] VS SCREEN — 3 segundos de adrenalina
    Split diagonal, jugador izq vs boss/enemigo dcha
    "VS" enorme con rayos pulsantes

[4] COMBATE COMIENZA
```

---

## Tono Narrativo — Reglas de Escritura

| Quién habla | Estilo | Ejemplo |
|---|---|---|
| **Noctus** | Teatral, sobre-actuado | "¡Las sombras del olvido te engullirán!" |
| **Boss** | Arrogante o misterioso, personalidad propia | "Mis cálculos oscuros te derrotarán..." |
| **Orión** | Cálido, gracioso, alentador | "¡Tú puedes! ¡Yo creía en ti antes de conocerte!" |
| **El Libro** | Narrador storybook | "Las nieves eternas cayeron sobre Ignis..." |

**NUNCA escribir:** "Ejercicio", "Responde", "Lección", "Prueba", "Examen", "Colegio", "Asignatura"  
**SIEMPRE en modo historia:** el jugador *derrota*, *descifra* o *rompe el hechizo*
