import 'package:go_router/go_router.dart';
import 'screens/map_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/avatar_creator_screen.dart';
import 'screens/chapter_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/teacher_dashboard_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'screens/shop_screen.dart';
import 'widgets/main_shell.dart';

/// Router principal de Arcana
final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    // ── Rutas sin shell (onboarding, avatar) ──
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/avatar',
      builder: (context, state) => AvatarCreatorScreen(
        onComplete: (_) {
          // TODO: Guardar avatar y continuar
        },
      ),
    ),

    // ── Shell con navegación inferior ──
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        // World Map (pestaña central del juego)
        GoRoute(
          path: '/world-map',
          builder: (context, state) => const MapScreen(),
        ),

        // Amigos + ranking
        GoRoute(
          path: '/friends',
          builder: (context, state) => const FriendsScreen(),
        ),

        // Escáner de material
        GoRoute(
          path: '/scan',
          builder: (context, state) => const ScanScreen(),
        ),

        // Práctica libre (banco de ejercicios)
        GoRoute(
          path: '/practice',
          builder: (context, state) => const PracticeScreen(),
        ),

        // Tienda de gemas
        GoRoute(
          path: '/shop',
          builder: (context, state) => const ShopScreen(),
        ),

        // Perfil del jugador
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),

        // Dashboard del profesor
        GoRoute(
          path: '/teacher',
          builder: (context, state) => const TeacherDashboardScreen(),
        ),

        // Dashboard del padre
        GoRoute(
          path: '/parent',
          builder: (context, state) => const ParentDashboardScreen(),
        ),
      ],
    ),

    // ── Rutas sin shell (detalle de capítulo, ajustes) ──
    GoRoute(
      path: '/chapter/:id',
      builder: (context, state) {
        final chapterId = state.pathParameters['id'] ?? '';
        return ChapterScreen(chapterId: chapterId);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
