import 'package:flutter/material.dart';

enum StationStatus { optimal, critical, medium, high }
enum Trend { up, down, stable }

class Station {
  final String stationId;
  final String location;
  final double latitude;
  final double longitude;
  final StationStatus status;
  final double waterLevelMeters;
  final double maxWaterLevelMeters;
  final Trend trend;
  final double rechargeRateMmPerDay;
  final DateTime lastUpdated;
  final int installedYear;
  final String aquiferType;
  final String wellType;
  final String telemetry;

  const Station({
    required this.stationId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.waterLevelMeters,
    required this.maxWaterLevelMeters,
    required this.trend,
    required this.rechargeRateMmPerDay,
    required this.lastUpdated,
    required this.installedYear,
    required this.aquiferType,
    required this.wellType,
    required this.telemetry,
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
  final base = <Station>[
    Station(
      stationId: 'DWLR-001',
      location: 'Delhi, India',
      latitude: 28.6139,
      longitude: 77.2090,
      status: StationStatus.optimal,
      waterLevelMeters: 12.5,
      maxWaterLevelMeters: 20,
      trend: Trend.stable,
      rechargeRateMmPerDay: 2.8,
      lastUpdated: now.subtract(const Duration(minutes: 2)),
      installedYear: 2019,
      aquiferType: 'Metamorphic',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
    Station(
      stationId: 'DWLR-002',
      location: 'Rajasthan, India',
      latitude: 26.9124,
      longitude: 75.7873,
      status: StationStatus.critical,
      waterLevelMeters: 4.2,
      maxWaterLevelMeters: 15,
      trend: Trend.down,
      rechargeRateMmPerDay: 0.3,
      lastUpdated: now.subtract(const Duration(minutes: 1)),
      installedYear: 2020,
      aquiferType: 'Alluvial',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
    Station(
      stationId: 'DWLR-003',
      location: 'Maharashtra, India',
      latitude: 18.5204,
      longitude: 73.8567,
      status: StationStatus.medium,
      waterLevelMeters: 8.7,
      maxWaterLevelMeters: 18,
      trend: Trend.up,
      rechargeRateMmPerDay: 1.7,
      lastUpdated: now.subtract(const Duration(minutes: 3)),
      installedYear: 2018,
      aquiferType: 'Basalt',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
    Station(
      stationId: 'DWLR-004',
      location: 'Kerala, India',
      latitude: 10.8505,
      longitude: 76.2711,
      status: StationStatus.high,
      waterLevelMeters: 16.3,
      maxWaterLevelMeters: 18,
      trend: Trend.stable,
      rechargeRateMmPerDay: 4.2,
      lastUpdated: now.subtract(const Duration(minutes: 1)),
      installedYear: 2017,
      aquiferType: 'Laterite',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
    // Add more stations to approximate a network of ~50 markers across India
    Station(
      stationId: 'DWLR-005',
      location: 'Ahmedabad, Gujarat',
      latitude: 23.0225,
      longitude: 72.5714,
      status: StationStatus.medium,
      waterLevelMeters: 9.1,
      maxWaterLevelMeters: 18,
      trend: Trend.up,
      rechargeRateMmPerDay: 1.2,
      lastUpdated: now.subtract(const Duration(minutes: 5)),
      installedYear: 2016,
      aquiferType: 'Alluvial',
      wellType: 'Tube Well',
      telemetry: 'Automatic',
    ),
    Station(
      stationId: 'DWLR-006',
      location: 'Bengaluru, Karnataka',
      latitude: 12.9716,
      longitude: 77.5946,
      status: StationStatus.critical,
      waterLevelMeters: 3.8,
      maxWaterLevelMeters: 16,
      trend: Trend.down,
      rechargeRateMmPerDay: 0.6,
      lastUpdated: now.subtract(const Duration(minutes: 6)),
      installedYear: 2017,
      aquiferType: 'Granite',
      wellType: 'Tube Well',
      telemetry: 'Automatic',
    ),
    Station(
      stationId: 'DWLR-007',
      location: 'Hyderabad, Telangana',
      latitude: 17.3850,
      longitude: 78.4867,
      status: StationStatus.optimal,
      waterLevelMeters: 13.2,
      maxWaterLevelMeters: 22,
      trend: Trend.stable,
      rechargeRateMmPerDay: 2.1,
      lastUpdated: now.subtract(const Duration(minutes: 7)),
      installedYear: 2015,
      aquiferType: 'Alluvial',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
    Station(
      stationId: 'DWLR-008',
      location: 'Kolkata, West Bengal',
      latitude: 22.5726,
      longitude: 88.3639,
      status: StationStatus.high,
      waterLevelMeters: 17.0,
      maxWaterLevelMeters: 20,
      trend: Trend.up,
      rechargeRateMmPerDay: 3.0,
      lastUpdated: now.subtract(const Duration(minutes: 8)),
      installedYear: 2019,
      aquiferType: 'Alluvial',
      wellType: 'Tube Well',
      telemetry: 'Automatic',
    ),
    Station(
      stationId: 'DWLR-009',
      location: 'Chennai, Tamil Nadu',
      latitude: 13.0827,
      longitude: 80.2707,
      status: StationStatus.medium,
      waterLevelMeters: 10.3,
      maxWaterLevelMeters: 19,
      trend: Trend.down,
      rechargeRateMmPerDay: 1.0,
      lastUpdated: now.subtract(const Duration(minutes: 9)),
      installedYear: 2018,
      aquiferType: 'Sedimentary',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
    Station(
      stationId: 'DWLR-010',
      location: 'Jaipur, Rajasthan',
      latitude: 26.9124,
      longitude: 75.7873,
      status: StationStatus.critical,
      waterLevelMeters: 4.0,
      maxWaterLevelMeters: 15,
      trend: Trend.down,
      rechargeRateMmPerDay: 0.4,
      lastUpdated: now.subtract(const Duration(minutes: 10)),
      installedYear: 2016,
      aquiferType: 'Alluvial',
      wellType: 'Tube Well',
      telemetry: 'Automatic',
    ),
    Station(
      stationId: 'DWLR-011',
      location: 'Lucknow, Uttar Pradesh',
      latitude: 26.8467,
      longitude: 80.9462,
      status: StationStatus.optimal,
      waterLevelMeters: 14.0,
      maxWaterLevelMeters: 22,
      trend: Trend.stable,
      rechargeRateMmPerDay: 2.5,
      lastUpdated: now.subtract(const Duration(minutes: 11)),
      installedYear: 2021,
      aquiferType: 'Alluvial',
      wellType: 'Tube Well',
      telemetry: 'Automatic',
    ),
    Station(
      stationId: 'DWLR-012',
      location: 'Bhopal, Madhya Pradesh',
      latitude: 23.2599,
      longitude: 77.4126,
      status: StationStatus.medium,
      waterLevelMeters: 9.9,
      maxWaterLevelMeters: 18,
      trend: Trend.up,
      rechargeRateMmPerDay: 1.4,
      lastUpdated: now.subtract(const Duration(minutes: 12)),
      installedYear: 2017,
      aquiferType: 'Sandstone',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
    Station(
      stationId: 'DWLR-013',
      location: 'Pune, Maharashtra',
      latitude: 18.5204,
      longitude: 73.8567,
      status: StationStatus.high,
      waterLevelMeters: 16.2,
      maxWaterLevelMeters: 19,
      trend: Trend.stable,
      rechargeRateMmPerDay: 2.8,
      lastUpdated: now.subtract(const Duration(minutes: 13)),
      installedYear: 2020,
      aquiferType: 'Basalt',
      wellType: 'Tube Well',
      telemetry: 'Automatic',
    ),
    Station(
      stationId: 'DWLR-014',
      location: 'Surat, Gujarat',
      latitude: 21.1702,
      longitude: 72.8311,
      status: StationStatus.optimal,
      waterLevelMeters: 15.0,
      maxWaterLevelMeters: 20,
      trend: Trend.up,
      rechargeRateMmPerDay: 2.0,
      lastUpdated: now.subtract(const Duration(minutes: 14)),
      installedYear: 2019,
      aquiferType: 'Alluvial',
      wellType: 'Tube Well',
      telemetry: 'Automatic',
    ),
    Station(
      stationId: 'DWLR-015',
      location: 'Nagpur, Maharashtra',
      latitude: 21.1458,
      longitude: 79.0882,
      status: StationStatus.medium,
      waterLevelMeters: 11.1,
      maxWaterLevelMeters: 20,
      trend: Trend.stable,
      rechargeRateMmPerDay: 1.7,
      lastUpdated: now.subtract(const Duration(minutes: 15)),
      installedYear: 2018,
      aquiferType: 'Basalt',
      wellType: 'Tube Well',
      telemetry: 'Manual',
    ),
  ];

  // Programmatically generate additional stations to reach exactly 50
  final List<Station> generated = [];
  // India approx bounds (tight)
  const minLat = 6.5;   // Kanyakumari
  const maxLat = 35.7;  // J&K
  const minLng = 68.0;  // Gujarat west
  const maxLng = 97.5;  // Arunachal east
  final needed = 50 - base.length;

  // Seed locations across India to ensure all points stay inside India
  const seeds = [
    [28.6139, 77.2090], // Delhi
    [19.0760, 72.8777], // Mumbai
    [13.0827, 80.2707], // Chennai
    [22.5726, 88.3639], // Kolkata
    [12.9716, 77.5946], // Bengaluru
    [17.3850, 78.4867], // Hyderabad
    [23.0225, 72.5714], // Ahmedabad
    [18.5204, 73.8567], // Pune
    [26.8467, 80.9462], // Lucknow
    [23.2599, 77.4126], // Bhopal
    [26.9124, 75.7873], // Jaipur
    [21.1702, 72.8311], // Surat
    [25.3176, 82.9739], // Varanasi
    [15.2993, 74.1240], // Goa region
    [24.5854, 73.7125], // Udaipur
  ];

  double clamp(double v, double lo, double hi) => v < lo ? lo : (v > hi ? hi : v);

  for (int i = 0; i < needed; i++) {
    final idx = base.length + i + 1;
    final seed = seeds[i % seeds.length];
    // Deterministic small offsets per index to scatter near seeds
    final offLat = (((i * 37) % 21) - 10) * 0.025; // ~±0.25°
    final offLng = (((i * 53) % 21) - 10) * 0.03;  // ~±0.30°
    final lat = clamp(seed[0] + offLat, minLat, maxLat);
    final lng = clamp(seed[1] + offLng, minLng, maxLng);
    final status = i % 4 == 0
        ? StationStatus.high
        : i % 4 == 1
            ? StationStatus.optimal
            : i % 4 == 2
                ? StationStatus.medium
                : StationStatus.critical;
    final wl = 5 + (i % 15).toDouble();
    final maxWl = 18 + (i % 5).toDouble();
    final trend = i % 3 == 0 ? Trend.up : i % 3 == 1 ? Trend.down : Trend.stable;
    final recharge = 0.5 + (i % 8) * 0.4;
    generated.add(Station(
      stationId: 'DWLR-${idx.toString().padLeft(3, '0')}',
      location: 'Station $idx, India',
      latitude: lat,
      longitude: lng,
      status: status,
      waterLevelMeters: wl,
      maxWaterLevelMeters: maxWl,
      trend: trend,
      rechargeRateMmPerDay: recharge,
      lastUpdated: now.subtract(Duration(minutes: 16 + i)),
      installedYear: 2015 + (i % 10),
      aquiferType: i % 2 == 0 ? 'Alluvial' : 'Basalt',
      wellType: 'Tube Well',
      telemetry: i % 3 == 0 ? 'Manual' : 'Automatic',
    ));
  }

  return [...base, ...generated];
}
