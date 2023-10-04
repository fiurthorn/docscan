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
  final documentTypes = FormArray<String>([]);

  ItemBloc() : super(parameter: const StateParameter());

  Map<String, AbstractControl>? _form;

  @override
  Map<String, AbstractControl> get form => _form ??= {
        "documentTypes": documentTypes,
      };

  @override
  Future<void> loading() async {
    final items = getItems(KeyValueNames.documentTypes);
    for (var item in items) {
      documentTypes.add(FormControl<String>(value: item, validators: [Validators.required]));
    }
  }

  void removeItem(int index) {
    documentTypes.removeAt(index);
    documentTypes.markAsDirty();
  }

  void addItem() {
    documentTypes.add(FormControl<String>(validators: [Validators.required]));
    documentTypes.markAsDirty();
    emit(UpdateReactiveState(parameter: state.parameter));
  }

  List<String> getItems(KeyValueNames key) {
    return syncUsecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(key))..sort(compare);
  }

  submit() {
    try {
      emitSubmitting();
      usecase<StoreListItemsResult, StoreListItemsParam>(
        StoreListItemsParam(KeyValueNames.documentTypes, documentTypes.value!.map((e) => e!).toList()),
      ).then((value) => emitSuccess(successResponse: "Saved"));
    } on Exception catch (err, stack) {
      emitFailure(failureResponse: ErrorValue(err, stack));
    }
  }
}
