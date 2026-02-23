/**
 * Cloud Functions para ArcanaApp
 * ═══════════════════════════════
 * - onXpAdded: trigger Firestore → recalcula nivel, actualiza leaderboard
 * - onDailyStreak: trigger Firestore → controla racha y vidas
 * - updateLeaderboard: scheduled → reconstruye ranking diario
 * - onChapterCompleted: trigger → otorga gemas por logros
 */

const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

// ═══════════════════════════════════════════
// CONSTANTES
// ═══════════════════════════════════════════

const REGION = "europe-west1";

// Tabla de niveles: XP necesario para cada nivel
const LEVEL_THRESHOLDS = [
    0,     // Nivel 1
    100,   // Nivel 2
    250,   // Nivel 3
    500,   // Nivel 4
    850,   // Nivel 5
    1300,  // Nivel 6
    1900,  // Nivel 7
    2600,  // Nivel 8
    3500,  // Nivel 9
    4500,  // Nivel 10
    5800,  // Nivel 11
    7200,  // Nivel 12
    8800,  // Nivel 13
    10600, // Nivel 14
    12600, // Nivel 15
    15000, // Nivel 16
    17800, // Nivel 17
    21000, // Nivel 18
    24600, // Nivel 19
    28700, // Nivel 20
];

// Gemas por logro
const GEM_REWARDS = {
    chapterComplete: 5,
    perfectChapter: 15,     // 100% aciertos
    streakMilestone7: 10,   // 7 días seguidos
    streakMilestone30: 50,  // 30 días seguidos
    levelUp: 10,
};

// ═══════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════

/**
 * Calcula el nivel basado en XP total
 */
function calculateLevel(xp) {
    let level = 1;
    for (let i = 0; i < LEVEL_THRESHOLDS.length; i++) {
        if (xp >= LEVEL_THRESHOLDS[i]) {
            level = i + 1;
        } else {
            break;
        }
    }
    return level;
}

/**
 * XP necesario para el siguiente nivel
 */
function xpForNextLevel(currentLevel) {
    if (currentLevel >= LEVEL_THRESHOLDS.length) {
        return LEVEL_THRESHOLDS[LEVEL_THRESHOLDS.length - 1] + 5000;
    }
    return LEVEL_THRESHOLDS[currentLevel]; // currentLevel es 1-indexed, threshold es 0-indexed
}

/**
 * Verifica si hoy ya se registró actividad
 */
function isToday(timestamp) {
    if (!timestamp) return false;
    const date = timestamp.toDate ? timestamp.toDate() : new Date(timestamp);
    const today = new Date();
    return (
        date.getFullYear() === today.getFullYear() &&
        date.getMonth() === today.getMonth() &&
        date.getDate() === today.getDate()
    );
}

/**
 * Verifica si fue ayer
 */
function isYesterday(timestamp) {
    if (!timestamp) return false;
    const date = timestamp.toDate ? timestamp.toDate() : new Date(timestamp);
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    return (
        date.getFullYear() === yesterday.getFullYear() &&
        date.getMonth() === yesterday.getMonth() &&
        date.getDate() === yesterday.getDate()
    );
}

// ═══════════════════════════════════════════
// 1. ON XP ADDED — Recalcula nivel cuando cambia XP
// ═══════════════════════════════════════════

exports.onXpChanged = onDocumentWritten(
    {
        document: "users/{userId}",
        region: REGION,
    },
    async (event) => {
        const before = event.data?.before?.data();
        const after = event.data?.after?.data();

        if (!after) return; // Documento eliminado

        const oldXp = before?.xp ?? 0;
        const newXp = after.xp ?? 0;

        // Solo actuar si el XP ha cambiado
        if (oldXp === newXp) return;

        const oldLevel = calculateLevel(oldXp);
        const newLevel = calculateLevel(newXp);

        // Si subió de nivel → actualizar nivel + dar gemas
        if (newLevel > oldLevel) {
            const userId = event.params.userId;
            const updates = {
                level: newLevel,
                xpForNext: xpForNextLevel(newLevel),
            };

            // Gemas por subir de nivel
            updates.gems = FieldValue.increment(GEM_REWARDS.levelUp * (newLevel - oldLevel));

            await db.collection("users").doc(userId).update(updates);

            console.log(`🎉 ${userId} subió de nivel ${oldLevel} → ${newLevel}`);
        }
    }
);

// ═══════════════════════════════════════════
// 2. ON CHAPTER COMPLETED — Gemas por logros
// ═══════════════════════════════════════════

exports.onChapterCompleted = onDocumentWritten(
    {
        document: "users/{userId}/adventure/{actId}/chapters/{chapterId}",
        region: REGION,
    },
    async (event) => {
        const after = event.data?.after?.data();
        if (!after || !after.completed) return;

        const userId = event.params.userId;
        const score = after.score ?? 0;
        const total = after.totalExercises ?? 0;

        let gemsToAdd = GEM_REWARDS.chapterComplete;

        // Bonus por capítulo perfecto
        if (total > 0 && score === total) {
            gemsToAdd += GEM_REWARDS.perfectChapter;
            console.log(`💎 ${userId} — ¡Capítulo perfecto! +${GEM_REWARDS.perfectChapter} gemas`);
        }

        await db.collection("users").doc(userId).update({
            gems: FieldValue.increment(gemsToAdd),
        });

        console.log(`💎 ${userId} — +${gemsToAdd} gemas por completar capítulo`);
    }
);

