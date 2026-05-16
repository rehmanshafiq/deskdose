import 'package:deskdose/core/constants/auth_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to environment variables loaded via flutter_dotenv.
abstract final class EnvConfig {
  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? const String.fromEnvironment('SUPABASE_URL');

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ??
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Optional override; defaults to [AuthConstants.oauthRedirectUrl].
  static String get oauthRedirectUrl {
    final fromEnv = dotenv.env['OAUTH_REDIRECT_URL'] ??
        const String.fromEnvironment('OAUTH_REDIRECT_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return AuthConstants.oauthRedirectUrl;
  }
}
