import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final String tooltip;
  final IconData icon;

  const RoundIconButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    required this.tooltip,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 46,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: backgroundColor,
            onPressed: onPressed,
            tooltip: tooltip,
            heroTag: null,
            child: Icon(icon),
          ),
        ),
      );
}
