class AIFeedback {
  final int? id;
  final int expeditionId;
  final String suggestionKey;
  final String suggestionText;
  final bool wasHelpful;
  final String createdAt;

  AIFeedback({
    this.id,
    required this.expeditionId,
    required this.suggestionKey,
    required this.suggestionText,
    required this.wasHelpful,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'suggestionKey': suggestionKey,
      'suggestionText': suggestionText,
      'wasHelpful': wasHelpful ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  factory AIFeedback.fromMap(Map<String, dynamic> map) {
    return AIFeedback(
      id: map['id'],
      expeditionId: map['expeditionId'],
      suggestionKey: map['suggestionKey'] ?? '',
      suggestionText: map['suggestionText'] ?? '',
      wasHelpful: (map['wasHelpful'] ?? 0) == 1,
      createdAt: map['createdAt'] ?? '',
    );
  }
}