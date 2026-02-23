# 02 · Mundo y Personajes
> **Última actualización**: 2026-02-21

---

## El Mundo: Numeralia

Un mundo mágico donde el conocimiento tiene forma física. Cada asignatura es un **reino** con su propia geografía, NPC guardián y gema de poder. Noctus, el villano, roba las gemas para mantener a todos en la ignorancia.

### Los 4 Reinos

| Reino | Gema | Asignatura | Idioma | NPC Guardián | Estética |
|---|---|---|---|---|---|
| 🔴 **Ignis** | Gema Ignis | Matemáticas | Español | Vulkan 🔥 | Forja, volcanes, cristales numéricos |
| 🟡 **Lexis** | Gema Lexis | Lengua | Español | Lexia 📖 | Bosque de palabras, bibliotecas |
| 🟢 **Sylva** | Gema Sylva | Ciencias | ES o EN* | Silvana 🌿 | Jardín salvaje, laboratorios naturales |
| ⚪ **Babel** | Gema Babel | Inglés | Inglés | Professor Pax 🐱 | Ciudad flotante, portales |

> *El idioma de Sylva depende del libro de texto del centro. Ver política de idioma más abajo.

### Geografía

```
                    🏰 Torre Celeste
                   (El Archimago — solo si hay profe)
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    🔴 Ignis        🌊 Fuente del      🟡 Lexis
    (Mates)          Saber             (Lengua)
         │          (Centro)              │
         │               │               │
    🟢 Sylva             │          ⚪ Babel
    (Ciencias)           │          (Inglés)
                         │
                    🌑 Torre del Vacío
                   (Guarida de Noctus — solo con 4 gemas)
```

---

## Personajes Principales

### El Aprendiz (Jugador)

| Aspecto | Detalle |
|---|---|
| **Identidad** | Un niño/a normal absorbido por un sobre mágico |
| **Silueta base** | Elegible al crear cuenta: **Niño** o **Niña** (siluetas distintas: pelo, pose idle, proporciones) |
| **Avatar** | Personalizable (tono piel, pelo, ojos, gafas, ropa) estilo MumaBLUE |
| **Bastón** | Madera retorcida con esfera cyan. Crece en brillo con el XP. Se usa para teletransportarse entre reinos y a la Torre del Archimago |
| **Evolución** | 4 fases de vestuario (Niño/a → Aprendiz → Explorador/a → Mago/a Arcano/a) |

> ⚠️ **Neutralidad de género**: El juego usa siempre "Aprendiz", "Mago/a", "[nick]". Las dos siluetas base comparten TODAS las opciones de personalización (pelo, ropa, etc.). No hay prendas "solo de niño" o "solo de niña".

### Orión 🦉 (Mentor)

| Aspecto | Detalle |
|---|---|
| **Especie** | Búho pequeño, plumas azul-plateado, ojos enormes |
| **Personalidad** | Dramático, gracioso, llorón (lo niega), leal |
| **Rol** | Guía principal. Da instrucciones, reacciona a aciertos/fallos. Acompaña SIEMPRE |
| **Frases** | En aciertos celebra exageradamente. Llora en momentos épicos ("¡NO ESTOY LLORANDO!") |

### Noctus (Villano)

| Aspecto | Detalle |
|---|---|
| **Identidad** | Ex-alumno de Orión. No es malvado: es alguien que se rindió |
| **Apariencia** | Capa negra, ojos de cristal violeta |
| **Motivación** | Cree que el conocimiento debería ser solo para unos pocos. Roba las gemas |
| **Guarida** | La Torre del Vacío: una torre invertida que crece hacia abajo |
| **Boss Final** | 5 fases (1 por reino + 1 combinada). Requiere las 4 gemas |

#### Foreshadowing de Noctus (3 seeds obligatorios)

1. **Tras Boss T1**: Orión susurra: *"Noctus… no siempre fue así."* y cambia de tema.
2. **En un mini-boss T2**: Se encuentra un dibujo infantil tachado: *"NO SIRVO"*. Orión se queda callado.
3. **Tras Boss T3**: La voz de Noctus se quiebra como la de un niño: *"Yo también las tuve. Y me las quitaron."*

---

## NPCs Aliados (Guardianes de Reino)

| NPC | Reino | Apariencia | Personalidad | Rol |
|---|---|---|---|---|
| **Vulkan** 🔥 | Ignis | Herrero enano, barba con chispas, martillo | Directo, brusco, buen corazón | Guardián de la Forja de los Números |
| **Lexia** 📖 | Lexis | Zorra anciana, gafas de media luna, bufanda pergamino | Sabia, paciente, habla con refranes | Guardiana del Bosque de las Palabras |
| **Silvana** 🌿 | Sylva | Anciana cubierta de musgo, ojos verdes brillantes | Torpe con humanos, brillante con seres vivos | Guardiana del Jardín Salvaje |
| **Professor Pax** 🐱 | Babel | Gato con gafitas, pajarita, pelaje gris | Políglota, elegante, pronunciación perfecta | Solo habla en inglés |

> ⚠️ **Consistencia**: El reino = **Lexis**. La gema = **Gema Lexis**. El NPC = **Lexia** (nombre propio ≠ reino).

### NPCs Secundarios (cameos)

| NPC | Reino | Capítulo | Rol |
|---|---|---|---|
| El Coleccionista de Runas | Ignis | Cap 3 | Anciano con runas numéricas |
| La Bruja Ortográfica | Lexis | Cap 4 | Amigable, caldero con recetas con faltas |
| El Hada-Libro | Lexis | Cap 5 | Bibliotecaria del Bosque |

---

## El Archimago 🧙 (NPC del Profesor)

