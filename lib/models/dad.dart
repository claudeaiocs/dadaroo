import 'package:dadaroo/models/badge.dart';
import 'package:dadaroo/models/delivery.dart';

class Dad {
  final String id;
  final String name;
  final List<Badge> badges;
  final List<Delivery> deliveries;

  Dad({
    required this.id,
    required this.name,
    this.badges = const [],
    this.deliveries = const [],
  });

  int get totalDeliveries => deliveries.length;

  double get averageRating {
    final rated = deliveries.where((d) => d.rating != null).toList();
    if (rated.isEmpty) return 0;
    return rated.map((d) => d.rating!.average).reduce((a, b) => a + b) / rated.length;
  }

  double get bestRating {
    final rated = deliveries.where((d) => d.rating != null).toList();
    if (rated.isEmpty) return 0;
    return rated.map((d) => d.rating!.average).reduce((a, b) => a > b ? a : b);
  }
}
