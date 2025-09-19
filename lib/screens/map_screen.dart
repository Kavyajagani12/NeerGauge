import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../models/station_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  late final List<Station> _stations;
  Station? _selected;
  final List<String> _mapboxStyles = const [
    'outdoors-v12',
    'streets-v12',
    'satellite-streets-v12',
    'dark-v11',
    'light-v11',
  ];
  int _styleIndex = 0;
  late final String _mapboxToken =
      (const String.fromEnvironment('MAPBOX_TOKEN').isEmpty)
          ? 'pk.eyJ1Ijoia2F2eWFqYWdhbmkyNCIsImEiOiJjbWZqeWpyZngwODM4MmtwdHV1N25jaHNqIn0.uTMNkkGn5LXEs5qCiShQmw'
          : const String.fromEnvironment('MAPBOX_TOKEN');

  @override
  void initState() {
    super.initState();
    _stations = mockStations();
  }

  void _focusStation(Station s) {
    setState(() => _selected = s);
    _mapController.move(LatLng(s.latitude, s.longitude), 7.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(22.3511148, 78.6677428),
              initialZoom: 4.5,
            ),
            children: [
              _buildBaseLayer(_mapboxToken, _mapboxStyles[_styleIndex]),
              MarkerLayer(
                markers: _stations
                    .map((s) => Marker(
                          point: LatLng(s.latitude, s.longitude),
                          width: 32,
                          height: 32,
                          child: GestureDetector(
                            onTap: () => _focusStation(s),
                            child: _buildMarkerDot(s),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          // Top-left title card
          Positioned(left: 12, top: 12, child: _TitleCard(totalActive: _stations.length)),
          // Top-right search button
          Positioned(
            right: 12,
            top: 12,
            child: ElevatedButton.icon(
              onPressed: () => _openSearch(context),
              icon: const Icon(Icons.search),
              label: const Text('Search Stations'),
            ),
          ),
          // Style switcher
          Positioned(
            right: 12,
            top: 62,
            child: ElevatedButton.icon(
              onPressed: _cycleStyle,
              icon: const Icon(Icons.palette_outlined),
              label: const Text('Style'),
            ),
          ),
          // Bottom-left legend
          Positioned(left: 12, bottom: 12, child: _LegendPanel(stations: _stations)),

          // Right-side details panel
          if (_selected != null)
            Positioned(
              right: 12,
              top: 12,
              bottom: 12,
              child: _DetailsSidePanel(
                station: _selected!,
                onClose: () => setState(() => _selected = null),
              ),
            ),
        ],
      ),
    );
  }

  void _cycleStyle() {
    setState(() {
      _styleIndex = (_styleIndex + 1) % _mapboxStyles.length;
    });
  }

  Widget _buildMarkerDot(Station s) {
    final ringColor = s.status == StationStatus.high
        ? const Color(0xFF2196F3) // Blue
        : s.status == StationStatus.optimal
            ? const Color(0xFF4CAF50) // Green
            : s.status == StationStatus.medium
                ? const Color(0xFFFFA000) // Orange
                : const Color(0xFFD32F2F); // Red
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 2))],
        border: Border.all(color: ringColor, width: 5), // ✅ thinner ring
      ),
    );
  }

  void _openSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: _StationSearchDelegate(_stations, onSelected: _focusStation),
    );
  }

  void _showStationBottomSheet(Station s) {}
}

// Search delegate for station quick find
class _StationSearchDelegate extends SearchDelegate {
  final List<Station> stations;
  final ValueChanged<Station> onSelected;
  _StationSearchDelegate(this.stations, {required this.onSelected});

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => _buildSuggestions();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSuggestions();

  Widget _buildSuggestions() {
    final q = query.toLowerCase();
    final list = stations
        .where((s) => s.stationId.toLowerCase().contains(q) ||
            s.location.toLowerCase().contains(q))
        .toList();
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        final s = list[i];
        return ListTile(
          title: Text(s.stationId),
          subtitle: Text(s.location),
          onTap: () {
            onSelected(s);
            close(context, null);
          },
        );
      },
    );
  }
}

