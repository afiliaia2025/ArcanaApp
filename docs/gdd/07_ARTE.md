# 07 · Arte y Estética
> **Última actualización**: 2026-02-22
> **Fuente de verdad** para: estilo visual, paleta, tipografía, templates de pantalla, character sheets, specs de assets.

---

## Estilo Visual: 3D Cartoon Stylized (Supercell)

> **Referencias**: Clash of Clans, Clash Royale, Brawl Stars, Gem Hunter.

### Definición del Estilo (las 5 reglas de oro)

1. **3D cartoon "stylized"**: formas simples y volúmenes muy claros, con siluetas fuertes y "redondeadas" (casi de juguete).
2. **Proporciones caricaturescas**: manos/cabezas/armas algo grandes para leer bien en móvil.
3. **Materiales "pintados"**: colores limpios, pocas texturas finas; sombras suaves y brillos controlados para que todo se entienda rápido.
4. **Mucho contraste de valores** (claro/oscuro) para separar piezas y hacer legible cada unidad.
5. **Look final = modelado 3D + render estilizado**: todo se ve como si fuera renderizado desde modelos 3D, no dibujado a mano.

| ✅ ES | ❌ NO ES |
|---|---|
| 3D stylized, chunky, de juguete | Vectores planos, pixel art o acuarela |
| Clash Royale + Brawl Stars + Gem Hunter | Duolingo, Khan Academy, Ghibli |
| Colores limpios, saturados, boldos | Paleta pastel, minimalista o watercolor |
| Siluetas fuertes, redondeadas | Formas angulosas, realistas o anime |
| Sombras suaves + brillos controlados | Cel-shading, flat shading o sin sombras |
| Legible en 2cm de pantalla | Solo funciona grande |
| Cada pantalla se siente un JUEGO real | "App de deberes con dibujitos" |

### Prompt Engineering (Generación de Assets)

**Prompt base** (usar en TODAS las ilustraciones):
```
Supercell art style, Clash Royale / Clash of Clans 3D stylized
painterly render, chunky proportions, bold outlines, exaggerated
features, vibrant saturated colors, dramatic lighting, game-ready
quality, children's fantasy game, premium mobile game art
```

**Negative prompt** (usar siempre):
```
photograph, realistic, anime, flat colors, vector art, pixel art,
pastel colors, white background, scary, violent, blood, weapons,
ugly, deformed, blurry, low quality, watercolor, sketch
```

**Variables por reino**:
- **Ignis**: `volcanic forge kingdom, molten gold, crystal formations, deep red and amber, fire glow`
- **Lexis**: `enchanted book forest, giant tomes, floating letters, amber and parchment, warm candlelight`
- **Sylva**: `wild magical garden, overgrown greenhouse, glowing plants, emerald and lime green, dappled light`
- **Babel**: `floating crystal city, glass bridges, portals, cyan and silver, moonlight and stars`
- **Noctus**: `inverted dark tower, void cracks, purple energy, deep violet and black, ominous glow`

---

## Paleta de Color (Hex)

### Por reino

```
IGNIS (Matemáticas)                    LEXIS (Lengua)
├── Primario:    #D4440F (volcánico)   ├── Primario:    #D4A017 (ámbar)
├── Secundario:  #FFB627 (oro fundido) ├── Secundario:  #A1887F (pergamino)
├── Acento:      #FF6B35 (magma)       ├── Acento:      #7B5E2C (cuero viejo)
├── Fondo claro: #FFF3E0              ├── Fondo claro: #FFFEF7
├── Fondo oscuro:#3E1506              ├── Fondo oscuro:#3E2723
└── Texto:       #2D1600              └── Texto:       #1B0E0A

SYLVA (Ciencias)                       BABEL (Inglés)
├── Primario:    #2E7D32 (esmeralda)   ├── Primario:    #00ACC1 (cyan)
├── Secundario:  #81C784 (hoja)        ├── Secundario:  #B0BEC5 (plata)
├── Acento:      #4CAF50 (musgo)       ├── Acento:      #4FC3F7 (cristal)
├── Fondo claro: #E8F5E9              ├── Fondo claro: #E0F7FA
├── Fondo oscuro:#1B3A1A              ├── Fondo oscuro:#1A237E
└── Texto:       #1B3A1A              └── Texto:       #0D47A1

NOCTUS (Oscuridad)                     UI GLOBAL
├── Primario:    #311B92 (violeta)     ├── Botón:       #5C6BC0 (índigo)
├── Secundario:  #9575CD (cristal)     ├── Éxito:       #43A047
├── Acento:      #CE93D8 (magia)       ├── Error:       #EF5350
├── Fondo:       #0D0221 (vacío)       ├── XP/Logro:    #FFD54F (dorado)
└── Glow:        #E040FB              ├── Panel:       #FAFAFA (85% op.)
                                       └── Sombra:      #000000 (12% op.)
```

