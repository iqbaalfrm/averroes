import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/app_session_controller.dart';
import '../../routes/app_routes.dart';

class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final sessionController = Get.find<AppSessionController>();

    // 1. Cek apakah user login
    if (!sessionController.isAuthenticated.value) {
      // Jika guest mencoba akses route secured, lempar ke login
      // Untuk route Guest-Allowed, jangan pasang Middleware ini.
      return const RouteSettings(name: Routes.LOGIN);
    }

    // 2. Cek apakah email sudah diverifikasi
    if (!sessionController.isEmailVerified) {
      // Jika login tapi belum verify, lempar ke screen verify
      return const RouteSettings(name: Routes.VERIFY_EMAIL);
    }

    // 3. Allow access
    return null;
  }
}
