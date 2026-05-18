import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/home/bloc/home_bloc.dart';
import 'package:deskdose/features/home/view/widgets/home_loading_shimmer.dart';
import 'package:deskdose/features/home/view/widgets/hydration_mini_bar.dart';
import 'package:deskdose/features/home/view/widgets/quick_start_card.dart';
import 'package:deskdose/features/home/view/widgets/stat_card.dart';
import 'package:deskdose/features/home/view/widgets/streak_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// App shell with bottom navigation and [StatefulNavigationShell] (IndexedStack).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTabSelected,
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Routines',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Hydration',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// Home tab content driven by [HomeBloc].
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.background,
      child: _HomeTabBody(),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || HomeLoading() => const HomeLoadingShimmer(),
          HomeError(:final message) => _HomeErrorView(message: message),
          HomeLoaded() => _HomeLoadedView(state: state),
        };
      },
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.read<HomeBloc>().add(const HomeLoadRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeLoadedView extends StatelessWidget {
  const _HomeLoadedView({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceContainer,
      onRefresh: () async {
        context.read<HomeBloc>().add(const HomeRefreshRequested());
        await context.read<HomeBloc>().stream.firstWhere(
              (s) => s is! HomeLoading,
            );
      },
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _HomeHeader(streak: state.currentStreak),
            const SizedBox(height: 20),
            _StatsRow(
              todaySessionCount: state.todaySessionCount,
              weeklyMinutes: state.weeklyMinutes,
              todayWaterMl: state.todayWaterMl,
            ),
            const SizedBox(height: 28),
            Text(
              'Quick Start',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            const _QuickStartGrid(),
            const SizedBox(height: 24),
            HydrationMiniBar(
              waterMl: state.todayWaterMl,
              goalMl: AppConstants.defaultHydrationGoalMl,
              onTap: () => context.push(AppRoutes.hydration),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready for a desk break?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        StreakPill(streakDays: streak),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.todaySessionCount,
    required this.weeklyMinutes,
    required this.todayWaterMl,
  });

  final int todaySessionCount;
  final int weeklyMinutes;
  final int todayWaterMl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatCard(
          num: '$todaySessionCount',
          label: 'Sessions today',
          accentColor: AppColors.primary,
        ),
        const SizedBox(width: 12),
        StatCard(
          num: '$weeklyMinutes',
          label: 'Weekly min',
          accentColor: AppColors.premiumAccent,
        ),
        const SizedBox(width: 12),
        StatCard(
          num: '${todayWaterMl}ml',
          label: 'Water today',
          accentColor: AppColors.hydrationAccent,
        ),
      ],
    );
  }
}

class _QuickStartGrid extends StatelessWidget {
  const _QuickStartGrid();

  static const _posturePurple = Color(0xFF9B6ED9);

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;
    const cardHeight = 140.0;

    return Column(
      children: [
        SizedBox(
          height: cardHeight,
          child: Row(
            children: [
              Expanded(
                child: QuickStartCard(
                  emoji: '🧘',
                  title: 'Desk Stretch',
                  subtitle: 'Loosen up at your desk',
                  durationLabel: '5 min',
                  accentColor: AppColors.primary,
                  onTap: () => context.push(
                    AppRoutes.routinesWithCategory('stretch'),
                  ),
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: QuickStartCard(
                  emoji: '👁️',
                  title: 'Eye Relief',
                  subtitle: 'Rest tired screen eyes',
                  durationLabel: '3 min',
                  accentColor: AppColors.hydrationAccent,
                  onTap: () => context.push(
                    AppRoutes.routinesWithCategory('eyes'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: gap),
        SizedBox(
          height: cardHeight,
          child: Row(
            children: [
              Expanded(
                child: QuickStartCard(
                  emoji: '🦴',
                  title: 'Back Pain',
                  subtitle: 'Ease lower back tension',
                  durationLabel: '7 min',
                  accentColor: AppColors.premiumAccent,
                  onTap: () => context.push(
                    AppRoutes.routinesWithCategory('mobility'),
                  ),
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: QuickStartCard(
                  emoji: '🧍',
                  title: 'Posture Fix',
                  subtitle: 'Align spine & shoulders',
                  durationLabel: '4 min',
                  accentColor: _posturePurple,
                  onTap: () => context.push(
                    AppRoutes.routinesWithCategory('posture'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
