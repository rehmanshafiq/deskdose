import 'package:equatable/equatable.dart';

class HydrationLog extends Equatable {
  const HydrationLog({
    required this.id,
    required this.anonymousUserId,
    required this.amountMl,
    required this.loggedAt,
  });

  final String id;
  final String anonymousUserId;
  final int amountMl;
  final DateTime loggedAt;

  factory HydrationLog.fromJson(Map<String, dynamic> json) {
    return HydrationLog(
      id: json['id'] as String,
      anonymousUserId: json['anonymous_user_id'] as String,
      amountMl: json['amount_ml'] as int,
      loggedAt: _parseDateTime(json['logged_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) 'id': id,
        'anonymous_user_id': anonymousUserId,
        'amount_ml': amountMl,
        'logged_at': loggedAt.toUtc().toIso8601String(),
      };

  HydrationLog copyWith({
    String? id,
    String? anonymousUserId,
    int? amountMl,
    DateTime? loggedAt,
  }) {
    return HydrationLog(
      id: id ?? this.id,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      amountMl: amountMl ?? this.amountMl,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  List<Object?> get props => [id, anonymousUserId, amountMl, loggedAt];
}

DateTime _parseDateTime(Object? value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  return DateTime.now().toUtc();
}
