import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/pagestyle.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';
import 'package:flutter_todo_web/widgets/custom_AppBar.dart';
import 'package:flutter_todo_web/widgets/todo_Treemap_Layout.dart';
import 'package:flutter_todo_web/widgets/add_ToDo.dart';
import 'package:flutter_todo_web/services/firestore_service.dart';
import 'package:flutter_todo_web/services/auto_cleanup_service.dart';
import 'package:flutter_todo_web/widgets/trash_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirestoreService _firestoreService = FirestoreService();
  final AutoCleanupService _autoCleanupService = AutoCleanupService();
  bool _showTrash = false;

  @override
  void initState() {
    super.initState();
    // Initialize user document on first login
    _firestoreService.initializeUserDocument();
    // Start the auto-cleanup service
    _autoCleanupService.startAutoCleanup();
  }

  @override
  void dispose() {
    _autoCleanupService.stopAutoCleanup();
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

  Future<void> _handlePermanentDelete(TodoItem item) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permanently Delete Note'),
        content: Text('Are you sure you want to permanently delete "${item.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firestoreService.permanentlyDeleteNote(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note permanently deleted'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting note: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
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
      body: _showTrash ? _buildTrashView() : _buildNotesView(),
      floatingActionButton: _showTrash
          ? null
          : AddTodo(onItemAdded: _handleItemAdded),
    );
  }

  Widget _buildNotesView() {
    return StreamBuilder<List<TodoItem>>(
      stream: _firestoreService.getActiveNotes(),
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
          return const Center(
            child: Text(
              'No notes yet. Add one with the + button!',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return TodoTreemapLayout(
          items: currentItems,
          onDelete: _handleItemDeleted,
          onRestore: null,
          isTrashView: false,
        );
      },
    );
  }

  Widget _buildTrashView() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestoreService.getTrashedNotesWithExpiryInfo(),
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
                  'Error loading trash: ${snapshot.error}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final trashItems = snapshot.data ?? [];

        if (trashItems.isEmpty) {
          return const Center(
            child: Text(
              'No items in trash.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Column(
          children: [
            // Info banner about auto-deletion
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Notes are automatically deleted after 14 days in trash. Use restore to recover them.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            // Trash grid
            Expanded(child: _buildTrashGrid(trashItems)),
          ],
        );
      },
    );
  }

  Widget _buildTrashGrid(List<Map<String, dynamic>> trashItems) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        int cols;
        if (screenWidth < 600) {
          cols = 1;
        } else if (screenWidth < 900) {
          cols = 2;
        } else {
          cols = 3;
        }

        double childAspectRatio = screenWidth < 600 ? 1.5 : 1.0;

        return GridView.builder(
          padding: EdgeInsets.all(screenWidth < 600 ? 4 : 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: screenWidth < 600 ? 4 : 8,
            mainAxisSpacing: screenWidth < 600 ? 4 : 8,
          ),
          itemCount: trashItems.length,
          itemBuilder: (context, index) {
            final trashItem = trashItems[index];
            final item = trashItem['note'] as TodoItem;
            final daysRemaining = trashItem['daysRemaining'] as int;
            
            final colorValue = 100 + (155 * (item.text.length / 100).clamp(0.0, 1.0)).toInt();

            return TrashTile(
              item: item,
              colorValue: colorValue,
              daysRemaining: daysRemaining,
              onRestore: () => _handleItemRestored(item),
              onPermanentDelete: () => _handlePermanentDelete(item),
            );
          },
        );
      },
    );
  }
}
