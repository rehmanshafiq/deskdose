import 'package:deskdose/features/auth/domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  factory UserModel.fromSupabaseUser({
    required String id,
    required String? email,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id,
      email: email ?? '',
      displayName: metadata?['display_name'] as String?,
      avatarUrl: metadata?['avatar_url'] as String?,
    );
  }
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
}
