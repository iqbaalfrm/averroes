import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';
import '../modules/auth/login_view.dart';
import 'app_session_controller.dart';

/// =============================================================================
/// AUTH GUARD SERVICE
/// =============================================================================
/// Service untuk mengecek akses pengguna dan menampilkan modal jika guest
/// mencoba akses fitur premium
/// =============================================================================

class AuthGuard {
  /// Daftar fitur yang memerlukan login (tidak bisa diakses Guest)
  static const List<String> premiumFeatures = [
    'Edukasi',
    'Tanya Ahli',
    'Chatbot',
    'Portfolio',
    'Portofolio',
    'Zakat',
  ];

  /// Cek apakah user adalah guest
  static bool get isGuest {
    try {
      final sessionController = Get.find<AppSessionController>();
      return sessionController.isGuest.value;
    } catch (e) {
      // Jika controller belum ada, anggap guest
      return true;
    }
  }

  /// Cek apakah user authenticated
  static bool get isAuthenticated {
    try {
      final sessionController = Get.find<AppSessionController>();
      return sessionController.isAuthenticated.value;
    } catch (e) {
      return false;
    }
  }

  /// Cek apakah user bisa akses fitur tertentu
  static bool canAccess(String featureName) {
    if (!premiumFeatures.contains(featureName)) {
      return true; // Fitur non-premium selalu bisa diakses
    }
    return isAuthenticated; // Fitur premium hanya bisa diakses jika authenticated
  }

  /// Guard untuk navigasi dengan callback
  /// 
  /// Contoh penggunaan:
  /// ```dart
  /// AuthGuard.requireAuth(
  ///   featureName: 'Edukasi',
  ///   onAllowed: () => Get.to(() => EdukasiView()),
  /// );
  /// ```
  static void requireAuth({
    required String featureName,
    required VoidCallback onAllowed,
  }) {
    if (canAccess(featureName)) {
      onAllowed();
    } else {
      _showLoginRequiredModal(featureName);
    }
  }

  /// Tampilkan modal "Login dulu untuk lanjut"
  static void _showLoginRequiredModal(String featureName) {
    Get.bottomSheet(
      _LoginRequiredBottomSheet(featureName: featureName),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

/// =============================================================================
/// LOGIN REQUIRED BOTTOM SHEET
/// =============================================================================

class _LoginRequiredBottomSheet extends StatelessWidget {
  final String featureName;

  const _LoginRequiredBottomSheet({required this.featureName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MuamalahColors.prosesBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: MuamalahColors.proses,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              'Login dulu untuk lanjut',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Fitur $featureName butuh akun agar data kamu tersimpan aman.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: MuamalahColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close modal
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
            ),

            const SizedBox(height: 12),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  foregroundColor: MuamalahColors.textSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Nanti',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
