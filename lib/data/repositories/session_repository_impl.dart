import 'package:deskdose/data/datasources/supabase_datasource.dart';
import 'package:deskdose/data/models/workout_session.dart';
import 'package:deskdose/data/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._dataSource);

  final SupabaseDataSource _dataSource;

  @override
  Future<List<WorkoutSession>> fetchWorkoutSessionsForUser(
    String userId, {
    DateTime? from,
  }) {
    return _dataSource.fetchWorkoutSessionsForUser(userId, from: from);
  }

  @override
  Future<WorkoutSession> insertWorkoutSession(WorkoutSession session) {
    return _dataSource.insertWorkoutSession(session);
  }
}
