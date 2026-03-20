class ExpenseItem {
  final int? id;
  final int expeditionId;
  final String title;
  final String amount;

  ExpenseItem({
    this.id,
    required this.expeditionId,
    required this.title,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'title': title,
      'amount': amount,
    };
  }

  factory ExpenseItem.fromMap(Map<String, dynamic> map) {
    return ExpenseItem(
      id: map['id'],
      expeditionId: map['expeditionId'],
      title: map['title'] ?? '',
      amount: map['amount'] ?? '',
    );
  }
}