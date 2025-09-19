import 'package:flutter/material.dart';
import '../models/station_model.dart';
import '../theme/app_colors.dart';

class WaterMonitoringCard extends StatelessWidget {
  final Station station;
  final VoidCallback? onTap;

  const WaterMonitoringCard({
    super.key,
    required this.station,
    this.onTap,
  });

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

  Color _statusColor(StationStatus status) {
    switch (status) {
      case StationStatus.optimal:
        return Colors.green;
      case StationStatus.critical:
        return Colors.red;
      case StationStatus.medium:
        return Colors.orange;
      case StationStatus.high:
        return Colors.blue;
    }
  }

  String _trendText(Trend trend) {
    switch (trend) {
      case Trend.up:
        return '↑ Up';
      case Trend.down:
        return '↓ Down';
      case Trend.stable:
        return '→ Stable';
    }
  }

  String _minutesAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    return diff.inMinutes.toString();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(station.status);
    final statusLabel = _statusLabel(station.status);
    final trendText = _trendText(station.trend);
    final minutesAgo = _minutesAgo(station.lastUpdated);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Location name and Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    station.location,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColorPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Water Level (large, bold text)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${station.waterLevelMeters.toStringAsFixed(1)}m',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColorPrimary,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  trendText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textColorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Recharge Rate
            Text(
              'Recharge Rate: ${station.rechargeRateMmPerDay.toStringAsFixed(2)} mm/day',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0m',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textColorSecondary,
                      ),
                    ),
                    Text(
                      '${station.maxWaterLevelMeters.toStringAsFixed(0)}m',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textColorSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: station.fillFraction,
                    minHeight: 8,
                    color: statusColor,
                    backgroundColor: statusColor.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Last updated time
            Text(
              'Last updated: $minutesAgo mins ago',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textColorSecondary,
              ),
            ),
            const SizedBox(height: 16),
            // Footer action
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'Click to view analytics',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
