import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/hydration/data/models/hydration_log_model.dart';

abstract class HydrationRemoteDataSource {
  Future<HydrationLogModel> logWaterIntake({required int amountMl});
}

class HydrationRemoteDataSourceImpl implements HydrationRemoteDataSource {
  HydrationRemoteDataSourceImpl({
    required SupabaseClientWrapper supabase,
    required AnonymousUserIdProvider anonymousUserId,
  })  : _supabase = supabase,
        _anonymousUserId = anonymousUserId;

  final SupabaseClientWrapper _supabase;
  final AnonymousUserIdProvider _anonymousUserId;

  @override
  Future<HydrationLogModel> logWaterIntake({required int amountMl}) {
    return _supabase.execute((client) async {
      final anonymousUserId = await _anonymousUserId.getOrCreate();

      final response = await client
          .from(SupabaseTables.hydrationLogs)
          .insert({
            SupabaseColumns.anonymousUserId: anonymousUserId,
            'amount_ml': amountMl,
            'logged_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select()
          .single();

      return HydrationLogModel.fromJson(response);
    });
  }
}
