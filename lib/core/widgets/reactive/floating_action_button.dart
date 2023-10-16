import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef ReactiveFabVoidCallback = void Function(FormGroup formGroup);

class ReactiveFloatingActionButton extends StatelessWidget {
  final ReactiveFabVoidCallback onPressed;
  final Widget child;

  final Color? backgroundColor;
  final Color? validBackgroundColor;

  final Object? heroTag;

  const ReactiveFloatingActionButton({
    required this.onPressed,
    required this.child,
    this.heroTag,
    this.backgroundColor,
    this.validBackgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ReactiveFormConsumer(
        child: child,
        builder: (context, formGroup, child) => FloatingActionButton(
          heroTag: heroTag,
          backgroundColor: formGroup.valid //
              ? validBackgroundColor
              : backgroundColor,
          onPressed: () => onPressed(formGroup),
          child: child,
        ),
      );
}
