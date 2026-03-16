import 'package:flutter/material.dart';
import '../widgets/module_button.dart';

class ExpeditionDetailsScreen extends StatelessWidget {
  const ExpeditionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final title = args?['title'] ?? 'Sample Expedition';
    final dates = args?['dates'] ?? 'Apr 12 - Apr 14';
    final risk = args?['risk'] ?? 'Low';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
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
            ModuleButton(
              title: 'Route Manager',
              subtitle: 'Manage trip stages, distances, and notes',
              icon: Icons.alt_route,
              onTap: () => Navigator.pushNamed(context, '/routes'),
            ),
            ModuleButton(
              title: 'Gear Manager',
              subtitle: 'Track items, categories, and total weight',
              icon: Icons.backpack,
              onTap: () => Navigator.pushNamed(context, '/gear'),
            ),
            ModuleButton(
              title: 'Trail Logs',
              subtitle: 'Store observations and trip notes',
              icon: Icons.menu_book,
              onTap: () => Navigator.pushNamed(context, '/logs'),
            ),
            ModuleButton(
              title: 'Budget & Tasks',
              subtitle: 'Track expenses and completion status',
              icon: Icons.checklist,
              onTap: () => Navigator.pushNamed(context, '/budget-tasks'),
            ),
            ModuleButton(
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