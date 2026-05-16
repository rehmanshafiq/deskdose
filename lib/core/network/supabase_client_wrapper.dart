import 'package:deskdose/core/error/exceptions.dart' as app_exceptions;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstraction over [SupabaseClient] — the only place Supabase SDK is used in core.
abstract class SupabaseClientWrapper {
  SupabaseClient get client;

  User? get currentUser;

  bool get isAuthenticated => currentUser != null;

  String? get currentUserId => currentUser?.id;

  Future<T> execute<T>(Future<T> Function(SupabaseClient client) action);

  Stream<AuthState> get authStateChanges;
}

class SupabaseClientWrapperImpl implements SupabaseClientWrapper {
  SupabaseClientWrapperImpl(this._client);

  final SupabaseClient _client;

  @override
  SupabaseClient get client => _client;

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  @override
  String? get currentUserId => currentUser?.id;

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  @override
  Future<T> execute<T>(Future<T> Function(SupabaseClient client) action) async {
    try {
      return await action(_client);
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(message: e.message);
    } on PostgrestException catch (e) {
      throw app_exceptions.ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } on StorageException catch (e) {
      throw app_exceptions.ServerException(message: e.message);
    } catch (e) {
      throw app_exceptions.ServerException(message: e.toString());
    }
  }
}
