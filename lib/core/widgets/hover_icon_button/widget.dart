import 'package:flutter/material.dart';

class HoverIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final IconData? hoverIcon;
  final String? tooltip;
  final double? size;
  final Color color;
  final Color? hoverColor;

  const HoverIconButton({
    required this.color,
    required this.icon,
    required this.onPressed,
    this.size,
    this.hoverColor,
    this.hoverIcon,
    this.tooltip,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HoverIconButton();
}

class _HoverIconButton extends State<HoverIconButton> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _isHover = true),
        onExit: (_) => setState(() => _isHover = false),
        child: Tooltip(
          message: widget.tooltip,
          child: IconButton(
            onPressed: widget.onPressed,
            icon: Icon(
              (_isHover ? widget.hoverIcon : widget.icon) ?? widget.icon,
              color: (_isHover ? widget.hoverColor : widget.color) ?? widget.color,
              size: widget.size,
            ),
          ),
        ),
      );
}
