import 'package:document_scanner/core/lib/compare/compare.dart';
import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/reactive/bloc.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/load_list_items.dart';
import 'package:document_scanner/scanner/domain/usecases/store_list_items.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'bloc.freezed.dart';

@freezed
class StateParameter with _$StateParameter {
  factory StateParameter() = _StateParameter;
}

class ItemBloc extends ReactiveBloc<StateParameter> {
  final senders = FormArray<String>([]);

  ItemBloc() : super(parameter: StateParameter());

  Map<String, AbstractControl>? _form;

  @override
  Map<String, AbstractControl> get form => _form ??= {
        "senders": senders,
      };

  @override
  Future<void> loading() async {
    final items = getItems(KeyValueNames.senderNames);
    for (var item in items) {
      senders.add(FormControl<String>(value: item, validators: [Validators.required]));
    }
  }

  void removeItem(int index) {
    senders.removeAt(index);
    senders.markAsDirty();
  }

  void addItem() {
    senders.add(FormControl<String>(validators: [Validators.required]));
    senders.markAsDirty();
    emitUpdate(parameter: state.parameter);
  }

  List<String> getItems(KeyValueNames key) {
    return syncUsecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(key))..sort(compare);
  }

  submit() {
    try {
      emitProgress();
      usecase<StoreListItemsResult, StoreListItemsParam>(
        StoreListItemsParam(KeyValueNames.senderNames, senders.value!.map((e) => e!).toList()),
      ).then((value) => emitProgressSuccess(successResponse: "Saved"));
    } on Exception catch (err, stack) {
      emitProgressFailureError(failureResponse: Failure(err, stack));
    }
  }
}
