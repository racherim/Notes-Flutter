class TodoItem {
  final String id;
  final String title;
  final String text;
  final bool isCompleted;
  final String dateCreated;
  final bool isDeleted;

  TodoItem({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    this.isCompleted = false,
    this.isDeleted = false,
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
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCreated: dateCreated ?? this.dateCreated,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
