import 'package:flutter/material.dart';

class MinimalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;

  const MinimalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.height = 48,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      actions: actions,
      leading: leading,
    );
  }
}
