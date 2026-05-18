import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/data/models/reminder_settings.dart';
import 'package:deskdose/features/hydration/bloc/hydration_bloc.dart';
import 'package:deskdose/features/hydration/utils/hydration_preferences.dart';
import 'package:deskdose/features/paywall/view/paywall_bottom_sheet.dart';
import 'package:deskdose/features/reminders/bloc/reminders_bloc.dart';
import 'package:deskdose/features/reminders/view/widgets/hydration_goal_picker_sheet.dart';
import 'package:deskdose/features/reminders/view/widgets/interval_picker_sheet.dart';
import 'package:deskdose/features/reminders/view/widgets/settings_loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings tab: reminders, preferences, and account.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.background,
      child: ScreenSafeArea(
        bottom: false,
        child: _SettingsBody(),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemindersBloc, RemindersState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
              title: const Text('Settings'),
            ),
            SliverToBoxAdapter(
              child: switch (state) {
                RemindersInitial() || RemindersLoading() =>
                  const SettingsLoadingShimmer(),
                RemindersError(:final message) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(message, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context
                              .read<RemindersBloc>()
                              .add(const RemindersLoadRequested()),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                RemindersLoaded() => _SettingsLoadedContent(state: state),
              },
            ),
          ],
        );
      },
    );
  }
}

class _SettingsLoadedContent extends StatelessWidget {
  const _SettingsLoadedContent({required this.state});

  final RemindersLoaded state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PremiumBanner(),
          const SizedBox(height: 28),
          _SectionHeader(title: 'Reminders'),
          const SizedBox(height: 8),
          _ReminderRow(
            icon: Icons.fitness_center_outlined,
            title: 'Workout Reminders',
            type: ReminderType.workout,
            state: state,
          ),
          _ReminderRow(
            icon: Icons.water_drop_outlined,
            title: 'Water Reminders',
            type: ReminderType.water,
            state: state,
          ),
          _ReminderRow(
            icon: Icons.visibility_outlined,
            title: 'Eye Break',
            type: ReminderType.eye,
            state: state,
          ),
          const SizedBox(height: 28),
          _SectionHeader(title: 'Preferences'),
          const SizedBox(height: 8),
          const _DailyWaterGoalTile(),
          _WorkHoursTile(workStart: state.workStart, workEnd: state.workEnd),
          const SizedBox(height: 28),
          _SectionHeader(title: 'Account'),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.upload_outlined),
            title: const Text('Export Data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export coming soon')),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            trailing: Text(
              SettingsScreen._appVersion,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner();

  static const _purpleStart = Color(0xFF534AB7);
  static const _purpleEnd = Color(0xFF7B6FE8);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => PaywallBottomSheet.show(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [_purpleStart, _purpleEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upgrade to Premium',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Unlimited routines & custom reminders',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.icon,
    required this.title,
    required this.type,
    required this.state,
  });

  final IconData icon;
  final String title;
  final ReminderType type;
  final RemindersLoaded state;

  @override
  Widget build(BuildContext context) {
    final setting = state.settingFor(type);
    final interval = setting?.intervalMinutes ?? 60;
    final enabled = setting?.isEnabled ?? false;
    final subtitle =
        'Every $interval min · ${state.workStart}–${state.workEnd}';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: enabled,
        onChanged: (value) {
          context.read<RemindersBloc>().add(
                ReminderToggled(type: type.name, isEnabled: value),
              );
        },
      ),
      onTap: () => IntervalPickerSheet.show(
        context,
        reminderType: type.name,
        initialMinutes: interval,
      ),
    );
  }
}

class _DailyWaterGoalTile extends StatelessWidget {
  const _DailyWaterGoalTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HydrationBloc, HydrationState>(
      builder: (context, hydrationState) {
        final goalMl = switch (hydrationState) {
          HydrationLoaded(:final goalMl) => goalMl,
          _ => AppConstants.defaultHydrationGoalMl,
        };

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.water_drop_outlined,
            color: Color(0xFF378ADD),
          ),
          title: const Text('Daily Water Goal'),
          subtitle: Text('$goalMl ml'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final initial = hydrationState is HydrationLoaded
                ? hydrationState.goalMl
                : await HydrationPreferences.getGoalMl();
            if (!context.mounted) return;
            await HydrationGoalPickerSheet.show(
              context,
              initialGoalMl: initial,
            );
          },
        );
      },
    );
  }
}

class _WorkHoursTile extends StatelessWidget {
  const _WorkHoursTile({
    required this.workStart,
    required this.workEnd,
  });

  final String workStart;
  final String workEnd;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.schedule_outlined),
      title: const Text('Work Hours'),
      subtitle: Text('$workStart – $workEnd'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pickWorkHours(context),
    );
  }

  Future<void> _pickWorkHours(BuildContext context) async {
    final start = _parseTime(workStart);
    final end = _parseTime(workEnd);

    final pickedStart = await showTimePicker(
      context: context,
      initialTime: start,
      helpText: 'Work day starts',
    );
    if (pickedStart == null || !context.mounted) return;

    final pickedEnd = await showTimePicker(
      context: context,
      initialTime: end,
      helpText: 'Work day ends',
    );
    if (pickedEnd == null || !context.mounted) return;

    context.read<RemindersBloc>().add(
          WorkHoursChanged(
            startTime: _formatTime(pickedStart),
            endTime: _formatTime(pickedEnd),
          ),
        );
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
