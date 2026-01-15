import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'config/env_config.dart';
import 'services/app_session_controller.dart';
import 'services/audio_player_manager.dart';
import 'services/api_client.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'services/deep_link_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Environment Config (API keys)
  await EnvConfig.init();
  
  // Initialize GetStorage for local persistence
  await GetStorage.init();

  // Initialize API client (Laravel)
  ApiClient.initialize(GetStorage());
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Initialize Global App Session Controller (Permanent)
  Get.put(AppSessionController(), permanent: true);

  // Initialize Audio Player Manager (Global Music/Reels)
  Get.put(AudioPlayerManager());
  
  // Initialize Deep Link Service
  Get.put(DeepLinkService()).init();
  
  runApp(const AverroesApp());
}

// ============================================================================
// MAIN APPLICATION
// ============================================================================

class AverroesApp extends StatelessWidget {
  const AverroesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AVERROES',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
