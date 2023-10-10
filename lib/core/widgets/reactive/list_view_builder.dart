import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef ReactiveNullableIndexedWidgetBuilder<ItemState> = Widget? Function(
    BuildContext context, int index, int count, AbstractControl<ItemState> item);

class ReactiveListViewBuilder<ItemState> extends StatelessWidget {
  final FormArray<ItemState> formArray;
  final ReactiveNullableIndexedWidgetBuilder itemBuilder;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ReactiveListViewBuilder({
    required this.itemBuilder,
    required this.formArray,
    this.shrinkWrap = true,
    this.physics = const ClampingScrollPhysics(),
    super.key,
  });

  @override
  Widget build(BuildContext context) => ReactiveFormArray<ItemState>(
        formArray: formArray,
        builder: (context, formArray, child) {
          return ListView.builder(
            key: ValueKey(formArray.controls),
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemCount: formArray.controls.length,
            itemBuilder: (context, index) => itemBuilder(
              context,
              index,
              formArray.controls.length,
              formArray.controls[index],
            ),
          );
        },
      );
}
