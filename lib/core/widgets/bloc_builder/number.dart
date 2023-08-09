import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class NumberBlocBuilder extends TextFieldBlocBuilder {
  NumberBlocBuilder({
    required TextFieldBloc<dynamic> bloc,
    bool requestFocus = false,
    bool rightAlign = false,
    bool isEnabled = true,
    String? label,
    String? hint,
    super.key,
  }) : super(
          textFieldBloc: bloc,
          autofocus: requestFocus,
          isEnabled: isEnabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9,.]"))],
          textAlign: rightAlign ? TextAlign.right : null,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
          ),
        );
}