### Regla de color por contexto
- **Dentro de un reino**: Usar la paleta de ese reino en todo (fondo, botones, acentos)
- **En el mapa**: Fondo neutro oscuro (#1A1A2E) con acentos de cada reino en su zona
- **En bosses**: Fondo oscuro + el color del reino se intensifica
- **En Noctus**: La paleta violeta invade la pantalla progresivamente

---

## Tipografía

| Uso | Fuente | Peso | Tamaño | Color |
|---|---|---|---|---|
| **Título de capítulo** | PlusJakartaSans | ExtraBold | 28sp | Acento del reino |
| **Narración (Orión habla)** | PlusJakartaSans | Medium | 20sp | Texto del reino |
| **Texto de ejercicio** | PlusJakartaSans | SemiBold | 22sp | Texto del reino |
| **Botones de respuesta** | PlusJakartaSans | Bold | 20sp | Blanco sobre primario |
| **HUD (XP, nivel, runas)** | PlusJakartaSans | Bold | 14sp | #FFD54F (dorado) |
| **Timer de boss** | PlusJakartaSans | ExtraBold | 32sp | Blanco → #EF5350 (últimos 5s) |
| **Accesibilidad** | OpenDyslexic | Regular | +2sp sobre todo | Activable en ajustes |

**Interlineado**: 1.5× siempre. **Largo máximo**: 60 palabras/pantalla.

---

## 🖼️ TEMPLATES DE PANTALLA (Tipos Reutilizables)

> Cada tipo es un **molde** que se rellena con distinto contenido. Un artista/programador solo necesita diseñar cada tipo UNA VEZ.

---

### Template 1: NARRATIVA (📖)
> **Se usa en**: Todas las pantallas de lectura de capítulos, diálogos de Orión, intros de boss.
> **Frecuencia**: ~70% de las pantallas del juego.

```
┌─────────────────────────────────────────┐
│                                         │
│         ┌───────────────────┐           │
│         │                   │           │
│         │   ILUSTRACIÓN     │           │
│         │   DE FONDO        │           │
│         │   (16:9)          │           │
│         │                   │           │
│         └───────────────────┘           │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ 🦉 ORIÓN              [🔊 TTS] │   │
│  │                                  │   │
│  │  "Texto narrativo aquí.          │   │
│  │   Máximo 60 palabras.            │   │
│  │   2-3 frases cortas."           │   │
│  │                                  │   │
│  │              [👆 Toca para continuar] │
│  └──────────────────────────────────┘   │
│                                         │
│  [📚 Diccionario]      [⏸️ Pausa]      │
└─────────────────────────────────────────┘
```

| Elemento | Especificación |
|---|---|
| **Ilustración** | 100% ancho, 55% alto. Fondo del reino. Esquinas redondeadas 16dp |
| **Caja de texto** | Fondo semi-transparente (fondo_oscuro al 85%). Padding 20dp. Esquinas 12dp |
| **Speaker** | Icono del personaje (Orión/NPC/Narrador) + nombre en bold a la izquierda |
| **TTS** | Botón 🔊 siempre visible arriba-derecha de la caja |
| **Tap zone** | TODA la pantalla es tappeable para avanzar (excepto botones) |
| **Transición** | Fade 0.3s al siguiente template |

**Variantes**:
- **Narrativa con speaker** (Orión, NPC): icono a la izquierda
- **Narrativa sin speaker** (narrador): texto centrado, fuente itálica
- **Narrativa de objetivo** (inicio de cap): icono 🎯 + texto dorado + fondo más oscuro

---

### Template 2: DECISIÓN (🔀)
> **Se usa en**: Bifurcaciones narrativas (branching convergente).
> **Frecuencia**: 1-2 por capítulo.

```
┌─────────────────────────────────────────┐
│                                         │
│         ┌───────────────────┐           │
│         │   ILUSTRACIÓN     │           │
│         │   (bifurcación    │           │
│         │    visual: dos    │           │
│         │    caminos)       │           │
│         └───────────────────┘           │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ 🦉 "¿Qué camino eliges?"        │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌────────────────┐ ┌────────────────┐  │
│  │ 🌉             │ │ 🌿             │  │
│  │ Cruzar el      │ │ Tomar el       │  │
│  │ puente viejo   │ │ atajo          │  │
│  │                │ │                │  │
│  └────────────────┘ └────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

| Elemento | Especificación |
|---|---|
| **Ilustración** | Misma que Narrativa pero mostrando una bifurcación visual |
| **Texto de Orión** | Breve, SIEMPRE una pregunta: "¿Qué camino eliges?" |
| **Botón A (izquierda)** | Color primario del reino. Icono + título + descripción corta |
| **Botón B (derecha)** | Color secundario del reino. Mismo formato |
| **Tamaño botones** | 45% ancho cada uno, separación 10dp, alto mínimo 120dp |
| **Animación** | Al elegir: botón elegido crece 10%, el otro se desvanece. Fade 0.5s |

---

### Template 3: EJERCICIO (🎮)
> **Se usa en**: Todas las pruebas académicas dentro de capítulos.
> **Frecuencia**: 2-3 por capítulo. EL template más importante para la app.

```
┌─────────────────────────────────────────┐
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ 🧙 "Resuelve para abrir         │   │
│  │    la puerta..."                 │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │                                  │   │
│  │     ZONA DE EJERCICIO            │   │
│  │     (contenido variable)         │   │
│  │                                  │   │
│  │     "347 + 258 = ?"              │   │
│  │                                  │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ 505  │ │ 605  │ │ 595  │ │ 615  │   │
│  └──────┘ └──────┘ └──────┘ └──────┘   │
│                                         │
│  🔥💧🌿 Runas    [🆘 Ayuda] [📚 Dict] │
│                                         │
│  🦉 Orión (reacción tras responder)     │
└─────────────────────────────────────────┘
```

| Elemento | Especificación |
|---|---|
| **Contexto narrativo** | Caja superior: POR QUÉ el niño resuelve esto (diegético) |
| **Zona de ejercicio** | Centro, fondo blanco, borde del color del reino. Tamaño variable |
| **Opciones (MC)** | Grid 2×2 o fila de 3-4. Touch target mín 64×48dp. Fondo primario del reino |
| **Runas** | Barra inferior izquierda. Solo las activas. Tappear activa ANTES de responder |
| **Ayuda** | Botón 🆘 siempre visible. Activa Modo Ayuda |
| **Feedback acierto** | Flash verde 0.3s + ✅ + sonido "ding" + Orión celebra |
| **Feedback fallo** | Shake 0.3s + ❌ + sonido suave + Orión da pista |

**Sub-variantes por tipo de input**:

| Variante | Zona de ejercicio | Input |
|---|---|---|
| **Opción múltiple** (60%) | Pregunta arriba, 3-4 botones abajo | Tap en botón |
| **Drag & Drop** (25%) | Elementos arrastrables + zonas de destino | Drag de A a B |
| **Ordenar** (10%) | Elementos desordenados en fila | Drag para reordenar |
| **Texto libre** (5%, solo Babel T3) | Pregunta + campo de texto + teclado | Escribir palabra |

---

### Template 4: COMBATE (⚔️)
> **Se usa en**: Batallas contra criaturas (dentro de capítulos) y Modo Práctica.
> **Frecuencia**: 1-2 por capítulo, ilimitado en Práctica.

```
┌─────────────────────────────────────────┐
│                                         │
│  🐉 SERPIENTE DE FUEGO                  │
│  ████████████░░░░░░░  HP: 3/5           │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │                                  │   │
│  │     "347 + 258 = ?"     ⏱️ 18s  │   │
│  │                                  │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ 505  │ │ 605  │ │ 595  │ │ 615  │   │
│  └──────┘ └──────┘ └──────┘ └──────┘   │
│                                         │
│  🧒 Aprendiz          🦉 Orión         │
│  ⬛⬛⬛ Runas                           │
└─────────────────────────────────────────┘
```

| Elemento | Especificación |
|---|---|
| **Criatura** | Ilustración en la parte superior, 40% de pantalla. Nombre + emoji |
| **Barra HP** | Color del reino → gris conforme pierde vida. Debajo del nombre |
| **Pregunta** | Centro, fondo oscuro semi-transparente. Timer arriba-derecha |
| **Timer** | 20s. Blanco → Naranja (10s) → Rojo parpadeante (5s) |
| **Acierto** | Flash de "ataque" desde el Aprendiz hacia la criatura. HP baja. Shake de la criatura |
| **Fallo** | Criatura "ataca" (shake de pantalla suave). Orión da pista |
| **Victoria** | Criatura se desvanece con partículas. Fanfarria. XP aparece |

**Diferencia con Template 3**: Tiene criatura + HP + timer. Es más URGENTE visualmente (fondo más oscuro, bordes más pronunciados).

---

### Template 5: BOSS (🏆)
> **Se usa en**: Mini-bosses (5/5), Bosses Trimestrales (10/10), Boss Final.
> **Frecuencia**: 29 veces en todo el juego.

```
┌─────────────────────────────────────────┐
│          ⚡ BOSS: GOLEM DE PIEDRA ⚡     │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │                                  │   │
│  │     [ILUSTRACIÓN DEL BOSS]       │   │
│  │     (pose amenazante,            │   │
│  │      ocupa 50% pantalla)         │   │
│  │                                  │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ████████████████████  5/10 · ⏱️ 17s   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │   "¿Cuántas decenas tiene 347?"  │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐   │
│  │  3   │ │  4   │ │  34  │ │  7   │   │
│  └──────┘ └──────┘ └──────┘ └──────┘   │
│                                         │
│  🔥💧🌿 Runas           [⚡ 5/10]      │
└─────────────────────────────────────────┘
```

| Elemento | Vs Template 4 (Combate normal) |
|---|---|
| **Fondo** | Más oscuro, con vignette, partículas flotantes |
| **Boss** | Más grande (50% pantalla vs 40%), con aura/glow |
| **Barra de progreso** | Muestra "5/10 aciertos limpios" (no HP sino progreso del niño) |
| **Música** | Cambia a track épica (130-140 BPM) |
| **Derrota del boss** | Secuencia especial: boss se resquebraja → fade blanco → Template 6 |

---

### Template 6: CELEBRACIÓN (🎉)
> **Se usa en**: Fin de capítulo, victoria de boss, logro desbloqueado, cambio de vestuario.
> **Frecuencia**: ~80 veces totales.

```
┌─────────────────────────────────────────┐
│                                         │
│         ✨ ¡CAPÍTULO COMPLETADO! ✨      │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │                                  │   │
│  │     [ILUSTRACIÓN HEROICA]        │   │
│  │     (Aprendiz en pose triunfal   │   │
│  │      + Orión celebrando)         │   │
│  │                                  │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ⭐⭐☆  2/3 estrellas                   │
│                                         │
│  ┌─────────┐ ┌─────────┐               │
│  │ +120 XP │ │ +50 ✨  │               │
│  └─────────┘ └─────────┘               │
│                                         │
│  🦉 "¡INCREÍBLE! ¡Eso ha sido          │
│     ESPECTACULAR!"                      │
│                                         │
│  ┌────────────────────────────────┐     │
│  │      [Volver al Mapa]          │     │
│  └────────────────────────────────┘     │
└─────────────────────────────────────────┘
```

| Nivel | Duración | Efecto visual |
|---|---|---|
| **Cap completado** | 2s auto | Flash + chispas + XP animado |
| **Mini-boss** | 4s | Cristalización de gema + ilustración especial |
| **Boss Trimestral** | 8s | Fusión de gemas + cambio de ropa + Orión llora |
| **Boss Final** | 15s | Secuencia cinemática: gemas → Fuente → créditos |

---

### Template 7: MAPA (🗺️)
> **Se usa en**: Pantalla de Numeralia (principal) y mapa de nodos por reino.
> **Frecuencia**: Cada vez que abre la app.

```
┌─────────────────────────────────────────┐
│  [HUD: Nvl 5 ⭐ 1240XP  🔥💧🌿 ⚙️]   │
│                                         │
│          🏰 Torre Celeste               │
│          (si hay profe)                 │
│               │                         │
│     🔴        │         🟡              │
│   IGNIS ──── ◈ ──── LEXIS              │
│               │     Fuente              │
│     🟢        │         ⚪              │
│   SYLVA       │      BABEL              │
│               │                         │
│          🌑 (oculto)                    │
│                                         │
│  ═══════════════════════════════════    │
│  🦉 "Hoy deberías visitar Ignis,       │
│     ¡hay un nuevo capítulo!"            │
│                                         │
│  [🏋️ Entrenamiento] [📜 Pergaminos]    │
└─────────────────────────────────────────┘
```

| Elemento | Especificación |
|---|---|
| **Perspectiva** | Isométrica suave (30°). Scroll vertical, ~3 pantallas de alto |
| **HUD superior** | Fijo. Nivel + XP + runas disponibles + engranaje (ajustes) |
| **Nodos** | 🔒 Bloqueado = gris+cadena · ⚪ Disponible = pulsa · ⭐ Completado = estrellas visibles |
| **Bastón** | Visible en esquina. Brilla si hay deberes del profe |
| **Orión** | Barra inferior con sugerencia de qué hacer hoy |
| **Botones de acceso rápido** | Entrenamiento (Modo Práctica), Pergaminos Olvidados |
| **Fondo** | Neutro oscuro (#1A1A2E) con cada zona iluminada con su color de reino |

---

### Template 8: PERFIL / AVATAR (👤)
> **Se usa en**: Creación de avatar (onboarding) y pantalla de perfil.
> **Frecuencia**: 1 vez en onboarding, accesible desde ajustes.

```
┌─────────────────────────────────────────┐
│  ← Volver           MI MAGO       ⚙️   │
│                                         │
│           ┌─────────────┐               │
│           │             │               │
│           │  [AVATAR]   │               │
│           │  (preview   │               │
│           │   en vivo)  │               │
│           │             │               │
│           └─────────────┘               │
│     MagoDragon · Nvl 5 · Explorador    │
│                                         │
│  ┌───┐┌───┐┌───┐┌───┐┌───┐             │
│  │👤 ││💇 ││👁️ ││👓 ││👕 │ ← Tabs      │
│  └───┘└───┘└───┘└───┘└───┘             │
│                                         │
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐        │
│  │🏽│ │🏻│ │🏾│ │🏿│ │🏼│ │🏽│ ← Grid   │
│  └──┘ └──┘ └──┘ └──┘ └──┘ └──┘        │
│                                         │
│  💎 Gemas: 🔴✨ 🟡⬜ 🟢💎 ⚪⬜        │
│  🏆 Logros: 8/25                        │
└─────────────────────────────────────────┘
```

---

## Resumen de Templates

| # | Template | Se usa en | Frecuencia |
|---|---|---|---|
| 1 | 📖 **Narrativa** | Lectura de capítulos, diálogos | ~70% de pantallas |
| 2 | 🔀 **Decisión** | Bifurcaciones (branching) | 1-2 por capítulo |
| 3 | 🎮 **Ejercicio** | Pruebas dentro de capítulos | 2-3 por capítulo |
| 4 | ⚔️ **Combate** | Batallas + Modo Práctica | 1-2 por cap + ilim. |
| 5 | 🏆 **Boss** | Mini-bosses y Bosses | 29 veces total |
| 6 | 🎉 **Celebración** | Fin de cap, victoria, logro | ~80 veces |
| 7 | 🗺️ **Mapa** | Pantalla principal + reinos | Cada apertura |
| 8 | 👤 **Perfil** | Avatar y estadísticas | Ajustes |

> Con estos 8 templates se construye el 100% de la experiencia del alumno.

---

## Character Sheets (Especificaciones)

### Orión 🦉

| Aspecto | Especificación |
|---|---|
| **Proporciones** | Chibi: cabeza = 40% del cuerpo total |
| **Plumas** | Base #8B9DC3 (azul-plateado), puntas #C5CAE9 (más claras) |
| **Ojos** | Grandes (30% de la cara), iris #FFD700 (oro), pupila negra, brillo blanco |
| **Pico** | #C77A30, pequeño, curvado |
| **Tamaño vs Aprendiz** | Llega al hombro del niño |
| **Posición en pantalla** | Esquina inferior-izquierda, sobre la caja de texto |

**6 expresiones obligatorias**:
1. 😊 **Normal**: ojos abiertos, boca cerrada, plumas lisas
2. 😱 **Sorpresa**: ojos 2×, plumas erizadas, boca en O
3. 😭 **"NO lloro"**: lágrimas + boca temblorosa + ceño fruncido
4. 🎉 **Celebración**: alas abiertas, brillo en ojos, salta
5. 😤 **Enfado leve**: ceño + plumas en punta + boca torcida
6. 😴 **Dormido**: ojos cerrados, zzz, cabeza ladeada

### Aprendiz 🧒🧒‍♀️ (2 siluetas × 4 fases)

**Silueta base**: El jugador elige al crear la cuenta. Afecta la pose idle y las proporciones, NO las opciones de personalización.

| Aspecto | Silueta Niño | Silueta Niña |
|---|---|---|
| **Pelo por defecto** | Corto despeinado | Recogido con mechón |
| **Pose idle** | De pie, bastón en mano derecha | De pie, bastón apoyado en hombro |
| **Proporciones** | Ligeramente más ancho de hombros | Ligeramente más alta |
| **Ropa Fase 0** | Camiseta + pantalón | Camiseta + falda-pantalón (skort) |

> ⚠️ **Todas las opciones de personalización son compartidas**. Ambas siluetas acceden a los mismos 8 estilos de pelo, 6 tonos de piel, colores de ropa, etc. No hay bloqueo por género.

| Fase | Añade | Paleta |
|---|---|---|
| 0 — Niño/a | Ropa de calle, bastón gris apagado | Tonos tierra naturales |
| 1 — Aprendiz | +Capa corta marrón, +botas de cuero | +#8D6E63 (cuero) |
| 2 — Explorador/a | +Bufanda dorada, +cinturón, capa con estrellas | +#FFD54F (dorado) |
| 3 — Mago/a | Túnica completa, sombrero, bastón brillante | +#5C6BC0 (índigo) + glow |

**Personalización**: 2 siluetas × 6 tonos de piel × 8 pelos × 4 ojos × 3 gafas = **1.152 combinaciones**
**Las 4 fases se generan para cada silueta** (via layers, no sprites individuales).

### Bastón Mágico

| Estado | Visual |
|---|---|
| Fase 0 | Palo de madera sin brillo, esfera gris apagada |
| Fase 1 | +vetas azuladas en la madera |
| Fase 2 | Esfera brilla cyan, partículas flotan alrededor |
| Fase 3 | Toda la madera brilla, esfera dorada radiante |
| **Brilla** (deberes) | Esfera pulsa como latido, rayos de luz, 🔔 flotante |

---

## Iconografía de Runas

| Runa | Forma base | Color | Estado inactivo | Estado activo |
|---|---|---|---|---|
| 🔥 Fuego | Círculo con llama interior | #FF6B35 | 50% saturación, sin glow | 100% saturación + glow pulsante |
| 💧 Agua | Gota con espiral interior | #4FC3F7 | 50% saturación | 100% + glow suave |
| 🌿 Tierra | Hoja con raíces | #4CAF50 | 50% saturación | 100% + glow orgánico |
| 🌀 Viento | Espiral de aire | #B0BEC5 → #E0F7FA | 50% saturación | 100% + glow giratorio |
| 🌑 Sombra | Luna creciente | #9575CD | 50% saturación | 100% + glow intermitente |

**Formato**: 128×128px, PNG con alpha, 2 estados.

---

## Accesibilidad

| Área | Implementación |
|---|---|
| **Tipografía** | Mín 18sp, interlineado 1.5×, OpenDyslexic opcional |
| **Contraste** | Ratio mín 4.5:1, botones con borde visible |
| **Color** | Gemas usan forma además de color (🔴=círculo, 🟡=estrella, 🟢=hoja, ⚪=diamante) |
| **Audio** | TTS disponible para TODO el texto. Botón 🔊 siempre visible |
| **Motor** | Zonas táctiles mín 48×48dp. Drag & drop con snap generoso |
| **Tiempo** | Modo Ayuda elimina timers. Pausa siempre disponible |
| **Cognitivo** | Máx 60 palabras/pantalla. Icono + texto en instrucciones |

---

## Dirección Musical

Generada con Stable Audio. Pistas de 45-90s en loop, 2-3 variaciones por zona.

| Zona | Estilo | BPM |
|---|---|---|
| Menú / Mapa | Orquestal whimsical, celesta, arpa. Ghibli. | 90 |
| Ignis | Medieval tavern, laúd, flauta. | 100 |
| Lexis | Bosque encantado, vientos, marimba. | 85 |
| Sylva | Pastoral, oboe, guitarra acústica. | 80 |
| Babel | Piano elegante, jazz brushes, vibráfono. | 95 |
| Mini-bosses | Orquestal dramático. | 130 |
| Bosses | Épico, coro, bronces. | 140 |
| Noctus | Oscuro misterioso, cello, coro susurrado. | 120→150 |
| Lectura | Piano solo suave. | 70 |
| Práctica | Lo-fi study beats. | 85 |

**Leitmotif**: Motivo de 6 notas en celesta que se varía por instrumento/reino.

---

## Specs de Producción

### Formatos de Assets

| Asset | Resolución | Formato | Notas |
|---|---|---|---|
| Ilustraciones (fondos) | 1920×1080 (16:9) | WebP, 85% quality | Zona inferior 25% más oscura (para texto) |
| Sprites personajes | 512×512 base | PNG con alpha | Por layers (skin/pelo/ropa separados) |
| Iconos (runas, logros) | 128×128 | PNG con alpha | 2 estados: activo + inactivo |
| Fondos de mapa | 1080×3240 (scrolleable) | WebP, 90% | 3 pantallas de alto |
| Música | Loop 45-90s | OGG Vorbis, 128kbps | Crossfade de 2s entre zonas |
| SFX | 0.1-2s | OGG Vorbis, 128kbps | Ding, error, fanfarria, etc. |

### Pipeline

| Asset | Cantidad | Método | Coste |
|---|---|---|---|
| Viñetas narrativas | ~300 textos | Script + Gemini Flash | ~$2 |
| Ejercicios | 900+ | Ya existentes en JSON | $0 |
| Ilustraciones | ~150 | Stable Diffusion + LoRA | ~$0 |
| Fondos de mapa | 9 | Recraft / SD | ~$0 |
| Sprites | Layers (no 576 individuales) | PixelVibe / Recraft | ~$0 |
| Música | ~15 pistas | Stable Audio | ~$0 |
| Iconos | ~30 | Recraft | ~$0 |
| **TOTAL** | ~1.000 assets | | **~$4** |
