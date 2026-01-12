import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

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
  late Animation<double> shimmerAnimation;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    animationController.forward();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    
    final sessionController = Get.find<AppSessionController>();
    
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MuamalahColors.primaryEmerald,
              MuamalahColors.emeraldLight,
              MuamalahColors.mint,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Islamic Pattern Background
            Positioned.fill(
              child: CustomPaint(
                painter: IslamicPatternPainter(),
              ),
            ),

            // Main Content
            Center(
              child: AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.fadeAnimation.value,
                    child: Transform.scale(
                      scale: controller.scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Container with Shimmer
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Rotating Halo
                              Transform.rotate(
                                angle: controller.shimmerAnimation.value * 2 * math.pi,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        Colors.white.withAlpha(0),
                                        Colors.white.withAlpha(100),
                                        Colors.white.withAlpha(0),
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                ),
                              ),

                              // Logo Circle
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(40),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'A',
                                    style: TextStyle(
                                      fontSize: 72,
                                      fontWeight: FontWeight.bold,
                                      color: MuamalahColors.primaryEmerald,
                                      fontFamily: 'serif',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // App Name
                          const Text(
                            'Averroes',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Tagline
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(40),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                                'Crypto Syariah • Edukasi • Zakat',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Loading Indicator
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withAlpha(150),
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =============================================================================
/// ISLAMIC PATTERN PAINTER (Subtle)
/// =============================================================================

class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 100.0;
    const starSize = 30.0;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = (y ~/ spacing).isEven ? 0 : spacing / 2; 
           x < size.width; 
           x += spacing) {
        _drawStar8(canvas, Offset(x, y), starSize, paint);
      }
    }
  }

  void _drawStar8(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const points = 8;
    final outerRadius = size / 2;
    final innerRadius = size / 4;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
