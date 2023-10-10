import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum ReactivePasswordKind {
  password,
  confirm,
  current,
}

extension ReactivePasswordKindExtension on ReactivePasswordKind {
  String get label {
    switch (this) {
      case ReactivePasswordKind.password:
        return AppLang.i18n.field_password_label;
      case ReactivePasswordKind.confirm:
        return AppLang.i18n.field_confirmPassword_label;
      case ReactivePasswordKind.current:
        return AppLang.i18n.field_currentPassword_label;
    }
  }
}

class ReactivePassword extends StatefulWidget {
  final FormControl<String> formControl;
  final ValueChanged<FormControl<String>>? onChanged;
  final ReactivePasswordKind kind;
  final bool autofocus;

  const ReactivePassword({
    required this.formControl,
    required this.kind,
    this.autofocus = false,
    this.onChanged,
    super.key,
  });

  @override
  State<ReactivePassword> createState() => _ReactivePasswordState();
}

class _ReactivePasswordState extends State<ReactivePassword> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ReactiveTextField(
            formControl: widget.formControl,
            onChanged: (control) => widget.onChanged,
            textInputAction: TextInputAction.next,
            autofocus: widget.autofocus,
            obscureText: obscureText,
            autofillHints: widget.kind == ReactivePasswordKind.password //
                ? const [AutofillHints.password]
                : null,
            decoration: InputDecoration(
              hintText: AppLang.i18n.field_password_hint,
              labelText: widget.kind.label,
              suffixIcon: ExcludeFocus(
                child: InkWell(
                  child: Icon(
                    obscureText //
                        ? ThemeIcons.noObscure
                        : ThemeIcons.obscure,
                  ),
                  onTap: () => setState(() => obscureText = !obscureText),
                ),
              ),
            ),
          ),
        ],
      );
}
