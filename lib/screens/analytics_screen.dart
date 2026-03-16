import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Widget summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            summaryCard(
              icon: Icons.route,
              title: 'Total Route Distance',
              value: '6.3 miles',
            ),
            summaryCard(
              icon: Icons.scale,
              title: 'Total Gear Weight',
              value: '7.0 lbs',
            ),
            summaryCard(
              icon: Icons.payments,
              title: 'Total Planned Expenses',
              value: '\$83',
            ),
            summaryCard(
              icon: Icons.task_alt,
              title: 'Tasks Completed',
              value: '2 / 3',
            ),
          ],
        ),
      ),
    );
  }
}