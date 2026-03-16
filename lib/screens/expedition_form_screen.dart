import 'package:flutter/material.dart';

class ExpeditionFormScreen extends StatefulWidget {
  const ExpeditionFormScreen({super.key});

  @override
  State<ExpeditionFormScreen> createState() => _ExpeditionFormScreenState();
}

class _ExpeditionFormScreenState extends State<ExpeditionFormScreen> {
  String selectedRisk = 'Low';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Expedition'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Expedition Name',
                hintText: 'Example: Appalachian Weekend Trip',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Start Date',
                hintText: 'Select start date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'End Date',
                hintText: 'Select end date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedRisk,
              decoration: const InputDecoration(
                labelText: 'Risk Level',
              ),
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                DropdownMenuItem(value: 'High', child: Text('High')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRisk = value;
                  });
                }
              },
            ),
            const SizedBox(height: 14),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add any trip notes, goals, or reminders',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('More implementation coming soon.'),
                  ),
                );
              },
              child: const Text('Save Expedition'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}