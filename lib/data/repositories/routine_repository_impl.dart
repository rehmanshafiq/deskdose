import 'package:deskdose/data/datasources/supabase_datasource.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/data/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  RoutineRepositoryImpl(this._dataSource);

  final SupabaseDataSource _dataSource;

  @override
  Future<List<Routine>> fetchRoutines({
    String? category,
    bool? isPremiumOnly,
  }) {
    return _dataSource.fetchRoutines(
      category: category,
      isPremiumOnly: isPremiumOnly,
    );
  }
}
