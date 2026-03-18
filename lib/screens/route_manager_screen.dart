// This screen provides a route management interface for an expedition.
// It displays different route stages with their distances and risk levels,
// allowing users to view planned routes and (eventually) add new stages.

import 'package:flutter/material.dart';

// Stateless widget since route data is currently static
class RouteManagerScreen extends StatelessWidget {
  const RouteManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list of route stages (name, distance, risk level)
    final routes = [
      {'name': 'Base Camp to Ridge', 'distance': '4.2 mi', 'risk': 'Medium'},
      {'name': 'Ridge to Summit', 'distance': '2.1 mi', 'risk': 'High'},
    ];

    return Scaffold(
      // App bar with screen title
      appBar: AppBar(
        title: const Text('Route Manager'),
      ),

      // Main content area with padding
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Introductory text describing the screen's purpose
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Plan route stages, distances, and risk levels.',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Expanded list of route stages
            Expanded(
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final route = routes[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.alt_route),

                      // Route stage name
                      title: Text(route['name']!),

                      // Displays distance and risk level
                      subtitle: Text(
                        '${route['distance']} • ${route['risk']} Risk',
                      ),
                    ),
                  );
                },
              ),
            ),

            // Button to add a new route stage (functionality not implemented yet)
            ElevatedButton.icon(
              onPressed: () {}, // TODO: Implement add route functionality
              icon: const Icon(Icons.add),
              label: const Text('Add Route Stage'),
            ),
          ],
        ),
      ),
    );
  }
}