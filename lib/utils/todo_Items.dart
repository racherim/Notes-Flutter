class TodoItem {
  final String id;
  final String title;
  final String text;
  final bool isCompleted;

  TodoItem({required this.id, required this.title, required this.text, this.isCompleted = false});
}
