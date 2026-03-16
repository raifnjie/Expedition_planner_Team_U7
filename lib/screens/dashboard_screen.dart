import 'package:flutter/material.dart';
import '../widgets/expedition_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expeditions = [
      {
        'title': 'Blue Ridge Weekend',
        'dates': 'Apr 12 - Apr 14',
        'risk': 'Low',
      },
      {
        'title': 'Smoky Mountains Trip',
        'dates': 'May 03 - May 06',
        'risk': 'Medium',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition Planner'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Expeditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your upcoming trips and open any expedition to view its modules.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: expeditions.isEmpty
                  ? Center(
                      child: Text(
                        'No expeditions yet. Create your first trip.',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    )
                  : ListView.builder(
                      itemCount: expeditions.length,
                      itemBuilder: (context, index) {
                        final expedition = expeditions[index];
                        return ExpeditionCard(
                          title: expedition['title']!,
                          dates: expedition['dates']!,
                          riskLevel: expedition['risk']!,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/expedition-details',
                              arguments: expedition,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/expedition-form'),
        icon: const Icon(Icons.add),
        label: const Text('New Expedition'),
      ),
    );
  }
}