import 'package:reactive_forms/reactive_forms.dart';

class OneOfValidationMessage extends ValidationMessage {
  static const String oneOf = 'oneOf';
}

class OneOfRequiredValidator extends Validator<dynamic> {
  final List<AbstractControl> controls;

  const OneOfRequiredValidator(this.controls) : super();

  bool _notEmpty(AbstractControl control) =>
      ((control.value is String && (control.value as String).trim().isNotEmpty) ||
          (control.value is! String && control.value != null));

  void _reset() {
    for (var control in controls) {
      control.removeError(OneOfValidationMessage.oneOf);
    }
  }

  void _setError(Map<String, dynamic> error) {
    for (var control in controls) {
      control.setErrors(error, markAsDirty: false);
    }
  }

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final error = <String, dynamic>{OneOfValidationMessage.oneOf: true};

    if (control is! FormGroup) {
      return error;
    }
    final anyNotEmpty = controls.map((v) => _notEmpty(v)).any((element) => element);

    if (anyNotEmpty) {
      _reset();
    } else {
      _setError(error);
    }

    return null;
  }
}
