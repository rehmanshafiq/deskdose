import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/data/models/exercise.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/features/workout_player/bloc/workout_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WorkoutPlayerScreen extends StatelessWidget {
  const WorkoutPlayerScreen({super.key, required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: ScreenSafeArea(
        child: BlocConsumer<WorkoutPlayerBloc, WorkoutPlayerState>(
          listenWhen: (previous, current) => current is WorkoutPlayerComplete,
          listener: (context, state) {
            if (state is WorkoutPlayerComplete) {
              context.pushReplacement(
                AppRoutes.workoutComplete,
                extra: state,
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              WorkoutPlayerInitial() || WorkoutPlayerRunning() ||
              WorkoutPlayerPaused() =>
                _WorkoutPlayerBody(routine: routine, state: state),
              WorkoutPlayerError(:final message) => _WorkoutPlayerError(
                  message: message,
                  onClose: () => context.pop(),
                ),
              WorkoutPlayerComplete() => const Center(
                  child: CircularProgressIndicator(),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _WorkoutPlayerBody extends StatelessWidget {
  const _WorkoutPlayerBody({required this.routine, required this.state});

  final Routine routine;
  final WorkoutPlayerState state;

  @override
  Widget build(BuildContext context) {
    final session = _sessionData(state);
    if (session == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final bloc = context.read<WorkoutPlayerBloc>();
    final isPaused = state is WorkoutPlayerPaused;
    final progress = session.exercise.durationSeconds > 0
        ? session.remainingSeconds / session.exercise.durationSeconds
        : 0.0;

    return Column(
      children: [
        _WorkoutTopBar(
          title:
              '${routine.title} · ${session.exerciseIndex + 1}/${session.totalExercises}',
          onBack: () => _confirmExit(context),
          onClose: () => _confirmExit(context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _PulsingExerciseCircle(
                  remainingSeconds: session.remainingSeconds,
                  child: Text(
                    session.exercise.emoji,
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  session.exercise.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  session.exercise.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        strokeWidth: 8,
                        backgroundColor: AppColors.outlineVariant,
                        color: AppColors.primary,
                      ),
                      Text(
                        '${session.remainingSeconds}',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _ProgressDots(
                  total: session.totalExercises,
                  currentIndex: session.exerciseIndex,
                ),
                const Spacer(),
                _WorkoutControls(
                  canGoPrevious: session.exerciseIndex > 0,
                  canGoNext: session.exerciseIndex < session.totalExercises - 1,
                  isPaused: isPaused,
                  onPrevious: () =>
                      bloc.add(const WorkoutPlayerPreviousExercise()),
                  onPlayPause: () {
                    if (isPaused) {
                      bloc.add(const WorkoutPlayerResume());
                    } else {
                      bloc.add(const WorkoutPlayerPause());
                    }
                  },
                  onNext: () => bloc.add(const WorkoutPlayerNextExercise()),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _SessionData? _sessionData(WorkoutPlayerState state) {
    return switch (state) {
      WorkoutPlayerRunning() => _SessionData(
          exercise: state.exercise,
          exerciseIndex: state.exerciseIndex,
          totalExercises: state.totalExercises,
          remainingSeconds: state.remainingSeconds,
        ),
      WorkoutPlayerPaused() => _SessionData(
          exercise: state.exercise,
          exerciseIndex: state.exerciseIndex,
          totalExercises: state.totalExercises,
          remainingSeconds: state.remainingSeconds,
        ),
      _ => null,
    };
  }

  Future<void> _confirmExit(BuildContext context) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave workout?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (leave == true && context.mounted) {
      context.pop();
    }
  }
}

class _SessionData {
  const _SessionData({
    required this.exercise,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.remainingSeconds,
  });

  final Exercise exercise;
  final int exerciseIndex;
  final int totalExercises;
  final int remainingSeconds;
}

class _WorkoutTopBar extends StatelessWidget {
  const _WorkoutTopBar({
    required this.title,
    required this.onBack,
    required this.onClose,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _PulsingExerciseCircle extends StatelessWidget {
  const _PulsingExerciseCircle({
    required this.remainingSeconds,
    required this.child,
  });

  final int remainingSeconds;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey<bool>(remainingSeconds.isOdd),
      tween: Tween(begin: 0.92, end: 1.08),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 140 * scale,
          height: 140 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.45),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 24 * scale,
                spreadRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.total, required this.currentIndex});

  final int total;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isDone = index < currentIndex;
        final isCurrent = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 12 : 8,
          height: isCurrent ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? AppColors.primary
                : isCurrent
                    ? AppColors.hydrationAccent
                    : AppColors.outlineVariant,
          ),
        );
      }),
    );
  }
}

class _WorkoutControls extends StatelessWidget {
  const _WorkoutControls({
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isPaused,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
  });

  final bool canGoPrevious;
  final bool canGoNext;
  final bool isPaused;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlButton(
          icon: Icons.skip_previous_rounded,
          onPressed: canGoPrevious ? onPrevious : null,
        ),
        const SizedBox(width: 20),
        _ControlButton(
          icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          size: 64,
          filled: true,
          onPressed: onPlayPause,
        ),
        const SizedBox(width: 20),
        _ControlButton(
          icon: Icons.skip_next_rounded,
          onPressed: canGoNext ? onNext : null,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: filled ? AppColors.onPrimary : AppColors.onSurface,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

class _WorkoutPlayerError extends StatelessWidget {
  const _WorkoutPlayerError({
    required this.message,
    required this.onClose,
  });

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onClose, child: const Text('Close')),
          ],
        ),
      ),
    );
  }
}
