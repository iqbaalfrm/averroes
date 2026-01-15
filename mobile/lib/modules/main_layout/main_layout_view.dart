import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_guard.dart';
import 'main_layout_controller.dart';

import '../beranda/beranda_view.dart';
import '../edukasi/edukasi_page_view.dart';
import '../tanya_ahli/tanya_ahli_view.dart'; // Chatbot
import '../diskusi/diskusi_view.dart'; // Diskusi
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
          // Background - Warm organic blobs (Subtle)
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    MuamalahColors.accentGold.withOpacity(0.05), // Earthy
                    Colors.transparent,
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
               EdukasiHomeView(showBackButton: false),
               TanyaAhliView(), // Center Action - Chatbot
               DiskusiView(),   // Changed from Portfolio to Diskusi
               ProfilView(),
            ],
          )),
          
          // Floating Bottom Navigation Bar (Minimalist)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildCleanBottomNav(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanBottomNav(MainLayoutController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: MuamalahColors.glassBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28), // Compact padding
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Space equally
        children: [
          _buildNavItem(
            icon: Icons.home_rounded,
            label: 'Beranda', // Renamed from Home
            isSelected: controller.currentIndex.value == 0,
            onTap: () => controller.changePage(0),
          ),
          _buildNavItem(
            icon: Icons.school_rounded,
            label: 'Edukasi',
            isSelected: controller.currentIndex.value == 1,
            onTap: () => controller.changePage(1),
          ),
          // Center Action - Chatbot (Calm)
          _buildNavItem(
             icon: Icons.support_agent_rounded, // Chatbot specific
            label: 'Chatbot', // Renamed from Tanya
            isSelected: controller.currentIndex.value == 2,
            onTap: () {
              AuthGuard.requireAuth(
                featureName: 'Chatbot',
                onAllowed: () => controller.changePage(2),
              );
            },
          ),
          _buildNavItem(
            icon: Icons.people_outline_rounded, // Diskusi Icon
            label: 'Diskusi', // Changed from Portofolio
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
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        // Haptic Feedback for "Gentle Bounce" feel
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected 
          ? BoxDecoration(
              color: MuamalahColors.primaryEmerald.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            )
          : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24, // Standard size
              color: isSelected ? MuamalahColors.primaryEmerald : MuamalahColors.textMuted,
            ),
             const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11, // Small & crisp
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? MuamalahColors.primaryEmerald : MuamalahColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
