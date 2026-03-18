// This screen provides a form for creating or editing an expedition.
// It allows users to input expedition details such as name, dates,
// risk level, and notes. The form validates input, supports date pickers,
// and saves data to a local database (create or update).

import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../services/database_helper.dart';

// Stateful widget since form inputs and UI state change dynamically
class ExpeditionFormScreen extends StatefulWidget {
  const ExpeditionFormScreen({super.key});

  @override
  State<ExpeditionFormScreen> createState() => _ExpeditionFormScreenState();
}

class _ExpeditionFormScreenState extends State<ExpeditionFormScreen> {
  // Key used to validate the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Date selections
  DateTime? _startDate;
  DateTime? _endDate;

  // Selected risk level
  String selectedRisk = 'Low';

  // UI state flags
  bool isSaving = false;
  Expedition? editingExpedition; // Holds expedition if editing
  bool didLoadArgs = false; // Prevents reloading arguments multiple times

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Load arguments passed from previous screen (only once)
    if (!didLoadArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // If editing an existing expedition, populate fields
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
    // Clean up controllers to prevent memory leaks
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Formats DateTime into YYYY-MM-DD string
  String formatDate(DateTime? date) {
    if (date == null) return '';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  // Opens date picker for selecting start date
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

        // Reset end date if it becomes invalid
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  // Opens date picker for selecting end date
  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020), // Prevent selecting before start date
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  // Validates input and saves expedition to database
  Future<void> saveExpedition() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) return;

    // Ensure both dates are selected
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates.'),
        ),
      );
      return;
    }

    // Ensure end date is not before start date
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be before start date.'),
        ),
      );
      return;
    }

    // Show saving state
    setState(() {
      isSaving = true;
    });

    // Create expedition object from form data
    final expedition = Expedition(
      id: editingExpedition?.id, // Keep ID if updating
      name: _nameController.text.trim(),
      startDate: formatDate(_startDate),
      endDate: formatDate(_endDate),
      notes: _notesController.text.trim(),
      riskLevel: selectedRisk,
    );

    // Insert or update depending on editing state
    if (editingExpedition == null) {
      await DatabaseHelper.instance.createExpedition(expedition);
    } else {
      await DatabaseHelper.instance.updateExpedition(expedition);
    }

    // Prevent UI update if widget is disposed
    if (!mounted) return;

    // Reset saving state
    setState(() {
      isSaving = false;
    });

    // Go back to previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingExpedition != null;

    return Scaffold(
      // App bar changes title based on mode (create vs edit)
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expedition' : 'Create Expedition'),
      ),

      // Scrollable form to prevent overflow
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Expedition name input
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

              // Start date picker field (read-only)
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

              // End date picker field (read-only)
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

              // Dropdown for selecting risk level
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

              // Notes input field
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add any trip notes, goals, or reminders',
                ),
              ),

              const SizedBox(height: 24),

              // Save / Update button
              ElevatedButton(
                onPressed: isSaving ? null : saveExpedition,
                child: Text(isSaving
                    ? 'Saving...'
                    : isEditing
                        ? 'Update Expedition'
                        : 'Save Expedition'),
              ),

              const SizedBox(height: 12),

              // Back button
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