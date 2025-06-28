import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';

class TodoTile extends StatelessWidget {
  final TodoItem item;
  final int colorValue;

  const TodoTile({
    super.key,
    required this.item,
    required this.colorValue,
  });

  @override
  Widget build(BuildContext context) {
    final hue = (item.id.hashCode % 360).toDouble();
    
    return Card(
      elevation: 3,
      color: HSLColor.fromAHSL(
        1.0,
        hue,
        0.7,
        colorValue / 255,
      ).toColor(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(
                  color: colorValue > 180 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            Text(
              '${item.text.length} chars',
              style: TextStyle(
                fontSize: 10,
                color: colorValue > 180 ? Colors.black54 : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}