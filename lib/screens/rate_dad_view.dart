import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dadaroo/models/rating.dart';
import 'package:dadaroo/providers/app_provider.dart';
import 'package:dadaroo/theme/app_theme.dart';
import 'package:dadaroo/widgets/star_rating_widget.dart';

class RateDadView extends StatefulWidget {
  const RateDadView({super.key});

  @override
  State<RateDadView> createState() => _RateDadViewState();
}

class _RateDadViewState extends State<RateDadView> {
  double _speed = 0;
  double _foodChoice = 0;
  double _communication = 0;
  double _overallDadness = 0;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('⭐ Rate Your Dad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (provider.activeDelivery != null && !_submitted)
              _buildRatingForm(provider)
            else if (_submitted)
              _buildThankYou()
            else
              _buildNoDelivery(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingForm(AppProvider provider) {
    final delivery = provider.activeDelivery!;
    return Column(
      children: [
        // Header
        Text(
          delivery.takeawayEmoji,
          style: const TextStyle(fontSize: 60),
        ),
        const SizedBox(height: 8),
        Text(
          'How did ${delivery.dadName} do?',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        Text(
          '${delivery.takeawayDisplayName} delivery',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.warmBrown.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 32),

        // Rating categories
        _buildRatingCategory(
          '⚡ Speed',
          'How fast was the delivery?',
          _speed,
          (v) => setState(() => _speed = v),
        ),
        _buildRatingCategory(
          '🍽️ Food Choice',
          'Great pick for dinner?',
          _foodChoice,
          (v) => setState(() => _foodChoice = v),
        ),
        _buildRatingCategory(
          '📱 Communication',
          'Did Dad keep you updated?',
          _communication,
          (v) => setState(() => _communication = v),
        ),
        _buildRatingCategory(
          '👨 Overall Dadness',
          'The complete Dad experience',
          _overallDadness,
          (v) => setState(() => _overallDadness = v),
        ),

        const SizedBox(height: 24),

        // Overall average display
        if (_speed > 0 && _foodChoice > 0 && _communication > 0 && _overallDadness > 0)
          Card(
            color: AppTheme.lightOrange,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Overall: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  StarRatingWidget(
                    rating: (_speed + _foodChoice + _communication + _overallDadness) / 4,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ((_speed + _foodChoice + _communication + _overallDadness) / 4)
                        .toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_speed > 0 &&
                    _foodChoice > 0 &&
                    _communication > 0 &&
                    _overallDadness > 0)
                ? () {
                    provider.rateDelivery(Rating(
                      speed: _speed,
                      foodChoice: _foodChoice,
                      communication: _communication,
                      overallDadness: _overallDadness,
                    ));
                    setState(() => _submitted = true);
                  }
                : null,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text('Submit Rating! 🎉', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => provider.skipRating(),
          child: const Text(
            'Skip',
            style: TextStyle(color: AppTheme.warmBrown),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingCategory(
    String title,
    String subtitle,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.warmBrown.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: StarRatingWidget(
                rating: value,
                size: 40,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYou() {
    return Column(
      children: [
        const SizedBox(height: 60),
        const Text('🎉', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        const Text(
          'Thanks for rating!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Dad appreciates the feedback!',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.warmBrown.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _submitted = false;
              _speed = 0;
              _foodChoice = 0;
              _communication = 0;
              _overallDadness = 0;
            });
          },
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _buildNoDelivery(AppProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Badges section
        const Text(
          '🏆 Badges & Achievements',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        const SizedBox(height: 16),

        if (provider.currentDad.badges.isEmpty)
          Card(
            color: AppTheme.lightOrange,
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Text('🎯', style: TextStyle(fontSize: 40)),
                  SizedBox(height: 8),
                  Text(
                    'No badges yet!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  Text(
                    'Complete deliveries to earn badges',
                    style: TextStyle(color: AppTheme.warmBrown),
                  ),
                ],
              ),
            ),
          )
        else
          ...provider.currentDad.badges.map((badge) => Card(
                child: ListTile(
                  leading: Text(
                    badge.type.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    badge.type.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  subtitle: Text(badge.type.description),
                  trailing: const Icon(
                    Icons.verified,
                    color: AppTheme.starGold,
                  ),
                ),
              )),

        const SizedBox(height: 32),

        // Leaderboard
        const Text(
          '🏅 Dad Leaderboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        const SizedBox(height: 16),

        ...(provider.dads.toList()
              ..sort((a, b) => b.averageRating.compareTo(a.averageRating)))
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key;
          final dad = entry.value;
          final medals = ['🥇', '🥈', '🥉'];
          return Card(
            color: index == 0 ? AppTheme.lightOrange : null,
            child: ListTile(
              leading: Text(
                index < 3 ? medals[index] : '${index + 1}',
                style: TextStyle(
                  fontSize: index < 3 ? 28 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                dad.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
              ),
              subtitle: Text(
                '${dad.totalDeliveries} deliveries | ${dad.badges.length} badges',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: AppTheme.starGold, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    dad.averageRating > 0
                        ? dad.averageRating.toStringAsFixed(1)
                        : '-',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 16),
        Text(
          'No active delivery to rate.\nStart a food run from the Dad tab!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.warmBrown.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
