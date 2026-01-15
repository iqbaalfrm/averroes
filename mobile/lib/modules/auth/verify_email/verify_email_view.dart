import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import 'verify_email_controller.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final controller = Get.put(VerifyEmailController());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _collectOtp() {
    return _controllers.map((c) => c.text).join();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '').split('');
      for (var i = 0; i < _controllers.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      if (digits.length >= 6) {
        _focusNodes.last.unfocus();
      }
      return;
    }

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _submitOtp() async {
    final otp = _collectOtp();
    if (otp.length != 6) return;
    await controller.verifyOtp(otp);

    if (controller.errorMessage.value.isEmpty) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/branding/logoutama.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MuamalahColors.mint.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  size: 64,
                  color: MuamalahColors.primaryEmerald,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Masukkan Kode OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => Text(
                'Kode 6 digit telah kami kirim ke ${controller.email}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: MuamalahColors.textSecondary,
                  height: 1.5,
                ),
              )),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 44,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MuamalahColors.glassBorder),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                      onSubmitted: (_) => _submitOtp(),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Obx(() => controller.errorMessage.value.isEmpty
                  ? const SizedBox.shrink()
                  : Text(
                      controller.errorMessage.value,
                      style: const TextStyle(
                        color: MuamalahColors.haram,
                        fontSize: 13,
                      ),
                    )),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _submitOtp,
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
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Verifikasi OTP',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              )),
              const SizedBox(height: 16),
              Obx(() => TextButton(
                onPressed: (controller.resendCountdown.value == 0 && !controller.isLoading.value)
                    ? controller.resendOtp
                    : null,
                child: Text(
                  controller.resendCountdown.value == 0
                      ? 'Kirim Ulang OTP'
                      : 'Kirim Ulang (${controller.resendCountdown.value}s)',
                  style: TextStyle(
                    color: controller.resendCountdown.value == 0
                        ? MuamalahColors.primaryEmerald
                        : MuamalahColors.textMuted,
                    fontWeight: controller.resendCountdown.value == 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
