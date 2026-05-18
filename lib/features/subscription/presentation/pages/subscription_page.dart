import 'package:deskdose/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(const LoadSubscriptionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          : Icons.lock_outline,
                      size: 64,
                      color: subscription.isPremium
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subscription.isPremium
                          ? 'You have Premium'
                          : 'Upgrade to Premium',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subscription.isPremium
                          ? 'Enjoy unlimited routines and reminders.'
                          : 'Unlock all routines, hydration insights, and more.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}
