import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

import 'app_session_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class DeepLinkService extends GetxService {
  static DeepLinkService get to => Get.find();

  late final AppLinks _appLinks;
  StreamSubscription? _linkSubscription;

  Future<void> init() async {
    _appLinks = AppLinks();

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print('[DeepLink] Failed to get initial URI: $e');
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('[DeepLink] Error listener: $err');
    });
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  Future<void> _handleDeepLink(Uri uri) async {
    print('[DeepLink] Received: $uri');

    if (uri.scheme == 'averroes' && uri.host == 'verify') {
      await _processVerifyCallback(uri);
    }
  }

  Future<void> _processVerifyCallback(Uri uri) async {
    final token = uri.queryParameters['token'];

    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Verifikasi Gagal',
        'Token tidak ditemukan. Silakan login kembali.',
        backgroundColor: MuamalahColors.haramBg,
        colorText: MuamalahColors.haram,
      );
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final sessionController = Get.find<AppSessionController>();
    await sessionController.setToken(token);

    if (Get.isDialogOpen ?? false) Get.back();

    _navigateToSuccess();
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