// ═══════════════════════════════════════════
// 3. UPDATE STREAK — Callable desde el cliente
// ═══════════════════════════════════════════

exports.updateStreak = onCall(
    { region: REGION },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError("unauthenticated", "Debes iniciar sesión");
        }

        const userId = request.auth.uid;
        const userRef = db.collection("users").doc(userId);

        return db.runTransaction(async (transaction) => {
            const userDoc = await transaction.get(userRef);
            if (!userDoc.exists) {
                throw new HttpsError("not-found", "Usuario no encontrado");
            }

            const data = userDoc.data();
            const lastActivity = data.lastActivity;
            const currentStreak = data.streak ?? 0;
            const bestStreak = data.bestStreak ?? 0;

            // Si ya jugó hoy, no hacer nada
            if (isToday(lastActivity)) {
                return {
                    streak: currentStreak,
                    bestStreak,
                    alreadyUpdated: true,
                };
            }

            let newStreak;
            let gemsEarned = 0;

            if (isYesterday(lastActivity)) {
                // Racha continúa
                newStreak = currentStreak + 1;
            } else {
                // Racha rota — empezar de nuevo
                newStreak = 1;
            }

            // Milestones de racha
            if (newStreak === 7) {
                gemsEarned += GEM_REWARDS.streakMilestone7;
            }
            if (newStreak === 30) {
                gemsEarned += GEM_REWARDS.streakMilestone30;
            }

            const updates = {
                streak: newStreak,
                bestStreak: Math.max(newStreak, bestStreak),
                lastActivity: FieldValue.serverTimestamp(),
            };

            if (gemsEarned > 0) {
                updates.gems = FieldValue.increment(gemsEarned);
            }

            transaction.update(userRef, updates);

            return {
                streak: newStreak,
                bestStreak: Math.max(newStreak, bestStreak),
                gemsEarned,
                alreadyUpdated: false,
            };
        });
    }
);

// ═══════════════════════════════════════════
// 4. DAILY LEADERBOARD — Scheduled (cada hora)
// ═══════════════════════════════════════════

exports.updateLeaderboard = onSchedule(
    {
        schedule: "every 60 minutes",
        region: REGION,
        timeZone: "Europe/Madrid",
    },
    async () => {
        console.log("🏆 Actualizando leaderboard...");

        // Obtener top 100 usuarios por XP
        const usersSnap = await db
            .collection("users")
            .where("role", "==", "estudiante")
            .orderBy("xp", "desc")
            .limit(100)
            .get();

        const batch = db.batch();

        // Limpiar leaderboard actual
        const currentLeaderboard = await db.collection("leaderboard").get();
        currentLeaderboard.docs.forEach((doc) => {
            batch.delete(doc.ref);
        });

        // Escribir nuevo ranking
        let rank = 1;
        usersSnap.docs.forEach((doc) => {
            const data = doc.data();
            const leaderboardRef = db.collection("leaderboard").doc(`rank_${String(rank).padStart(3, "0")}`);

            batch.set(leaderboardRef, {
                uid: doc.id,
                displayName: data.displayName ?? "Aventurero",
                avatar: data.avatar?.emoji ?? "👤",
                xp: data.xp ?? 0,
                level: data.level ?? 1,
                streak: data.streak ?? 0,
                rank,
                updatedAt: FieldValue.serverTimestamp(),
            });

            rank++;
        });

        await batch.commit();
        console.log(`🏆 Leaderboard actualizado: ${rank - 1} usuarios`);
    }
);

// ═══════════════════════════════════════════
// 5. GET LEADERBOARD — Callable rápido
// ═══════════════════════════════════════════

exports.getLeaderboard = onCall(
    { region: REGION },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError("unauthenticated", "Debes iniciar sesión");
        }

        const leaderboardSnap = await db
            .collection("leaderboard")
            .orderBy("rank")
            .limit(50)
            .get();

        const entries = leaderboardSnap.docs.map((doc) => doc.data());

        // Buscar posición del usuario actual
        const userId = request.auth.uid;
        const userEntry = entries.find((e) => e.uid === userId);

        return {
            entries,
            userRank: userEntry?.rank ?? null,
        };
    }
);

// ═══════════════════════════════════════════
// 6. RESET DAILY LIVES — Scheduled (cada día a las 6:00)
// ═══════════════════════════════════════════

exports.resetDailyLives = onSchedule(
    {
        schedule: "0 6 * * *",
        region: REGION,
        timeZone: "Europe/Madrid",
    },
    async () => {
        console.log("❤️ Reseteando vidas diarias...");

        // Obtener usuarios con menos de 5 vidas
        const usersSnap = await db
            .collection("users")
            .where("lives", "<", 5)
            .get();

        if (usersSnap.empty) {
            console.log("❤️ Todos tienen vidas completas");
            return;
        }

        const batch = db.batch();
        usersSnap.docs.forEach((doc) => {
            batch.update(doc.ref, { lives: 5 });
        });

        await batch.commit();
        console.log(`❤️ Vidas reseteadas para ${usersSnap.size} usuarios`);
    }
);
