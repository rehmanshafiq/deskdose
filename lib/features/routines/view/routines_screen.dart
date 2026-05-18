import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/features/paywall/view/paywall_bottom_sheet.dart';
import 'package:deskdose/features/routines/bloc/routines_bloc.dart';
import 'package:deskdose/features/routines/view/widgets/routine_card.dart';
import 'package:deskdose/features/routines/view/widgets/routines_header.dart';
import 'package:deskdose/features/routines/view/widgets/routines_loading_shimmer.dart';
import 'package:deskdose/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({
    super.key,
    this.initialCategory,
    this.showBackButton = false,
  });

  final String? initialCategory;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoutinesBloc, RoutinesState>(
      listenWhen: (previous, current) =>
          initialCategory != null &&
          previous is! RoutinesLoaded &&
          current is RoutinesLoaded,
      listener: (context, state) {
        context.read<RoutinesBloc>().add(
              RoutinesCategoryFilterChanged(initialCategory),
            );
      },
      child: Material(
        color: AppColors.background,
        child: ScreenSafeArea(
          bottom: showBackButton,
          child: _RoutinesBody(showBackButton: showBackButton),
        ),
      ),
    );
  }
}

class _RoutinesBody extends StatelessWidget {
  const _RoutinesBody({required this.showBackButton});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutinesBloc, RoutinesState>(
      builder: (context, state) {
        final hasProAccess = _hasProAccess(context);

        return switch (state) {
          RoutinesInitial() || RoutinesLoading() => RoutinesLoadingShimmer(
              showBackButton: showBackButton,
            ),
          RoutinesError(:final message) => _RoutinesErrorView(message: message),
          RoutinesLoaded() => _RoutinesLoadedView(
              state: state,
              hasProAccess: hasProAccess,
              showBackButton: showBackButton,
            ),
        };
      },
    );
  }

  bool _hasProAccess(BuildContext context) {
    final subState = context.watch<SubscriptionBloc>().state;
    return switch (subState) {
      SubscriptionLoaded(:final subscription) => subscription.isPremium,
      _ => false,
    };
  }
}

class _RoutinesErrorView extends StatelessWidget {
  const _RoutinesErrorView({required this.message});

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
              onPressed: () => context
                  .read<RoutinesBloc>()
                  .add(const RoutinesLoadRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutinesLoadedView extends StatelessWidget {
  const _RoutinesLoadedView({
    required this.state,
    required this.hasProAccess,
    required this.showBackButton,
  });

  final RoutinesLoaded state;
  final bool hasProAccess;
  final bool showBackButton;

  static const _filters = <({String? category, String label})>[
    (category: null, label: 'All'),
    (category: 'stretch', label: 'Stretch'),
    (category: 'eyes', label: 'Eye Relief'),
    (category: 'mobility', label: 'Back Pain'),
    (category: 'posture', label: 'Posture'),
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceContainer,
      onRefresh: () async {
        context.read<RoutinesBloc>().add(
              RoutinesLoadRequested(initialCategory: state.selectedCategory),
            );
        await context.read<RoutinesBloc>().stream.firstWhere(
              (s) => s is! RoutinesLoading,
            );
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          RoutinesHeader(showBackButton: showBackButton),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilterChip(
              label: const Text('Free only'),
              selected: state.showFreeOnly,
              onSelected: (_) => context
                  .read<RoutinesBloc>()
                  .add(const RoutinesShowFreeOnlyToggled()),
              selectedColor: AppColors.primary.withValues(alpha: 0.25),
              checkmarkColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final selected = state.selectedCategory == filter.category ||
                    (filter.category == null && state.selectedCategory == null);

                return FilterChip(
                  label: Text(filter.label),
                  selected: selected,
                  onSelected: (_) => context.read<RoutinesBloc>().add(
                        RoutinesCategoryFilterChanged(filter.category),
                      ),
                  selectedColor: AppColors.primary.withValues(alpha: 0.25),
                  checkmarkColor: AppColors.primary,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (state.routines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: Text('No routines match your filters.')),
            )
          else
            ...state.routines.map(
              (routine) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RoutineCard(
                  routine: routine,
                  isPremium: routine.isPremium,
                  hasProAccess: hasProAccess,
                  onTap: () => _onRoutineTap(context, routine, hasProAccess),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onRoutineTap(
    BuildContext context,
    Routine routine,
    bool hasProAccess,
  ) {
    if (routine.isPremium && !hasProAccess) {
      PaywallBottomSheet.show(context);
      return;
    }

    context.push(
      AppRoutes.routineDetailPath(routine.id),
      extra: routine,
    );
  }
}
