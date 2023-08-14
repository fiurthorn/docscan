import 'dart:async';

import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

part 'state.dart';

const original = "Original";
const grayscale = "GrayScale";
const monochrome = "Monochrome";
const luminance = "Luminance";

class ItemBloc extends FormBloc<String, ErrorValue> {
  ItemState get main => (state.groupFieldBlocOf("main")! as ItemState);

  ItemBloc() {
    addFieldBlocs(fieldBlocs: [ItemState()]);
  }

  Future<bool> validate() {
    return main.validate();
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      keyValues().setSupplierNames(main.areas.value.map((e) => e.value).toList());
      emitSuccess(successResponse: "Saved");
    } on Exception catch (err, stack) {
      emitFailure(failureResponse: ErrorValue(err, stack));
    }
  }
}
