import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dadaroo/config/app_config.dart';
import 'package:dadaroo/providers/app_provider.dart';
import 'package:dadaroo/services/parent_jokes.dart';
import 'package:dadaroo/theme/app_theme.dart';
import 'package:dadaroo/widgets/map_widget.dart';
import 'package:dadaroo/widgets/celebration_widget.dart';

class FamilyView extends StatelessWidget {
  const FamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.showCelebration) {
      return _buildCelebrationView(context, provider);
    }

    if (!provider.isDeliveryActive) {
      return _buildWaitingView();
    }

    return _buildTrackingView(context, provider);
  }

  Widget _buildWaitingView() {
    return Scaffold(
      appBar: AppBar(title: Text('${appConfig.familyMemberEmoji} Family View')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.lightOrange,
                  shape: BoxShape.circle,
                ),
                child: const Text('🍽️', style: TextStyle(fontSize: 64)),
              ),
              const SizedBox(height: 24),
              Text(
                'Waiting for ${appConfig.parentRole}...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "No food run in progress yet.\nTell ${appConfig.parentRole} it's dinner time!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.warmBrown.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                color: AppTheme.lightOrange,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('😄', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ParentJokes.random,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.warmBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingView(BuildContext context, AppProvider provider) {
    final eta = provider.etaRemaining;
    final minutes = eta.inMinutes;
    final seconds = eta.inSeconds % 60;
    final delivery = provider.activeDelivery!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${appConfig.familyMemberEmoji} ${appConfig.parentRole} Tracker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              child: Column(
                children: [
                  Text(
                    delivery.takeawayEmoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${delivery.dadName} is bringing ${delivery.takeawayDisplayName}!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                ],
              ),
            ),

            MockMapWidget(
              dadLocation: provider.currentParentLocation,
              homeLocation: provider.gpsService.homeLocation,
              progress: provider.deliveryProgress,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: provider.parentIsClose
                                ? AppTheme.successGreen
                                : AppTheme.primaryOrange,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${minutes}m ${seconds.toString().padLeft(2, '0')}s',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: provider.parentIsClose
                                  ? AppTheme.successGreen
                                  : AppTheme.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (provider.parentIsClose)
                        _ParentCloseAlert()
                      else
                        Text(
                          '${appConfig.parentRole} is on the way! 🚗',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.warmBrown.withValues(alpha: 0.8),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationView(BuildContext context, AppProvider provider) {
    return Scaffold(
      body: Stack(
        children: [
          const CelebrationWidget(),
          Positioned(
            left: 24,
            right: 24,
            bottom: 60,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    provider.skipRating();
                  },
                  icon: const Icon(Icons.star),
                  label: Text('Rate Your ${appConfig.parentRole}!'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => provider.skipRating(),
                  child: Text(
                    'Skip Rating',
                    style: TextStyle(color: AppTheme.warmBrown),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParentCloseAlert extends StatefulWidget {
  @override
  State<_ParentCloseAlert> createState() => _ParentCloseAlertState();
}

class _ParentCloseAlertState extends State<_ParentCloseAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.successGreen
                .withValues(alpha: 0.15 + _controller.value * 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.successGreen.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎉',
                style: TextStyle(
                  fontSize: 20 + _controller.value * 4,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${appConfig.parentRole.toUpperCase()} IS ALMOST HOME!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
