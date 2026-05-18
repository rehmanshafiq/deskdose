import 'package:deskdose/data/models/workout_session.dart';

abstract class SessionRepository {
  Future<List<WorkoutSession>> fetchWorkoutSessionsForUser(
    String userId, {
    DateTime? from,
  });

  Future<WorkoutSession> insertWorkoutSession(WorkoutSession session);
}
