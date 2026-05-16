import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/utils/exception_handler.dart';
import 'package:deskdose/features/reminders/data/datasources/reminder_remote_datasource.dart';
import 'package:deskdose/features/reminders/data/models/reminder_setting_model.dart';
import 'package:deskdose/features/reminders/domain/entities/reminder_setting_entity.dart';
import 'package:deskdose/features/reminders/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl({
    required ReminderRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final ReminderRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<ReminderSettingEntity>>> getReminderSettings() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(() async {
      final models = await _remote.getReminderSettings();
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
