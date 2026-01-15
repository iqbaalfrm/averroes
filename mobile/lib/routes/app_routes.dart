import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/app_session_controller.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/register_view.dart';
import '../modules/auth/verify_email/verify_email_view.dart';
import '../modules/auth/auth_choice_view.dart';
import '../modules/auth/onboarding_view.dart';
import '../modules/auth/splash_view.dart';
import '../modules/main_layout/main_layout_view.dart';

abstract class Routes {
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const AUTH_CHOICE = '/auth-choice';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const VERIFY_EMAIL = '/verify-email';
  static const HOME = '/home';
  
  // Protected Routes
  static const EDUKASI = '/edukasi';
  static const PORTFOLIO = '/portfolio';
  static const ZAKAT = '/zakat';
}

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      transition: Transition.fadeIn, // Splash -> Onboarding: Fade
    ),
    GetPage(
      name: Routes.AUTH_CHOICE,
      page: () => const AuthChoiceView(),
      transition: Transition.downToUp, // Onboarding -> Auth/Home: Slide Up
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: Routes.VERIFY_EMAIL,
      page: () => const VerifyEmailView(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const MainLayoutView(), 
      middlewares: [VerificationGuard()], 
      transition: Transition.downToUp, // Guest join: Slide Up
    ),
    
    // Contoh Protected Route (bisa ditambahkan nanti saat modulnya diintegrasikan ke named routes)
    // GetPage(name: Routes.PORTFOLIO, page: () => PortfolioView(), middlewares: [AuthGuard()]),
  ];
}

/// Guard khusus untuk Home:
/// Guest -> ALLOW
/// Login Verified -> ALLOW
/// Login Unverified -> REDIRECT verify-email
class VerificationGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
     final sessionController = Get.find<AppSessionController>(); // Error here if import missing, but it is imported via auth_guard logic usually.
     // Wait, I need import.
     // Importing app_session_controller is needed.
     
     // Logic:
     if (!sessionController.isGuest.value && !sessionController.isEmailVerified) {
       return const RouteSettings(name: Routes.VERIFY_EMAIL);
     }
     return null;
  }
}
