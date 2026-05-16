import 'package:deskdose/core/di/injection_container.dart';
import 'package:deskdose/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SubscriptionBloc>()..add(const LoadSubscriptionEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Premium')),
        body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            return switch (state) {
              SubscriptionLoading() || SubscriptionInitial() =>
                const Center(child: CircularProgressIndicator()),
              SubscriptionError(:final message) => Center(child: Text(message)),
              SubscriptionLoaded(:final subscription) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        subscription.isPremium
                            ? Icons.workspace_premium
                            : Icons.lock_open,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        subscription.isPremium
                            ? 'Premium Active'
                            : 'Upgrade to Premium',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current plan: ${subscription.tier.name}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      if (!subscription.isPremium)
                        FilledButton(
                          onPressed: () {
                            // RevenueCat paywall integration point
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'RevenueCat paywall will be wired here.',
                                ),
                              ),
                            );
                          },
                          child: const Text('View Plans'),
                        ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