// Right-side details panel (dark header + dark tiles, light text)
class _DetailsSidePanel extends StatelessWidget {
  final Station station;
  final VoidCallback onClose;
  const _DetailsSidePanel({required this.station, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF111318),
                border: Border(bottom: BorderSide(color: Color(0xFF1E222A))),
              ),
              child: Row(
                children: [
                  const Expanded(child: Text('Station Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white))),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white70))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(station.location, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _metricBox(title: 'Current Level', value: '${station.waterLevelMeters.toStringAsFixed(1)}m'),
                        const SizedBox(width: 12),
                        _metricBox(title: 'Capacity', value: '${(station.fillFraction * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _metricBox(title: 'Total Depth', value: '${station.maxWaterLevelMeters.toStringAsFixed(0)}m'),
                        const SizedBox(width: 12),
                        _metricBox(title: 'Installed', value: '${station.installedYear}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Technical Information', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1976D2))),
                    const SizedBox(height: 10),
                    _infoGrid(
                      leftTitle: 'Aquifer Type', leftValue: station.aquiferType,
                      rightTitle: 'Well Type', rightValue: station.wellType,
                    ),
                    const SizedBox(height: 10),
                    _infoGrid(
                      leftTitle: 'Telemetry', leftValue: station.telemetry,
                      rightTitle: 'Last Updated', rightValue: station.lastUpdated.toString().split('.').first,
                    ),
                    const SizedBox(height: 16),
                    Text('ID: ${station.stationId}', style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text('Lat: ${station.latitude.toStringAsFixed(4)}   Lng: ${station.longitude.toStringAsFixed(4)}', style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _metricBox({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E222A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2C313A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _infoGrid({required String leftTitle, required String leftValue, required String rightTitle, required String rightValue}) {
    return Row(
      children: [
        Expanded(child: _infoCell(leftTitle, leftValue)),
        const SizedBox(width: 12),
        Expanded(child: _infoCell(rightTitle, rightValue)),
      ],
    );
  }

  Widget _infoCell(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

TileLayer _buildBaseLayer(String mapboxToken, String mapboxStyleId) {
  if (mapboxToken.isEmpty) {
    return TileLayer(
      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      subdomains: const ['a', 'b', 'c'],
      userAgentPackageName: 'com.example.neer_gauge',
    );
  }
  return TileLayer(
    urlTemplate:
        'https://api.mapbox.com/styles/v1/mapbox/'
        '$mapboxStyleId/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxToken',
    userAgentPackageName: 'com.example.neer_gauge',
  );
}

class _TitleCard extends StatelessWidget {
  final int totalActive;
  const _TitleCard({required this.totalActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111318), // ✅ dark background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('India DWLR Network',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            'Real-time Groundwater Monitoring System • $totalActive Active Stations',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _LegendPanel extends StatelessWidget {
  final List<Station> stations;
  const _LegendPanel({required this.stations});

  int _count(bool Function(Station s) predicate) => stations.where(predicate).length;

  @override
  Widget build(BuildContext context) {
    final high = _count((s) => s.status == StationStatus.high);
    final normal = _count((s) => s.status == StationStatus.optimal);
    final low = _count((s) => s.status == StationStatus.medium);
    final critical = _count((s) => s.status == StationStatus.critical);
    final healthy = high + normal;
    final atRisk = low + critical;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Water Level Status', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _legendItem(const Color(0xFF2196F3), 'High (>80% capacity)'), // ✅ fixed
          _legendItem(const Color(0xFF4CAF50), 'Normal (40-80%)'),
          _legendItem(const Color(0xFFFFA000), 'Low (20-40%)'),
          _legendItem(const Color(0xFFD32F2F), 'Critical (<20%)'),
          _legendItem(Colors.grey, 'Inactive'),
          const SizedBox(height: 12),
          Row(
            children: [
              _counterTile(healthy, 'Healthy', const Color(0xFF2196F3)),
              const SizedBox(width: 12),
              _counterTile(atRisk, 'At Risk', const Color(0xFFD32F2F)),
            ],
          )
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
      ]),
    );
  }

  Widget _counterTile(int value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Text('$value', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
