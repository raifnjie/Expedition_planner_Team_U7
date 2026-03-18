//This screen displays a combined budget and task tracker showing the list of expenses with 
//thier cost and checklist of task. the UI is scrollable for users and uses cards to organize budget and task data.

import 'package:flutter/material.dart';

// Stateless widget since data is currently static and not changing
class BudgetTasksScreen extends StatelessWidget {
  const BudgetTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
        // List of expense items (title + amount)
    final expenses = [
      {'title': 'Gas', 'amount': '\$40'},
      {'title': 'Snacks', 'amount': '\$18'},
      {'title': 'Camping Permit', 'amount': '\$25'},
    ];
    // List of tasks with completion status
    final tasks = [
      {'title': 'Pack sleeping bag', 'done': true},
      {'title': 'Buy food supplies', 'done': false},
      {'title': 'Check weather forecast', 'done': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget & Tasks'),
      ),
  // Scrollable body to prevent overflow on smaller screens
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
         // Section title for expenses
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expenses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
        //dynamically generate expense cards 
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
            //Section title for tasks
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

      //Same thing of dynamically generating the task checklist
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