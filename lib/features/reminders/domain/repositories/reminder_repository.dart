import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/features/reminders/domain/entities/reminder_setting_entity.dart';

abstract class ReminderRepository {
  Future<Either<Failure, List<ReminderSettingEntity>>> getReminderSettings();
}
