import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/error/exceptions.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/reminders/data/models/reminder_setting_model.dart';

abstract class ReminderRemoteDataSource {
  Future<List<ReminderSettingModel>> getReminderSettings();
}

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  ReminderRemoteDataSourceImpl(this._supabase);

  final SupabaseClientWrapper _supabase;

  @override
  Future<List<ReminderSettingModel>> getReminderSettings() {
    return _supabase.execute((client) async {
      final userId = _supabase.currentUserId;
      if (userId == null) {
        throw const AuthException(message: 'Not authenticated');
      }

      final response = await client
          .from(SupabaseTables.reminderSettings)
          .select()
          .eq('user_id', userId);

      return (response as List<dynamic>)
          .map((e) => ReminderSettingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
