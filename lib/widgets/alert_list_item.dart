import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../theme/app_colors.dart';

class AlertListItem extends StatelessWidget {
  final AlertItem alert;
  const AlertListItem({super.key, required this.alert});

  Color _bgFor(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical:
        return AppColors.statusCritical.withValues(alpha: 0.08);
      case AlertSeverity.moderate:
        return AppColors.statusMedium.withValues(alpha: 0.08);
      case AlertSeverity.general:
        return AppColors.statusHigh.withValues(alpha: 0.06);
    }
  }

  Color _iconFor(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical:
        return AppColors.statusCritical;
      case AlertSeverity.moderate:
        return AppColors.statusMedium;
      case AlertSeverity.general:
        return AppColors.statusHigh;
    }
  }

  IconData _symbol(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical:
        return Icons.error_outline;
      case AlertSeverity.moderate:
        return Icons.warning_amber_outlined;
      case AlertSeverity.general:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgFor(alert.severity);
    final iconColor = _iconFor(alert.severity);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_symbol(alert.severity), color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _severityLabel(alert.severity),
                        style: TextStyle(color: iconColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!alert.isRead)
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.statusHigh, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(alert.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 16, color: AppColors.textColorSecondary),
                    const SizedBox(width: 4),
                    Text(alert.location, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 16, color: AppColors.textColorSecondary),
                    const SizedBox(width: 4),
                    Text(_timeAgo(alert.timestamp), style: Theme.of(context).textTheme.bodySmall),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String _severityLabel(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical:
        return 'Critical';
      case AlertSeverity.moderate:
        return 'Moderate';
      case AlertSeverity.general:
        return 'General';
    }
  }

  String _timeAgo(DateTime ts) {
    final diff = DateTime.now().difference(ts);
    if (diff.inMinutes < 1) return 'Just now';
    return '${diff.inMinutes} mins ago';
  }
}
