import 'package:document_scanner/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveUsername extends ReactiveTextField {
  ReactiveUsername({
    required FormControl<String> formControl,
    bool autofocus = false,
    bool enabled = true,
    super.key,
  }) : super(
          textInputAction: TextInputAction.next,
          formControl: formControl,
          autofocus: autofocus,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(
            hintText: AppLang.i18n.field_username_hint,
            labelText: AppLang.i18n.field_username_label,
            // prefixIcon: Icon(PurchaseIcons.user)    ,
          ),
        );
}
