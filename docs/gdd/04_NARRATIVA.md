# 04 · Narrativa
> **Última actualización**: 2026-02-21
> **Fuente de verdad** para: motor narrativo, branching, micro-lecturas, formato de texto.
> Consolida: `narrative_system`, `narrative_branching_design`, `rediseno_narrativo_v2`.

---

## Principio Narrativo

ArcanaApp es un **libro de cuentos ilustrado interactivo**, NO un videojuego animado. Cada pantalla = 1 ilustración estática + texto superpuesto + elementos interactivos.

```
┌─────────────────────────────────┐
│  [Ilustración de fondo]         │
│                                 │
│  ╔═══════════════════╗          │
│  ║ Texto narrativo   ║          │
│  ║ (2-3 líneas)      ║          │
│  ╚═══════════════════╝          │
│                                 │
│     [Elementos interactivos]    │
│                                 │
│  [Orión]          [📚 Dict.]   │
└─────────────────────────────────┘
```

---

## Regla de Oro: Micro-lecturas

**Máximo 60 palabras por pantalla.** Un niño de 7 años no lee párrafos de 200 palabras en una app.

| Segmento | Contenido | Palabras | Interacción |
|---|---|---|---|
| **Objetivo** | Orión anuncia el objetivo del capítulo | 15-20 | 👆 Toca para avanzar |
| **Intro** | Orión habla | 40-60 | 👆 Toca para avanzar |
| **Acción 1** | Contexto + ejercicio | 30-40 + widget | 🎮 Ejercicio |
| **Respiro** | Reacción de Orión | 15-25 | 👆 Toca |
| **Acción 2** | Contexto + ejercicio | 30-40 + widget | 🎮 Ejercicio |
| **Respiro** | Micro-narrativa | 20-30 | 👆 Toca |
| **Acción 3** | Contexto + ejercicio | 30-40 + widget | 🎮 Ejercicio |
| **Cierre** | Celebración | 20-30 | 🎉 Auto |

**Total por capítulo**: ~7 pantallas · ~5-8 minutos · ~250 palabras.

### Reglas de "respiro"
- Después de CADA ejercicio → reacción corta de Orión
- **Nunca 2 ejercicios seguidos** sin pausa narrativa
- Los NPCs solo hablan en su reino (excepto bosses)
- Las instrucciones del ejercicio las da Orión, no el texto narrativo

---

## Branching Convergente

> Consolida las 3 versiones de branching en un modelo único.

**Problema**: Los niños se frustran si mueren/pierden. Los "bucles de error" (repetir hasta acertar) son aburridos.

**Solución**: Branching convergente — las decisiones incorrectas llevan a **consecuencias narrativas temporales** pero el camino se re-une.

```
        Capítulo 5
        ┌───┴───┐
     ✅ Bien   ❌ Mal
        │        │
     Cap 6A    Cap 6B
   (avanzas)  (ruta diferente
               + refuerzo)
        └───┬───┘
         Cap 7 (se unen)
```

### Reglas del Branching

1. **Cap A** (acierta): Avanza por el camino principal. Historia favorable.
2. **Cap B** (falla): Ruta alternativa con su PROPIA historia (no es castigo). Incluye ejercicios de refuerzo del mismo tema.
3. **Ambas rutas convergen**: Nadie se queda atrás. El niño de la Ruta B llega al mismo punto, solo con una experiencia diferente.

### Ejemplo concreto

```
CAP 5: "El Puente de las Sumas"

✅ Resuelve la suma correctamente:
   → El puente se forma → cruza triunfante → Cap 6A

❌ Falla la suma:
   → "¡El puente se rompe! Caes al pantano"
   → Cap 6B: "El Pantano de las Sumas"
   → Orión: "¡Conozco otro camino!"
   → Resuelve 2 sumas más (refuerzo) para salir del pantano
   → Sale del pantano → se une al camino principal → Cap 7
```

---

## Objetivos Narrativos Inmediatos

En las primeras 3 pantallas de la app, el niño debe saber:

| Qué | Cómo |
|---|---|
| **Quién es el villano** | Noctus aparece robando las gemas |
| **Qué está en juego** | Sin las gemas, Numeralia pierde su conocimiento |
| **Qué tiene que hacer** | Recuperar las 4 gemas |
| **Quién le ayuda** | Orión (y su bastón mágico) |

---

## La Novela Completa

La historia detallada de todos los capítulos está en `novela_arcana_completa.md` (129KB).
Los capítulos escena-por-escena con ejercicios están en [05_CONTENIDO_CURRICULAR.md](05_CONTENIDO_CURRICULAR.md).

---

## Mapa de Repetición Inteligente

Cada concepto aparece en 3 contextos:

1. **Introducción**: Feedback generoso. Pistas visibles.
2. **Refuerzo**: Menos pistas. Contexto diferente.
3. **Maestría**: Bajo presión (boss). Sin pistas.

---

## Curva de Dificultad

| Trimestre | Nivel cognitivo | Hints | Timer |
|---|---|---|---|
| **T1** | Reconocer (qué es) | Abundantes | NO |
| **T2** | Aplicar (usarlo) | Moderados | NO |
| **T3** | Razonar (por qué) | Solo en Ayuda | Solo Desafío ⭐ |
