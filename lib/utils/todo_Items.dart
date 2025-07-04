class TodoItem {
  final String id;
  final String title;
  final String text;
  final bool isCompleted;
  final String dateCreated;
  final bool isDeleted;
  final DateTime? deletedAt;

  TodoItem({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    this.isCompleted = false,
    this.isDeleted = false,
    this.deletedAt,
  });

  // Convert TodoItem to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'isCompleted': isCompleted,
      'dateCreated': dateCreated,
      'isDeleted': isDeleted,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  // Create TodoItem from Firestore document
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      dateCreated: map['dateCreated'] ?? '',
      isDeleted: map['isDeleted'] ?? false,
      deletedAt: map['deletedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt']) 
          : null,
    );
  }

  // Create a copy with updated fields
  TodoItem copyWith({
    String? id,
    String? title,
    String? text,
    bool? isCompleted,
    String? dateCreated,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCreated: dateCreated ?? this.dateCreated,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
