import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../services/database_helper.dart';
import '../widgets/expedition_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Expedition> expeditions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExpeditions();
  }

  Future<void> loadExpeditions() async {
    setState(() {
      isLoading = true;
    });

    final data = await DatabaseHelper.instance.getAllExpeditions();

    if (!mounted) return;

    setState(() {
      expeditions = data;
      isLoading = false;
    });
  }

  Future<void> openFormScreen({Expedition? expedition}) async {
    await Navigator.pushNamed(
      context,
      '/expedition-form',
      arguments: expedition,
    );

    loadExpeditions();
  }

  Future<void> openDetailsScreen(Expedition expedition) async {
    await Navigator.pushNamed(
      context,
      '/expedition-details',
      arguments: expedition,
    );

    loadExpeditions();
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