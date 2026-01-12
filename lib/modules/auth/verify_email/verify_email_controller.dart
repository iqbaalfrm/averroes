import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class VerifyEmailController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Timer State
  final RxInt secondsLeft = 60.obs;
  final RxBool canResend = false.obs;
  final RxBool isLoading = false.obs;
  Timer? _timer;

  // Args
  String email = '';

  @override
  void onInit() {
    super.onInit();
    // Ambil email dari arguments atau current session
    email = Get.arguments as String? ?? _supabase.auth.currentUser?.email ?? '';
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    secondsLeft.value = 60;
    canResend.value = false;
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  Future<void> resendEmail() async {
    if (!canResend.value) return;

    try {
      isLoading.value = true;
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: 'io.supabase.cryptosyaria://login-callback',
      );
      
      Get.snackbar(
        'Email Terkirim',
        'Cek inbox atau folder spam Anda sekarang.',
        backgroundColor: MuamalahColors.halalBg,
        colorText: MuamalahColors.halal,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
      
      // Restart cooldown
      startTimer();
    } on AuthException catch (e) {
      Get.snackbar('Gagal', e.message, backgroundColor: MuamalahColors.haramBg);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim email verifikasi.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkVerificationStatus() async {
    try {
      isLoading.value = true;
      // Refresh session user data
      final response = await _supabase.auth.refreshSession();
      final user = response.user;

      if (user != null && user.emailConfirmedAt != null) {
        // Verified!
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'Alhamdulillah',
          'Email berhasil diverifikasi.',
          backgroundColor: MuamalahColors.primaryEmerald,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Belum Terverifikasi',
          'Silakan klik link di email Anda, lalu tekan tombol ini lagi.',
          backgroundColor: MuamalahColors.neutralBg,
          colorText: MuamalahColors.textPrimary,
        );
      }
    } catch (e) {
      Get.snackbar('Gagal Check', 'Sesi mungkin berakhir, silakan login ulang.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
