import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/app_session_controller.dart';
import 'login_view.dart';
import '../main_layout/main_layout_view.dart';

/// =============================================================================
/// AUTH CHOICE VIEW
/// =============================================================================
/// Screen untuk memilih: Login/Register atau Continue as Guest
/// =============================================================================

class AuthChoiceView extends StatelessWidget {
  const AuthChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<AppSessionController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0FDF4), // mint very light
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MuamalahColors.primaryEmerald.withAlpha(40),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: MuamalahColors.primaryEmerald,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App Name
                const Text(
                  'Averroes',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: MuamalahColors.textPrimary,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: MuamalahColors.halalBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Crypto Syariah • Edukasi • Zakat',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.halal,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Welcome Text
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MuamalahColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Pilih cara untuk melanjutkan',
                  style: TextStyle(
                    fontSize: 15,
                    color: MuamalahColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 40),

                // Login/Register Button
                SizedBox(
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
                      shadowColor: MuamalahColors.primaryEmerald.withAlpha(100),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded, size: 22),
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

                const SizedBox(height: 16),

                // Guest Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      await sessionController.continueAsGuest();
                      Get.offAll(() => const MainLayoutView());
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MuamalahColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: MuamalahColors.textMuted.withAlpha(100),
                        width: 1.5,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline_rounded, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Lanjut sebagai Tamu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Guest Mode Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MuamalahColors.neutralBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MuamalahColors.neutralLight.withAlpha(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: MuamalahColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Mode tamu: portofolio, zakat, dan kelas premium terkunci.',
                          style: TextStyle(
                            fontSize: 12,
                            color: MuamalahColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
