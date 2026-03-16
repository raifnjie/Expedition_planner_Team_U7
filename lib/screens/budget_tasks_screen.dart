import 'package:flutter/material.dart';

class BudgetTasksScreen extends StatelessWidget {
  const BudgetTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = [
      {'title': 'Gas', 'amount': '\$40'},
      {'title': 'Snacks', 'amount': '\$18'},
      {'title': 'Camping Permit', 'amount': '\$25'},
    ];

    final tasks = [
      {'title': 'Pack sleeping bag', 'done': true},
      {'title': 'Buy food supplies', 'done': false},
      {'title': 'Check weather forecast', 'done': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget & Tasks'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: const ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Estimated Total Budget'),
                subtitle: Text('\$83'),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expenses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...expenses.map(
              (expense) => Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(expense['title']!),
                  trailing: Text(expense['amount']!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...tasks.map(
              (task) => Card(
                child: CheckboxListTile(
                  value: task['done'] as bool,
                  onChanged: null,
                  title: Text(task['title'] as String),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Expense or Task'),
            ),
          ],
        ),
      ),
    );
  }
}