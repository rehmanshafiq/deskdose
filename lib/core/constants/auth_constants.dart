/// OAuth / deep-link configuration for Supabase Auth.
abstract final class AuthConstants {
  /// Must match Android intent-filter, iOS URL scheme, and Supabase redirect URLs.
  static const String oauthRedirectScheme = 'deskdose';
  static const String oauthRedirectHost = 'login-callback';
  static const String oauthRedirectUrl = '$oauthRedirectScheme://$oauthRedirectHost';
}
