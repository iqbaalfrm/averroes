import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =============================================================================
/// APP SESSION CONTROLLER
/// =============================================================================
/// Manages authentication state: Logged-in vs Guest mode
/// =============================================================================

class AppSessionController extends GetxController {
  final GetStorage _storage = GetStorage();
  final SupabaseClient _supabase = Supabase.instance.client;

  // Observable state
  final RxBool isGuest = true.obs;
  final RxBool isAuthenticated = false.obs;
  final RxnString userId = RxnString();
  final RxnString username = RxnString();
  final RxnString email = RxnString();

  // Route persistence
  final RxnString _lastIntendedRoute = RxnString();

  // Storage keys
  static const String _guestModeKey = 'is_guest_mode';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _lastRouteKey = 'last_intended_route';

  @override
  void onInit() {
    super.onInit();
    _loadPersistedRoute();
    _initializeSession();
    _listenToAuthChanges();
  }

  /// Initialize session from storage and Supabase
  Future<void> _initializeSession() async {
    // Check Supabase session
    final session = _supabase.auth.currentSession;
    
    if (session != null) {
      _updateSessionState(session);
    } else {
      // Check if previously chose guest mode
      final wasGuest = _storage.read<bool>(_guestModeKey) ?? false;
      isGuest.value = wasGuest;
      isAuthenticated.value = false;
    }
  }

  /// Listen to auth state changes
  void _listenToAuthChanges() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      
      if (session != null) {
        _updateSessionState(session);
      } else {
        // User logged out
        isAuthenticated.value = false;
        userId.value = null;
        username.value = null;
        email.value = null;
      }
    });
  }
  
  /// Helper to update local state from session
  void _updateSessionState(Session session) {
    isAuthenticated.value = true;
    isGuest.value = false;
    userId.value = session.user.id;
    email.value = session.user.email;
    _loadUserProfile(session.user.id);
    
    // Clear guest mode flag explicitly
    _storage.write(_guestModeKey, false);
  }

  /// Load user profile (username)
  Future<void> _loadUserProfile(String uid) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('username')
          .eq('id', uid)
          .single();
      
      username.value = response['username'] as String?;
    } catch (e) {
      print('⚠️ [Session] Failed to load profile: $e');
    }
  }
  
  /// Force Refresh Session (misal setelah deep link verify)
  Future<void> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      if (response.session != null) {
        _updateSessionState(response.session!);
      }
    } catch (e) {
      print('⚠️ [Session] Refresh failed: $e');
    }
  }

  // ===========================================================================
  // AUTH ACTIONS
  // ===========================================================================

  /// Continue as guest
  Future<void> continueAsGuest() async {
    isGuest.value = true;
    isAuthenticated.value = false;
    await _storage.write(_guestModeKey, true);
    print('✅ [Session] Continued as guest');
  }

  /// Sign Out (returns to auth choice)
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    isGuest.value = false;
    isAuthenticated.value = false;
    userId.value = null;
    username.value = null;
    email.value = null;
    await _storage.remove(_guestModeKey);
    print('✅ [Session] Signed out');
  }

  /// Reset to initial state (for testing)
  Future<void> resetSession() async {
    await signOut();
    await _storage.remove(_onboardingKey);
  }

  // ===========================================================================
  // ROUTE PERSISTENCE (Last Intended)
  // ===========================================================================
  
  String? get lastIntendedRoute => _lastIntendedRoute.value;

  void setLastIntendedRoute(String route) {
    _lastIntendedRoute.value = route;
    _storage.write(_lastRouteKey, route);
  }
  
  void clearLastIntendedRoute() {
    _lastIntendedRoute.value = null;
    _storage.remove(_lastRouteKey);
  }
  
  void _loadPersistedRoute() {
    final savedRoute = _storage.read<String>(_lastRouteKey);
    if (savedRoute != null) {
      _lastIntendedRoute.value = savedRoute;
    }
  }

  // ===========================================================================
  // ONBOARDING
  // ===========================================================================

  bool get hasCompletedOnboarding {
    return _storage.read<bool>(_onboardingKey) ?? false;
  }

  Future<void> markOnboardingComplete() async {
    await _storage.write(_onboardingKey, true);
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  /// Check if user needs to see onboarding
  bool get shouldShowOnboarding {
    return !hasCompletedOnboarding;
  }

  /// Check if user has made auth choice (logged in or guest)
  bool get hasAuthChoice {
    return isAuthenticated.value || isGuest.value;
  }
  
  /// Check if email verified
  bool get isEmailVerified {
    final session = _supabase.auth.currentSession;
    return session?.user.emailConfirmedAt != null;
  }

  String? get currentEmail => email.value;

  /// Get display name
  String get displayName {
    if (isGuest.value) return 'Tamu';
    return username.value ?? email.value ?? 'User';
  }
}
