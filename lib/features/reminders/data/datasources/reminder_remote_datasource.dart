import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/reminders/data/models/reminder_setting_model.dart';

abstract class ReminderRemoteDataSource {
  Future<List<ReminderSettingModel>> getReminderSettings();
}

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  ReminderRemoteDataSourceImpl({
    required SupabaseClientWrapper supabase,
    required AnonymousUserIdProvider anonymousUserId,
  })  : _supabase = supabase,
        _anonymousUserId = anonymousUserId;

  final SupabaseClientWrapper _supabase;
  final AnonymousUserIdProvider _anonymousUserId;

  @override
  Future<List<ReminderSettingModel>> getReminderSettings() {
    return _supabase.execute((client) async {
      final anonymousUserId = await _anonymousUserId.getOrCreate();

      final response = await client
          .from(SupabaseTables.reminderSettings)
          .select()
          .eq(SupabaseColumns.anonymousUserId, anonymousUserId);

      return (response as List<dynamic>)
          .map((e) => ReminderSettingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
