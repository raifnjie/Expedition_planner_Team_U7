class TaskItem {
  final int? id;
  final int expeditionId;
  final String title;
  final bool isCompleted;

  TaskItem({
    this.id,
    required this.expeditionId,
    required this.title,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'],
      expeditionId: map['expeditionId'],
      title: map['title'] ?? '',
      isCompleted: (map['isCompleted'] ?? 0) == 1,
    );
  }
}