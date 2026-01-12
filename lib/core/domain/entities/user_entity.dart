/// =============================================================================
/// USER ENTITY - Domain Layer
/// =============================================================================

class UserEntity {
  final String id;
  final String email;
  final String username;
  final String? fullName;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.createdAt,
  });

  /// Get display name (username atau full_name jika tersedia)
  String get displayName => fullName?.isNotEmpty == true ? fullName! : username;

  /// Get initial untuk avatar
  String get initial => displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, username: $username)';
  }
}
