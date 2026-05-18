import 'package:deskdose/core/utils/anonymous_user_helper.dart';
import 'package:deskdose/data/models/reminder_settings.dart';
import 'package:deskdose/data/repositories/reminder_repository.dart';
import 'package:deskdose/features/reminders/services/reminder_notification_service.dart';
import 'package:deskdose/features/reminders/utils/reminders_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reminders_event.dart';
part 'reminders_state.dart';

class RemindersBloc extends Bloc<RemindersEvent, RemindersState> {
  RemindersBloc({
    required ReminderRepository reminderRepository,
    required ReminderNotificationService notificationService,
  })  : _reminderRepository = reminderRepository,
        _notificationService = notificationService,
        super(const RemindersInitial()) {
    on<RemindersLoadRequested>(_onLoadRequested);
    on<ReminderToggled>(_onReminderToggled);
    on<ReminderIntervalChanged>(_onReminderIntervalChanged);
    on<WorkHoursChanged>(_onWorkHoursChanged);
  }

  final ReminderRepository _reminderRepository;
  final ReminderNotificationService _notificationService;

  Future<void> _onLoadRequested(
    RemindersLoadRequested event,
    Emitter<RemindersState> emit,
  ) async {
    emit(const RemindersLoading());

    try {
      await _notificationService.initialize();
      final userId = await getOrCreateAnonymousUserId();
      final workHours = await RemindersPreferences.getWorkHours();
      final fetched =
          await _reminderRepository.fetchReminderSettings(userId);
      final settings = _mergeSettings(
        fetched,
        userId: userId,
        workStart: workHours.start,
        workEnd: workHours.end,
      );

      for (final setting in settings) {
        if (setting.isEnabled) {
          await _notificationService.syncReminder(setting);
        }
      }

      emit(
        RemindersLoaded(
          settings: settings,
          workStart: workHours.start,
          workEnd: workHours.end,
        ),
      );
    } catch (e) {
      emit(RemindersError(message: e.toString()));
    }
  }

  Future<void> _onReminderToggled(
    ReminderToggled event,
    Emitter<RemindersState> emit,
  ) async {
    final current = state;
    if (current is! RemindersLoaded) return;

    try {
      final userId = await getOrCreateAnonymousUserId();
      final existing = _findByType(current.settings, event.type);
      final reminderType = ReminderType.fromString(event.type);
      final updated = (existing ?? _defaultSetting(
        userId: userId,
        type: reminderType,
        workStart: current.workStart,
        workEnd: current.workEnd,
      )).copyWith(isEnabled: event.isEnabled);

      await _upsertAndSync(updated, emit, current);
    } catch (e) {
      emit(RemindersError(message: e.toString()));
    }
  }

  Future<void> _onReminderIntervalChanged(
    ReminderIntervalChanged event,
    Emitter<RemindersState> emit,
  ) async {
    final current = state;
    if (current is! RemindersLoaded) return;

    try {
      final userId = await getOrCreateAnonymousUserId();
      final existing = _findByType(current.settings, event.type);
      final reminderType = ReminderType.fromString(event.type);
      final updated = (existing ?? _defaultSetting(
        userId: userId,
        type: reminderType,
        workStart: current.workStart,
        workEnd: current.workEnd,
      )).copyWith(intervalMinutes: event.intervalMinutes);

      await _upsertAndSync(updated, emit, current);
    } catch (e) {
      emit(RemindersError(message: e.toString()));
    }
  }

  Future<void> _onWorkHoursChanged(
    WorkHoursChanged event,
    Emitter<RemindersState> emit,
  ) async {
    final current = state;
    if (current is! RemindersLoaded) return;

    try {
      await RemindersPreferences.setWorkHours(
        startTime: event.startTime,
        endTime: event.endTime,
      );

      final updatedSettings = current.settings
          .map(
            (setting) => setting.copyWith(
              startTime: event.startTime,
              endTime: event.endTime,
            ),
          )
          .toList();

      emit(
        RemindersLoaded(
          settings: updatedSettings,
          workStart: event.startTime,
          workEnd: event.endTime,
        ),
      );
    } catch (e) {
      emit(RemindersError(message: e.toString()));
    }
  }

  Future<void> _upsertAndSync(
    ReminderSettings updated,
    Emitter<RemindersState> emit,
    RemindersLoaded current,
  ) async {
    final saved = await _reminderRepository.upsertReminderSetting(updated);

    if (saved.isEnabled) {
      await _notificationService.syncReminder(saved);
    } else {
      await _notificationService.cancelType(saved.type);
    }

    final userId = await getOrCreateAnonymousUserId();
    final refetched =
        await _reminderRepository.fetchReminderSettings(userId);
    final settings = _mergeSettings(
      refetched,
      userId: userId,
      workStart: current.workStart,
      workEnd: current.workEnd,
    );

    emit(
      RemindersLoaded(
        settings: settings,
        workStart: current.workStart,
        workEnd: current.workEnd,
      ),
    );
  }

  List<ReminderSettings> _mergeSettings(
    List<ReminderSettings> fetched, {
    required String userId,
    required String workStart,
    required String workEnd,
  }) {
    final byType = {for (final s in fetched) s.type: s};
    return ReminderType.values
        .map(
          (type) =>
              byType[type] ??
              _defaultSetting(
                userId: userId,
                type: type,
                workStart: workStart,
                workEnd: workEnd,
              ),
        )
        .toList();
  }

  ReminderSettings? _findByType(List<ReminderSettings> settings, String type) {
    final reminderType = ReminderType.fromString(type);
    for (final s in settings) {
      if (s.type == reminderType) return s;
    }
    return null;
  }

  ReminderSettings _defaultSetting({
    required String userId,
    required ReminderType type,
    required String workStart,
    required String workEnd,
  }) {
    return ReminderSettings(
      id: '',
      anonymousUserId: userId,
      type: type,
      isEnabled: false,
      intervalMinutes: switch (type) {
        ReminderType.workout => 60,
        ReminderType.water => 45,
        ReminderType.eye => 30,
      },
      startTime: workStart,
      endTime: workEnd,
    );
  }
}
