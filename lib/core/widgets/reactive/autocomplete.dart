import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveAutocomplete<T extends Object> extends StatelessWidget {
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final FormControl<T> formControl;
  final TextInputAction? textInputAction;
  final InputDecoration decoration;
  final bool enableSuggestions;

  const ReactiveAutocomplete({
    required this.formControl,
    required this.optionsBuilder,
    this.enableSuggestions = false,
    this.textInputAction,
    this.decoration = const InputDecoration(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: optionsBuilder,
      onSelected: (option) => formControl.updateValue(option),
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return ReactiveTextField<T>(
          textInputAction: textInputAction,
          formControl: formControl,
          focusNode: focusNode,
          controller: textEditingController,
          decoration: decoration,
          enableSuggestions: enableSuggestions,
          onSubmitted: (control) => onFieldSubmitted(),
        );
      },
    );
  }
}
