import 'package:equatable/equatable.dart';

class HydrationLogEntity extends Equatable {
  const HydrationLogEntity({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.loggedAt,
  });

  final String id;
  final String userId;
  final int amountMl;
  final DateTime loggedAt;

  @override
  List<Object?> get props => [id, userId, amountMl, loggedAt];
}
