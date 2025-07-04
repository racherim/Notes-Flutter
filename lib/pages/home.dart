import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/pagestyle.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';
import 'package:flutter_todo_web/widgets/custom_AppBar.dart';
import 'package:flutter_todo_web/widgets/todo_Treemap_Layout.dart';
import 'package:flutter_todo_web/widgets/add_ToDo.dart';
import 'package:flutter_todo_web/services/firestore_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _showTrash = false;

  @override
  void initState() {
    super.initState();
    // Initialize user document on first login
    _firestoreService.initializeUserDocument();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleItemAdded(TodoItem newItem) async {
    try {
      await _firestoreService.addNote(newItem);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note added successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding note: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleItemDeleted(TodoItem item) async {
    try {
      await _firestoreService.moveToTrash(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note moved to trash'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error moving note to trash: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleItemRestored(TodoItem item) async {
    try {
      await _firestoreService.restoreFromTrash(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note restored successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error restoring note: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _toggleTrashView() {
    setState(() {
      _showTrash = !_showTrash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isTrashView: _showTrash,
        onToggleView: _toggleTrashView,
        appBarType: _showTrash ? AppBarType.trash : AppBarType.notes,
      ),
      backgroundColor: PageStyle().backgroundColor,
      body: StreamBuilder<List<TodoItem>>(
        stream: _showTrash 
            ? _firestoreService.getTrashedNotes()
            : _firestoreService.getActiveNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading notes: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final currentItems = snapshot.data ?? [];

          if (currentItems.isEmpty) {
            return Center(
              child: Text(
                _showTrash
                    ? 'No items in trash.'
                    : 'No notes yet. Add one with the + button!',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          return TodoTreemapLayout(
            items: currentItems,
            onDelete: _showTrash ? null : _handleItemDeleted,
            onRestore: _showTrash ? _handleItemRestored : null,
            isTrashView: _showTrash,
          );
        },
      ),
      floatingActionButton: _showTrash
          ? null
          : AddTodo(onItemAdded: _handleItemAdded),
    );
  }
}
