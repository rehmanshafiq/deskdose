import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutinesHeader extends StatelessWidget {
  const RoutinesHeader({
    super.key,
    required this.showBackButton,
  });

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          )
        else
          const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Routines',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
