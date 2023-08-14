part of "bloc.dart";

typedef ItemStateBloc = SingleFieldBloc<String, dynamic, FieldBlocState<String, dynamic, dynamic>, dynamic>;

class ItemState extends GroupFieldBloc<FieldBloc, dynamic> {
  ListFieldBloc<ItemStateBloc, dynamic> get areas => state.fieldBlocs["areas"] as ListFieldBloc<ItemStateBloc, dynamic>;

  ItemState()
      : super(name: "main", fieldBlocs: [
          ListFieldBloc<ItemStateBloc, String>(name: "area"),
        ]) {
    keyValues().areaItems().then((value) {
      for (var element in value) {
        createItem(initialValue: element);
      }
    });
  }

  void createItem({String? initialValue}) {
    areas.addFieldBloc(TextFieldBloc(initialValue: initialValue ?? ""));
  }

  void removeItem(int index) {
    areas.removeFieldBlocAt(index);
  }
}
