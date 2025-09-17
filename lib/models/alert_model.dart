enum AlertSeverity { critical, moderate, general }

class AlertItem {
  final AlertSeverity severity;
  final String title;
  final String description;
  final String location;
  final DateTime timestamp;
  final bool isRead;

  const AlertItem({
    required this.severity,
    required this.title,
    required this.description,
    required this.location,
    required this.timestamp,
    this.isRead = false,
  });
}

List<AlertItem> mockAlerts() {
  final now = DateTime.now();
  return [
    AlertItem(
      severity: AlertSeverity.critical,
      title: 'Critical Water Level',
      description:
          'DWLR-001 Delhi station showing critical water levels below 5m threshold',
      location: 'Delhi, India',
      timestamp: now.subtract(const Duration(minutes: 2)),
      isRead: false,
    ),
    AlertItem(
      severity: AlertSeverity.moderate,
      title: 'Recharge Rate Low',
      description: 'Station DWLR-003 recharge rate trending low',
      location: 'Maharashtra, India',
      timestamp: now.subtract(const Duration(minutes: 10)),
      isRead: true,
    ),
  ];
}
