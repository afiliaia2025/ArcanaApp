import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/title_screen.dart';
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
      home: const TitleScreen(),
    );
  }
}
