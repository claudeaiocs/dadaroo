import 'package:dadaroo/config/app_config.dart';

enum BadgeType {
  speedDemon,
  masterChefPicker,
  hundredDeliveries,
  nightOwl,
  weekendWarrior,
  consistentParent,
  fiveStarParent,
  varietyRoyalty;

  String get title {
    switch (this) {
      case BadgeType.speedDemon:
        return 'Speed Demon';
      case BadgeType.masterChefPicker:
        return 'Master Chef Picker';
      case BadgeType.hundredDeliveries:
        return '100 Deliveries';
      case BadgeType.nightOwl:
        return 'Night Owl';
      case BadgeType.weekendWarrior:
        return 'Weekend Warrior';
      case BadgeType.consistentParent:
        return appConfig.consistentBadgeTitle;
      case BadgeType.fiveStarParent:
        return appConfig.fiveStarBadgeTitle;
      case BadgeType.varietyRoyalty:
        return appConfig.varietyBadgeTitle;
    }
  }

  String get description {
    switch (this) {
      case BadgeType.speedDemon:
        return 'Delivered in under 15 minutes!';
      case BadgeType.masterChefPicker:
        return 'Always picks the best food';
      case BadgeType.hundredDeliveries:
        return 'Completed 100 food runs';
      case BadgeType.nightOwl:
        return 'Late night food hero';
      case BadgeType.weekendWarrior:
        return '10 weekend deliveries';
      case BadgeType.consistentParent:
        return '30-day delivery streak';
      case BadgeType.fiveStarParent:
        return 'Received a perfect 5-star rating';
      case BadgeType.varietyRoyalty:
        return 'Tried every takeaway type';
    }
  }

  String get icon {
    switch (this) {
      case BadgeType.speedDemon:
        return '⚡';
      case BadgeType.masterChefPicker:
        return '👨‍🍳';
      case BadgeType.hundredDeliveries:
        return '💯';
      case BadgeType.nightOwl:
        return '🦉';
      case BadgeType.weekendWarrior:
        return '🏆';
      case BadgeType.consistentParent:
        return '📅';
      case BadgeType.fiveStarParent:
        return '⭐';
      case BadgeType.varietyRoyalty:
        return '👑';
    }
  }

  /// Firestore storage name - maps new enum names to legacy stored values
  String get storageName {
    switch (this) {
      case BadgeType.consistentParent:
        return 'consistentDad';
      case BadgeType.fiveStarParent:
        return 'fiveStarDad';
      case BadgeType.varietyRoyalty:
        return 'varietyKing';
      default:
        return name;
    }
  }

  static BadgeType fromStorageName(String name) {
    // Handle legacy names from Firestore
    switch (name) {
      case 'consistentDad':
        return BadgeType.consistentParent;
      case 'fiveStarDad':
        return BadgeType.fiveStarParent;
      case 'varietyKing':
        return BadgeType.varietyRoyalty;
      default:
        return BadgeType.values.firstWhere(
          (b) => b.name == name || b.storageName == name,
          orElse: () => BadgeType.speedDemon,
        );
    }
  }
}

class Badge {
  final BadgeType type;
  final DateTime earnedAt;

  Badge({required this.type, required this.earnedAt});

  Map<String, dynamic> toMap() {
    return {
      'type': type.storageName,
      'earnedAt': earnedAt.toIso8601String(),
    };
  }

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      type: BadgeType.fromStorageName(map['type'] ?? 'speedDemon'),
      earnedAt: map['earnedAt'] != null
          ? DateTime.parse(map['earnedAt'])
          : DateTime.now(),
    );
  }
}
