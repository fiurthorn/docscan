import 'package:reactive_forms/reactive_forms.dart';

abstract class ReactiveBlocForm {
  Map<String, AbstractControl> get form;
}
