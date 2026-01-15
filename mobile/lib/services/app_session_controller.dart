import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'api_client.dart';

class AppSessionController extends GetxController {
  final GetStorage _storage = GetStorage();

  final RxBool isGuest = true.obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool isDemoMode = false.obs;
  final RxnString userId = RxnString();
  final RxnString username = RxnString();
  final RxnString email = RxnString();
  final RxnString role = RxnString();

  final RxnString _lastIntendedRoute = RxnString();

  static const String _guestModeKey = 'is_guest_mode';
  static const String _demoModeKey = 'is_demo_mode';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _lastRouteKey = 'last_intended_route';

  @override
  void onInit() {
    super.onInit();
    _loadPersistedRoute();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    final isDemo = _storage.read<bool>(_demoModeKey) ?? false;
    if (isDemo) {
      enableDemoMode();
      return;
    }

    final token = _storage.read<String>(ApiClient.tokenKey);
    if (token != null && token.isNotEmpty) {
      await _loadRemoteSession();
      return;
    }

    final wasGuest = _storage.read<bool>(_guestModeKey) ?? false;
    isGuest.value = wasGuest;
    isAuthenticated.value = false;
  }

  Future<void> _loadRemoteSession() async {
    try {
      final response = await ApiClient.get('/auth/me');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = data['user'] as Map<String, dynamic>?;
        final profile = data['profile'] as Map<String, dynamic>?;

        isAuthenticated.value = true;
        isGuest.value = false;
        isDemoMode.value = false;
        _storage.write(_demoModeKey, false);
        userId.value = user?['id']?.toString();
        email.value = user?['email']?.toString();
        username.value = profile?['display_name']?.toString();
        role.value = profile?['role']?.toString();
        _storage.write(_guestModeKey, false);
        return;
      }
    } catch (_) {}

    await clearSession();
  }

  Future<void> setToken(String token) async {
    await _storage.write(ApiClient.tokenKey, token);
    await _loadRemoteSession();
  }

  Future<void> refreshSession() async {
    await _loadRemoteSession();
  }

  void enableDemoMode() {
    isDemoMode.value = true;
    isAuthenticated.value = true;
    isGuest.value = false;
    username.value = 'Demo User';
    email.value = 'demo@averroes.id';
    role.value = 'user';

    _storage.write(_demoModeKey, true);
    _storage.write(_guestModeKey, true);
  }

  Future<void> continueAsGuest() async {
    isGuest.value = true;
    isAuthenticated.value = false;
    await _storage.write(_guestModeKey, true);
  }

  Future<void> signOut() async {
    if (!isDemoMode.value) {
      try {
        await ApiClient.post('/auth/logout');
      } catch (_) {}
    }
    await clearSession();
  }

  Future<void> clearSession() async {
    isDemoMode.value = false;
    _storage.write(_demoModeKey, false);
    await _storage.remove(ApiClient.tokenKey);

    isGuest.value = false;
    isAuthenticated.value = false;
    userId.value = null;
    username.value = null;
    email.value = null;
    role.value = null;
    await _storage.remove(_guestModeKey);
  }

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

  bool get hasCompletedOnboarding {
    return _storage.read<bool>(_onboardingKey) ?? false;
  }

  Future<void> markOnboardingComplete() async {
    await _storage.write(_onboardingKey, true);
  }

  bool get shouldShowOnboarding {
    return !hasCompletedOnboarding;
  }

  bool get hasAuthChoice {
    return isAuthenticated.value || isGuest.value || isDemoMode.value;
  }

  bool get isEmailVerified {
    return true;
  }

  String? get currentEmail => email.value;

  String get displayName {
    if (isDemoMode.value) return 'Demo User';
    if (isGuest.value) return 'Tamu';
    return username.value ?? email.value ?? 'User';
  }
}
