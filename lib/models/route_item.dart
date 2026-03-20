class RouteItem {
  final int? id;
  final int expeditionId;
  final String routeName;
  final String distance;
  final String riskLevel;
  final String notes;

  RouteItem({
    this.id,
    required this.expeditionId,
    required this.routeName,
    required this.distance,
    required this.riskLevel,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'routeName': routeName,
      'distance': distance,
      'riskLevel': riskLevel,
      'notes': notes,
    };
  }

  factory RouteItem.fromMap(Map<String, dynamic> map) {
    return RouteItem(
      id: map['id'],
      expeditionId: map['expeditionId'],
      routeName: map['routeName'] ?? '',
      distance: map['distance'] ?? '',
      riskLevel: map['riskLevel'] ?? 'Low',
      notes: map['notes'] ?? '',
    );
  }
}