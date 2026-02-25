import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/title_screen.dart';
import 'screens/arcana_onboarding_screen.dart';
import 'theme/arcana_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar orientación landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // UI inmersiva: ocultar barras de sistema
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const ArcanaApp());
}

class ArcanaApp extends StatelessWidget {
  const ArcanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ArcanaColors.background,
        fontFamily: 'PlusJakartaSans',
        colorScheme: const ColorScheme.dark(
          primary: ArcanaColors.gold,
          secondary: ArcanaColors.turquoise,
          surface: ArcanaColors.surface,
          error: ArcanaColors.ruby,
        ),
      ),
      home: const _EntryRouter(),
    );
  }
}

/// Decide si mostrar onboarding o ir directo al juego.
class _EntryRouter extends StatefulWidget {
  const _EntryRouter();

  @override
  State<_EntryRouter> createState() => _EntryRouterState();
}

class _EntryRouterState extends State<_EntryRouter> {
  bool _loading = true;
  bool _onboardingDone = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_done') ?? false;
    if (!mounted) return;
    setState(() {
      _onboardingDone = done;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF050310),
        body: Center(
          child: CircularProgressIndicator(color: ArcanaColors.gold),
        ),
      );
    }

    if (_onboardingDone) {
      return const TitleScreen();
    }

    return const ArcanaSplashScreen();
  }
}
