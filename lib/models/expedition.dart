class Expedition {
  final int? id;
  final String name;
  final String startDate;
  final String endDate;
  final String notes;
  final String riskLevel;

  Expedition({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.notes,
    required this.riskLevel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
      'riskLevel': riskLevel,
    };
  }

  factory Expedition.fromMap(Map<String, dynamic> map) {
    return Expedition(
      id: map['id'],
      name: map['name'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      notes: map['notes'] ?? '',
      riskLevel: map['riskLevel'] ?? 'Low',
    );
  }

  Expedition copyWith({
    int? id,
    String? name,
    String? startDate,
    String? endDate,
    String? notes,
    String? riskLevel,
  }) {
    return Expedition(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }
}