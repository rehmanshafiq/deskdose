import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class HydrationPreferences {
  static Future<int> getGoalMl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(StorageKeys.hydrationGoalMl) ??
        AppConstants.defaultHydrationGoalMl;
  }

  static Future<void> setGoalMl(int goalMl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StorageKeys.hydrationGoalMl, goalMl);
  }
}
