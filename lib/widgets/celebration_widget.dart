import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dadaroo/theme/app_theme.dart';

class CelebrationWidget extends StatefulWidget {
  final VoidCallback? onComplete;

  const CelebrationWidget({super.key, this.onComplete});

  @override
  State<CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<CelebrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bounceController;
  final _random = Random();
  late List<_Confetti> _confettiPieces;

  @override
  void initState() {
    super.initState();
    _confettiPieces = List.generate(30, (_) => _Confetti(_random));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Confetti
            ..._confettiPieces.map((confetti) {
              final progress = _controller.value;
              return Positioned(
                left: confetti.startX +
                    sin(progress * confetti.wobbleFreq) * confetti.wobbleAmp,
                top: -20 + progress * (MediaQuery.of(context).size.height + 40),
                child: Transform.rotate(
                  angle: progress * confetti.rotationSpeed,
                  child: Container(
                    width: confetti.size,
                    height: confetti.size * 1.5,
                    decoration: BoxDecoration(
                      color: confetti.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
            // Main celebration content
            Center(
              child: AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _bounceController.value * 0.1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🎉',
                          style: TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'DAD\'S HOME!',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryOrange,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '🍕 Food has arrived! 🍕',
                          style: TextStyle(
                            fontSize: 22,
                            color: AppTheme.warmBrown,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Confetti {
  late double startX;
  late double size;
  late Color color;
  late double wobbleFreq;
  late double wobbleAmp;
  late double rotationSpeed;

  static const _colors = [
    AppTheme.primaryOrange,
    AppTheme.accentYellow,
    AppTheme.starGold,
    AppTheme.warmBrown,
    AppTheme.successGreen,
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
  ];

  _Confetti(Random random) {
    startX = random.nextDouble() * 400;
    size = 6 + random.nextDouble() * 8;
    color = _colors[random.nextInt(_colors.length)];
    wobbleFreq = 2 + random.nextDouble() * 6;
    wobbleAmp = 20 + random.nextDouble() * 40;
    rotationSpeed = 2 + random.nextDouble() * 8;
  }
}
