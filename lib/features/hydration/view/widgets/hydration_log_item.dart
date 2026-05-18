import 'package:deskdose/data/models/hydration_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HydrationLogItem extends StatelessWidget {
  const HydrationLogItem({super.key, required this.log});

  final HydrationLog log;

  static String emojiForAmount(int amountMl) {
    return switch (amountMl) {
      150 => '☕',
      250 => '🥤',
      350 => '🍶',
      500 => '🫗',
      _ => '💧',
    };
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.jm().format(log.loggedAt.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141C2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3A55)),
      ),
      child: Row(
        children: [
          Text(emojiForAmount(log.amountMl), style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              time,
              style: const TextStyle(
                color: Color(0xFFB8B8C4),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '${log.amountMl} ml',
            style: const TextStyle(
              color: Color(0xFF378ADD),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
