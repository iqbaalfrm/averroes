import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/app_session_controller.dart';
import 'auth_choice_view.dart';

/// =============================================================================
/// ONBOARDING CONTROLLER
/// =============================================================================

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skip() {
    pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> completeOnboarding() async {
    final sessionController = Get.find<AppSessionController>();
    await sessionController.markOnboardingComplete();
    Get.off(() => const AuthChoiceView());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

/// =============================================================================
/// ONBOARDING VIEW
/// =============================================================================

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: controller.pageController,
            onPageChanged: (index) => controller.currentPage.value = index,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildPage1(),
              _buildPage2(),
              _buildPage3(),
              _buildPage4(controller),
            ],
          ),

          // Skip Button (pages 0-2)
          Obx(() => controller.currentPage.value < 3
              ? Positioned(
                  top: 50,
                  right: 20,
                  child: GestureDetector(
                    onTap: controller.skip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Lewati',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: MuamalahColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),

          // Progress Dots (pages 0-2)
          Obx(() => controller.currentPage.value < 3
              ? Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isActive = controller.currentPage.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? MuamalahColors.primaryEmerald
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                )
              : const SizedBox.shrink()),

          // Next Button (pages 0-3)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.currentPage.value == 3
                          ? MuamalahColors.primaryEmerald
                          : MuamalahColors.primaryEmerald,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      controller.currentPage.value == 3
                          ? 'Mulai Sekarang'
                          : 'Lanjut  →',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // Page 1: Intro
  Widget _buildPage1() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MuamalahColors.mint.withAlpha(100),
            Colors.white,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  MuamalahColors.primaryEmerald,
                  MuamalahColors.emeraldLight,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: MuamalahColors.primaryEmerald.withAlpha(60),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.shield_moon_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 48),

          const Text(
            'Averroes',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: MuamalahColors.halalBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Crypto Syariah',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MuamalahColors.halal,
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Screener syariah, edukasi,\ndan tools zakat aset digital.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: MuamalahColors.textSecondary,
              height: 1.5,
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Page 2: Market
  Widget _buildPage2() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFEC4899).withAlpha(50),
            Colors.white,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFFF472B6),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEC4899).withAlpha(60),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.candlestick_chart_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 48),

          const Text(
            'Pantau Pasar Realtime',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Harga crypto realtime dan insight\nsingkat yang mudah dipahami.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: MuamalahColors.textSecondary,
              height: 1.5,
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Page 3: Portfolio & Zakat
  Widget _buildPage3() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6366F1).withAlpha(50),
            Colors.white,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withAlpha(60),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 48),

          const Text(
            'Portofolio & Zakat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: MuamalahColors.prosesBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Butuh Akun',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MuamalahColors.proses,
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Simpan asetmu dan dapatkan\nestimasi zakat otomatis (read-only).',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: MuamalahColors.textSecondary,
              height: 1.5,
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Page 4: Reels Hikmah
  Widget _buildPage4(OnboardingController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFBBF24).withAlpha(50),
            Colors.white,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF59E0B),
                  Color(0xFFFBBF24),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withAlpha(60),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 48),

          const Text(
            'Reels Hikmah',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Ayat & hadits tentang muamalah,\nsabar, qonaah, dan takdir.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: MuamalahColors.textSecondary,
              height: 1.5,
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
