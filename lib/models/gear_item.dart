class GearItem {
  final int? id;
  final int expeditionId;
  final String itemName;
  final String category;
  final String weight;

  GearItem({
    this.id,
    required this.expeditionId,
    required this.itemName,
    required this.category,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'itemName': itemName,
      'category': category,
      'weight': weight,
    };
  }

  factory GearItem.fromMap(Map<String, dynamic> map) {
    return GearItem(
      id: map['id'],
      expeditionId: map['expeditionId'],
      itemName: map['itemName'] ?? '',
      category: map['category'] ?? '',
      weight: map['weight'] ?? '',
    );
  }
}