import '../../domain/entities/user_entity.dart';

/// =============================================================================
/// USER MODEL - Data Layer
/// =============================================================================
/// Model untuk mapping data dari/ke Supabase

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    super.createdAt,
  });

  /// Factory dari Supabase auth.users + profiles join
  factory UserModel.fromSupabase({
    required String id,
    required String email,
    required Map<String, dynamic>? profile,
  }) {
    return UserModel(
      id: id,
      email: email,
      username: profile?['username'] ?? email.split('@').first,
      fullName: profile?['full_name'],
      createdAt: profile?['created_at'] != null
          ? DateTime.tryParse(profile!['created_at'])
          : null,
    );
  }

  /// Factory dari profiles table only
  factory UserModel.fromProfileJson(Map<String, dynamic> json, String email) {
    return UserModel(
      id: json['id'] ?? '',
      email: email,
      username: json['username'] ?? '',
      fullName: json['full_name'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  /// Convert ke Map untuk insert/update profiles
  Map<String, dynamic> toProfileJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
    };
  }

  /// Convert ke user metadata untuk sign up
  Map<String, dynamic> toMetadata() {
    return {
      'username': username,
      'full_name': fullName ?? '',
    };
  }
}
