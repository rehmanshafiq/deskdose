import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/error/exceptions.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/routines/data/models/routine_model.dart';
import 'package:deskdose/features/routines/data/models/workout_session_model.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getRoutines({
    RoutineCategory? category,
    int limit = 20,
    int offset = 0,
  });

  Future<RoutineModel> getRoutineById(String id);

  Future<WorkoutSessionModel> completeRoutine({
    required String routineId,
    required int durationSeconds,
    double? caloriesBurned,
  });
}

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  RoutineRemoteDataSourceImpl(this._supabase);

  final SupabaseClientWrapper _supabase;

  @override
  Future<List<RoutineModel>> getRoutines({
    RoutineCategory? category,
    int limit = 20,
    int offset = 0,
  }) {
    return _supabase.execute((client) async {
      var query = client
          .from(SupabaseTables.routines)
          .select()
          .order('title', ascending: true)
          .range(offset, offset + limit - 1);

      if (category != null) {
        query = client
            .from(SupabaseTables.routines)
            .select()
            .eq('category', category.name)
            .order('title', ascending: true)
            .range(offset, offset + limit - 1);
      }

      final response = await query;
      return (response as List<dynamic>)
          .map((json) => RoutineModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<RoutineModel> getRoutineById(String id) {
    return _supabase.execute((client) async {
      final response = await client
          .from(SupabaseTables.routines)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        throw const NotFoundException(message: 'Routine not found');
      }
      return RoutineModel.fromJson(response);
    });
  }

  @override
  Future<WorkoutSessionModel> completeRoutine({
    required String routineId,
    required int durationSeconds,
    double? caloriesBurned,
  }) {
    return _supabase.execute((client) async {
      final userId = _supabase.currentUserId;
      if (userId == null) {
        throw const AuthException(message: 'User not authenticated');
      }

      final payload = {
        'user_id': userId,
        'routine_id': routineId,
        'completed_at': DateTime.now().toUtc().toIso8601String(),
        'duration_seconds': durationSeconds,
        if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      };

      final response = await client
          .from(SupabaseTables.workoutSessions)
          .insert(payload)
          .select()
          .single();

      return WorkoutSessionModel.fromJson(response);
    });
  }
}
