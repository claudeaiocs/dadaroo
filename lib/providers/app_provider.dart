import 'package:flutter/foundation.dart';
import 'package:dadaroo/models/takeaway_type.dart';
import 'package:dadaroo/models/delivery.dart';
import 'package:dadaroo/models/rating.dart';
import 'package:dadaroo/models/badge.dart';
import 'package:dadaroo/models/dad.dart';
import 'package:dadaroo/services/mock_gps_service.dart';

class AppProvider extends ChangeNotifier {
  final MockGpsService _gpsService = MockGpsService();

  // Current state
  TakeawayType _selectedTakeaway = TakeawayType.pizza;
  String _customTakeawayName = '';
  Delivery? _activeDelivery;
  LatLng? _currentDadLocation;
  bool _dadIsClose = false;
  bool _showCelebration = false;

  // Dad profiles
  final List<Dad> _dads = [
    Dad(id: '1', name: 'Dad', badges: [], deliveries: []),
    Dad(id: '2', name: 'Uncle Bob', badges: [], deliveries: []),
    Dad(id: '3', name: 'Grandad', badges: [], deliveries: []),
  ];
  String _currentDadId = '1';

  // History
  final List<Delivery> _deliveryHistory = [];

  // Getters
  TakeawayType get selectedTakeaway => _selectedTakeaway;
  String get customTakeawayName => _customTakeawayName;
  Delivery? get activeDelivery => _activeDelivery;
  LatLng? get currentDadLocation => _currentDadLocation;
  bool get dadIsClose => _dadIsClose;
  bool get showCelebration => _showCelebration;
  bool get isDeliveryActive => _activeDelivery != null && _activeDelivery!.isActive;
  List<Delivery> get deliveryHistory => List.unmodifiable(_deliveryHistory);
  List<Dad> get dads => List.unmodifiable(_dads);
  Dad get currentDad => _dads.firstWhere((d) => d.id == _currentDadId);
  MockGpsService get gpsService => _gpsService;

  Duration get etaRemaining => _gpsService.estimatedTimeRemaining;
  double get deliveryProgress => _gpsService.progress;

  void setSelectedTakeaway(TakeawayType type) {
    _selectedTakeaway = type;
    notifyListeners();
  }

  void setCustomTakeawayName(String name) {
    _customTakeawayName = name;
    notifyListeners();
  }

  void setCurrentDad(String dadId) {
    _currentDadId = dadId;
    notifyListeners();
  }

  void startDelivery() {
    final delivery = Delivery(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dadName: currentDad.name,
      takeawayType: _selectedTakeaway,
      customTakeawayName:
          _selectedTakeaway == TakeawayType.custom ? _customTakeawayName : null,
      startTime: DateTime.now(),
      estimatedDuration: const Duration(minutes: 10),
      isActive: true,
    );

    _activeDelivery = delivery;
    _dadIsClose = false;
    _showCelebration = false;

    _gpsService.startTracking((location) {
      _currentDadLocation = location;
      final remaining = _gpsService.estimatedTimeRemaining;

      if (remaining.inSeconds <= 120 && !_dadIsClose) {
        _dadIsClose = true;
      }

      if (_gpsService.hasArrived) {
        _completeDelivery();
      }

      notifyListeners();
    });

    notifyListeners();
  }

  void _completeDelivery() {
    if (_activeDelivery == null) return;

    _activeDelivery = _activeDelivery!.copyWith(
      arrivalTime: DateTime.now(),
      isActive: false,
    );
    _showCelebration = true;
    notifyListeners();
  }

  void rateDelivery(Rating rating) {
    if (_activeDelivery == null) return;

    final ratedDelivery = _activeDelivery!.copyWith(rating: rating);
    _deliveryHistory.insert(0, ratedDelivery);

    // Update dad's deliveries
    final dadIndex = _dads.indexWhere((d) => d.id == _currentDadId);
    if (dadIndex != -1) {
      final dad = _dads[dadIndex];
      final updatedDeliveries = [...dad.deliveries, ratedDelivery];
      final updatedBadges = _checkBadges(updatedDeliveries, dad.badges);
      _dads[dadIndex] = Dad(
        id: dad.id,
        name: dad.name,
        badges: updatedBadges,
        deliveries: updatedDeliveries,
      );
    }

    _activeDelivery = null;
    _currentDadLocation = null;
    _dadIsClose = false;
    _showCelebration = false;
    _gpsService.stopTracking();

    notifyListeners();
  }

  void skipRating() {
    if (_activeDelivery != null) {
      _deliveryHistory.insert(0, _activeDelivery!.copyWith(isActive: false));
    }
    _activeDelivery = null;
    _currentDadLocation = null;
    _dadIsClose = false;
    _showCelebration = false;
    _gpsService.stopTracking();
    notifyListeners();
  }

  void cancelDelivery() {
    _activeDelivery = null;
    _currentDadLocation = null;
    _dadIsClose = false;
    _showCelebration = false;
    _gpsService.stopTracking();
    notifyListeners();
  }

  // Simulate instant arrival for demo purposes
  void simulateArrival() {
    if (_activeDelivery == null) return;
    _gpsService.stopTracking();
    _dadIsClose = true;
    _completeDelivery();
  }

