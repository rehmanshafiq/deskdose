/// Supabase table and column name constants.
abstract final class SupabaseTables {
  static const String users = 'users';
  static const String routines = 'routines';
  static const String workoutSessions = 'workout_sessions';
  static const String hydrationLogs = 'hydration_logs';
  static const String reminderSettings = 'reminder_settings';
}

abstract final class SupabaseColumns {
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String userId = 'user_id';
}
