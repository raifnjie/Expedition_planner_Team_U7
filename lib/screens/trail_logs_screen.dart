import 'package:flutter/material.dart';

class TrailLogsScreen extends StatelessWidget {
  const TrailLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      'Reached camp before sunset. Weather stayed clear.',
      'Steep incline after checkpoint 2. Trail became muddy.',
      'Need extra water refill stop for future trips.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trail Logs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Store notes, observations, and safety reminders.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.note_alt),
                      title: Text(logs[index]),
                      subtitle: Text('Log ${index + 1} • Timestamp placeholder'),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Trail Log'),
            ),
          ],
        ),
      ),
    );
  }
}