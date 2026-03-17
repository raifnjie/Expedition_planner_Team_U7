import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../services/database_helper.dart';

class ExpeditionFormScreen extends StatefulWidget {
  const ExpeditionFormScreen({super.key});

  @override
  State<ExpeditionFormScreen> createState() => _ExpeditionFormScreenState();
}

class _ExpeditionFormScreenState extends State<ExpeditionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String selectedRisk = 'Low';
  bool isSaving = false;
  Expedition? editingExpedition;
  bool didLoadArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!didLoadArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Expedition) {
        editingExpedition = args;
        _nameController.text = args.name;
        _notesController.text = args.notes;
        _startDate = DateTime.tryParse(args.startDate);
        _endDate = DateTime.tryParse(args.endDate);
        selectedRisk = args.riskLevel;
      }
      didLoadArgs = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> saveExpedition() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates.'),
        ),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be before start date.'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final expedition = Expedition(
      id: editingExpedition?.id,
      name: _nameController.text.trim(),
      startDate: formatDate(_startDate),
      endDate: formatDate(_endDate),
      notes: _notesController.text.trim(),
      riskLevel: selectedRisk,
    );

    if (editingExpedition == null) {
      await DatabaseHelper.instance.createExpedition(expedition);
    } else {
      await DatabaseHelper.instance.updateExpedition(expedition);
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingExpedition != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expedition' : 'Create Expedition'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Expedition Name',
                  hintText: 'Example: Appalachian Weekend Trip',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Expedition name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: formatDate(_startDate)),
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  hintText: 'Select start date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: pickStartDate,
              ),
              const SizedBox(height: 14),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: formatDate(_endDate)),
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  hintText: 'Select end date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: pickEndDate,
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
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add any trip notes, goals, or reminders',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSaving ? null : saveExpedition,
                child: Text(isSaving
                    ? 'Saving...'
                    : isEditing
                        ? 'Update Expedition'
                        : 'Save Expedition'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: isSaving ? null : () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}