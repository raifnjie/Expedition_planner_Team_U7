import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../models/route_item.dart';
import '../services/database_helper.dart';

class RouteManagerScreen extends StatefulWidget {
  const RouteManagerScreen({super.key});

  @override
  State<RouteManagerScreen> createState() => _RouteManagerScreenState();
}

class _RouteManagerScreenState extends State<RouteManagerScreen> {
  List<RouteItem> routes = [];
  bool isLoading = true;

  Expedition get expedition =>
      ModalRoute.of(context)!.settings.arguments as Expedition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    final data =
        await DatabaseHelper.instance.getRoutesForExpedition(expedition.id!);
    if (!mounted) return;
    setState(() {
      routes = data;
      isLoading = false;
    });
  }

  Future<void> showRouteDialog({RouteItem? route}) async {
    final nameController = TextEditingController(text: route?.routeName ?? '');
    final distanceController = TextEditingController(text: route?.distance ?? '');
    final notesController = TextEditingController(text: route?.notes ?? '');
    String selectedRisk = route?.riskLevel ?? 'Low';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(route == null ? 'Add Route Stage' : 'Edit Route Stage'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Route Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: distanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Distance',
                        hintText: 'Example: 4.5',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedRisk,
                      decoration:
                          const InputDecoration(labelText: 'Risk Level'),
                      items: const [
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'High', child: Text('High')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedRisk = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final routeName = nameController.text.trim();
                final distance = distanceController.text.trim();

                if (routeName.isEmpty) return;
                if (distance.isEmpty || double.tryParse(distance) == null) return;

                final newRoute = RouteItem(
                  id: route?.id,
                  expeditionId: expedition.id!,
                  routeName: routeName,
                  distance: distance,
                  riskLevel: selectedRisk,
                  notes: notesController.text.trim(),
                );

                if (route == null) {
                  await DatabaseHelper.instance.createRoute(newRoute);
                } else {
                  await DatabaseHelper.instance.updateRoute(newRoute);
                }

                if (!mounted) return;
                Navigator.pop(context);
                loadRoutes();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteRoute(int id) async {
    await DatabaseHelper.instance.deleteRoute(id);
    loadRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${expedition.name} Routes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                    child: routes.isEmpty
                        ? const Center(child: Text('No route stages yet.'))
                        : ListView.builder(
                            itemCount: routes.length,
                            itemBuilder: (context, index) {
                              final route = routes[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.alt_route),
                                  title: Text(route.routeName),
                                  subtitle: Text(
                                    '${route.distance} miles • ${route.riskLevel} Risk',
                                  ),
                                  onTap: () => showRouteDialog(route: route),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => deleteRoute(route.id!),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showRouteDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Route Stage'),
      ),
    );
  }
}