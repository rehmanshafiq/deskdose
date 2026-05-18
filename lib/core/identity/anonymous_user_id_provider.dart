import 'package:deskdose/core/utils/anonymous_user_helper.dart';

/// Provides a stable anonymous identity for no-login Supabase writes.
abstract class AnonymousUserIdProvider {
  String? get id;

  Future<String> getOrCreate();
}

class AnonymousUserIdProviderImpl implements AnonymousUserIdProvider {
  String? _cachedId;

  @override
  String? get id => _cachedId;

  @override
  Future<String> getOrCreate() async {
    if (_cachedId != null && _cachedId!.isNotEmpty) {
      return _cachedId!;
    }

    final id = await getOrCreateAnonymousUserId();
    _cachedId = id;
    return id;
  }
}
