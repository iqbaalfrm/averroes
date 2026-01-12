import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../theme/app_theme.dart';
import 'auth_controller.dart';
import 'login_view.dart';

/// =============================================================================
/// VERIFICATION PENDING VIEW
/// =============================================================================
/// Screen wajib bagi user yang belum verifikasi email.
/// =============================================================================

class VerificationPendingView extends StatefulWidget {
  final String email;
  final bool fromLogin; // True jika dari login (sudah ada session tapi belum verified)

  const VerificationPendingView({
    super.key, 
    required this.email,
    this.fromLogin = false,
  });

  @override
  State<VerificationPendingView> createState() => _VerificationPendingViewState();
}

class _VerificationPendingViewState extends State<VerificationPendingView> {
  final AuthController _authController = Get.find<AuthController>();
  
  // Timer State
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      _canResend = false;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;

    await _authController.resendVerificationEmail(widget.email);
    _startTimer(); // Reset timer
  }

  Future<void> _handleLogOut() async {
    await _authController.signOut();
    Get.offAll(() => const LoginView());
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
              // Icon Ilustrasi
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: MuamalahColors.mint.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_rounded,
                  size: 60,
                  color: MuamalahColors.primaryEmerald,
                ),
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Verifikasi Email Anda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text.rich(
                TextSpan(
                  text: 'Kami telah mengirimkan link verifikasi ke\n',
                  children: [
                    TextSpan(
                      text: widget.email,
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
              ),
              
              const SizedBox(height: 48),

              // Tombol Cek Status (Optional, sekedar refresh session user)
              OutlinedButton(
                onPressed: () async {
                   // Coba reload user
                   await _authController.checkEmailVerified();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  side: const BorderSide(color: MuamalahColors.primaryEmerald),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Saya Sudah Verifikasi',
                  style: TextStyle(
                    color: MuamalahColors.primaryEmerald,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Resend Button
              TextButton(
                onPressed: _canResend ? _handleResend : null,
                child: Text(
                  _canResend 
                      ? 'Kirim Ulang Email'
                      : 'Kirim Ulang ($_start detik)',
                  style: TextStyle(
                    color: _canResend 
                        ? MuamalahColors.textPrimary 
                        : MuamalahColors.textMuted,
                    fontWeight: _canResend ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Ganti Email / Logout
              GestureDetector(
                onTap: _handleLogOut,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 16, color: MuamalahColors.textMuted),
                    SizedBox(width: 8),
                    Text(
                      'Kembali ke Login / Ganti Email',
                      style: TextStyle(
                        color: MuamalahColors.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
