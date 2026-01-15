import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerManager extends GetxService {
  static AudioPlayerManager get to => Get.find();
  
  final AudioPlayer _player = AudioPlayer();
  final RxBool isSoundEnabled = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  
  static const String _soundPrefKey = 'reels_sound_enabled';

  @override
  void onInit() {
    super.onInit();
    _loadSoundPreference();
    
    // Listeners
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      isBuffering.value = state.processingState == ProcessingState.buffering || 
                          state.processingState == ProcessingState.loading;
      
      if (state.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });
  }

  Future<void> _loadSoundPreference() async {
    final prefs = await SharedPreferences.getInstance();
    isSoundEnabled.value = prefs.getBool(_soundPrefKey) ?? false;
  }

  Future<void> toggleSound() async {
    isSoundEnabled.value = !isSoundEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundPrefKey, isSoundEnabled.value);
    
    if (!isSoundEnabled.value) {
      stop();
    } else {
       // Logic play akan dipanggil oleh UI/Controller saat toggle on
    }
  }

  Future<void> playUrl(String url) async {
    if (!isSoundEnabled.value) return; // Hard rule: Mute default
    
    try {
      if (_player.playing) await _player.stop();
      
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print('Audio Error: $e');
      // Jangan ganggu user dengan error popup agresif, cukup log.
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> pause() async {
    await _player.pause();
  }
  
  Future<void> resume() async {
     if (isSoundEnabled.value) {
       await _player.play();
     }
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
