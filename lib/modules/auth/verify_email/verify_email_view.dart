import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import 'verify_email_controller.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Ilustrasi
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MuamalahColors.mint.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_rounded,
                  size: 64,
                  color: MuamalahColors.primaryEmerald,
                ),
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Verifikasi Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Obx(() => Text.rich(
                TextSpan(
                  text: 'Kami telah mengirim link verifikasi ke\n',
                  children: [
                    TextSpan(
                      text: controller.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    const TextSpan(
                      text: '.\nSilakan cek inbox atau folder spam Anda.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: MuamalahColors.textSecondary,
                  height: 1.5,
                ),
              )),
              
              const SizedBox(height: 48),

              // Tombol Cek Status
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value 
                      ? null 
                      : () {
                          HapticFeedback.lightImpact();
                          controller.checkVerificationStatus();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MuamalahColors.primaryEmerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text(
                          'Saya Sudah Verifikasi',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              )),

              const SizedBox(height: 24),

              // Resend Button
              Obx(() => TextButton(
                onPressed: (controller.canResend.value && !controller.isLoading.value)
                    ? () {
                        HapticFeedback.lightImpact();
                        controller.resendEmail();
                      }
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: MuamalahColors.textMuted, 
                ),
                child: Text(
                  controller.canResend.value 
                      ? 'Kirim Ulang Email'
                      : 'Kirim Ulang (${controller.secondsLeft}s)',
                  style: TextStyle(
                    color: controller.canResend.value 
                        ? MuamalahColors.primaryEmerald 
                        : MuamalahColors.textMuted,
                    fontWeight: controller.canResend.value ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              )),

              const SizedBox(height: 40),

              // Logout / Ganti Email
              GestureDetector(
                onTap: controller.logout,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: 18, color: MuamalahColors.textSecondary),
                      SizedBox(width: 8),
                      Text(
                        'Keluar / Ganti Email',
                        style: TextStyle(
                          color: MuamalahColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
