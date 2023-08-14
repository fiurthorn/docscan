part of "bloc.dart";

typedef ItemStateBloc = TextFieldBloc<dynamic>;

class ItemState extends GroupFieldBloc<FieldBloc, dynamic> {
  ListFieldBloc<ItemStateBloc, dynamic> get documentTypes =>
      state.fieldBlocs["documentTypes"] as ListFieldBloc<ItemStateBloc, dynamic>;

  ItemState()
      : super(name: "main", fieldBlocs: [
          ListFieldBloc<ItemStateBloc, String>(name: "documentTypes"),
        ]) {
    keyValues().documentTypeItems().then((value) {
      for (var element in value) {
        createItem(initialValue: element);
      }
    });
  }

  void createItem({String? initialValue}) {
    documentTypes.addFieldBloc(
      TextFieldBloc(
        initialValue: initialValue ?? "",
        validators: [
          FieldBlocValidators.required,
        ],
      ),
    );
  }

  void removeItem(int index) {
    documentTypes.removeFieldBlocAt(index);
  }
}
