import 'package:dadaroo/models/takeaway_type.dart';
import 'package:dadaroo/models/rating.dart';

class Delivery {
  final String id;
  final String dadName;
  final TakeawayType takeawayType;
  final String? customTakeawayName;
  final DateTime startTime;
  final DateTime? arrivalTime;
  final Duration estimatedDuration;
  final Rating? rating;
  final bool isActive;

  Delivery({
    required this.id,
    required this.dadName,
    required this.takeawayType,
    this.customTakeawayName,
    required this.startTime,
    this.arrivalTime,
    required this.estimatedDuration,
    this.rating,
    this.isActive = false,
  });

  String get takeawayDisplayName {
    if (takeawayType == TakeawayType.custom && customTakeawayName != null) {
      return customTakeawayName!;
    }
    return takeawayType.displayName;
  }

  String get takeawayEmoji => takeawayType.emoji;

  Duration? get actualDuration {
    if (arrivalTime == null) return null;
    return arrivalTime!.difference(startTime);
  }

  Delivery copyWith({
    String? id,
    String? dadName,
    TakeawayType? takeawayType,
    String? customTakeawayName,
    DateTime? startTime,
    DateTime? arrivalTime,
    Duration? estimatedDuration,
    Rating? rating,
    bool? isActive,
  }) {
    return Delivery(
      id: id ?? this.id,
      dadName: dadName ?? this.dadName,
      takeawayType: takeawayType ?? this.takeawayType,
      customTakeawayName: customTakeawayName ?? this.customTakeawayName,
      startTime: startTime ?? this.startTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
    );
  }
}
