import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _anonymousUserIdKey = 'anonymous_user_id';
const _uuid = Uuid();

/// Returns a stable anonymous user id (UUID v4), persisted across launches.
/// Sole identity mechanism — no login or auth.
Future<String> getOrCreateAnonymousUserId() async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getString(_anonymousUserIdKey);
  if (existing != null && existing.isNotEmpty) {
    return existing;
  }

  final id = _uuid.v4();
  await prefs.setString(_anonymousUserIdKey, id);
  return id;
}
