import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/pagestyle.dart';
import 'package:flutter_todo_web/utils/routing.dart';

enum AppBarType { notes, trash, login, profile }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTrashView;
  final VoidCallback onToggleView;
  final AppBarType appBarType;

  const CustomAppBar({
    super.key,
    this.isTrashView = false,
    required this.onToggleView,
    this.appBarType = AppBarType.notes,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_getTitle()),
      backgroundColor: PageStyle().mainColor,
      elevation: 8.0,
      shadowColor: Colors.black.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false, // Prevents automatic back button
      actions: _buildActions(context),
    );
  }

  String _getTitle() {
    switch (appBarType) {
      case AppBarType.trash:
        return 'Trash';
      case AppBarType.profile:
        return 'Profile';
      case AppBarType.login:
        return 'Welcome';
      default:
        return 'Notes';
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    final List<Widget> actions = [];

    // Only show trash/notes toggle on notes or trash pages
    if (appBarType == AppBarType.notes || appBarType == AppBarType.trash) {
      actions.add(
        IconButton(
          onPressed: onToggleView,
          icon: Icon(isTrashView ? Icons.note : Icons.delete),
          tooltip: isTrashView ? 'View Notes' : 'View Trash',
          color: PageStyle().buttonColor,
        ),
      );

      // Only show profile icon on notes/trash pages
      actions.add(const SizedBox(width: 10));
      actions.add(
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.profile);
          },
          icon: const Icon(Icons.account_circle),
          color: PageStyle().buttonColor,
        ),
      );
    }

    // Add logout button on profile page
    if (appBarType == AppBarType.profile) {
      actions.add(
        IconButton(
          onPressed: () {
            // Implement logout functionality here
            Navigator.pushReplacementNamed(context, AppRouter.login);
          },
          icon: const Icon(Icons.logout),
          color: PageStyle().buttonColor,
        ),
      );
    }

    return actions;
  }
}
