import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';

class AddTodo extends StatelessWidget {
  final TextEditingController textController;
  final Function(TodoItem) onItemAdded;

  const AddTodo({
    super.key,
    required this.textController,
    required this.onItemAdded,
  });

  void _addTodoItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Todo'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Enter notes here'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                onItemAdded(
                  TodoItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    text: textController.text,
                  ),
                );
                textController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addTodoItem(context),
      backgroundColor: Color(0xffa663cc),
      child: const Icon(Icons.add),
    );
  }
}