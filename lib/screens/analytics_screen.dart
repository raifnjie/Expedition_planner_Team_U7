//This screen displays a simple analytics dashboard for the app, showing key metrics and 
//information about about the expidition like total distance, gear weight, expenses, etc. 

import 'package:flutter/material.dart';

//StatelessWidget since the analytics data is static
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});


//reusable widget method used to create a summary card with an icon, title, and value. This is used to display different analytics metrics in a consistent format.
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
            //Displays the number of completed task
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