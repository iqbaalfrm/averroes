import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/app_session_controller.dart';
import '../../services/auth_guard.dart';
import '../auth/login_view.dart';
import '../auth/auth_choice_view.dart';
import '../pustaka/pustaka_view.dart';
import '../zakat/zakat_view.dart';
import '../fatwa/fatwa_view.dart';
import '../settings/settings_views.dart';

/// =============================================================================
/// PROFIL VIEW
/// =============================================================================

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<AppSessionController>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      child: Obx(() => Column(
        children: [
          const SizedBox(height: 40),

          // Header
          const Text(
            'Profil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),

          const SizedBox(height: 32),

          // Avatar & Name
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: sessionController.isDemoMode.value
                    ? [const Color(0xFF4F46E5), const Color(0xFF818CF8)] // Indigo
                    : (sessionController.isAuthenticated.value
                        ? [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight]
                        : [MuamalahColors.textMuted, MuamalahColors.textSecondary]),
              ),
              boxShadow: [
                BoxShadow(
                  color: (sessionController.isAuthenticated.value
                          ? MuamalahColors.primaryEmerald
                          : MuamalahColors.textMuted)
                      .withAlpha(60),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                sessionController.isAuthenticated.value
                    ? (sessionController.username.value?.substring(0, 1).toUpperCase() ?? 'U')
                    : 'T',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Display Name
          Text(
            sessionController.displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: sessionController.isDemoMode.value 
                  ? const Color(0xFFE0E7FF) // Indigo Light
                  : (sessionController.isAuthenticated.value
                      ? MuamalahColors.halalBg
                      : MuamalahColors.prosesBg),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  sessionController.isDemoMode.value
                      ? Icons.developer_mode_rounded
                      : (sessionController.isAuthenticated.value
                          ? Icons.verified_rounded
                          : Icons.person_outline_rounded),
                  size: 16,
                  color: sessionController.isDemoMode.value
                      ? const Color(0xFF4F46E5) // Indigo
                      : (sessionController.isAuthenticated.value
                          ? MuamalahColors.halal
                          : MuamalahColors.proses),
                ),
                const SizedBox(width: 6),
                Text(
                  sessionController.isDemoMode.value 
                      ? 'Mode Demo' 
                      : (sessionController.isAuthenticated.value ? 'Akun Terverifikasi' : 'Mode Tamu'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: sessionController.isDemoMode.value
                      ? const Color(0xFF4F46E5) // Indigo
                      : (sessionController.isAuthenticated.value
                          ? MuamalahColors.halal
                          : MuamalahColors.proses),
                  ),
                ),
              ],
            ),
          ),

          if (sessionController.isAuthenticated.value && sessionController.email.value != null) ...[
            const SizedBox(height: 8),
            Text(
              sessionController.email.value!,
              style: const TextStyle(
                fontSize: 14,
                color: MuamalahColors.textSecondary,
              ),
            ),
          ],

          const SizedBox(height: 40),

          // Quick Shortcuts
          _buildShortcutSection(),

          const SizedBox(height: 24),

          // Menu Items
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profil',
                  iconColor: MuamalahColors.primaryEmerald,
                  onTap: () {
                    Get.snackbar(
                      'Segera Hadir',
                      'Fitur edit profil akan segera tersedia',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: MuamalahColors.primaryEmerald,
                      colorText: Colors.white,
                    );
                  },
                  enabled: sessionController.isAuthenticated.value,
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi',
                  iconColor: const Color(0xFFF59E0B),
                  onTap: () {
                    Get.snackbar(
                      'Segera Hadir',
                      'Pengaturan notifikasi akan segera tersedia',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: MuamalahColors.primaryEmerald,
                      colorText: Colors.white,
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.language_rounded,
                  title: 'Bahasa',
                  iconColor: const Color(0xFF6366F1),
                  trailingText: 'Indonesia',
                  onTap: () {
                    Get.snackbar(
                      'Segera Hadir',
                      'Pengaturan bahasa akan segera tersedia',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: MuamalahColors.primaryEmerald,
                      colorText: Colors.white,
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Bantuan & FAQ',
                  iconColor: const Color(0xFF14B8A6),
                  onTap: () {
                    Get.snackbar(
                      'Segera Hadir',
                      'Halaman bantuan akan segera tersedia',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: MuamalahColors.primaryEmerald,
                      colorText: Colors.white,
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Averroes',
                  iconColor: MuamalahColors.textMuted,
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Login/Logout Button
          if (!sessionController.isAuthenticated.value)
            _buildLoginButton()
          else
            _buildLogoutButton(sessionController),

          const SizedBox(height: 16),

          // Version
          Text(
            'Versi 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: MuamalahColors.textMuted,
            ),
          ),

          const SizedBox(height: 40),
        ],
      )),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    String? trailingText,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: enabled
                        ? MuamalahColors.textPrimary
                        : MuamalahColors.textMuted,
                  ),
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: MuamalahColors.textSecondary,
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: enabled
                    ? MuamalahColors.textMuted
                    : MuamalahColors.textMuted.withAlpha(100),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Akses Cepat',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ShortcutChip(
                label: 'Pustaka',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFF7C3AED),
                onTap: () => Get.to(() => const PustakaView()),
              ),
              _ShortcutChip(
                label: 'Zakat',
                icon: Icons.volunteer_activism_rounded,
                color: MuamalahColors.proses,
                onTap: () {
                  AuthGuard.requireAuth(
                    featureName: 'Zakat',
                    onAllowed: () => Get.to(() => const ZakatView()),
                  );
                },
              ),
              _ShortcutChip(
                label: 'Fatwa',
                icon: Icons.gavel_rounded,
                color: const Color(0xFF1F2937),
                onTap: () => Get.to(() => const FatwaView()),
              ),
              _ShortcutChip(
                label: 'Settings',
                icon: Icons.settings_rounded,
                color: MuamalahColors.textMuted,
                onTap: () => Get.to(() => const SettingsHomeView()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: MuamalahColors.textMuted.withAlpha(20),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => const LoginView());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MuamalahColors.primaryEmerald,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded, size: 20),
            SizedBox(width: 10),
            Text(
              'Login / Daftar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AppSessionController sessionController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _showLogoutDialog(sessionController);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: MuamalahColors.haram,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: MuamalahColors.haram.withAlpha(100),
            width: 1.5,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20),
            SizedBox(width: 10),
            Text(
              'Keluar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AppSessionController sessionController) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MuamalahColors.haramBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 40,
                  color: MuamalahColors.haram,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Keluar dari Akun?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Anda akan kembali ke halaman pilihan login.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: MuamalahColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MuamalahColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: MuamalahColors.textMuted.withAlpha(100),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back(); // Close dialog
                        await sessionController.signOut();
                        Get.offAll(() => const AuthChoiceView());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MuamalahColors.haram,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      MuamalahColors.primaryEmerald,
                      MuamalahColors.emeraldLight,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Averroes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: MuamalahColors.halalBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.halal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Crypto Syariah • Edukasi • Zakat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: MuamalahColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Platform edukasi dan tools untuk memahami aset digital dari perspektif syariah.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: MuamalahColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MuamalahColors.primaryEmerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ShortcutChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
