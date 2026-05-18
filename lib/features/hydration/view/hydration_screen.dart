import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/features/hydration/bloc/hydration_bloc.dart';
import 'package:deskdose/features/hydration/view/widgets/hydration_circle.dart';
import 'package:deskdose/features/hydration/view/widgets/hydration_loading_shimmer.dart';
import 'package:deskdose/features/hydration/view/widgets/hydration_log_item.dart';
import 'package:deskdose/features/hydration/view/widgets/quick_add_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dark blue hydration tracking screen.
class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  static const _background = Color(0xFF0A0F1A);

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: _background,
      child: ScreenSafeArea(
        bottom: false,
        child: _HydrationBody(),
      ),
    );
  }
}

class _HydrationBody extends StatelessWidget {
  const _HydrationBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HydrationBloc, HydrationState>(
      listenWhen: (previous, current) {
        if (current is HydrationLoaded && current.actionError != null) {
          return true;
        }
        if (current is! HydrationLoaded || previous is! HydrationLoaded) {
          return false;
        }
        return current.todayLogs.length > previous.todayLogs.length &&
            !current.isLogging &&
            current.actionError == null;
      },
      listener: (context, state) {
        if (state is HydrationLoaded && state.actionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionError!),
              backgroundColor: Colors.red.shade800,
            ),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Water logged! 💧')),
        );
      },
      builder: (context, state) {
        return switch (state) {
          HydrationInitial() || HydrationLoading() =>
            const HydrationLoadingShimmer(),
          HydrationError(:final message) => _HydrationErrorView(message: message),
          HydrationLoaded() => _HydrationLoadedView(state: state),
        };
      },
    );
  }
}

class _HydrationLoadedView extends StatelessWidget {
  const _HydrationLoadedView({required this.state});

  final HydrationLoaded state;

  static const _quickAdds = <({int ml, String emoji})>[
    (ml: 150, emoji: '☕'),
    (ml: 250, emoji: '🥤'),
    (ml: 350, emoji: '🍶'),
    (ml: 500, emoji: '🫗'),
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HydrationBloc>();
    final percentLabel = state.goalMl > 0
        ? '${((state.totalMl / state.goalMl) * 100).round()}% of goal'
        : '0% of goal';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          'Hydration',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              HydrationCircle(
                percentage: state.percentage,
                totalMl: state.totalMl,
                goalMl: state.goalMl,
              ),
              const SizedBox(height: 12),
              Text(
                percentLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF378ADD),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: _quickAdds.map((item) {
            return QuickAddChip(
              emoji: item.emoji,
              amountMl: item.ml,
              enabled: !state.isLogging,
              onTap: () => bloc.add(HydrationLogAdded(item.ml)),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: state.isLogging
                ? null
                : () => _showCustomAmountSheet(context, bloc),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Custom amount'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF378ADD),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Today's log",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 12),
        if (state.todayLogs.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No water logged yet today.',
                style: TextStyle(color: Color(0xFFB8B8C4)),
              ),
            ),
          )
        else
          ...state.todayLogs.map((log) => HydrationLogItem(log: log)),
      ],
    );
  }

  Future<void> _showCustomAmountSheet(
    BuildContext context,
    HydrationBloc bloc,
  ) {
    final controller = TextEditingController();

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF141C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            24 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Custom amount',
                style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Amount in ml',
                  hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: const Color(0xFF0A0F1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A3A55)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A3A55)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF378ADD)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final amount = int.tryParse(controller.text.trim());
                  if (amount == null || amount <= 0) return;
                  Navigator.of(sheetContext).pop();
                  bloc.add(HydrationLogAdded(amount));
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF378ADD),
                ),
                child: const Text('Log'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(controller.dispose);
  }
}

class _HydrationErrorView extends StatelessWidget {
  const _HydrationErrorView({required this.message});

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
              style: const TextStyle(color: Colors.redAccent),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<HydrationBloc>().add(
                    HydrationLoadRequested(DateTime.now()),
                  ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
