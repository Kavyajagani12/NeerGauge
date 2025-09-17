import 'package:flutter/material.dart';
import '../models/station_model.dart';
import '../theme/app_colors.dart';

class StationStatusCard extends StatelessWidget {
  final Station station;

  const StationStatusCard({super.key, required this.station});

  String _statusLabel(StationStatus status) {
    switch (status) {
      case StationStatus.optimal:
        return 'Optimal';
      case StationStatus.critical:
        return 'Critical';
      case StationStatus.medium:
        return 'Medium';
      case StationStatus.high:
        return 'High';
    }
  }

  IconData _trendIcon(Trend trend) {
    switch (trend) {
      case Trend.up:
        return Icons.arrow_upward;
      case Trend.down:
        return Icons.arrow_downward;
      case Trend.stable:
        return Icons.remove;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = station.statusColor();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.water_drop, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.stationId,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        station.location,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textColorSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(station.status),
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${station.waterLevelMeters.toStringAsFixed(1)}m',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Icon(_trendIcon(station.trend), size: 18, color: AppColors.textColorSecondary),
                const SizedBox(width: 4),
                Text(
                  station.trend == Trend.up
                      ? 'Up'
                      : station.trend == Trend.down
                          ? 'Down'
                          : 'Stable',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textColorSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Water Level', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: station.fillFraction,
                minHeight: 10,
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0m', style: Theme.of(context).textTheme.bodySmall),
                Text('${station.maxWaterLevelMeters.toStringAsFixed(0)}m',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Recharge Rate:', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(width: 8),
                        Text(
                          '${station.rechargeRateMmPerDay.toStringAsFixed(2)} mm/day',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Last updated: ${_minutesAgo(station.lastUpdated)} mins ago',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textColorSecondary),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Text('Recharge Rate:', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 8),
                  Text(
                    '${station.rechargeRateMmPerDay.toStringAsFixed(2)} mm/day',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text('Last updated: ', style: Theme.of(context).textTheme.bodySmall),
                  Text(
                    '${_minutesAgo(station.lastUpdated)} mins ago',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textColorSecondary),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  String _minutesAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    return diff.inMinutes.toString();
  }
}
