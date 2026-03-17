import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../services/database_helper.dart';
import '../widgets/module_button.dart';

class ExpeditionDetailsScreen extends StatelessWidget {
  const ExpeditionDetailsScreen({super.key});

  Future<void> _deleteExpedition(
    BuildContext context,
    Expedition expedition,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Expedition'),
          content: Text(
            'Are you sure you want to delete "${expedition.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await DatabaseHelper.instance.deleteExpedition(expedition.id!);
      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expedition =
        ModalRoute.of(context)!.settings.arguments as Expedition;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition Details'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                '/expedition-form',
                arguments: expedition,
              );
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _deleteExpedition(context, expedition),
            icon: const Icon(Icons.delete),
          ),
        ],
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
                      expedition.name,
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
                        Expanded(
                          child: Text(
                            '${expedition.startDate} - ${expedition.endDate}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text('Risk Level: ${expedition.riskLevel}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      expedition.notes.isEmpty
                          ? 'No notes added yet.'
                          : expedition.notes,
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