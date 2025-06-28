import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';

class TodoTile extends StatelessWidget {
  final TodoItem item;
  final int colorValue;
  final VoidCallback? onDelete;
  final bool isInTrash;

  const TodoTile({
    super.key,
    required this.item,
    required this.colorValue,
    this.onDelete,
    this.isInTrash = false,
  });

  @override
  Widget build(BuildContext context) {
    final charCount = item.text.length;

    return Card(
      color: Color.fromARGB(255, colorValue, 100, 255 - colorValue),
      elevation: 4,
      child: Stack(
        children: [
          
          // Main content
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 24.0),
            child: Center(
              child: Text(
                item.text,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 8,
              ),
            ),
          ),
          
          // Delete button - always visible on active notes
          if (!isInTrash && onDelete != null)
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onDelete,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.delete_outline, 
                      size: 20, 
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          
          // Character count indicator
          Positioned(
            bottom: 4,
            left: 8,
            child: Text(
              '$charCount chars',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}