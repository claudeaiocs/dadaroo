import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dadaroo/config/app_config.dart';
import 'package:dadaroo/providers/app_provider.dart';
import 'package:dadaroo/theme/app_theme.dart';
import 'package:dadaroo/widgets/star_rating_widget.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final history = provider.deliveryHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('📋 History')),
      body: history.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatsHeader(provider),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: AppTheme.primaryOrange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Deliveries',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...history.map((delivery) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightOrange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    delivery.takeawayEmoji,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      delivery.takeawayDisplayName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.darkBrown,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${delivery.dadName} • ${DateFormat('MMM d, h:mm a').format(delivery.startTime)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.warmBrown.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    if (delivery.actualDuration != null)
                                      Text(
                                        '${delivery.actualDuration!.inMinutes} min delivery',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.warmBrown.withValues(alpha: 0.6),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (delivery.rating != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    StarRatingWidget(
                                      rating: delivery.rating!.average,
                                      size: 16,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      delivery.rating!.average.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryOrange,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  'No rating',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.warmBrown.withValues(alpha: 0.5),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsHeader(AppProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppTheme.primaryOrange.withValues(alpha: 0.08),
      child: Column(
        children: [
          Text(
            '📊 ${appConfig.statsLabel}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                '🏆',
                'Favourite',
                provider.favouriteTakeaway?.displayName ?? '-',
              ),
              _buildStatCard(
                '⏱️',
                'Avg Time',
                provider.averageDeliveryTime != null
                    ? '${provider.averageDeliveryTime!.inMinutes}m'
                    : '-',
              ),
              _buildStatCard(
                '⭐',
                'Best Rating',
                provider.bestRating?.toStringAsFixed(1) ?? '-',
              ),
              _buildStatCard(
                '📦',
                'Total',
                '${provider.deliveryHistory.length}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (provider.takeawayStats.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Takeaway Breakdown',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...(provider.takeawayStats.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value)))
                .map((entry) {
              final maxCount = provider.takeawayStats.values
                  .reduce((a, b) => a > b ? a : b);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(entry.key.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        entry.key.displayName,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: entry.value / maxCount,
                          backgroundColor: AppTheme.lightOrange,
                          valueColor: AlwaysStoppedAnimation(
                            AppTheme.primaryOrange,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryOrange,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.warmBrown.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📋', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'No deliveries yet!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a food run to see your history here',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.warmBrown.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
