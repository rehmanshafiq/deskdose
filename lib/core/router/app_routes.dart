/// Centralized route path constants for go_router.
abstract final class AppRoutes {
  static const String home = '/';
  static const String routines = '/routines';
  static const String hydration = '/hydration';
  static const String settings = '/settings';
  static const String workoutPlayer = '/workout-player';
  static const String workoutComplete = '/workout-complete';

  static String routineDetailPath(String id) => '/routines/$id';

  static String routinesWithCategory(String category) =>
      '$routines?category=$category';
}
