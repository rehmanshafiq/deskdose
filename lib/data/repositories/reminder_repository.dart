import 'package:deskdose/data/models/reminder_settings.dart';

abstract class ReminderRepository {
  Future<List<ReminderSettings>> fetchReminderSettings(String userId);

  Future<ReminderSettings> upsertReminderSetting(ReminderSettings setting);
}
