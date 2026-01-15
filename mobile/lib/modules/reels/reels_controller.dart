import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../services/audio_player_manager.dart';
import 'reel_item_model.dart';
import 'reels_repository.dart';

class ReelsController extends GetxController with WidgetsBindingObserver {
  final AudioPlayerManager _audioManager = Get.find<AudioPlayerManager>();
  final ReelsRepository _repository = ReelsRepository();

  // State
  final RxList<ReelItem> reels = <ReelItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentIndex = 0.obs;
  final RxString selectedCategory = 'Acak'.obs; 

  // Audio State proxies
  RxBool get isSoundEnabled => _audioManager.isSoundEnabled;
  RxBool get isPlaying => _audioManager.isPlaying;
  RxBool get isBuffering => _audioManager.isBuffering;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    print('ReelsController: Initialized.');
    fetchReels();
  }
  
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioManager.stop();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _audioManager.stop();
    }
  }

  Future<void> fetchReels() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      _audioManager.stop();
      
      print('ReelsController: Fetching reels for category "${selectedCategory.value}"...');
      
      // Call Repository (which handles fallback internally)
      final items = await _repository.getReels(category: selectedCategory.value);
      
      reels.value = items;
      print('ReelsController: Loaded ${reels.length} items.');
      
      if (reels.isEmpty) {
        // This should theoretically not happen due to repository fallback, 
        // but handle generic error state just in case.
        errorMessage.value = 'Gagal memuat konten. Silakan coba lagi.';
      } else {
        // Auto play if enabled
        if (isSoundEnabled.value) {
          _playCurrentAudio();
        }
      }
      
    } catch (e) {
      print('ReelsController: Unhandled error: $e');
      errorMessage.value = 'Terjadi kesalahan sistem.';
      // Even here, we can force fallback UI by emptying list? 
      // Or repository logic should have caught it.
      // If list is empty, repository likely failed completely.
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    // Stop audio immediately on swipe
    _audioManager.stop();
    
    // Play next audio if enabled
    if (isSoundEnabled.value) {
      _playCurrentAudio();
    }
  }

  void toggleSound() {
    HapticFeedback.lightImpact();
    _audioManager.toggleSound();
    
    if (isSoundEnabled.value) {
         _playCurrentAudio();
    } else {
         _audioManager.stop();
    }
  }
  
  void _playCurrentAudio() {
    if (reels.isEmpty || currentIndex.value >= reels.length) return;
    
    final item = reels[currentIndex.value];
    
    print('PLAYING INDEX ${currentIndex.value}: ${item.verseKey ?? item.id}');
    print('AUDIO URL: ${item.playAudioUrl}');

    if (item.playAudioUrl != null && item.playAudioUrl!.isNotEmpty) {
      _audioManager.playUrl(item.playAudioUrl!);
    } else {
      print('Audio URL is missing for ${item.verseKey}');
    }
  }

  void filterCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    fetchReels();
    currentIndex.value = 0; 
  }
}
