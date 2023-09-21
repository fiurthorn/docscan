part of "bloc.dart";

typedef ItemStateBloc = TextFieldBloc<dynamic>;

class ItemState extends GroupFieldBloc<FieldBloc, dynamic> {
  ListFieldBloc<ItemStateBloc, dynamic> get areas => state.fieldBlocs["areas"] as ListFieldBloc<ItemStateBloc, dynamic>;

  ItemState()
      : super(name: "main", fieldBlocs: [
          ListFieldBloc<ItemStateBloc, String>(name: "areas"),
        ]) {
    usecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(KeyValueNames.areas)).then((value) {
      for (var element in value) {
        createItem(initialValue: element);
      }
    });
  }

  void createItem({String? initialValue}) {
    areas.addFieldBloc(
      TextFieldBloc(
        initialValue: initialValue ?? "",
        validators: [
          FieldBlocValidators.required,
        ],
      ),
    );
  }

  void removeItem(int index) {
    areas.removeFieldBlocAt(index);
  }
}
