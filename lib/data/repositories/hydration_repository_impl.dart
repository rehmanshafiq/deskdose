import 'package:deskdose/data/datasources/supabase_datasource.dart';
import 'package:deskdose/data/models/hydration_log.dart';
import 'package:deskdose/data/repositories/hydration_repository.dart';

class HydrationRepositoryImpl implements HydrationRepository {
  HydrationRepositoryImpl(this._dataSource);

  final SupabaseDataSource _dataSource;

  @override
  Future<List<HydrationLog>> fetchHydrationLogsForUser(
    String userId,
    DateTime date,
  ) {
    return _dataSource.fetchHydrationLogsForUser(userId, date);
  }

  @override
  Future<HydrationLog> insertHydrationLog(HydrationLog log) {
    return _dataSource.insertHydrationLog(log);
  }

  @override
  Future<int> getTodayHydrationTotal(String userId) {
    return _dataSource.getTodayHydrationTotal(userId);
  }
}
