import 'package:deskdose/core/constants/supabase_tables.dart';
import 'package:deskdose/core/error/exceptions.dart' as app_exceptions;
import 'package:deskdose/data/models/hydration_log.dart';
import 'package:deskdose/data/models/reminder_settings.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/data/models/workout_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDataSource {
  SupabaseDataSource(this._client);

  final SupabaseClient _client;

  Future<List<Routine>> fetchRoutines({
    String? category,
    bool? isPremiumOnly,
  }) {
    return _run(() async {
      var query = _client.from(SupabaseTables.routines).select();

      if (category != null) {
        query = query.eq('category', category);
      }
      if (isPremiumOnly != null) {
        query = query.eq('is_premium', isPremiumOnly);
      }

      final response = await query.order('title', ascending: true);
      return _mapList(response, Routine.fromJson);
    });
  }

  Future<List<WorkoutSession>> fetchWorkoutSessionsForUser(
    String userId, {
    DateTime? from,
  }) {
    return _run(() async {
      var query = _client
          .from(SupabaseTables.workoutSessions)
          .select()
          .eq(SupabaseColumns.anonymousUserId, userId);

      if (from != null) {
        query = query.gte(
          'completed_at',
          from.toUtc().toIso8601String(),
        );
      }

      final response = await query.order('completed_at', ascending: false);
      return _mapList(response, WorkoutSession.fromJson);
    });
  }

  Future<WorkoutSession> insertWorkoutSession(WorkoutSession session) {
    return _run(() async {
      final payload = Map<String, dynamic>.from(session.toJson())
        ..remove('id')
        ..remove('created_at');

      final response = await _client
          .from(SupabaseTables.workoutSessions)
          .insert(payload)
          .select()
          .single();

      return WorkoutSession.fromJson(response);
    });
  }

  Future<List<HydrationLog>> fetchHydrationLogsForUser(
    String userId,
    DateTime date,
  ) {
    return _run(() async {
      final range = _dayRange(date);
      final response = await _client
          .from(SupabaseTables.hydrationLogs)
          .select()
          .eq(SupabaseColumns.anonymousUserId, userId)
          .gte('logged_at', range.start.toUtc().toIso8601String())
          .lt('logged_at', range.end.toUtc().toIso8601String())
          .order('logged_at', ascending: false);

      return _mapList(response, HydrationLog.fromJson);
    });
  }

  Future<HydrationLog> insertHydrationLog(HydrationLog log) {
    return _run(() async {
      final payload = Map<String, dynamic>.from(log.toJson())..remove('id');

      final response = await _client
          .from(SupabaseTables.hydrationLogs)
          .insert(payload)
          .select()
          .single();

      return HydrationLog.fromJson(response);
    });
  }

  Future<int> getTodayHydrationTotal(String userId) {
    return _run(() async {
      final logs = await fetchHydrationLogsForUser(userId, DateTime.now());
      return logs.fold<int>(0, (sum, log) => sum + log.amountMl);
    });
  }

  Future<List<ReminderSettings>> fetchReminderSettings(String userId) {
    return _run(() async {
      final response = await _client
          .from(SupabaseTables.reminderSettings)
          .select()
          .eq(SupabaseColumns.anonymousUserId, userId)
          .order('type', ascending: true);

      return _mapList(response, ReminderSettings.fromJson);
    });
  }

  Future<ReminderSettings> upsertReminderSetting(ReminderSettings setting) {
    return _run(() async {
      final payload = Map<String, dynamic>.from(setting.toJson());
      if (setting.id.isEmpty) {
        payload.remove('id');
      }

      final response = await _client
          .from(SupabaseTables.reminderSettings)
          .upsert(payload, onConflict: 'anonymous_user_id,type')
          .select()
          .single();

      return ReminderSettings.fromJson(response);
    });
  }

  Future<T> _run<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw app_exceptions.NotFoundException(message: e.message);
      }
      throw app_exceptions.ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } on app_exceptions.ServerException {
      rethrow;
    } on app_exceptions.NotFoundException {
      rethrow;
    } catch (e) {
      throw app_exceptions.ServerException(message: e.toString());
    }
  }

  List<T> _mapList<T>(
    dynamic response,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return (response as List<dynamic>)
        .map((row) => fromJson(row as Map<String, dynamic>))
        .toList();
  }

  ({DateTime start, DateTime end}) _dayRange(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    return (
      start: local,
      end: local.add(const Duration(days: 1)),
    );
  }
}
