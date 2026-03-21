import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../models/expense_item.dart';
import '../models/task_item.dart';
import '../services/database_helper.dart';

class BudgetTasksScreen extends StatefulWidget {
  const BudgetTasksScreen({super.key});

  @override
  State<BudgetTasksScreen> createState() => _BudgetTasksScreenState();
}

class _BudgetTasksScreenState extends State<BudgetTasksScreen> {
  List<ExpenseItem> expenses = [];
  List<TaskItem> tasks = [];
  bool isLoading = true;
  double totalBudget = 0;

  Expedition get expedition =>
      ModalRoute.of(context)!.settings.arguments as Expedition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    final expenseData =
        await DatabaseHelper.instance.getExpensesForExpedition(expedition.id!);
    final taskData =
        await DatabaseHelper.instance.getTasksForExpedition(expedition.id!);

    double total = 0;
    for (final expense in expenseData) {
      total += double.tryParse(expense.amount) ?? 0;
    }

    if (!mounted) return;
    setState(() {
      expenses = expenseData;
      tasks = taskData;
      totalBudget = total;
      isLoading = false;
    });
  }

  Future<void> showExpenseDialog({ExpenseItem? expense}) async {
    final titleController = TextEditingController(text: expense?.title ?? '');
    final amountController = TextEditingController(text: expense?.amount ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(expense == null ? 'Add Expense' : 'Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Expense Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Example: 25.50',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final amount = amountController.text.trim();
                final parsed = double.tryParse(amount);

                if (title.isEmpty || parsed == null || parsed < 0) return;

                final item = ExpenseItem(
                  id: expense?.id,
                  expeditionId: expedition.id!,
                  title: title,
                  amount: amount,
                );

                if (expense == null) {
                  await DatabaseHelper.instance.createExpense(item);
                } else {
                  await DatabaseHelper.instance.updateExpense(item);
                }

                if (!mounted) return;
                Navigator.pop(context);
                loadData();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showTaskDialog({TaskItem? task}) async {
    final titleController = TextEditingController(text: task?.title ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) return;

                final item = TaskItem(
                  id: task?.id,
                  expeditionId: expedition.id!,
                  title: title,
                  isCompleted: task?.isCompleted ?? false,
                );

                if (task == null) {
                  await DatabaseHelper.instance.createTask(item);
                } else {
                  await DatabaseHelper.instance.updateTask(item);
                }

                if (!mounted) return;
                Navigator.pop(context);
                loadData();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> toggleTask(TaskItem task, bool value) async {
    final updated = TaskItem(
      id: task.id,
      expeditionId: task.expeditionId,
      title: task.title,
      isCompleted: value,
    );
    await DatabaseHelper.instance.updateTask(updated);
    loadData();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.instance.deleteExpense(id);
    loadData();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${expedition.name} Budget & Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.attach_money),
                        title: const Text('Estimated Total Budget'),
                        subtitle: Text('\$${totalBudget.toStringAsFixed(2)}'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Expenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (expenses.isEmpty)
                      const Card(
                        child: ListTile(title: Text('No expenses yet.')),
                      ),
                    ...expenses.map(
                      (expense) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long),
                          title: Text(expense.title),
                          subtitle: const Text('Tap to edit'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${expense.amount}'),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteExpense(expense.id!),
                              ),
                            ],
                          ),
                          onTap: () => showExpenseDialog(expense: expense),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => showExpenseDialog(),
                      child: const Text('Add Expense'),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (tasks.isEmpty)
                      const Card(
                        child: ListTile(title: Text('No tasks yet.')),
                      ),
                    ...tasks.map(
                      (task) => Card(
                        child: CheckboxListTile(
                          value: task.isCompleted,
                          onChanged: (value) {
                            if (value != null) {
                              toggleTask(task, value);
                            }
                          },
                          title: Text(task.title),
                          secondary: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteTask(task.id!),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => showTaskDialog(),
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}