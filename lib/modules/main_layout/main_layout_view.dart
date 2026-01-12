import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../theme/app_theme.dart';
import '../../services/auth_guard.dart';
import 'main_layout_controller.dart';

import '../beranda/beranda_view.dart';
import '../edukasi/edukasi_page_view.dart';
import '../tanya_ahli/tanya_ahli_view.dart';
import '../reels/reels_view.dart';
import '../profil/profil_view.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainLayoutController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: Stack(
        children: [
          // Background gradient decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    MuamalahColors.mint.withAlpha(128),
                    MuamalahColors.mint.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    MuamalahColors.softBlue.withAlpha(102),
                    MuamalahColors.softBlue.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          // Crypto accent gradient
          Positioned(
            top: 200,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    MuamalahColors.bitcoin.withAlpha(40),
                    MuamalahColors.bitcoin.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          
          // Main content with IndexedStack
          Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
               BerandaView(),
               EdukasiPageView(showBackButton: false),
               TanyaAhliView(), // Center Action - Chatbot
               ReelsView(), // Reels/Hikmah Feed
               ProfilView(),
            ],
          )),
          
          // Floating Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildFloatingBottomNav(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav(MainLayoutController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(235),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Colors.white.withAlpha(128),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Beranda',
                isSelected: controller.currentIndex.value == 0,
                onTap: () => controller.changePage(0),
              ),
              _buildNavItem(
                icon: Icons.school_rounded,
                label: 'Edukasi',
                isSelected: controller.currentIndex.value == 1,
                onTap: () {
                  AuthGuard.requireAuth(
                    featureName: 'Edukasi',
                    onAllowed: () => controller.changePage(1),
                  );
                },
              ),
              _buildCenterAction(
                isSelected: controller.currentIndex.value == 2,
                onTap: () {
                   AuthGuard.requireAuth(
                    featureName: 'Chatbot',
                    onAllowed: () => controller.changePage(2),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.auto_awesome_rounded, // Reels/Hikmah icon
                label: 'Hikmah',
                isSelected: controller.currentIndex.value == 3,
                onTap: () => controller.changePage(3),
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                isSelected: controller.currentIndex.value == 4,
                onTap: () => controller.changePage(4),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected
                  ? MuamalahColors.primaryEmerald
                  : MuamalahColors.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? MuamalahColors.primaryEmerald
                    : MuamalahColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAction({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MuamalahColors.primaryEmerald,
              MuamalahColors.emeraldLight,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: MuamalahColors.primaryEmerald.withAlpha(89),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_toy_rounded,
              size: 24, // Chatbot Icon
              color: Colors.white,
            ),
            SizedBox(height: 2),
            Text(
              'Chatbot',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
