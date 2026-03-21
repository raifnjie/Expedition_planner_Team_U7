import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../services/database_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool isLoading = true;
  double totalDistance = 0;
  double totalWeight = 0;
  double totalExpenses = 0;
  int completedTasks = 0;
  int totalTasks = 0;

  Expedition get expedition =>
      ModalRoute.of(context)!.settings.arguments as Expedition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    final distance =
        await DatabaseHelper.instance.getTotalRouteDistance(expedition.id!);
    final weight =
        await DatabaseHelper.instance.getTotalGearWeight(expedition.id!);
    final expenses =
        await DatabaseHelper.instance.getTotalExpenses(expedition.id!);
    final taskStats =
        await DatabaseHelper.instance.getTaskStats(expedition.id!);

    if (!mounted) return;
    setState(() {
      totalDistance = distance;
      totalWeight = weight;
      totalExpenses = expenses;
      completedTasks = taskStats['completed'] ?? 0;
      totalTasks = taskStats['total'] ?? 0;
      isLoading = false;
    });
  }

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
        title: Text('${expedition.name} Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  summaryCard(
                    icon: Icons.route,
                    title: 'Total Route Distance',
                    value: '${totalDistance.toStringAsFixed(1)} miles',
                  ),
                  summaryCard(
                    icon: Icons.scale,
                    title: 'Total Gear Weight',
                    value: '${totalWeight.toStringAsFixed(1)} lbs',
                  ),
                  summaryCard(
                    icon: Icons.payments,
                    title: 'Total Planned Expenses',
                    value: '\$${totalExpenses.toStringAsFixed(2)}',
                  ),
                  summaryCard(
                    icon: Icons.task_alt,
                    title: 'Tasks Completed',
                    value: '$completedTasks / $totalTasks',
                  ),
                ],
              ),
      ),
    );
  }
}