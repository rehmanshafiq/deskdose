import 'package:deskdose/data/models/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> fetchRoutines({
    String? category,
    bool? isPremiumOnly,
  });
}
