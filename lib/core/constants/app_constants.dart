/// Application-wide constants.
abstract final class AppConstants {
  static const String appName = 'DeskDose';
  static const String envFileName = '.env';

  /// Default pagination for list endpoints.
  static const int defaultPageSize = 20;

  /// Micro-workout duration bounds (seconds).
  static const int minRoutineDurationSec = 30;
  static const int maxRoutineDurationSec = 300;

  /// Hydration daily goal (ml).
  static const int defaultHydrationGoalMl = 2000;
}
