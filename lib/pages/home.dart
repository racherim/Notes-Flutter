import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';

import 'package:flutter_todo_web/widgets/treemap_Layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<TodoItem> _items = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodoItem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Todo'),
        content: TextField(
          controller: _textController,
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
              if (_textController.text.isNotEmpty) {
                setState(() {
                  _items.add(TodoItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    text: _textController.text,
                  ));
                  _textController.clear();
                });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes TreeMap'),
        backgroundColor: Color(0xffcdb4db),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No notes yet. Add one with the + button!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : TreemapLayout(items: _items),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoItem,
        backgroundColor: Color(0xffcdb4db),
        child: const Icon(Icons.add),
      ),
    );
  }
}
