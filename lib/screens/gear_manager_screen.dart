//This screen displays a gear management interface for an expidition. 
//It shows a list of gear items with their category and weight, along with a total 
// estimated weight. Users can view their items and add gear. 

import 'package:flutter/material.dart';

// Stateless widget since gear data is currently static
class GearManagerScreen extends StatelessWidget {
  const GearManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list of gear items (name, category, weight)
    final gearItems = [
      {'name': 'Tent', 'category': 'Shelter', 'weight': '5.0 lbs'},
      {'name': 'First Aid Kit', 'category': 'Safety', 'weight': '1.2 lbs'},
      {'name': 'Water Filter', 'category': 'Utility', 'weight': '0.8 lbs'},
    ];

    return Scaffold(
      // App bar with screen title
      appBar: AppBar(
        title: const Text('Gear Manager'),
      ),

      // Main content area with padding
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card displaying total estimated gear weight
            Card(
              child: ListTile(
                leading: const Icon(Icons.scale),
                title: const Text('Estimated Total Weight'),
                subtitle: const Text('7.0 lbs'),
              ),
            ),

            const SizedBox(height: 8),

            // Expanded list to display gear items
            Expanded(
              child: ListView.builder(
                itemCount: gearItems.length,
                itemBuilder: (context, index) {
                  final item = gearItems[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.backpack),

                      // Gear item name
                      title: Text(item['name']!),

                      // Displays category and weight
                      subtitle: Text(
                        '${item['category']} • ${item['weight']}',
                      ),
                    ),
                  );
                },
              ),
            ),

            // Button to add a new gear item (functionality not implemented yet)
            ElevatedButton.icon(
              onPressed: () {}, // TODO: Implement add gear functionality
              icon: const Icon(Icons.add),
              label: const Text('Add Gear Item'),
            ),
          ],
        ),
      ),
    );
  }
}