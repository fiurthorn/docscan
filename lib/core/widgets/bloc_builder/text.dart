import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class TextBlocBuilder extends TextFieldBlocBuilder {
  TextBlocBuilder({
    required TextFieldBloc<dynamic> bloc,
    bool requestFocus = false,
    bool isEnabled = true,
    String? label,
    String? hint,
    super.key,
  }) : super(
          autofocus: requestFocus,
          enableSuggestions: true,
          isEnabled: isEnabled,
          textFieldBloc: bloc,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
          ),
        );
}
