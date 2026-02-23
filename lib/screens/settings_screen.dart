import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../providers/firebase_providers.dart';

// ═══════════════════════════════════════════
// PANTALLA DE AJUSTES
// ═══════════════════════════════════════════

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEffectsEnabled = true;
  bool _musicEnabled = true;
  bool _showHints = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final profileAsync = user != null
        ? ref.watch(userProfileProvider(user.uid))
        : const AsyncValue<Map<String, dynamic>?>.data(null);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          '⚙️ Ajustes',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // ── Perfil rápido ──
          profileAsync.when(
            data: (profile) => _buildProfileHeader(profile, isDark),
            loading: () => const SizedBox.shrink(),
            error: (_, stackTrace) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          // ── Sección: Cuenta ──
          _buildSectionLabel('Cuenta', isDark),
          const SizedBox(height: 8),
          _buildSettingsCard(isDark, [
            _buildNavItem(
              icon: Icons.person_outline,
              title: 'Editar perfil',
              onTap: () => context.push('/profile'),
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildNavItem(
              icon: Icons.school_outlined,
              title: 'Cambiar curso',
              subtitle: 'Actualiza tu clase y asignaturas',
              onTap: () {
                // TODO: popup cambio de curso
              },
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildNavItem(
              icon: Icons.family_restroom_outlined,
              title: 'Vincular padre/madre',
              subtitle: 'Comparte tu progreso con tu familia',
              onTap: () {
                // TODO: vincular padre
              },
              isDark: isDark,
            ),
          ]),

          const SizedBox(height: 24),

          // ── Sección: Preferencias ──
          _buildSectionLabel('Preferencias', isDark),
          const SizedBox(height: 8),
          _buildSettingsCard(isDark, [
            _buildToggle(
              icon: Icons.notifications_outlined,
              title: 'Notificaciones',
              subtitle: 'Recordatorios de estudio y racha',
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildToggle(
              icon: Icons.volume_up_outlined,
              title: 'Efectos de sonido',
              value: _soundEffectsEnabled,
              onChanged: (v) => setState(() => _soundEffectsEnabled = v),
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildToggle(
              icon: Icons.music_note_outlined,
              title: 'Música',
              value: _musicEnabled,
              onChanged: (v) => setState(() => _musicEnabled = v),
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildToggle(
              icon: Icons.lightbulb_outline,
              title: 'Mostrar pistas',
              subtitle: 'Pistas automáticas en ejercicios',
              value: _showHints,
              onChanged: (v) => setState(() => _showHints = v),
              isDark: isDark,
            ),
          ]),

          const SizedBox(height: 24),

          // ── Sección: Apariencia ──
          _buildSectionLabel('Apariencia', isDark),
          const SizedBox(height: 8),
          _buildSettingsCard(isDark, [
            _buildNavItem(
              icon: Icons.palette_outlined,
              title: 'Tema',
              subtitle: isDark ? 'Modo oscuro' : 'Modo claro',
              onTap: () {
                // El tema sigue al sistema (ThemeMode.system)
                _showInfoDialog(
                  'Tema',
                  'El tema se adapta automáticamente al modo de tu dispositivo (claro/oscuro).',
                );
              },
              isDark: isDark,
            ),
          ]),

          const SizedBox(height: 24),

          // ── Sección: Información ──
          _buildSectionLabel('Información', isDark),
          const SizedBox(height: 8),
          _buildSettingsCard(isDark, [
            _buildNavItem(
              icon: Icons.info_outline,
              title: 'Acerca de Arcana',
              subtitle: 'Versión 1.0.0',
              onTap: () {
                _showInfoDialog(
                  '🧙 Arcana — Los Arcanos del Saber',
                  'Una aventura educativa con IA para aprender mates, lengua y ciencias.\n\n'
                  '900 ejercicios curriculares alineados con la LOMLOE.\n\n'
                  'Hecho con ❤️ para niños de 2º y 3º de Primaria.',
                );
              },
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildNavItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Política de privacidad',
              onTap: () {
                // TODO: abrir URL de privacidad
              },
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildNavItem(
              icon: Icons.description_outlined,
              title: 'Términos de uso',
              onTap: () {
                // TODO: abrir URL de términos
              },
              isDark: isDark,
            ),
          ]),

          const SizedBox(height: 24),

          // ── Cerrar sesión ──
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _confirmLogout,
              icon: const Icon(Icons.logout, color: AppColors.lives),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  color: AppColors.lives,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.lives),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // WIDGETS
  // ═══════════════════════════════════════════

  Widget _buildProfileHeader(Map<String, dynamic>? profile, bool isDark) {
    final name = profile?['displayName'] as String? ?? 'Aventurero';
    final grade = profile?['grade'] as String? ?? '';
    final xp = profile?['xp'] as int? ?? 0;
    final level = profile?['level'] as int? ?? 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                if (grade.isNotEmpty)
                  Text(
                    grade,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Nv $level',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '⭐ $xp XP',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textTertiary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 56,
      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
    );
  }

  // ═══════════════════════════════════════════
  // DIÁLOGOS
  // ═══════════════════════════════════════════

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(fontFamily: 'Nunito', height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¿Cerrar sesión?',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Tu progreso está guardado en la nube. Podrás volver cuando quieras.',
          style: TextStyle(fontFamily: 'Nunito'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/onboarding');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lives,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
