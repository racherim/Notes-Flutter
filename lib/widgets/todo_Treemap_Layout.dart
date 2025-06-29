import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';
import 'package:flutter_todo_web/widgets/todo_Tiles.dart';

class TodoTreemapLayout extends StatelessWidget {
  final List<TodoItem> items;
  final Function(TodoItem)? onDelete;
  final bool isTrashView;

  const TodoTreemapLayout({
    super.key,
    required this.items,
    this.onDelete,
    this.isTrashView = false,
  });

  @override
  Widget build(BuildContext context) {
    // Sort items by text length to make sizing more predictable
    final sortedItems = List<TodoItem>.from(items)
      ..sort((a, b) => b.text.length.compareTo(a.text.length));

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalChars = items.fold<int>(
          0,
          (sum, item) => sum + item.text.length,
        );

        final screenWidth = constraints.maxWidth;
        int cols;
        if (screenWidth < 600) {
          // For small mobile screens
          cols = 1;
        } else if (screenWidth < 900) {
          // For larger mobile/small tablet screens
          cols = 2;
        } else {
          // For larger screens, use the original calculation with a max limit
          final aspectRatio = constraints.maxWidth / constraints.maxHeight;
          cols = math.min(5, math.sqrt(items.length * aspectRatio).ceil());
        }

        int rows = (items.length / cols).ceil();

        // Adjust tile aspect ratio based on screen size
        double childAspectRatio;
        if (screenWidth < 600) {
          childAspectRatio = 1.5; // More rectangular on small screens
        } else {
          childAspectRatio = 1.0; // Square on larger screens
        }

        return GridView.builder(
          padding: EdgeInsets.all(screenWidth < 600 ? 4 : 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: screenWidth < 600 ? 4 : 8,
            mainAxisSpacing: screenWidth < 600 ? 4 : 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = sortedItems[index];
            final itemSize = item.text.length / totalChars;
            final colorValue =
                100 +
                (155 * (item.text.length / sortedItems[0].text.length)).toInt();

            return TodoTile(
              item: item,
              colorValue: colorValue,
              onDelete: onDelete != null ? () => onDelete!(item) : null,
              isInTrash: isTrashView,
            );
          },
        );
      },
    );
  }
}
