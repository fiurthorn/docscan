import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;

  const RectangleButton({
    super.key,
    this.icon,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              for (final w in [
                Icon(icon),
                const SizedBox(
                  width: 8,
                )
              ])
                w,
            Text(label),
          ],
        ),
      ),
    );
  }
}
