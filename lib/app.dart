import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router.dart';

/// Punto de entrada de Arcana
class ArcanaApp extends StatelessWidget {
  const ArcanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Arcana — Los Arcanos del Saber',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Sigue la preferencia del sistema
      routerConfig: appRouter,
    );
  }
}
