import 'dart:async';

import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/load_list_items.dart';
import 'package:document_scanner/scanner/domain/usecases/store_list_items.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

part 'state.dart';

class ItemBloc extends FormBloc<String, ErrorValue> {
  ItemState get main => (state.groupFieldBlocOf("main")! as ItemState);

  ItemBloc() : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [ItemState()]);
  }

  @override
  FutureOr<void> onLoading() {
    emitLoaded();
  }

  Future<bool> validate() {
    return main.validate();
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      await sl<StoreListItemsUseCase>().call(
        StoreListItemsParam(
          KeyValueNames.senderNames,
          main.receivers.value.map((e) => e.value).toList(),
        ),
      );
      emitSuccess(successResponse: "Saved");
    } on Exception catch (err, stack) {
      emitFailure(failureResponse: ErrorValue(err, stack));
    }
  }
}
