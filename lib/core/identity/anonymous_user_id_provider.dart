import 'package:deskdose/core/constants/storage_keys.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

/// Provides a stable anonymous identity for no-login Supabase writes.
abstract class AnonymousUserIdProvider {
  String? get id;

  Future<String> getOrCreate();
}

class AnonymousUserIdProviderImpl implements AnonymousUserIdProvider {
  AnonymousUserIdProviderImpl(this._storage);

  final GetStorage _storage;
  static const _uuid = Uuid();

  String? _cachedId;

  @override
  String? get id => _cachedId ?? _storage.read<String>(StorageKeys.anonymousUserId);

  @override
  Future<String> getOrCreate() async {
    final existing = id;
    if (existing != null && existing.isNotEmpty) {
      _cachedId = existing;
      return existing;
    }

    final generated = _uuid.v4();
    await _storage.write(StorageKeys.anonymousUserId, generated);
    _cachedId = generated;
    return generated;
  }
}
