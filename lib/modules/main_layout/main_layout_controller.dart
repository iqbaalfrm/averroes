import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/app_session_controller.dart';
import '../../services/audio_player_manager.dart';
import '../../services/auth_guard.dart'; // Import AuthGuard help
import '../auth/login_view.dart';

class MainLayoutController extends GetxController {
  final AppSessionController sessionController = Get.find<AppSessionController>();
  final AudioPlayerManager audioPlayerManager = Get.find<AudioPlayerManager>();
  
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    // Logic Audio: Hanya mainkan audio jika di Tab Hikmah (Index 3)
    // Jika keluar dari index 3, stop audio.
    if (currentIndex.value == 3 && index != 3) {
      audioPlayerManager.stop();
    } 
    
    // Auth Guards handled by UI or here?
    // UI in previous code handled AuthGuard.requireAuth.
    // We will trust the UI to call this method ONLY when allowed, OR check here.
    // For safety, let's just update index here.
    
    currentIndex.value = index;
  }
}
