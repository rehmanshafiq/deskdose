import 'package:deskdose/core/di/injection_container.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_event.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutineDetailPage extends StatelessWidget {
  const RoutineDetailPage({super.key, required this.routineId});

  final String routineId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RoutineBloc>()
        ..add(LoadRoutineDetailEvent(routineId: routineId)),
      child: _RoutineDetailView(routineId: routineId),
    );
  }
}

class _RoutineDetailView extends StatelessWidget {
  const _RoutineDetailView({required this.routineId});

  final String routineId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Routine')),
      body: BlocBuilder<RoutineBloc, RoutineState>(
        builder: (context, state) {
          return switch (state) {
            RoutineInitial() || RoutineLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            RoutineError(:final message) => Center(child: Text(message)),
            RoutineLoaded(:final selectedRoutine) when selectedRoutine != null =>
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      selectedRoutine.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedRoutine.formattedDuration,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(selectedRoutine.description),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: selectedRoutine.tags
                          .map((t) => Chip(label: Text(t)))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: state.isCompleting
                          ? null
                          : () => context.read<RoutineBloc>().add(
                                CompleteRoutineEvent(
                                  routineId: routineId,
                                  durationSeconds:
                                      selectedRoutine.durationSeconds,
                                ),
                              ),
                      icon: state.isCompleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                        state.isCompleting ? 'Saving...' : 'Mark Complete',
                      ),
                    ),
                  ],
                ),
              ),
            _ => const Center(child: Text('Routine not found')),
          };
        },
      ),
    );
  }
}
