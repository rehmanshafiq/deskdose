import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/routines/data/models/routine_model.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';

abstract class PostureRemoteDataSource {
  Future<List<RoutineModel>> getPostureRoutines();
}

class PostureRemoteDataSourceImpl implements PostureRemoteDataSource {
  PostureRemoteDataSourceImpl(this._supabase);

  final SupabaseClientWrapper _supabase;

  @override
  Future<List<RoutineModel>> getPostureRoutines() {
    return _supabase.execute((client) async {
      final response = await client
          .from(SupabaseTables.routines)
          .select()
          .eq('category', RoutineCategory.posture.name)
          .order('title');

      return (response as List<dynamic>)
          .map((e) => RoutineModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
