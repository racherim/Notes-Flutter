import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xffa663cc),
      shadowColor: Colors.black,
      leading: isTrashView ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onToggleView,
        tooltip: 'Back to Notes',
      ) : null,
      actions: [
        IconButton(
          onPressed: onToggleView,
          icon: Icon(isTrashView ? Icons.note : Icons.delete),
          tooltip: isTrashView ? 'View Notes' : 'View Trash',
          color: Colors.white,
        ),
      ],
    );
  }
}