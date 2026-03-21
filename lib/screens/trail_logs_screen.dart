import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../models/trail_log_item.dart';
import '../services/database_helper.dart';

class TrailLogsScreen extends StatefulWidget {
  const TrailLogsScreen({super.key});

  @override
  State<TrailLogsScreen> createState() => _TrailLogsScreenState();
}

class _TrailLogsScreenState extends State<TrailLogsScreen> {
  List<TrailLogItem> logs = [];
  bool isLoading = true;

  Expedition get expedition =>
      ModalRoute.of(context)!.settings.arguments as Expedition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadLogs();
  }

  Future<void> loadLogs() async {
    final data =
        await DatabaseHelper.instance.getLogsForExpedition(expedition.id!);
    if (!mounted) return;
    setState(() {
      logs = data;
      isLoading = false;
    });
  }

  String nowString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> showLogDialog({TrailLogItem? log}) async {
    final noteController = TextEditingController(text: log?.note ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(log == null ? 'Add Trail Log' : 'Edit Trail Log'),
          content: TextField(
            controller: noteController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Log Note'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final note = noteController.text.trim();
                if (note.isEmpty) return;

                final newLog = TrailLogItem(
                  id: log?.id,
                  expeditionId: expedition.id!,
                  note: note,
                  timestamp: log?.timestamp ?? nowString(),
                );

                if (log == null) {
                  await DatabaseHelper.instance.createTrailLog(newLog);
                } else {
                  await DatabaseHelper.instance.updateTrailLog(newLog);
                }

                if (!mounted) return;
                Navigator.pop(context);
                loadLogs();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteLog(int id) async {
    await DatabaseHelper.instance.deleteTrailLog(id);
    loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${expedition.name} Logs'),
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
                      'Store notes, observations, and safety reminders.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: logs.isEmpty
                        ? const Center(child: Text('No trail logs yet.'))
                        : ListView.builder(
                            itemCount: logs.length,
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.note_alt),
                                  title: Text(log.note),
                                  subtitle: Text(log.timestamp),
                                  onTap: () => showLogDialog(log: log),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => deleteLog(log.id!),
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
        onPressed: () => showLogDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Trail Log'),
      ),
    );
  }
}