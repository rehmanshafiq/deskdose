import 'package:deskdose/core/di/injection_container.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_event.dart';
import 'package:deskdose/features/home/presentation/bloc/home_bloc.dart';
import 'package:deskdose/features/home/presentation/bloc/home_event.dart';
import 'package:deskdose/features/home/presentation/bloc/home_state.dart';
import 'package:deskdose/features/home/presentation/widgets/daily_stats_card.dart';
import 'package:deskdose/features/home/presentation/widgets/feature_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<HomeBloc>()..add(const LoadDailyStatsEvent()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DeskDose'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const SignOutRequested()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const LoadDailyStatsEvent());
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return switch (state) {
                  HomeLoading() || HomeInitial() => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  HomeError(:final message) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(message),
                      ),
                    ),
                  HomeLoaded(:final stats) => Column(
                      children: [
                        DailyStatsCard(stats: stats),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 40,
                                      lineWidth: 6,
                                      percent: stats.hydrationProgress,
                                      center: Text(
                                        '${(stats.hydrationProgress * 100).toInt()}%',
                                        style: theme.textTheme.labelSmall,
                                      ),
                                      progressColor: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('Hydration'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${stats.streakDays}',
                                      style: theme.textTheme.headlineMedium,
                                    ),
                                    Text(
                                      'day streak',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                };
              },
            ),
            const SizedBox(height: 24),
            Text('Quick Access', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                FeatureTile(
                  icon: Icons.fitness_center,
                  label: 'Routines',
                  onTap: () => context.push(AppRoutes.routines),
                ),
                FeatureTile(
                  icon: Icons.water_drop,
                  label: 'Hydration',
                  onTap: () => context.push(AppRoutes.hydration),
                ),
                FeatureTile(
                  icon: Icons.accessibility_new,
                  label: 'Posture',
                  onTap: () => context.push(AppRoutes.posture),
                ),
                FeatureTile(
                  icon: Icons.notifications_active,
                  label: 'Reminders',
                  onTap: () => context.push(AppRoutes.reminders),
                ),
                FeatureTile(
                  icon: Icons.workspace_premium,
                  label: 'Premium',
                  onTap: () => context.push(AppRoutes.subscription),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
