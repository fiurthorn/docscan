import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final labelStyle = const TextStyle(fontSize: 15, letterSpacing: 0);

  final Color backgroundColor;
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const RoundButton({
    super.key,
    this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        key: ObjectKey(label),
        height: 46,
        child: FittedBox(
          child: FloatingActionButton.extended(
            label: Text(label, style: labelStyle),
            icon: icon == null ? null : Icon(icon, size: 18),
            backgroundColor: backgroundColor,
            onPressed: onPressed,
            heroTag: null,
          ),
        ),
      );
}
