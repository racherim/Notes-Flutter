import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';

class TrashTilesWidget extends StatelessWidget {
  final TodoItem item;
  final int colorValue;
  final VoidCallback? onRestore;
  final VoidCallback? onPermanentDelete;
  final int daysRemaining;

  const TrashTilesWidget({
    super.key,
    required this.item,
    required this.colorValue,
    this.onRestore,
    this.onPermanentDelete,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final charCount = item.text.length;
    final isExpiringSoon = daysRemaining <= 3;
    final isExpired = daysRemaining <= 0;

    return Card(
      color: isExpired 
          ? Colors.red.withValues(alpha: 0.3)
          : isExpiringSoon 
              ? Colors.orange.withValues(alpha: 0.3)
              : Color.fromARGB(255, colorValue, 100, 255 - colorValue).withValues(alpha: 0.7),
      elevation: 4,
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 40.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Note Title
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isExpired ? Colors.red.shade700 : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
                  ),
                  const SizedBox(height: 4),
                  // Main Note Text Content
                  Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isExpired ? Colors.red.shade600 : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
                  ),
                ],
              ),
            ),
          ),

          // Restore button
          if (onRestore != null)
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onRestore,
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.restore,
                      size: 20,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),

          // Permanent delete button
          if (onPermanentDelete != null)
            Positioned(
              top: 4,
              right: 30,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onPermanentDelete,
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.delete_forever,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),

          // Character count and expiry info
          Positioned(
            bottom: 4,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$charCount chars',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isExpired 
                        ? Colors.red 
                        : isExpiringSoon 
                            ? Colors.orange 
                            : Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isExpired 
                        ? 'Expired' 
                        : daysRemaining == 1 
                            ? '1 day left' 
                            : '$daysRemaining days left',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
