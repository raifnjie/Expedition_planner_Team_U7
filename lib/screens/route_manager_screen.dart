import 'package:flutter/material.dart';

class RouteManagerScreen extends StatelessWidget {
  const RouteManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [
      {'name': 'Base Camp to Ridge', 'distance': '4.2 mi', 'risk': 'Medium'},
      {'name': 'Ridge to Summit', 'distance': '2.1 mi', 'risk': 'High'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Plan route stages, distances, and risk levels.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final route = routes[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.alt_route),
                      title: Text(route['name']!),
                      subtitle: Text(
                        '${route['distance']} • ${route['risk']} Risk',
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Route Stage'),
            ),
          ],
        ),
      ),
    );
  }
}