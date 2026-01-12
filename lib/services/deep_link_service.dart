import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';

import 'app_session_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class DeepLinkService extends GetxService {
  static DeepLinkService get to => Get.find();
  
  late final AppLinks _appLinks;
  StreamSubscription? _linkSubscription;

  Future<void> init() async {
    _appLinks = AppLinks();

    // 1. Handle Initial Link (App opened from terminated state)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print('⚠️ [DeepLink] Failed to get initial URI: $e');
    }

    // 2. Handle Continuous Links (App in background/foreground)
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('⚠️ [DeepLink] Error listener: $err');
    });
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  Future<void> _handleDeepLink(Uri uri) async {
    print('🔗 [DeepLink] Received: $uri');
    
    // Scheme: averroes, Host: auth, Path: /callback
    if (uri.scheme == 'averroes' && uri.host == 'auth' && uri.path.contains('callback')) {
      _processAuthCallback(uri);
    }
  }

  Future<void> _processAuthCallback(Uri uri) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final session = await Supabase.instance.client.auth.getSessionFromUrl(uri);
      
      Get.back(); // Close loading

      final sessionController = Get.find<AppSessionController>();
      await sessionController.refreshSession();

      if (sessionController.isEmailVerified) {
        _navigateToSuccess();
      } else {
        Get.offAllNamed(Routes.VERIFY_EMAIL);
        Get.snackbar(
          'Verifikasi Gagal',
          'Link mungkin sudah kadaluarsa atau tidak valid.',
          backgroundColor: MuamalahColors.haramBg,
          colorText: MuamalahColors.haram,
        );
      }
      
    } on AuthException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print('❌ [DeepLink] Auth Error: ${e.message}');
      Get.snackbar('Error', e.message, backgroundColor: MuamalahColors.haramBg);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print('❌ [DeepLink] Error: $e');
      Get.snackbar('Error', 'Gagal memproses link verifikasi.');
    }
  }

  void _navigateToSuccess() {
    final sessionController = Get.find<AppSessionController>();
    final targetRoute = sessionController.lastIntendedRoute ?? Routes.HOME;
    
    sessionController.clearLastIntendedRoute();

    Get.offAllNamed(targetRoute);
    
    Get.snackbar(
      'Alhamdulillah',
      'Email berhasil diverifikasi. Selamat datang!',
      backgroundColor: MuamalahColors.primaryEmerald,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 16, 
    );
  }
}