  List<Badge> _checkBadges(List<Delivery> deliveries, List<Badge> existing) {
    final badges = List<Badge>.from(existing);
    final existingTypes = existing.map((b) => b.type).toSet();
    final now = DateTime.now();

    // Speed Demon: any delivery under 15 min
    if (!existingTypes.contains(BadgeType.speedDemon)) {
      if (deliveries.any((d) =>
          d.actualDuration != null &&
          d.actualDuration!.inMinutes < 15)) {
        badges.add(Badge(type: BadgeType.speedDemon, earnedAt: now));
      }
    }

    // 100 Deliveries
    if (!existingTypes.contains(BadgeType.hundredDeliveries)) {
      if (deliveries.length >= 100) {
        badges.add(Badge(type: BadgeType.hundredDeliveries, earnedAt: now));
      }
    }

    // 5-Star Dad
    if (!existingTypes.contains(BadgeType.fiveStarDad)) {
      if (deliveries.any((d) => d.rating != null && d.rating!.average == 5.0)) {
        badges.add(Badge(type: BadgeType.fiveStarDad, earnedAt: now));
      }
    }

    // Master Chef Picker: avg food choice >= 4.5
    if (!existingTypes.contains(BadgeType.masterChefPicker)) {
      final rated = deliveries.where((d) => d.rating != null).toList();
      if (rated.length >= 3) {
        final avgFoodChoice =
            rated.map((d) => d.rating!.foodChoice).reduce((a, b) => a + b) /
                rated.length;
        if (avgFoodChoice >= 4.5) {
          badges.add(Badge(type: BadgeType.masterChefPicker, earnedAt: now));
        }
      }
    }

    // Variety King: tried all non-custom/other takeaway types
    if (!existingTypes.contains(BadgeType.varietyKing)) {
      final types = deliveries.map((d) => d.takeawayType).toSet();
      final mainTypes = TakeawayType.values
          .where((t) => t != TakeawayType.other && t != TakeawayType.custom)
          .toSet();
      if (types.containsAll(mainTypes)) {
        badges.add(Badge(type: BadgeType.varietyKing, earnedAt: now));
      }
    }

    return badges;
  }

  // Stats
  Map<TakeawayType, int> get takeawayStats {
    final stats = <TakeawayType, int>{};
    for (final d in _deliveryHistory) {
      stats[d.takeawayType] = (stats[d.takeawayType] ?? 0) + 1;
    }
    return stats;
  }

  TakeawayType? get favouriteTakeaway {
    final stats = takeawayStats;
    if (stats.isEmpty) return null;
    return stats.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Duration? get averageDeliveryTime {
    final completed =
        _deliveryHistory.where((d) => d.actualDuration != null).toList();
    if (completed.isEmpty) return null;
    final totalSeconds = completed
        .map((d) => d.actualDuration!.inSeconds)
        .reduce((a, b) => a + b);
    return Duration(seconds: totalSeconds ~/ completed.length);
  }

  double? get bestRating {
    final rated = _deliveryHistory.where((d) => d.rating != null).toList();
    if (rated.isEmpty) return null;
    return rated
        .map((d) => d.rating!.average)
        .reduce((a, b) => a > b ? a : b);
  }

  // Seed some demo history data
  void seedDemoData() {
    if (_deliveryHistory.isNotEmpty) return;

    final demoDeliveries = [
      Delivery(
        id: 'demo1',
        dadName: 'Dad',
        takeawayType: TakeawayType.pizza,
        startTime: DateTime.now().subtract(const Duration(days: 7)),
        arrivalTime: DateTime.now()
            .subtract(const Duration(days: 7))
            .add(const Duration(minutes: 18)),
        estimatedDuration: const Duration(minutes: 20),
        rating: Rating(speed: 4, foodChoice: 5, communication: 4, overallDadness: 5),
      ),
      Delivery(
        id: 'demo2',
        dadName: 'Dad',
        takeawayType: TakeawayType.chinese,
        startTime: DateTime.now().subtract(const Duration(days: 5)),
        arrivalTime: DateTime.now()
            .subtract(const Duration(days: 5))
            .add(const Duration(minutes: 12)),
        estimatedDuration: const Duration(minutes: 15),
        rating: Rating(speed: 5, foodChoice: 4, communication: 5, overallDadness: 5),
      ),
      Delivery(
        id: 'demo3',
        dadName: 'Uncle Bob',
        takeawayType: TakeawayType.burger,
        startTime: DateTime.now().subtract(const Duration(days: 3)),
        arrivalTime: DateTime.now()
            .subtract(const Duration(days: 3))
            .add(const Duration(minutes: 22)),
        estimatedDuration: const Duration(minutes: 25),
        rating: Rating(speed: 3, foodChoice: 4, communication: 3, overallDadness: 4),
      ),
      Delivery(
        id: 'demo4',
        dadName: 'Dad',
        takeawayType: TakeawayType.indian,
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        arrivalTime: DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(minutes: 16)),
        estimatedDuration: const Duration(minutes: 20),
        rating: Rating(speed: 4, foodChoice: 5, communication: 4, overallDadness: 4),
      ),
    ];

    _deliveryHistory.addAll(demoDeliveries);

    // Add to Dad's profile
    final dadIndex = _dads.indexWhere((d) => d.id == '1');
    if (dadIndex != -1) {
      final dad = _dads[dadIndex];
      _dads[dadIndex] = Dad(
        id: dad.id,
        name: dad.name,
        badges: [
          Badge(type: BadgeType.speedDemon, earnedAt: DateTime.now().subtract(const Duration(days: 5))),
          Badge(type: BadgeType.fiveStarDad, earnedAt: DateTime.now().subtract(const Duration(days: 7))),
        ],
        deliveries: demoDeliveries.where((d) => d.dadName == 'Dad').toList(),
      );
    }

    // Add to Uncle Bob's profile
    final bobIndex = _dads.indexWhere((d) => d.id == '2');
    if (bobIndex != -1) {
      final bob = _dads[bobIndex];
      _dads[bobIndex] = Dad(
        id: bob.id,
        name: bob.name,
        badges: [],
        deliveries: demoDeliveries.where((d) => d.dadName == 'Uncle Bob').toList(),
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _gpsService.dispose();
    super.dispose();
  }
}
