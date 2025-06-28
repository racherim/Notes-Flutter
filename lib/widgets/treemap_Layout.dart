import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';
import 'package:flutter_todo_web/widgets/todo_Tiles.dart';

class TreemapLayout extends StatelessWidget {
  final List<TodoItem> items;

  const TreemapLayout({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Sort items by text length to make sizing more predictable
    final sortedItems = List<TodoItem>.from(items)
      ..sort((a, b) => b.text.length.compareTo(a.text.length));

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalChars = items.fold<int>(
            0, (sum, item) => sum + item.text.length);
        
        // Calculate grid dimensions
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        int cols = math.sqrt(items.length * aspectRatio).ceil();
        int rows = (items.length / cols).ceil();
        
        // Make sure we have at least one column and row
        cols = math.max(1, cols);
        rows = math.max(1, rows);
        
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = sortedItems[index];
            final itemSize = item.text.length / totalChars;
            // Select a color based on text length
            final colorValue = 100 + (155 * (item.text.length / sortedItems[0].text.length)).toInt();
            
            return TodoTile(item: item, colorValue: colorValue);
          },
        );
      },
    );
  }
}