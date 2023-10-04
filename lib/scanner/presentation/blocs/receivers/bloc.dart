import 'package:document_scanner/core/lib/compare/compare.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/reactive/bloc.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/load_list_items.dart';
import 'package:document_scanner/scanner/domain/usecases/store_list_items.dart';
import 'package:equatable/equatable.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'state.dart';

class ItemBloc extends ReactiveBloc<StateParameter> {
  final receivers = FormArray<String>([]);

  ItemBloc() : super(parameter: const StateParameter());

  Map<String, AbstractControl>? _form;

  @override
  Map<String, AbstractControl> get form => _form ??= {
        "receiver": receivers,
      };

  @override
  Future<void> loading() async {
    final items = getItems(KeyValueNames.receiverNames);
    for (var item in items) {
      receivers.add(FormControl<String>(value: item, validators: [Validators.required]));
    }
  }

  void removeItem(int index) {
    receivers.removeAt(index);
    receivers.markAsDirty();
  }

  void addItem() {
    receivers.add(FormControl<String>(validators: [Validators.required]));
    receivers.markAsDirty();
    emit(UpdateReactiveState(parameter: state.parameter));
  }

  List<String> getItems(KeyValueNames key) {
    return syncUsecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(key))..sort(compare);
  }

  submit() {
    try {
      emitSubmitting();
      usecase<StoreListItemsResult, StoreListItemsParam>(
        StoreListItemsParam(KeyValueNames.receiverNames, receivers.value!.map((e) => e!).toList()),
      ).then((value) => emitSuccess(successResponse: "Saved"));
    } on Exception catch (err, stack) {
      emitFailure(failureResponse: ErrorValue(err, stack));
    }
  }
}
