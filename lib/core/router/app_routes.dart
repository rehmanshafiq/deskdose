/// Centralized route path constants for go_router.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String routines = '/routines';
  static const String routineDetail = '/routines/:id';
  static const String reminders = '/reminders';
  static const String hydration = '/hydration';
  static const String posture = '/posture';
  static const String subscription = '/subscription';

  static String routineDetailPath(String id) => '/routines/$id';
}
