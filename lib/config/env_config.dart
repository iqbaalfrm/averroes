import 'package:flutter_dotenv/flutter_dotenv.dart';

/// =============================================================================
/// ENVIRONMENT CONFIG
/// =============================================================================
/// 
/// Centralized access to environment variables.
/// API keys tidak boleh hardcoded di source code.
/// =============================================================================

class EnvConfig {
  // Singleton pattern
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  /// Initialize dotenv - call this in main()
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  // ===========================================================================
  // SUPABASE CONFIG
  // ===========================================================================

  /// Supabase Project URL
  static String get supabaseUrl {
    return dotenv.env['SUPABASE_URL'] ?? '';
  }

  /// Supabase Anonymous Key
  static String get supabaseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  // ===========================================================================
  // API KEYS
  // ===========================================================================

  /// Covalent API Key untuk portfolio multi-chain
  static String get covalentApiKey {
    return dotenv.env['COVALENT_API_KEY'] ?? '';
  }

  /// CoinGecko API Key untuk market data
  static String get coinGeckoApiKey {
    return dotenv.env['COINGECKO_API_KEY'] ?? '';
  }

  /// Gold API Key untuk harga emas (fallback)
  static String get goldApiKey {
    return dotenv.env['GOLD_API_KEY'] ?? '';
  }

  // ===========================================================================
  // APP CONFIG
  // ===========================================================================

  /// App environment (development/staging/production)
  static String get appEnv {
    return dotenv.env['APP_ENV'] ?? 'development';
  }

  /// Debug mode flag
  static bool get debugMode {
    return dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  }

  /// Is production environment
  static bool get isProduction {
    return appEnv == 'production';
  }

  // ===========================================================================
  // API ENDPOINTS
  // ===========================================================================

  static const String covalentBaseUrl = 'https://api.covalenthq.com/v1';
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const String goldApiBaseUrl = 'https://www.goldapi.io/api';
  static const String exchangeRateBaseUrl = 'https://api.exchangerate-api.com/v4';

  // ===========================================================================
  // TIMEOUTS & CONFIG
  // ===========================================================================

  static const int networkTimeoutSeconds = 15;
  static const int maxRetries = 3;
  static const int portfolioCacheSeconds = 120;
  static const int goldPriceCacheHours = 6;
  static const int currencyRateCacheSeconds = 60;

  // ===========================================================================
  // EXTERNAL URLS (Privacy Policy, etc)
  // ===========================================================================

  /// Privacy Policy URL - ganti dengan URL asli untuk production
  static const String privacyPolicyUrl = 'https://averroes.app/privacy-policy';
  
  /// Terms of Service URL
  static const String termsOfServiceUrl = 'https://averroes.app/terms';
  
  /// Support Email
  static const String supportEmail = 'support@averroes.app';
}
