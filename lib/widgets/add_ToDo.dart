import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/PageStyle.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';

class AddTodo extends StatefulWidget {
  final Function(TodoItem) onItemAdded;

  const AddTodo({super.key, required this.onItemAdded});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addTodoItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: 'Enter notes here'),
              maxLines: 3,
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty ||
                  _contentController.text.isNotEmpty) {
                widget.onItemAdded(
                  TodoItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    text: _contentController.text,
                    dateCreated: "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  ),
                );
                _titleController.clear();
                _contentController.clear();
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
      backgroundColor: PageStyle().secondaryColor,
      child: const Icon(Icons.add),
    );
  }
}
