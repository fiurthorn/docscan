part of "bloc.dart";

typedef ItemStateBloc = TextFieldBloc<dynamic>;

class ItemState extends GroupFieldBloc<FieldBloc, dynamic> {
  ListFieldBloc<ItemStateBloc, dynamic> get receivers =>
      state.fieldBlocs["receivers"] as ListFieldBloc<ItemStateBloc, dynamic>;

  ItemState()
      : super(name: "main", fieldBlocs: [
          ListFieldBloc<ItemStateBloc, String>(name: "receivers"),
        ]) {
    sl<LoadListItemsUseCase>()
        .call(LoadListItemsParam(KeyValueNames.senderNames))
        .then((value) => value.eval())
        .then((value) {
      for (var element in value) {
        createItem(initialValue: element);
      }
    });
  }

  void createItem({String? initialValue}) {
    receivers.addFieldBloc(
      TextFieldBloc(
        initialValue: initialValue ?? "",
        validators: [
          FieldBlocValidators.required,
        ],
      ),
    );
  }

  void removeItem(int index) {
    receivers.removeFieldBlocAt(index);
  }
}
