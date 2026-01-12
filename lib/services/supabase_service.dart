import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

/// =============================================================================
/// SUPABASE SERVICE
/// =============================================================================
/// Singleton service untuk Supabase client initialization dan akses

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseClient? _client;

  SupabaseService._();

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Initialize Supabase - call this in main() after EnvConfig.init()
  static Future<void> initialize() async {
    if (_client != null) return; // Already initialized

    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    _client = Supabase.instance.client;
    print('✅ [Supabase] Initialized successfully');
  }

  /// Get Supabase client
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase belum diinisialisasi. Panggil SupabaseService.initialize() terlebih dahulu.');
    }
    return _client!;
  }

  /// Check if initialized
  static bool get isInitialized => _client != null;
}
