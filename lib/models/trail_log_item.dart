class TrailLogItem {
  final int? id;
  final int expeditionId;
  final String note;
  final String timestamp;

  TrailLogItem({
    this.id,
    required this.expeditionId,
    required this.note,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'note': note,
      'timestamp': timestamp,
    };
  }

  factory TrailLogItem.fromMap(Map<String, dynamic> map) {
    return TrailLogItem(
      id: map['id'],
      expeditionId: map['expeditionId'],
      note: map['note'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }
}