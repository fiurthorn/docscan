import 'package:document_scanner/core/reactive/i18n_label.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomRequiredValidator extends Validator<dynamic> {
  const CustomRequiredValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final error = <String, dynamic>{ValidationMessage.required: true};

    if (control.value == null) {
      return error;
    } else if (control.value is String) {
      return (control.value as String).trim().isEmpty ? error : null;
    } else if (control.value is I18nLabel) {
      return (control.value as I18nLabel).isEmpty ? error : null;
    }

    return null;
  }
}
