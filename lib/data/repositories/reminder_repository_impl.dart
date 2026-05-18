import 'package:deskdose/data/datasources/supabase_datasource.dart';
import 'package:deskdose/data/models/reminder_settings.dart';
import 'package:deskdose/data/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._dataSource);

  final SupabaseDataSource _dataSource;

  @override
  Future<List<ReminderSettings>> fetchReminderSettings(String userId) {
    return _dataSource.fetchReminderSettings(userId);
  }

  @override
  Future<ReminderSettings> upsertReminderSetting(ReminderSettings setting) {
    return _dataSource.upsertReminderSetting(setting);
  }
}
