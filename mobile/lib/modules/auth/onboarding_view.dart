import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/app_session_controller.dart';

/// =============================================================================
/// ONBOARDING CONTROLLER
/// =============================================================================

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  void nextPage() {
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn, // Softer transition
      );
    } else {
      completeOnboarding();
    }
  }

  void skip() {
    HapticFeedback.selectionClick();
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> completeOnboarding() async {
    HapticFeedback.mediumImpact();
    final sessionController = Get.find<AppSessionController>();
    
    // DEMO MODE ACTIVATION
    sessionController.enableDemoMode();
    await sessionController.markOnboardingComplete();
    
    // Go straight to Home (bypass AuthChoice)
    Get.offAllNamed('/home'); 
  }

  Future<void> joinAsGuest() async {
    HapticFeedback.mediumImpact();
    final sessionController = Get.find<AppSessionController>();
    
    // DEMO MODE ACTIVATION (Same behavior for Demo)
    sessionController.enableDemoMode();
    await sessionController.markOnboardingComplete();
    
    Get.offAllNamed('/home'); 
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
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: controller.pageController,
            onPageChanged: (index) => controller.currentPage.value = index,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildPage(
                title: "Ngatur Aset,\nTetap Tenang",
                subtitle: "Biar paham crypto & keuangan,\ntanpa ninggalin prinsip syariah.",
                imagePath: "assets/ui/illustrations/onboarding_1.png",
                fallbackIcon: Icons.spa_rounded,
                color: MuamalahColors.primaryEmerald,
                lightColor: MuamalahColors.mint,
              ),
              _buildPage(
                title: "Belajar Fiqh,\nNggak Ribet",
                subtitle: "Dari fiqh muamalah sampai\ncrypto syariah, semua pelan-pelan.",
                imagePath: "assets/ui/illustrations/onboarding_2.png",
                fallbackIcon: Icons.menu_book_rounded,
                color: const Color(0xFFD97706), // Warm Orange
                lightColor: const Color(0xFFFEF3C7),
              ),
              _buildPage(
                title: "Biar Cuan,\nTetap Berkah",
                subtitle: "Pantau aset, hitung zakat,\ndan refleksi diri — dalam satu aplikasi.",
                imagePath: "assets/ui/illustrations/onboarding_3.png",
                fallbackIcon: Icons.volunteer_activism_rounded,
                color: const Color(0xFF4F46E5), // Indigo
                lightColor: const Color(0xFFE0E7FF),
                isLastPage: true,
                controller: controller,
              ),
            ],
          ),

          // Top Skip Button (Only visible on first 2 pages)
          Obx(() => AnimatedOpacity(
            opacity: controller.currentPage.value < 2 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: controller.currentPage.value == 2,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GestureDetector(
                      onTap: controller.skip,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: MuamalahColors.glassBorder),
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
                  ),
                ),
              ),
            ),
          )),
          
          // Bottom Navigation UI (Dots + Button)
          Obx(() {
            final isLast = controller.currentPage.value == 2;
            return Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicators
                  if (!isLast)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isActive = controller.currentPage.value == index;
                         return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 32 : 8,
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
                  
                  // Next Button for non-last pages
                  if (!isLast) ...[
                     const SizedBox(height: 32),
                     ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MuamalahColors.primaryEmerald,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56), 
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text('Lanjut', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                             SizedBox(width: 8),
                             Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                     ),
                  ]
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required String imagePath, // Added image path
    required IconData fallbackIcon, // Renamed from icon
    required Color color,
    required Color lightColor,
    bool isLastPage = false,
    OnboardingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           const Spacer(),
          // Visual
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: lightColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
             child: Stack(
               alignment: Alignment.center,
               children: [
                  Container(
                     width: 240, // Increased size for image container
                     height: 240,
                     decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                           BoxShadow(
                              color: color.withOpacity(0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                           ),
                        ],
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(32.0),
                       child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                             // Fallback to Icon if image fails
                             return Icon(fallbackIcon, size: 80, color: color);
                          },
                       ),
                     ),
                  ),
                  
                  // Decorative floating elements (keep if using image? Maybe subtle ones)
                  if (!isLastPage) ...[
                      Positioned(
                         top: 40, right: 40,
                        child: _floatyDot(10, color.withOpacity(0.3)),
                      ),
                      Positioned(
                         bottom: 60, left: 40,
                        child: _floatyDot(16, color.withOpacity(0.2)),
                      ),
                  ]
               ],
             ),
          ),
          
          const SizedBox(height: 56),
          
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: MuamalahColors.textSecondary,
              height: 1.5,
            ),
          ),
          
          const Spacer(),
          
          if (isLastPage && controller != null) ...[
             // Primary CTA
             ElevatedButton(
                onPressed: controller.completeOnboarding, // "Mulai Sekarang" triggers complete
                style: ElevatedButton.styleFrom(
                  backgroundColor: MuamalahColors.primaryEmerald,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 56), 
                ),
                child: const Text('Lanjutkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             ),
             const SizedBox(height: 16),
             
             // Secondary CTA
             TextButton(
                onPressed: controller.joinAsGuest,
                style: TextButton.styleFrom(
                   foregroundColor: MuamalahColors.textSecondary,
                   padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Masuk sebagai Tamu", style: TextStyle(fontWeight: FontWeight.w600)),
             ),
             
             const SizedBox(height: 40),
          ] else ...[
             const SizedBox(height: 100), // Space for floating button
          ],
        ],
      ),
    );
  }
  
  Widget _floatyDot(double size, Color color) {
     return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
           color: color,
           shape: BoxShape.circle,
        ),
     );
  }
}
