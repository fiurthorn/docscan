import 'package:reactive_forms/reactive_forms.dart';

class ResetFormControl<T> extends FormControl<T> {
  T? initialValue;

  ResetFormControl({
    this.initialValue,
    super.validators,
    super.asyncValidators,
    super.asyncValidatorsDebounceTime,
    super.touched,
    super.disabled,
  }) : super(value: initialValue);

  @override
  void reset({T? value, bool updateParent = true, bool emitEvent = true, bool removeFocus = false, bool? disabled}) {
    super.reset(
      value: (value != null) ? (initialValue = value) : initialValue,
      updateParent: updateParent,
      emitEvent: emitEvent,
      removeFocus: removeFocus,
      disabled: disabled,
    );
  }
}
