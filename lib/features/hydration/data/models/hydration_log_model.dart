import 'package:deskdose/core/utils/typedef.dart';
import 'package:deskdose/features/hydration/domain/entities/hydration_log_entity.dart';

class HydrationLogModel {
  const HydrationLogModel({
    required this.id,
    required this.anonymousUserId,
    required this.amountMl,
    required this.loggedAt,
  });

  final String id;
  final String anonymousUserId;
  final int amountMl;
  final DateTime loggedAt;

  factory HydrationLogModel.fromJson(DataMap json) => HydrationLogModel(
        id: json['id'] as String,
        anonymousUserId: json['anonymous_user_id'] as String,
        amountMl: json['amount_ml'] as int,
        loggedAt: DateTime.parse(json['logged_at'] as String),
      );

  DataMap toJson() => {
        'anonymous_user_id': anonymousUserId,
        'amount_ml': amountMl,
        'logged_at': loggedAt.toUtc().toIso8601String(),
      };
}

extension HydrationLogModelMapper on HydrationLogModel {
  HydrationLogEntity toEntity() => HydrationLogEntity(
        id: id,
        anonymousUserId: anonymousUserId,
        amountMl: amountMl,
        loggedAt: loggedAt,
      );
}
