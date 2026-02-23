import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../providers/firebase_providers.dart';
import '../services/cloud_functions_service.dart';

/// Shell principal con barra de navegación inferior
/// Adaptable según rol: estudiante, profesor, padre
class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  void initState() {
    super.initState();
    // Actualizar racha diaria al abrir la app (fire-and-forget)
    CloudFunctionsService.updateStreak().catchError((_) => <String, dynamic>{});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final roleAsync = ref.watch(userRoleProvider);
    final role = roleAsync.value ?? 'estudiante';

    // Determinar ubicación actual
    final location = _currentPath(context);
    final currentIndex = _indexFromPath(location, role);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavItems(role, currentIndex, context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(
      String role, int currentIndex, BuildContext context) {
    final items = _navItemsForRole(role);

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == currentIndex;

      return _NavItem(
        icon: item['icon'] as String,
        label: item['label'] as String,
        isSelected: isSelected,
        onTap: () => _navigateTo(item['path'] as String, context),
      );
    }).toList();
  }

  List<Map<String, String>> _navItemsForRole(String role) {
    return switch (role) {
      'profesor' => [
        {'icon': '📊', 'label': 'Clase', 'path': '/teacher'},
        {'icon': '👥', 'label': 'Alumnos', 'path': '/friends'},
        {'icon': '👤', 'label': 'Perfil', 'path': '/profile'},
      ],
      'padre' => [
        {'icon': '📈', 'label': 'Progreso', 'path': '/parent'},
        {'icon': '👤', 'label': 'Perfil', 'path': '/profile'},
      ],
      _ => [
        {'icon': '🗺️', 'label': 'Mapa', 'path': '/world-map'},
        {'icon': '🎯', 'label': 'Practicar', 'path': '/practice'},
        {'icon': '📸', 'label': 'Escanear', 'path': '/scan'},
        {'icon': '👥', 'label': 'Amigos', 'path': '/friends'},
        {'icon': '👤', 'label': 'Perfil', 'path': '/profile'},
      ],
    };
  }

  String _currentPath(BuildContext context) {
    // GoRouterState no está directamente disponible, usamos el path del URI
    final uri = GoRouterState.of(context).uri.toString();
    return uri;
  }

  int _indexFromPath(String path, String role) {
    final items = _navItemsForRole(role);
    for (int i = 0; i < items.length; i++) {
      if (path.startsWith(items[i]['path']!)) return i;
    }
    return 0;
  }

  void _navigateTo(String path, BuildContext context) {
    GoRouter.of(context).go(path);
  }
}

/// Ítem individual de la barra de navegación
class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
