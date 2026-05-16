import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/reminders/domain/entities/reminder_setting_entity.dart';
import 'package:deskdose/features/reminders/domain/repositories/reminder_repository.dart';

class GetReminderSettingsUseCase
    implements UseCase<List<ReminderSettingEntity>, NoParams> {
  GetReminderSettingsUseCase(this._repository);

  final ReminderRepository _repository;

  @override
  Future<Either<Failure, List<ReminderSettingEntity>>> call(NoParams params) {
    return _repository.getReminderSettings();
  }
}
