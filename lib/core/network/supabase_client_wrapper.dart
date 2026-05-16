import 'package:deskdose/core/error/exceptions.dart' as app_exceptions;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstraction over [SupabaseClient] for data operations (no auth).
abstract class SupabaseClientWrapper {
  SupabaseClient get client;

  Future<T> execute<T>(Future<T> Function(SupabaseClient client) action);
}

class SupabaseClientWrapperImpl implements SupabaseClientWrapper {
  SupabaseClientWrapperImpl(this._client);

  final SupabaseClient _client;

  @override
  SupabaseClient get client => _client;

  @override
  Future<T> execute<T>(Future<T> Function(SupabaseClient client) action) async {
    try {
      return await action(_client);
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
