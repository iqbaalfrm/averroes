import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../services/app_session_controller.dart';
import '../../routes/app_routes.dart';

/// =============================================================================
/// SPLASH CONTROLLER
/// =============================================================================

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    animationController = AnimationController(
             // Duration 1.2s as requested for the animation phase
      duration: const Duration(milliseconds: 1000), 
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    animationController.forward();
  }

  Future<void> _navigateAfterDelay() async {
    // Total duration around 1.2s -> 1.5s to allow reading
    await Future.delayed(const Duration(milliseconds: 1200));
    
    final sessionController = Get.find<AppSessionController>();
    
    // Transition to next screen
    // Using Fade + Scale transition logic here implies we just navigate 
    // and let the route transition handle it, or we use a custom transition.
    // The requirement says "Splash -> Onboarding: fade + scale (subtle)".
    // GetX generic transition can be set to fadeIn or zoom.
    
    if (sessionController.shouldShowOnboarding) {
      Get.offNamed(Routes.ONBOARDING);
    } else if (sessionController.hasAuthChoice) {
      if (sessionController.isAuthenticated.value && !sessionController.isEmailVerified) {
        Get.offNamed(Routes.VERIFY_EMAIL, arguments: sessionController.currentEmail);
      } else {
        Get.offNamed(Routes.HOME);
      }
    } else {
      Get.offNamed(Routes.AUTH_CHOICE);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

/// =============================================================================
/// SPLASH VIEW
/// =============================================================================

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Soft gradient
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MuamalahColors.primaryEmerald,
              Color(0xFF065F46), // A slightly deeper/richer emerald for depth
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: [
             // Soft Texture / Grain
             // Assuming asset might exist, otherwise fallback to simple grain
             Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: Image.asset(
                    'assets/ui/backgrounds/splash_bg.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                         decoration: const BoxDecoration(
                            color: Colors.black, 
                         ),
                      );
                    },
                  ),
                ),
             ),

            // Main Content
            Center(
              child: AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: ScaleTransition(
                      scale: controller.scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/branding/logoutama.png',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Brand Name
                          const Text(
                            'Averroes',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          
                          const SizedBox(height: 6),
                          
                          // Tagline
                          const Text(
                              'Keuangan & Ilmu, dengan Hikmah',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                                letterSpacing: 0.2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
