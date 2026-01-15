import 'package:get/get.dart';

import '../../../services/api_client.dart';
import '../../../services/app_session_controller.dart';

class VerifyEmailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxInt resendCountdown = 0.obs;
  final RxString errorMessage = ''.obs;
  String email = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email']?.toString() ?? '';
      final cooldown = int.tryParse(args['cooldown']?.toString() ?? '') ?? 0;
      if (cooldown > 0) {
        _startCountdown(cooldown);
      }
    } else if (args is String) {
      email = args;
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6 || email.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await ApiClient.post('/auth/verify-otp', data: {
        'email': email,
        'otp': otp,
      });

      if (response.statusCode == 200) {
        final token = response.data['token']?.toString();
        if (token != null && token.isNotEmpty) {
          await Get.find<AppSessionController>().setToken(token);
        }
        return;
      }

      errorMessage.value = response.data?['message']?.toString() ?? 'OTP tidak valid.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (email.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await ApiClient.post('/auth/resend-otp', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        final cooldown = int.tryParse(response.data?['resend_cooldown']?.toString() ?? '') ?? 90;
        _startCountdown(cooldown);
        return;
      }

      errorMessage.value = response.data?['message']?.toString() ?? 'Belum bisa kirim ulang.';
      final cooldown = int.tryParse(response.data?['resend_cooldown']?.toString() ?? '') ?? 0;
      if (cooldown > 0) {
        _startCountdown(cooldown);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _startCountdown(int seconds) {
    resendCountdown.value = seconds;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      resendCountdown.value--;
      return resendCountdown.value > 0;
    });
  }
}
