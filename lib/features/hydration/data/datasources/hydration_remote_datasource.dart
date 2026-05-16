import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/error/exceptions.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/hydration/data/models/hydration_log_model.dart';

abstract class HydrationRemoteDataSource {
  Future<HydrationLogModel> logWaterIntake({required int amountMl});
}

class HydrationRemoteDataSourceImpl implements HydrationRemoteDataSource {
  HydrationRemoteDataSourceImpl(this._supabase);

  final SupabaseClientWrapper _supabase;

  @override
  Future<HydrationLogModel> logWaterIntake({required int amountMl}) {
    return _supabase.execute((client) async {
      final userId = _supabase.currentUserId;
      if (userId == null) {
        throw const AuthException(message: 'Not authenticated');
      }

      final response = await client
          .from(SupabaseTables.hydrationLogs)
          .insert({
            'user_id': userId,
            'amount_ml': amountMl,
            'logged_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select()
          .single();

      return HydrationLogModel.fromJson(response);
    });
  }
}
