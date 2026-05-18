import 'package:deskdose/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class RemindersPreferences {
  static const defaultWorkStart = '09:00';
  static const defaultWorkEnd = '17:00';

  static Future<({String start, String end})> getWorkHours() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      start: prefs.getString(StorageKeys.workStartTime) ?? defaultWorkStart,
      end: prefs.getString(StorageKeys.workEndTime) ?? defaultWorkEnd,
    );
  }

  static Future<void> setWorkHours({
    required String startTime,
    required String endTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.workStartTime, startTime);
    await prefs.setString(StorageKeys.workEndTime, endTime);
  }
}
