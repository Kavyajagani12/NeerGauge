import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/station_status_card.dart';
import '../widgets/water_monitoring_card.dart';
import '../models/station_model.dart';
import '../models/alert_model.dart';
import 'alerts_screen.dart';
import 'map_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Station> _filteredStations = [];
  List<Station> _displayedStations = [];
  int _displayCount = 3;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredStations = mockStations();
    _updateDisplayedStations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateDisplayedStations() {
    setState(() {
      _displayedStations = _filteredStations.take(_displayCount).toList();
    });
  }

  void _filterStations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStations = mockStations();
      } else {
        _filteredStations = mockStations().where((station) {
          return station.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _displayCount = 3;
      _updateDisplayedStations();
    });
  }

  void _loadMoreStations() {
    setState(() {
      _displayCount += 3;
      _updateDisplayedStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _TopBar()),
          SliverToBoxAdapter(child: _SearchSection()),
          _WaterMonitoringCards(),
        ],
      ),
    );
  }

  Widget _SearchSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search by District or State',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by district or state...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: _filterStations,
          ),
        ],
      ),
    );
  }

  Widget _WaterMonitoringCards() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index < _displayedStations.length) {
              return WaterMonitoringCard(
                station: _displayedStations[index],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AnalyticsScreen(),
                    ),
                  );
                },
              );
            } else if (index == _displayedStations.length && _displayedStations.length < _filteredStations.length) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _loadMoreStations,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Load More'),
                  ),
                ),
              );
            }
            return null;
          },
          childCount: _displayedStations.length + (_displayedStations.length < _filteredStations.length ? 1 : 0),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unreadCount = mockAlerts().where((a) => !a.isRead).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Left: App Logo
          const _NeerGaugeLogo(size: 40),
          const Spacer(),
          // Right: Profile, Settings, Alerts buttons
          Row(
            children: [
              _IconSquare(
                icon: Icons.person_outline,
                onTap: () {
                  // TODO: Navigate to profile
                },
                size: 44,
              ),
              const SizedBox(width: 8),
              _IconSquare(
                icon: Icons.settings_outlined,
                onTap: () {
                  // TODO: Navigate to settings
                },
                size: 44,
              ),
              const SizedBox(width: 8),
              _IconSquare(
                icon: Icons.warning_amber_outlined,
                showDot: unreadCount > 0,
                badgeCount: unreadCount,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AlertsScreen()),
                ),
                size: 44,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NeerGaugeLogo extends StatelessWidget {
  final double size;
  const _NeerGaugeLogo({this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/logo/neergauge.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) {
          // Fallback to vector-style painter if asset not found
          return CustomPaint(size: Size.square(size), painter: _LogoPainter());
        },
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF1976D2);

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.3, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.8, size.width * 0.5, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width * 0.7, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width * 0.5, size.height * 0.1);
    path.close();

    paint.color = const Color(0xFF4FC3F7);
    canvas.drawPath(path, paint);

    paint.color = const Color(0xFF81D4FA);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.45), size.width * 0.15, paint);

    strokePaint.color = const Color(0xFF1976D2);
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.35),
      strokePaint,
    );

    paint.color = const Color(0xFF2196F3);
    final wave1 = Path();
    wave1.moveTo(size.width * 0.2, size.height * 0.7);
    wave1.quadraticBezierTo(size.width * 0.35, size.height * 0.65, size.width * 0.5, size.height * 0.7);
    wave1.quadraticBezierTo(size.width * 0.65, size.height * 0.75, size.width * 0.8, size.height * 0.7);
    canvas.drawPath(wave1, paint);

    paint.color = const Color(0xFF1976D2);
    final wave2 = Path();
    wave2.moveTo(size.width * 0.1, size.height * 0.85);
    wave2.quadraticBezierTo(size.width * 0.3, size.height * 0.8, size.width * 0.5, size.height * 0.85);
    wave2.quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width * 0.9, size.height * 0.85);
    canvas.drawPath(wave2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IconSquare extends StatelessWidget {
  final IconData icon;
  final bool showDot;
  final int? badgeCount;
  final VoidCallback? onTap;
  final double size;
  const _IconSquare({required this.icon, this.showDot = false, this.badgeCount, this.onTap, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.22),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Icon(icon, color: AppColors.textColorPrimary, size: size * 0.5),
      ),
    );

    if (!showDot && (badgeCount == null || badgeCount == 0)) return button;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        button,
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(label)]),
    );
  }
}

