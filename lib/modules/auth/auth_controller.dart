import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final RxBool isLoading = false.obs;

  /// Sign Up (Register)
  Future<void> signUp({
    required String email, 
    required String password, 
    required String username, 
    String? fullName,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'full_name': fullName,
        },
        emailRedirectTo: 'io.supabase.cryptosyaria://login-callback', 
      );

      if (response.user != null) {
        // Logout dulu agar session unverified tidak nyangkut (opsional, tapi good practice)
        await _supabase.auth.signOut(); 

        _showSuccess('Registrasi berhasil! Silakan cek email Anda.');
        
        // Navigate ke Verify Email page dengan argument email
        Get.offAllNamed(Routes.VERIFY_EMAIL, arguments: email);
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Terjadi kesalahan koneksi.');
      print('SignUp Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign In (Login)
  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        if (user.emailConfirmedAt == null) {
           print('⚠️ Login berhasil tapi email belum verify');
           
           _showInfo('Email Anda belum diverifikasi.');
           // Pass email sebagai argument
           Get.offAllNamed(Routes.VERIFY_EMAIL, arguments: email);
           
        } else {
           _showSuccess('Login berhasil!');
           Get.offAllNamed(Routes.HOME);
        }
      }
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        _showError('Email atau password salah.');
      } else {
        _showError(e.message);
      }
    } catch (e) {
      _showError('Gagal terhubung ke server.');
      print('SignIn Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Resend logic dipindah ke VerifyEmailController, tapi auth wrapper bisa ada di sini jika perlu.
  
  /// Send Password Reset Email
  Future<bool> sendPasswordReset(String email) async {
    try {
      isLoading.value = true;
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.cryptosyaria://reset-callback', // Adjust scheme if needed
      );
      _showSuccess('Email reset password telah dikirim.');
      return true;
    } on AuthException catch (e) {
      _showError(e.message);
      return false;
    } catch (e) {
      _showError('Gagal mengirim email reset.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // --- Helpers ---

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
