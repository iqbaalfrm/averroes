import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../services/app_session_controller.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': fullName ?? username,
      });

      if (response.statusCode == 201) {
        _showSuccess('Pendaftaran berhasil! Kode OTP sudah dikirim.');
        final cooldown = response.data?['resend_cooldown'];
        Get.offAllNamed(
          Routes.VERIFY_EMAIL,
          arguments: {
            'email': email,
            'cooldown': cooldown,
          },
        );
        return;
      }

      _showError(response.data?['message']?.toString() ?? 'Gagal registrasi.');
    } catch (e) {
      _showError('Terjadi kesalahan koneksi.');
      print('SignUp Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token']?.toString();
        if (token == null || token.isEmpty) {
        _showError('Token masuk tidak valid.');
          return;
        }

        final session = Get.find<AppSessionController>();
        await session.setToken(token);

        _showSuccess('Berhasil masuk!');
        Get.offAllNamed(Routes.HOME);
        return;
      }

      final message = response.data?['message']?.toString() ?? 'Email atau kata sandi salah.';
      final code = response.data?['code']?.toString();
      if (response.statusCode == 403 && code == 'EMAIL_NOT_VERIFIED') {
        _showInfo(message);
        Get.offAllNamed(
          Routes.VERIFY_EMAIL,
          arguments: {'email': email},
        );
        return;
      }

      _showError(message);
    } catch (e) {
      _showError('Gagal terhubung ke server.');
      print('SignIn Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      isLoading.value = true;
      final response = await ApiClient.post('/auth/forgot-password', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        _showSuccess('Email pemulihan kata sandi telah dikirim.');
        return true;
      }

      _showError(response.data?['message']?.toString() ?? 'Gagal mengirim email pemulihan.');
      return false;
    } catch (e) {
      _showError('Gagal mengirim email pemulihan.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await Get.find<AppSessionController>().signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void _showError(String message) {
    Get.snackbar(
      'Gagal',
      message,
      backgroundColor: MuamalahColors.haramBg,
      colorText: MuamalahColors.haram,
      icon: const Icon(Icons.error_outline_rounded, color: MuamalahColors.haram),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: MuamalahColors.halalBg,
      colorText: MuamalahColors.halal,
      icon: const Icon(Icons.check_circle_outline_rounded, color: MuamalahColors.halal),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
    );
  }

  void _showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: MuamalahColors.neutralBg,
      colorText: MuamalahColors.textPrimary,
      icon: const Icon(Icons.info_outline_rounded, color: MuamalahColors.primaryEmerald),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
    );
  }
}
