import 'package:deskdose/data/models/hydration_log.dart';

abstract class HydrationRepository {
  Future<List<HydrationLog>> fetchHydrationLogsForUser(
    String userId,
    DateTime date,
  );

  Future<HydrationLog> insertHydrationLog(HydrationLog log);

  Future<int> getTodayHydrationTotal(String userId);
}
