part of "bloc.dart";

class FileAttachment extends Tuple3<String, Uint8List, int> {
  String get name => a;
  Uint8List get data => b;
  int get size => c;

  const FileAttachment(String name, Uint8List data, int size) : super(name, data, size);
}

typedef AttachmentState
    = SingleFieldBloc<FileAttachment, dynamic, FieldBlocState<FileAttachment, dynamic, dynamic>, dynamic>;

class AttachState extends GroupFieldBloc<FieldBloc, dynamic> {
  ListFieldBloc<AttachmentState, String> get attachments =>
      state.fieldBlocs["attachments"] as ListFieldBloc<AttachmentState, String>;

  SelectFieldBloc<I18nLabel, dynamic> get documentType =>
      state.fieldBlocs["documentType"] as SelectFieldBloc<I18nLabel, dynamic>;

  SelectFieldBloc<I18nLabel, dynamic> get area => state.fieldBlocs["area"] as SelectFieldBloc<I18nLabel, dynamic>;

  TextFieldBloc<String> get senderName => state.fieldBlocs["senderName"] as TextFieldBloc<String>;

  SelectFieldBloc<DropDownEntry, dynamic> get receiverName =>
      state.fieldBlocs["receiverName"] as SelectFieldBloc<DropDownEntry, dynamic>;

  DateTimeBloc get documentDate => state.fieldBlocs["documentDate"] as DateTimeBloc;

  AttachState()
      : super(name: "main", fieldBlocs: [
          ListFieldBloc<AttachmentState, String>(name: "attachments"),
          SelectFieldBloc<I18nLabel, dynamic>(
            name: "area",
            validators: [notEmptyObject()],
          ),
          SelectFieldBloc<I18nLabel, dynamic>(
            name: "documentType",
            validators: [notEmptyObject()],
          ),
          TextFieldBloc<String>(
            name: "senderName",
            validators: [notEmpty()],
            suggestions: senderNames,
          ),
          SelectFieldBloc<DropDownEntry, dynamic>(
            name: "receiverName",
            validators: [notEmptyObject()],
          ),
          DateTimeBloc.create(name: "documentDate", validators: [notEmpty()]),
        ]) {
    attachments.emit(attachments.state.copyWith(isValidating: false));

    receiverNameItems().then((value) => receiverName.updateItems(value));
    documentTypeItems().then((value) => documentType.updateItems(value));
    areaItems().then((value) => area.updateItems(value));
  }

  void uploadAttachment(String filename, Uint8List bytes) {
    final value = FileAttachment(filename, bytes, bytes.length);
    final attachment = InputFieldBloc<FileAttachment, dynamic>(initialValue: value);
    attachments.addFieldBloc(attachment);
  }

  void removeAttachment(int index) {
    attachments.removeFieldBlocAt(index);
  }

  static Future<List<String>> senderNames(String pattern) async {
    return sl<LoadListItemsUseCase>()
        .call(LoadListItemsParam(KeyValueNames.senderNames))
        .then((value) => value.eval())
        .then(
          (value) => value
              .where(
                (element) => element.toLowerCase().contains(pattern.toLowerCase()),
              )
              .toList()
            ..sort((a, b) => a.compareTo(b)),
        );
  }

  static Future<List<DropDownEntry>> receiverNameItems() async {
    return sl<LoadListItemsUseCase>()
        .call(LoadListItemsParam(KeyValueNames.receiverNames))
        .then((value) => value.eval())
        .then(
          (value) => value
              .map(
                (element) => DropDownEntry.build(label: element),
              )
              .toList()
            ..sort((a, b) => a.label.compareTo(b.label)),
        );
  }

  static Future<List<I18nLabel>> documentTypeItems() async {
    return sl<LoadListItemsUseCase>()
        .call(LoadListItemsParam(KeyValueNames.documentTypes))
        .then((value) => value.eval())
        .then(
          (value) => value
              .map(
                (element) => I18nLabel.build(label: element),
              )
              .toList()
            ..sort((a, b) => a.label.compareTo(b.label)),
        );
  }

  static Future<List<I18nLabel>> areaItems() async {
    return sl<LoadListItemsUseCase>().call(LoadListItemsParam(KeyValueNames.areas)).then((value) => value.eval()).then(
          (value) => value
              .map(
                (element) => I18nLabel.build(label: element),
              )
              .toList()
            ..sort((a, b) => a.label.compareTo(b.label)),
        );
  }
}
