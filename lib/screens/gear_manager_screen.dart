import 'package:flutter/material.dart';

class GearManagerScreen extends StatelessWidget {
  const GearManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gearItems = [
      {'name': 'Tent', 'category': 'Shelter', 'weight': '5.0 lbs'},
      {'name': 'First Aid Kit', 'category': 'Safety', 'weight': '1.2 lbs'},
      {'name': 'Water Filter', 'category': 'Utility', 'weight': '0.8 lbs'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gear Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.scale),
                title: const Text('Estimated Total Weight'),
                subtitle: const Text('7.0 lbs'),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: gearItems.length,
                itemBuilder: (context, index) {
                  final item = gearItems[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.backpack),
                      title: Text(item['name']!),
                      subtitle: Text(
                        '${item['category']} • ${item['weight']}',
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Gear Item'),
            ),
          ],
        ),
      ),
    );
  }
}