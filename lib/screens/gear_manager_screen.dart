import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../models/gear_item.dart';
import '../services/database_helper.dart';
import '../services/app_settings.dart';

class GearManagerScreen extends StatefulWidget {
  const GearManagerScreen({super.key});

  @override
  State<GearManagerScreen> createState() => _GearManagerScreenState();
}

class _GearManagerScreenState extends State<GearManagerScreen> {
  List<GearItem> gearItems = [];
  bool isLoading = true;
  double totalWeight = 0;
  String selectedCategory = 'All';

  Expedition get expedition =>
      ModalRoute.of(context)!.settings.arguments as Expedition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadGear();
  }

  Future<void> loadGear() async {
    final data =
        await DatabaseHelper.instance.getGearForExpedition(expedition.id!);
    double total = 0;
    for (final item in data) {
      total += double.tryParse(item.weight) ?? 0;
    }

    if (!mounted) return;
    setState(() {
      gearItems = data;
      totalWeight = total;
      isLoading = false;
    });
  }

  List<String> get categories {
    final values = gearItems.map((e) => e.category.trim()).where((e) => e.isNotEmpty).toSet().toList();
    values.sort();
    return ['All', ...values];
  }

  List<GearItem> get filteredGear {
    if (selectedCategory == 'All') return gearItems;
    return gearItems.where((item) => item.category == selectedCategory).toList();
  }

  String get weightUnit {
    return AppSettings.instance.selectedUnit == 'Km / kg' ? 'kg' : 'lbs';
  }

  Future<void> showGearDialog({GearItem? item}) async {
    final nameController = TextEditingController(text: item?.itemName ?? '');
    final categoryController = TextEditingController(text: item?.category ?? '');
    final weightController = TextEditingController(text: item?.weight ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Gear Item' : 'Edit Gear Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Example: Safety, Shelter, Food',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    hintText: 'Example: 2.5',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final category = categoryController.text.trim();
                final weight = weightController.text.trim();

                if (name.isEmpty || category.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name and category are required.'),
                    ),
                  );
                  return;
                }

                if (weight.isEmpty || double.tryParse(weight) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Weight must be numeric.'),
                    ),
                  );
                  return;
                }

                final gear = GearItem(
                  id: item?.id,
                  expeditionId: expedition.id!,
                  itemName: name,
                  category: category,
                  weight: weight,
                );

                try {
                  if (item == null) {
                    await DatabaseHelper.instance.createGearItem(gear);
                  } else {
                    await DatabaseHelper.instance.updateGearItem(gear);
                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                  loadGear();
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not save gear item.'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteGear(int id) async {
    await DatabaseHelper.instance.deleteGearItem(id);
    loadGear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${expedition.name} Gear'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.scale),
                          title: const Text('Total Gear Weight'),
                          subtitle: Text(
                            '${totalWeight.toStringAsFixed(1)} $weightUnit',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (categories.length > 1)
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Filter by Category',
                          ),
                          items: categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedCategory = value;
                              });
                            }
                          },
                        ),
                      if (categories.length > 1) const SizedBox(height: 8),
                      Expanded(
                        child: filteredGear.isEmpty
                            ? const Center(child: Text('No gear items found.'))
                            : ListView.builder(
                                itemCount: filteredGear.length,
                                itemBuilder: (context, index) {
                                  final item = filteredGear[index];
                                  return Card(
                                    child: ListTile(
                                      leading: const Icon(Icons.backpack),
                                      title: Text(item.itemName),
                                      subtitle:
                                          Text('${item.category} • ${item.weight} $weightUnit'),
                                      onTap: () => showGearDialog(item: item),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => deleteGear(item.id!),
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
            onPressed: () => showGearDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Gear Item'),
          ),
        );
      },
    );
  }
}