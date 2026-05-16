import 'package:equatable/equatable.dart';

class HydrationLogEntity extends Equatable {
  const HydrationLogEntity({
    required this.id,
    required this.anonymousUserId,
    required this.amountMl,
    required this.loggedAt,
  });

  final String id;
  final String anonymousUserId;
  final int amountMl;
  final DateTime loggedAt;

  @override
  List<Object?> get props => [id, anonymousUserId, amountMl, loggedAt];
}
