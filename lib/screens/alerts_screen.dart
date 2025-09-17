import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../widgets/summary_card.dart';
import '../widgets/alert_list_item.dart';
import '../theme/app_colors.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = mockAlerts();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Alerts & Notifications'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Filter Alerts', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: const [
                _FilterChip(label: 'All', selected: true, count: 12),
                _FilterChip(label: 'Critical', count: 3, color: AppColors.statusCritical),
                _FilterChip(label: 'Moderate', count: 5, color: AppColors.statusMedium),
                _FilterChip(label: 'General', count: 4, color: AppColors.statusHigh),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                SizedBox(width: 240, child: SummaryCard(title: 'Critical', value: '3', icon: Icons.error_outline, color: AppColors.statusCritical)),
                SizedBox(width: 240, child: SummaryCard(title: 'Moderate', value: '5', icon: Icons.warning_amber_outlined, color: AppColors.statusMedium)),
                SizedBox(width: 240, child: SummaryCard(title: 'General', value: '4', icon: Icons.info_outline, color: AppColors.statusHigh)),
                SizedBox(width: 240, child: SummaryCard(title: 'Total Today', value: '12', icon: Icons.notifications_active_outlined)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Recent Alerts', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Alert Center', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.statusCritical.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('2 new', style: TextStyle(color: AppColors.statusCritical, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    TextButton(onPressed: () {}, child: const Text('Mark All Read')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...alerts.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AlertListItem(alert: a),
                )),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int count;
  final Color? color;
  const _FilterChip({required this.label, this.selected = false, required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text('$label  $count'),
      selected: selected,
      onSelected: (_) {},
      selectedColor: (color ?? AppColors.primaryBlue).withValues(alpha: 0.15),
      side: const BorderSide(color: Colors.black12),
      labelStyle: TextStyle(color: color ?? AppColors.textColorPrimary),
    );
  }
}
