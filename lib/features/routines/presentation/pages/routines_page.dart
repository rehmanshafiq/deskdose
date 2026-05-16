import 'package:deskdose/core/di/injection_container.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_event.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_state.dart';
import 'package:deskdose/features/routines/presentation/widgets/routine_card.dart';
import 'package:deskdose/features/routines/presentation/widgets/routine_list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoutinesPage extends StatelessWidget {
  const RoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RoutineBloc>()..add(const LoadRoutinesEvent()),
      child: const _RoutinesView(),
    );
  }
}

class _RoutinesView extends StatelessWidget {
  const _RoutinesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<RoutineBloc>().add(const RefreshRoutinesEvent()),
          ),
        ],
      ),
      body: BlocConsumer<RoutineBloc, RoutineState>(
        listener: (context, state) {
          if (state is RoutineLoaded && state.lastCompletedSession != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Workout completed! Great job.')),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            RoutineInitial() || RoutineLoading() => const RoutineListShimmer(),
            RoutineError(:final message) => _ErrorView(
                message: message,
                onRetry: () => context
                    .read<RoutineBloc>()
                    .add(const LoadRoutinesEvent()),
              ),
            RoutineLoaded(:final routines) => RefreshIndicator(
                onRefresh: () async {
                  context.read<RoutineBloc>().add(const RefreshRoutinesEvent());
                },
                child: routines.isEmpty
                    ? const _EmptyView()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: routines.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final routine = routines[index];
                          return RoutineCard(
                            routine: routine,
                            onTap: () => context.push(
                              AppRoutes.routineDetailPath(routine.id),
                            ),
                          );
                        },
                      ),
              ),
          };
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No routines available yet.'),
    );
  }
}
