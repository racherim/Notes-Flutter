import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';
import 'package:flutter_todo_web/widgets/custom_AppBar.dart';
import 'package:flutter_todo_web/widgets/todo_Treemap_Layout.dart';
import 'package:flutter_todo_web/widgets/add_ToDo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<TodoItem> _items = [];
  final List<TodoItem> _trashedItems = [];
  bool _showTrash = false;

  @override
  void dispose() {
    // No need to dispose of _textController anymore
    super.dispose();
  }

  void _handleItemAdded(TodoItem newItem) {
    setState(() {
      _items.add(newItem);
    });
  }

  void _handleItemDeleted(TodoItem item) {
    setState(() {
      _items.remove(item);
      _trashedItems.add(item);
    });
  }

  void _toggleTrashView() {
    setState(() {
      _showTrash = !_showTrash;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentItems = _showTrash ? _trashedItems : _items;
    return Scaffold(
      appBar: CustomAppBar(
        isTrashView: _showTrash,
        onToggleView: _toggleTrashView,
      ),
      backgroundColor: Color(0xffb8d0eb),
      body: currentItems.isEmpty
          ? Center(
              child: Text(
                _showTrash
                    ? 'No items in trash.'
                    : 'No notes yet. Add one with the + button!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : TodoTreemapLayout(
              items: currentItems,
              onDelete: _showTrash ? null : _handleItemDeleted,
              isTrashView: _showTrash,
            ),
      floatingActionButton: _showTrash
          ? null
          : AddTodo(onItemAdded: _handleItemAdded),
    );
  }
}
