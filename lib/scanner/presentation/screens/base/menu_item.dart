import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final Widget icon;
  final bool closeDrawer;
  final void Function(BuildContext context) action;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.action,
    this.closeDrawer = true,
  });
}
