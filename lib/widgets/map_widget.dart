import 'package:flutter/material.dart';
import 'package:dadaroo/services/mock_gps_service.dart';
import 'package:dadaroo/theme/app_theme.dart';

class MockMapWidget extends StatelessWidget {
  final LatLng? dadLocation;
  final LatLng homeLocation;
  final double progress;

  const MockMapWidget({
    super.key,
    required this.dadLocation,
    required this.homeLocation,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E0D8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warmBrown.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Map background with grid
            CustomPaint(
              size: const Size(double.infinity, 280),
              painter: _MapPainter(progress: progress),
            ),
            // Road path
            CustomPaint(
              size: const Size(double.infinity, 280),
              painter: _RoutePainter(progress: progress),
            ),
            // Home marker
            Positioned(
              right: 40,
              top: 50,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text('🏠', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('HOME',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Dad marker (animated along route)
            if (dadLocation != null)
              Positioned(
                left: 30 + (progress * 240).clamp(0.0, 260.0),
                bottom: 40 + (progress * 100).clamp(0, 120).toDouble(),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryOrange.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Text('🚗', style: TextStyle(fontSize: 24)),
                      ),
                      Container(
                        width: 3,
                        height: 8,
                        color: AppTheme.primaryOrange,
                      ),
                    ],
                  ),
                ),
              ),
            // Progress bar at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
                      valueColor: AlwaysStoppedAnimation(AppTheme.primaryOrange),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🍽️ Takeaway',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.darkBrown.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        '🏠 Home',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.darkBrown.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final double progress;
  _MapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF5EDE3);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw grid streets
    final streetPaint = Paint()
      ..color = const Color(0xFFE0D5C8)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }

    // Draw some "blocks"
    final blockPaint = Paint()..color = const Color(0xFFE8DDD0);
    for (double x = 20; x < size.width - 40; x += 80) {
      for (double y = 20; y < size.height - 60; y += 80) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, 35, 35),
            const Radius.circular(4),
          ),
          blockPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  final double progress;
  _RoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppTheme.primaryOrange.withValues(alpha: 0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(40, size.height - 50)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.4,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.3,
        size.width - 50,
        70,
      );

    canvas.drawPath(path, routePaint);

    // Travelled portion
    final travelledPaint = Paint()
      ..color = AppTheme.primaryOrange
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw dotted line for remaining route
    final dashPaint = Paint()
      ..color = AppTheme.primaryOrange.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, dashPaint);

    // Solid for travelled
    if (progress > 0) {
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
      canvas.drawPath(path, travelledPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) => oldDelegate.progress != progress;
}

