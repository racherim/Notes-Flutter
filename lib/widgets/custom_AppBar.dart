import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/pagestyle.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTrashView;
  final VoidCallback onToggleView;

  const CustomAppBar({
    super.key,
    this.isTrashView = false,
    required this.onToggleView,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(isTrashView ? 'Trash' : 'Notes'),
      backgroundColor: PageStyle().mainColor,
      elevation: 8.0,
      shadowColor: Colors.black.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: isTrashView
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onToggleView,
              tooltip: 'Back to Notes',
            )
          : null,
      actions: [
        IconButton(
          onPressed: onToggleView,
          icon: Icon(isTrashView ? Icons.note : Icons.delete),
          tooltip: isTrashView ? 'View Notes' : 'View Trash',
          color: PageStyle().buttonColor
        ),
        SizedBox(width: 10),
        IconButton(
          onPressed: (){}, 
          icon: Icon(Icons.account_circle),
          color: PageStyle().buttonColor
          )
      ],
    );
  }
}
