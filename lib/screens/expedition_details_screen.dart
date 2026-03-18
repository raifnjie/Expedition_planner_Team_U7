// This screen displays detailed information about a selected expedition.
// It shows the expedition's title, dates, and risk level, and provides
// navigation buttons to different modules such as routes, gear, logs,
// budget/tasks, and analytics.

import 'package:flutter/material.dart';
import '../widgets/module_button.dart';

class ExpeditionDetailsScreen extends StatelessWidget {
  const ExpeditionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from previous screen (if any)
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

//Extract expidition details or use default values
    final title = args?['title'] ?? 'Sample Expedition';
    final dates = args?['dates'] ?? 'Apr 12 - Apr 14';
    final risk = args?['risk'] ?? 'Low';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition Details'),
      ),   
    // Scrollable body to prevent overflow
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
// Card displaying expedition basic information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
  // Expedition title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
             // Row displaying expedition dates
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 18),
                        const SizedBox(width: 8),
                        Text(dates),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text('Risk Level: $risk'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

          //Navigation buttons to different modules
          //Route management module
            ModuleButton(
              title: 'Route Manager',
              subtitle: 'Manage trip stages, distances, and notes',
              icon: Icons.alt_route,
              onTap: () => Navigator.pushNamed(context, '/routes'),
            ),
            //Gear tracking module
            ModuleButton(
              title: 'Gear Manager',
              subtitle: 'Track items, categories, and total weight',
              icon: Icons.backpack,
              onTap: () => Navigator.pushNamed(context, '/gear'),
            ),
            ModuleButton( //Trail logs module 
              title: 'Trail Logs',
              subtitle: 'Store observations and trip notes',
              icon: Icons.menu_book,
              onTap: () => Navigator.pushNamed(context, '/logs'),
            ),
            ModuleButton( //Budget and task tracking module
              title: 'Budget & Tasks',
              subtitle: 'Track expenses and completion status',
              icon: Icons.checklist,
              onTap: () => Navigator.pushNamed(context, '/budget-tasks'),
            ),
            ModuleButton( //analytics module 
              title: 'Analytics',
              subtitle: 'View expedition summary information',
              icon: Icons.analytics,
              onTap: () => Navigator.pushNamed(context, '/analytics'),
            ),
          ],
        ),
      ),
    );
  }
}