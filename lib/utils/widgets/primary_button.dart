import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = Text(text);
    return icon == null
        ? ElevatedButton(onPressed: onPressed, child: child)
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: child,
          );
  }
}
