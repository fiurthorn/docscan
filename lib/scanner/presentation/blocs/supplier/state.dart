part of "bloc.dart";

typedef ItemStateBloc = TextFieldBloc<dynamic>;

class ItemState extends GroupFieldBloc<FieldBloc, dynamic> {
  ListFieldBloc<ItemStateBloc, dynamic> get suppliers =>
      state.fieldBlocs["suppliers"] as ListFieldBloc<ItemStateBloc, dynamic>;

  ItemState()
      : super(name: "main", fieldBlocs: [
          ListFieldBloc<ItemStateBloc, String>(name: "suppliers"),
        ]) {
    keyValues().supplierNames().then((value) {
      for (var element in value) {
        createItem(initialValue: element);
      }
    });
  }

  void createItem({String? initialValue}) {
    suppliers.addFieldBloc(
      TextFieldBloc(
        initialValue: initialValue ?? "",
        validators: [
          FieldBlocValidators.required,
        ],
      ),
    );
  }

  void removeItem(int index) {
    suppliers.removeFieldBlocAt(index);
  }
}
