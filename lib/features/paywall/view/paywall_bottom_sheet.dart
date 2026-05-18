import 'package:deskdose/features/paywall/cubit/paywall_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaywallBottomSheet extends StatelessWidget {
  const PaywallBottomSheet({super.key});

  static const _purple = Color(0xFF534AB7);
  static const _teal = Color(0xFF0F6E56);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider(
        create: (_) => PaywallCubit(),
        child: const PaywallBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaywallCubit, PaywallState>(
      listener: (context, state) {
        if (state is PaywallSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Purchase initiated')),
          );
          Navigator.of(context).pop();
        } else if (state is PaywallError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A22),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _Header(),
                const SizedBox(height: 24),
                const _FeatureList(),
                const SizedBox(height: 24),
                BlocBuilder<PaywallCubit, PaywallState>(
                  builder: (context, state) {
                    final purchasing = state is PaywallPurchasing;
                    return Column(
                      children: [
                        _PlanTile(
                          title: 'Monthly',
                          price: '\$4.99/mo',
                          highlighted: true,
                          badge: null,
                          loading: purchasing,
                          onTap: purchasing
                              ? null
                              : () => context
                                  .read<PaywallCubit>()
                                  .purchase(PaywallPlan.monthly),
                        ),
                        const SizedBox(height: 12),
                        _PlanTile(
                          title: 'Yearly',
                          price: '\$39.99/yr',
                          highlighted: false,
                          badge: 'Best Value',
                          loading: purchasing,
                          onTap: purchasing
                              ? null
                              : () => context
                                  .read<PaywallCubit>()
                                  .purchase(PaywallPlan.yearly),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Continue for Free'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaywallBottomSheet._purple,
            PaywallBottomSheet._teal,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⭐ DeskDose Pro',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Unlock Everything',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  static const _features = [
    'All routines',
    'Advanced analytics',
    'Priority support',
    'Custom reminders',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _features
          .map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 22),
                  const SizedBox(width: 12),
                  Text(
                    feature,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.title,
    required this.price,
    required this.highlighted,
    required this.onTap,
    this.badge,
    this.loading = false,
  });

  final String title;
  final String price;
  final bool highlighted;
  final String? badge;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        highlighted ? PaywallBottomSheet._purple : Colors.white24;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: highlighted ? 2 : 1),
            color: highlighted
                ? PaywallBottomSheet._purple.withValues(alpha: 0.15)
                : const Color(0xFF22222C),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: PaywallBottomSheet._teal,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                badge!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),
                if (loading)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: highlighted ? Colors.white : Colors.white54,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
