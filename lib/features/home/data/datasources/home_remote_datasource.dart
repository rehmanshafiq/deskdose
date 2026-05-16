import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/home/data/models/daily_stats_model.dart';

abstract class HomeRemoteDataSource {
  Future<DailyStatsModel> getDailyStats({DateTime? date});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({
    required SupabaseClientWrapper supabase,
    required AnonymousUserIdProvider anonymousUserId,
  })  : _supabase = supabase,
        _anonymousUserId = anonymousUserId;

  final SupabaseClientWrapper _supabase;
  final AnonymousUserIdProvider _anonymousUserId;

  @override
  Future<DailyStatsModel> getDailyStats({DateTime? date}) {
    return _supabase.execute((client) async {
      final anonymousUserId = await _anonymousUserId.getOrCreate();

      final targetDate = date ?? DateTime.now();
      final startOfDay = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final workouts = await client
          .from(SupabaseTables.workoutSessions)
          .select('duration_seconds')
          .eq(SupabaseColumns.anonymousUserId, anonymousUserId)
          .gte('completed_at', startOfDay.toUtc().toIso8601String())
          .lt('completed_at', endOfDay.toUtc().toIso8601String());

      final hydration = await client
          .from(SupabaseTables.hydrationLogs)
          .select('amount_ml')
          .eq(SupabaseColumns.anonymousUserId, anonymousUserId)
          .gte('logged_at', startOfDay.toUtc().toIso8601String())
          .lt('logged_at', endOfDay.toUtc().toIso8601String());

      final workoutList = workouts as List<dynamic>;
      final hydrationList = hydration as List<dynamic>;

      final totalSeconds = workoutList.fold<int>(
        0,
        (sum, row) => sum + ((row as Map)['duration_seconds'] as int? ?? 0),
      );
      final totalMl = hydrationList.fold<int>(
        0,
        (sum, row) => sum + ((row as Map)['amount_ml'] as int? ?? 0),
      );

      return DailyStatsModel(
        workoutsCompleted: workoutList.length,
        totalWorkoutMinutes: totalSeconds ~/ 60,
        hydrationMl: totalMl,
        hydrationGoalMl: 2000,
        postureSessionsCompleted: 0,
        streakDays: 0,
      );
    });
  }
}
