import 'package:flutter/material.dart';
import '../models/expedition.dart';
import '../models/gear_item.dart';
import '../models/ai_feedback.dart';
import '../services/database_helper.dart';
import '../services/app_settings.dart';
import '../widgets/module_button.dart';

class ExpeditionDetailsScreen extends StatefulWidget {
  const ExpeditionDetailsScreen({super.key});

  @override
  State<ExpeditionDetailsScreen> createState() => _ExpeditionDetailsScreenState();
}

class _ExpeditionDetailsScreenState extends State<ExpeditionDetailsScreen> {
  bool isLoadingSuggestions = true;
  List<_SuggestionData> suggestions = [];
  bool didLoad = false;

  Expedition get expedition =>
      ModalRoute.of(context)!.settings.arguments as Expedition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!didLoad) {
      didLoad = true;
      AppSettings.instance.setLastOpenedExpedition(expedition);
      loadSuggestions();
    }
  }

  Future<void> _deleteExpedition(
    BuildContext context,
    Expedition expedition,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Expedition'),
          content: Text(
            'Are you sure you want to delete "${expedition.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await DatabaseHelper.instance.deleteExpedition(expedition.id!);

      if (AppSettings.instance.lastOpenedExpeditionId == expedition.id) {
        await AppSettings.instance.clearLastOpenedExpedition();
      }

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> loadSuggestions() async {
    if (!AppSettings.instance.aiSuggestionsEnabled) {
      setState(() {
        suggestions = [];
        isLoadingSuggestions = false;
      });
      return;
    }

    final db = DatabaseHelper.instance;
    final totalWeight = await db.getTotalGearWeight(expedition.id!);
    final historicalAverage =
        await db.getAverageHistoricalGearWeight(expedition.id!);
    final hasRainHistory = await db.hasRainHistory(expedition.id!);
    final gear = await db.getGearForExpedition(expedition.id!);

    final weightFeedbackDelta =
        await db.getFeedbackDelta('weight_reduction');
    final rainFeedbackDelta =
        await db.getFeedbackDelta('waterproof_recommendation');

    final builtSuggestions = <_SuggestionData>[];

    final weightThreshold = (historicalAverage ?? 8.0) +
        (weightFeedbackDelta < 0 ? 1.0 : 0.0) -
        (weightFeedbackDelta > 1 ? 0.5 : 0.0);

    if (totalWeight > weightThreshold) {
      builtSuggestions.add(
        _SuggestionData(
          key: 'weight_reduction',
          title: 'Reduce your pack weight',
          message:
              'Your current load is heavier than your usual trips. Consider removing non-essential gear.',
          reason:
              historicalAverage == null
                  ? 'Triggered because current gear weight is high for a first baseline.'
                  : 'Triggered because total gear weight (${totalWeight.toStringAsFixed(1)}) is above your historical average (${historicalAverage.toStringAsFixed(1)}).',
        ),
      );
    }

    final hasWaterproofGear = _containsWaterproofGear(gear);
    if (hasRainHistory && !hasWaterproofGear) {
      builtSuggestions.add(
        _SuggestionData(
          key: 'waterproof_recommendation',
          title: 'Add waterproof gear',
          message:
              'Past logs suggest wet conditions. Add waterproof gear or rain protection.',
          reason:
              'Triggered because previous trail logs mention rain/wet conditions and this expedition does not appear to include waterproof gear.',
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      suggestions = builtSuggestions;
      isLoadingSuggestions = false;
    });
  }

  bool _containsWaterproofGear(List<GearItem> gear) {
    for (final item in gear) {
      final text = '${item.itemName} ${item.category}'.toLowerCase();
      if (text.contains('rain') ||
          text.contains('waterproof') ||
          text.contains('poncho') ||
          text.contains('jacket')) {
        return true;
      }
    }
    return false;
  }

  Future<void> saveSuggestionFeedback(
    _SuggestionData suggestion,
    bool wasHelpful,
  ) async {
    final feedback = AIFeedback(
      expeditionId: expedition.id!,
      suggestionKey: suggestion.key,
      suggestionText: suggestion.message,
      wasHelpful: wasHelpful,
      createdAt: DateTime.now().toIso8601String(),
    );

    await DatabaseHelper.instance.createAiFeedback(feedback);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasHelpful
              ? 'Feedback saved: marked helpful.'
              : 'Feedback saved: marked not helpful.',
        ),
      ),
    );

    loadSuggestions();
  }

  Widget buildAiCard() {
    if (!AppSettings.instance.aiSuggestionsEnabled) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.smart_toy_outlined),
          title: const Text('AI Suggestions'),
          subtitle: const Text('AI suggestions are turned off in Settings.'),
        ),
      );
    }

    if (isLoadingSuggestions) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (suggestions.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text('AI Suggestions'),
          subtitle: Text('No suggestions right now for this expedition.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.smart_toy_outlined),
                SizedBox(width: 8),
                Text(
                  'AI Suggestions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...suggestions.map(
              (suggestion) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(suggestion.message),
                    const SizedBox(height: 8),
                    Text(
                      suggestion.reason,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                saveSuggestionFeedback(suggestion, true),
                            icon: const Icon(Icons.thumb_up_alt_outlined),
                            label: const Text('Helpful'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                saveSuggestionFeedback(suggestion, false),
                            icon: const Icon(Icons.thumb_down_alt_outlined),
                            label: const Text('Not Helpful'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expedition Details'),
            actions: [
              IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    '/expedition-form',
                    arguments: expedition,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => _deleteExpedition(context, expedition),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expedition.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${expedition.startDate} - ${expedition.endDate}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text('Risk Level: ${expedition.riskLevel}'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Notes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          expedition.notes.isEmpty
                              ? 'No notes added yet.'
                              : expedition.notes,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                buildAiCard(),
                const SizedBox(height: 12),
                ModuleButton(
                  title: 'Route Manager',
                  subtitle: 'Manage trip stages, distances, and notes',
                  icon: Icons.alt_route,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/routes',
                    arguments: expedition,
                  ),
                ),
                ModuleButton(
                  title: 'Gear Manager',
                  subtitle: 'Track items, categories, total weight, and filters',
                  icon: Icons.backpack,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/gear',
                    arguments: expedition,
                  ),
                ),
                ModuleButton(
                  title: 'Trail Logs',
                  subtitle: 'Store observations and trip notes',
                  icon: Icons.menu_book,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/logs',
                    arguments: expedition,
                  ),
                ),
                ModuleButton(
                  title: 'Budget & Tasks',
                  subtitle: 'Track expenses and completion status',
                  icon: Icons.checklist,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/budget-tasks',
                    arguments: expedition,
                  ),
                ),
                ModuleButton(
                  title: 'Analytics',
                  subtitle: 'View expedition summary information',
                  icon: Icons.analytics,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/analytics',
                    arguments: expedition,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionData {
  final String key;
  final String title;
  final String message;
  final String reason;

  _SuggestionData({
    required this.key,
    required this.title,
    required this.message,
    required this.reason,
  });
}