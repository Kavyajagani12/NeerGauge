import 'package:flutter/material.dart';

enum StationStatus { optimal, critical, medium, high }
enum Trend { up, down, stable }

class Station {
  final String stationId;
  final String location;
  final StationStatus status;
  final double waterLevelMeters;
  final double maxWaterLevelMeters;
  final Trend trend;
  final double rechargeRateMmPerDay;
  final DateTime lastUpdated;

  const Station({
    required this.stationId,
    required this.location,
    required this.status,
    required this.waterLevelMeters,
    required this.maxWaterLevelMeters,
    required this.trend,
    required this.rechargeRateMmPerDay,
    required this.lastUpdated,
  });

  double get fillFraction =>
      (waterLevelMeters / maxWaterLevelMeters).clamp(0.0, 1.0);

  Color statusColor() {
    switch (status) {
      case StationStatus.optimal:
        return const Color(0xFF4CAF50);
      case StationStatus.critical:
        return const Color(0xFFF44336);
      case StationStatus.medium:
        return const Color(0xFFFFC107);
      case StationStatus.high:
        return const Color(0xFF2196F3);
    }
  }
}

List<Station> mockStations() {
  final now = DateTime.now();
  return [
    Station(
      stationId: 'DWLR-001',
      location: 'Delhi, India',
      status: StationStatus.optimal,
      waterLevelMeters: 12.5,
      maxWaterLevelMeters: 20,
      trend: Trend.stable,
      rechargeRateMmPerDay: 2.8,
      lastUpdated: now.subtract(const Duration(minutes: 2)),
    ),
    Station(
      stationId: 'DWLR-002',
      location: 'Rajasthan, India',
      status: StationStatus.critical,
      waterLevelMeters: 4.2,
      maxWaterLevelMeters: 15,
      trend: Trend.down,
      rechargeRateMmPerDay: 0.3,
      lastUpdated: now.subtract(const Duration(minutes: 1)),
    ),
    Station(
      stationId: 'DWLR-003',
      location: 'Maharashtra, India',
      status: StationStatus.medium,
      waterLevelMeters: 8.7,
      maxWaterLevelMeters: 18,
      trend: Trend.up,
      rechargeRateMmPerDay: 1.7,
      lastUpdated: now.subtract(const Duration(minutes: 3)),
    ),
    Station(
      stationId: 'DWLR-004',
      location: 'Kerala, India',
      status: StationStatus.high,
      waterLevelMeters: 16.3,
      maxWaterLevelMeters: 18,
      trend: Trend.stable,
      rechargeRateMmPerDay: 4.2,
      lastUpdated: now.subtract(const Duration(minutes: 1)),
    ),
  ];
}
