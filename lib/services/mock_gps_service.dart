import 'dart:async';
import 'dart:math';

class LatLng {
  final double latitude;
  final double longitude;
  LatLng(this.latitude, this.longitude);
}

class MockGpsService {
  Timer? _timer;
  final _random = Random();

  // Simulated route: takeaway shop -> home
  static final LatLng _shopLocation = LatLng(51.5074, -0.1278); // Start
  static final LatLng _homeLocation = LatLng(51.5150, -0.1100); // End

  double _progress = 0.0; // 0.0 = at shop, 1.0 = at home

  LatLng get currentLocation {
    final lat = _shopLocation.latitude +
        (_homeLocation.latitude - _shopLocation.latitude) * _progress;
    final lng = _shopLocation.longitude +
        (_homeLocation.longitude - _shopLocation.longitude) * _progress;
    // Add tiny random wobble for realism
    return LatLng(
      lat + (_random.nextDouble() - 0.5) * 0.0002,
      lng + (_random.nextDouble() - 0.5) * 0.0002,
    );
  }

  double get progress => _progress;
  bool get hasArrived => _progress >= 1.0;
  LatLng get homeLocation => _homeLocation;

  Duration get estimatedTimeRemaining {
    final remaining = 1.0 - _progress;
    final seconds = (remaining * 600).round(); // ~10 min total journey
    return Duration(seconds: seconds);
  }

  void startTracking(void Function(LatLng location) onUpdate) {
    _progress = 0.0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Move roughly 0.3-0.7% per tick (variable speed for realism)
      _progress += 0.003 + _random.nextDouble() * 0.004;
      if (_progress >= 1.0) {
        _progress = 1.0;
        timer.cancel();
      }
      onUpdate(currentLocation);
    });
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    _progress = 0.0;
  }

  void dispose() {
    _timer?.cancel();
  }
}
