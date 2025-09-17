import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/station_status_card.dart';
import '../models/station_model.dart';
import '../models/alert_model.dart';
import 'alerts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stations = mockStations();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _TopBar()),
          SliverToBoxAdapter(child: _SubHeader()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(child: _HeroSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Real-time Monitoring Dashboard',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth >= 700
                          ? (constraints.maxWidth - 24) / 3
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(width: itemWidth, child: const SummaryCard(title: 'Critical Monitoring', value: '3', icon: Icons.stacked_bar_chart, color: AppColors.statusCritical)),
                          SizedBox(width: itemWidth, child: const SummaryCard(title: 'Water Level', value: '8.7m', icon: Icons.water_drop, color: AppColors.statusHigh)),
                          SizedBox(width: itemWidth, child: const SummaryCard(title: 'Recharge Rate', value: '2.3', icon: Icons.trending_up, color: AppColors.statusOptimal)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Station Details', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final crossAxisCount = width ~/ 320 > 0 ? width ~/ 320 : 1;
                final isNarrow = crossAxisCount == 1;
                final cardHeight = isNarrow ? 270.0 : 220.0;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: cardHeight,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => StationStatusCard(station: stations[index]),
                    childCount: stations.length,
                  ),
                );
              },
            ),
          ),
        ],
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
          // Left: Logo + title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _NeerGaugeLogo(size: 40),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NeerGauge',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  Text('Smart Water Monitor',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textColorSecondary)),
                ],
              )
            ],
          ),
          const SizedBox(width: 8),
          // Right responsive controls
          Flexible(
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.statusOptimal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.wifi, color: AppColors.statusOptimal, size: 18),
                      SizedBox(width: 6),
                      Text('Online', style: TextStyle(color: AppColors.statusOptimal, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                _IconSquare(
                  icon: Icons.warning_amber_outlined,
                  showDot: unreadCount > 0,
                  badgeCount: unreadCount,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlertsScreen()),
                  ),
                  size: 44,
                ),
                const _IconSquare(icon: Icons.person_outline, size: 44),
                const _IconSquare(icon: Icons.settings_outlined, size: 44),
              ],
            ),
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

class _SubHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x11000000))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: const [
          _InfoItem(label: 'Last Updated', value: '17/09/2025, 19:32:24'),
          _InfoItem(label: 'Data Collection', value: '99.2% active'),
          _InfoItem(label: 'System Status', value: 'All services operational'),
          _InfoItem(label: 'Real-time monitoring', value: 'active', dotColor: Colors.green),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? dotColor;
  const _InfoItem({required this.label, required this.value, this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dotColor != null)
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        if (dotColor != null) const SizedBox(width: 6),
        Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Text(
            'Smart India Hackathon 2025',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Revolutionary groundwater monitoring system integrating 5,260 DWLR stations across India.\nReal-time water resource evaluation for sustainable management.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
