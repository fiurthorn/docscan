import 'package:flutter/material.dart';

class ConfirmDialog extends AlertDialog {
  ConfirmDialog({
    required String title,
    required String content,
    required NavigatorState navigator,
    super.key,
  }) : super(
          title: Text(title),
          content: Text(content),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          alignment: Alignment.center,
          elevation: 0,
          actions: [
            TextButton(onPressed: () => navigator.pop(true), child: const Text("OK")),
            TextButton(onPressed: () => navigator.pop(false), child: const Text("Abbrechen")),
          ],
        );
}
