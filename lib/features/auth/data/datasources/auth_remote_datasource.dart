import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/error/exceptions.dart' as app_exceptions;
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/auth/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<void> signInWithGoogle();

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._supabase);

  final SupabaseClientWrapper _supabase;

  @override
  Future<void> signInWithGoogle() {
    return _supabase.execute((client) async {
      final launched = await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : EnvConfig.oauthRedirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw const app_exceptions.AuthException(
          message: 'Could not open Google sign-in. Check device browser settings.',
        );
      }
    });
  }

  @override
  Future<void> signOut() {
    return _supabase.execute((client) => client.auth.signOut());
  }

  @override
  Future<UserModel?> getCurrentUser() {
    return _supabase.execute((client) async {
      final user = client.auth.currentUser;
      if (user == null) return null;

      return UserModel.fromSupabaseUser(
        id: user.id,
        email: user.email,
        metadata: user.userMetadata,
      );
    });
  }
}