> **Fuente de verdad** para el Archimago. Consolida `manual_diseno_arcana` L185-261, `avatar_teacher.md`, y `archimago_lore_rules.md`.

### Principio Fundamental

El Archimago es un **NPC condicional**. Solo existe si hay un profesor vinculado. Para el niño, es un personaje más del mundo de Arcana. **NUNCA se rompe la cuarta pared.**

### Ficha del Personaje

| Aspecto | Detalle |
|---|---|
| **Nombre en juego** | "El Archimago" |
| **Avatar** | Lo elige el profesor (6 opciones de aspecto mágico) |
| **Vestimenta** | Túnica oscura con constelaciones, capa larga, bastón con cristal lunar |
| **Ubicación** | Torre Celeste (entre los 4 reinos en el mapa) |
| **Personalidad** | Misterioso, poderoso, habla poco pero cada frase importa |

### Lógica de Aparición

| Situación | Qué pasa |
|---|---|
| Profesor vinculado y activo | ✅ El Archimago y la Torre aparecen en el mapa |
| Profesor vinculado pero inactivo | El Archimago está "meditando" (sin misiones) |
| Sin profesor vinculado | ❌ El Archimago y la Torre no existen. El juego funciona igual |
| Padre vincula la clase después | Animación: la torre emerge del suelo entre los reinos |

### Reglas de Inmersión

| ✅ SÍ se hace | ❌ NUNCA se hace |
|---|---|
| Hablar como personaje del juego | Mencionar "tu profesor", "tu cole", "el mundo real" |
| Llamar las tareas "retos" o "pruebas" | Llamarlas "deberes", "tareas", "ejercicios del profe" |
| Ser un mago misterioso y poderoso | Ser una representación obvia del profesor |

> 🔒 El profesor **NO** escribe diálogos. Todas las frases del Archimago son predefinidas. El profesor solo controla QUÉ ejercicios enviar.

### Diálogos Predefinidos del Archimago

```
PRIMERA VEZ:
🧙 "Así que tú eres el nuevo aprendiz... Ven a mi torre
   cuando estés listo. Necesito entrenarte para lo que viene."

TELETRANSPORTE (profe activa Modo Aula):
🧙 "¡[nick]! Te invoco a la Torre Celeste.
   Hoy entrenaremos duro."

NUEVA MISIÓN (profe envía ejercicios):
🧙 "He preparado un entrenamiento especial.
   Solo los magos más valientes se atreven."

MISIÓN COMPLETADA:
🧙 "Impresionante. Pocos magos lo logran al primer intento."

RECORDATORIO (+3 días sin hacer misión):
🧙 "[nick], mi reto te espera. No dejes que el
   conocimiento se enfríe."
```

---

## Política de Idioma

> El idioma de cada reino depende del **libro de texto** del centro, no de una suposición.

| Reino | Narrativa | Ejercicios | Determinado por |
|---|---|---|---|
| 🔴 Ignis | Español | Español | Siempre ES |
| 🟡 Lexis | Español | Español | Siempre ES |
| 🟢 Sylva | Español | **Configurable** (ES/EN) | Libro de texto del centro |
| ⚪ Babel | **Inglés** (inmersión) | **Inglés** | Siempre EN |

### Prioridad para decidir idioma de Sylva

1. **Escáner de libro**: detecta idioma automáticamente
2. **Configuración del profesor**: marca si el cole es bilingüe
3. **Configuración de padres**: elige manualmente
4. **Por defecto**: Español

### Progresión del inglés

```
Ignis (100% ES) → Lexis (100% ES)
    ↓
Sylva (depende del libro: EN o ES)
    ↓
Babel T1 caps 1-4 (EN + traducción gris debajo)
    ↓
Babel T2 caps 5-8 (EN + iconos, sin traducción)
    ↓
Babel T3 caps 9-12 (EN puro, paracaídas disponible)
```

### Diccionario de Orión

| Aspecto | Detalle |
|---|---|
| **Botón** | 📚 esquina inferior del ejercicio |
| **Acción** | Toca una palabra en inglés → Orión la traduce + audio |
| **Coste** | **0 XP** (GRATUITO — el que más lo necesita no debe ser castigado) |
| **Límite** | Sin límite |

> 💡 Un niño que consulta vocabulario está aprendiendo, no fracasando.

---

## Bosses por Reino

| Reino | Mini-boss T1 | Mini-boss T2 | Mini-boss T3 (🌟 GEMA) |
|---|---|---|---|
| 🔴 Ignis | El Numerox Guardián | El General de Piedra | El Arquitecto de Fuego |
| 🟡 Lexis | El Letrón | El Escriba Oscuro | El Guardián de Palabras |
| 🟢 Sylva | El Guardián de Enredaderas | El Alquimista Corrupto | The Nature Dragon |
| ⚪ Babel | El Guardián de Babel | El Maestro de las Rimas | The English Dragon |

---

## Vestuario (4 Fases)

El vestuario cambia SOLO al derrotar un **Boss Trimestral** (fusión de las 4 gemas del trimestre).

| Fase | Trigger | Aspecto | Frase de Orión |
|---|---|---|---|
| **0 — Niño** | Inicio | Ropa de calle + bastón apagado | — |
| **1 — Aprendiz** | Boss T1 | +Capa corta + botas de cuero | *"No. Estás CRECIENDO."* |
| **2 — Explorador** | Boss T2 | +Bufanda dorada + cinturón + capa con estrellas | *"Las herramientas no hacen al mago… pero ayudan."* |
| **3 — Mago Arcano** | Boss T3 | Sombrero + túnica + bastón brillante | *"Ya no eres un aprendiz. Eres un MAGO."* |

> La **ceremonia de fusión** es la ÚNICA animación larga del juego: las 4 gemas colisionan → flash → ropa nueva → Orión llora.
