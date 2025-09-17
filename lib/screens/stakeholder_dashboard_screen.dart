import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StakeholderDashboardScreen extends StatelessWidget {
  const StakeholderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Multi-Stakeholder Views'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Farmer'),
                Tab(text: 'Research'),
                Tab(text: 'Policy'),
                Tab(text: 'Urban'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _FarmerTab(),
              Center(child: Text('Research - Coming soon')),
              Center(child: Text('Policy - Coming soon')),
              Center(child: Text('Urban - Coming soon')),
            ],
          ),
        ),
      ),
    );
  }
}

class _FarmerTab extends StatelessWidget {
  const _FarmerTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Text('Farmer Dashboard', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
              label: const Text('Alerts'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            SizedBox(width: 320, child: _MetricCard(title: 'Irrigation Water Available', value: '85%', tag: 'good', progress: 0.85, color: AppColors.statusOptimal)),
            SizedBox(width: 320, child: _MetricCard(title: 'Groundwater Depth', value: '12.5m', tag: 'medium', color: AppColors.statusMedium)),
            SizedBox(width: 320, child: _MetricCard(title: 'Seasonal Forecast', value: 'Favorable', tag: 'good', color: AppColors.statusOptimal)),
          ],
        ),
        const SizedBox(height: 16),
        Text('Recent Alerts & Recommendations', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        _DotItem(text: 'Water level dropping in nearby wells'),
        _DotItem(text: 'Optimal time for groundwater recharge'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('View Nearby Wells'))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Irrigation Planner'))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Weather Forecast'))),
          ],
        )
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String tag;
  final double? progress;
  final Color color;
  const _MetricCard({required this.title, required this.value, required this.tag, required this.color, this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                  child: Text(tag, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            if (progress != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress, color: color, backgroundColor: color.withValues(alpha: 0.15), minHeight: 8),
            ]
          ],
        ),
      ),
    );
  }
}

class _DotItem extends StatelessWidget {
  final String text;
  const _DotItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.statusOptimal, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
