//This screen serves as the main dashboard for the our expidition planner.
//It loads the expidition data from a local database, displays a loist of trips,
//and allows users to create, edit, and view expiditions that they ahve created. 

import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../services/database_helper.dart';
import '../widgets/expedition_card.dart';

// Here we use a Stateful widget since the data (expeditions) changes dynamically
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
    // List to store all expeditions retrieved from the database
  List<Expedition> expeditions = [];
    // We added a Loading state to show spinner while fetching data to display to ensure a smooth user experience
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExpeditions(); //load the data once the screen is initialized 
  }

  Future<void> loadExpeditions() async {
    setState(() {
      isLoading = true;
    });

    // Retrieve expedition data from database helper
    final data = await DatabaseHelper.instance.getAllExpeditions();
//Prevent updating UI if the widget is no longer mounted
    if (!mounted) return;

    setState(() {
      expeditions = data;
      isLoading = false;
    });
  }

  // Navigate to form screen (for creating or editing an expedition)
  Future<void> openFormScreen({Expedition? expedition}) async {
    await Navigator.pushNamed(
      context,
      '/expedition-form',
      arguments: expedition, // Pass existing expedition if editing
    );

    loadExpeditions(); // Reload list after returning
  }

// Navigate to details screen for a specific expedition
  Future<void> openDetailsScreen(Expedition expedition) async {
    await Navigator.pushNamed(
      context,
      '/expedition-details',
      arguments: expedition,
    );

    loadExpeditions(); // Refresh in case data was updated
  }

  @override
  Widget build(BuildContext context) {
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
            // Pull-to-refresh wrapper
      body: RefreshIndicator(
        onRefresh: loadExpeditions,
        child: Padding(
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
                'Create, view, edit, and manage your trips offline.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),

              //Main content area
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : expeditions.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'No expeditions yet. Create your first trip.',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: expeditions.length,
                            itemBuilder: (context, index) {
                              final expedition = expeditions[index];
                              return ExpeditionCard(
                                title: expedition.name,
                                dates:
                                    '${expedition.startDate} - ${expedition.endDate}',
                                riskLevel: expedition.riskLevel,
                                onTap: () => openDetailsScreen(expedition),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openFormScreen(),
        icon: const Icon(Icons.add),
        label: const Text('New Expedition'),
      ),
    );
  }
}