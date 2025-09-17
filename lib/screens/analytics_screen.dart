import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Analytics')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _ChartCard(title: 'Average Water Level (m)'),
            SizedBox(height: 12),
            _ChartCard(title: 'Recharge Rate (mm/day)'),
            SizedBox(height: 12),
            _ChartCard(title: 'Alerts Over Time'),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  const _ChartCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                ]),
              ),
              child: const Center(child: Text('Chart placeholder')),
            ),
          ],
        ),
      ),
    );
  }
}
