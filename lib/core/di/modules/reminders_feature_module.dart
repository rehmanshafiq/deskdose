import 'package:deskdose/data/repositories/reminder_repository.dart';
import 'package:deskdose/features/reminders/bloc/reminders_bloc.dart';
import 'package:deskdose/features/reminders/services/reminder_notification_service.dart';
import 'package:get_it/get_it.dart';

abstract final class RemindersFeatureModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<ReminderNotificationService>(
      () => ReminderNotificationService.instance,
    );

    sl.registerFactory(
      () => RemindersBloc(
        reminderRepository: sl<ReminderRepository>(),
        notificationService: sl<ReminderNotificationService>(),
      ),
    );
  }
}
