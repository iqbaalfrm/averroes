import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

/// =============================================================================
/// AUTH REMOTE DATA SOURCE
/// =============================================================================
/// Handles all authentication operations with Supabase

class AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSource(this._client);

  /// Get current supabase client
  SupabaseClient get client => _client;

  /// Get current user session
  Session? get currentSession => _client.auth.currentSession;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => currentSession != null;

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ===========================================================================
  // AUTHENTICATION METHODS
  // ===========================================================================

  /// Sign up with email, password, and username
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      // Check if username already exists
      final existingUsername = await _client
          .from('profiles')
          .select('username')
          .eq('username', username.toLowerCase())
          .maybeSingle();

      if (existingUsername != null) {
        throw Exception('Username "$username" sudah digunakan');
      }

      // Sign up
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username.toLowerCase(),
          'full_name': fullName ?? '',
        },
      );

      if (response.user == null) {
        throw Exception('Registrasi gagal');
      }

      // Fetch profile (should be created by trigger)
      final profile = await _client
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      return UserModel.fromSupabase(
        id: response.user!.id,
        email: email,
        profile: profile,
      );
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e.message));
    }
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login gagal');
      }

      // Fetch profile
      final profile = await _client
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      return UserModel.fromSupabase(
        id: response.user!.id,
        email: email,
        profile: profile,
      );
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e.message));
    }
  }

  /// Sign in with username (resolve to email first)
  Future<UserModel> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      // Call RPC to get email by username
      final email = await _client.rpc(
        'get_email_by_username',
        params: {'p_username': username.toLowerCase()},
      );

      if (email == null || email.toString().isEmpty) {
        throw Exception('Username "$username" tidak ditemukan');
      }

      // Sign in with resolved email
      return signInWithEmail(email: email.toString(), password: password);
    } on PostgrestException catch (e) {
      throw Exception('Gagal mencari username: ${e.message}');
    }
  }

  /// Sign in - auto detect email or username
  Future<UserModel> signIn({
    required String identifier,
    required String password,
  }) async {
    // Check if identifier contains @ (email format)
    if (identifier.contains('@')) {
      return signInWithEmail(email: identifier, password: password);
    }
    return signInWithUsername(username: identifier, password: password);
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e.message));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get current user profile
  Future<UserModel?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return UserModel.fromSupabase(
      id: user.id,
      email: user.email ?? '',
      profile: profile,
    );
  }

  /// Update profile
  Future<void> updateProfile({
    required String userId,
    String? fullName,
  }) async {
    await _client.from('profiles').update({
      'full_name': fullName,
    }).eq('id', userId);
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _mapAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Email/Username atau password salah';
    }
    if (message.contains('Email not confirmed')) {
      return 'Email belum dikonfirmasi. Silakan cek inbox Anda';
    }
    if (message.contains('User already registered')) {
      return 'Email sudah terdaftar';
    }
    if (message.contains('Password should be')) {
      return 'Password minimal 6 karakter';
    }
    return message;
  }
}
