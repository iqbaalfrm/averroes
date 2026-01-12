import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

// ============================================================================
// MUAMALAH DIALOG - REUSABLE GLOBAL COMPONENT
// ============================================================================

class MuamalahDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color primaryColor;
  final String mainButtonText;
  final VoidCallback? onMainButtonPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;

  const MuamalahDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.primaryColor = MuamalahColors.primaryEmerald,
    this.mainButtonText = 'Tutup',
    this.onMainButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: MuamalahColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (secondaryButtonText != null) ...[
                  Expanded(
                    child: TextButton(
                      onPressed: onSecondaryButtonPressed ?? () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        foregroundColor: MuamalahColors.textMuted,
                      ),
                      child: Text(
                        secondaryButtonText!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (onMainButtonPressed != null) {
                        onMainButtonPressed!();
                      } else {
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      mainButtonText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// APP DIALOGS HELPER
// ============================================================================

class AppDialogs {
  static void showSuccess({
    required String title,
    required String message,
  }) {
    Get.dialog(
      MuamalahDialog(
        title: title,
        message: message,
        icon: Icons.check_circle_rounded,
        iconColor: MuamalahColors.primaryEmerald,
        mainButtonText: 'Alhamdulillah, Lanjut',
      ),
      barrierDismissible: false,
    );
  }

  static void showError({
    required String title,
    required String message,
  }) {
    Get.dialog(
      MuamalahDialog(
        title: title,
        message: message,
        icon: Icons.warning_rounded,
        iconColor: MuamalahColors.risikoTinggi,
        mainButtonText: 'Coba Lagi',
      ),
    );
  }

  static void showInfo({
    required String title,
    required String message,
  }) {
    Get.dialog(
      MuamalahDialog(
        title: title,
        message: message,
        icon: Icons.info_rounded,
        iconColor: MuamalahColors.ethereum,
        mainButtonText: 'Saya Paham',
      ),
    );
  }

  static void showConfirmation({
    required String title,
    required String message,
    required String mainButtonText,
    required VoidCallback onConfirm,
    String secondaryButtonText = 'Batalkan',
  }) {
    Get.dialog(
      MuamalahDialog(
        title: title,
        message: message,
        icon: Icons.help_rounded,
        iconColor: MuamalahColors.bitcoin,
        mainButtonText: mainButtonText,
        secondaryButtonText: secondaryButtonText,
        onMainButtonPressed: () {
          Get.back();
          onConfirm();
        },
      ),
    );
  }
}
