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

    updateReceiverNames();
    updateDocumentTypeItems();
    updateAreaItems();
  }

  updateReceiverNames() => receiverNameItems().then((value) => receiverName.updateItems(value));
  updateDocumentTypeItems() => documentTypeItems().then((value) => documentType.updateItems(value));
  updateAreaItems() => areaItems().then((value) => area.updateItems(value));

  void uploadAttachment(String filename, Uint8List bytes) {
    final value = FileAttachment(filename, bytes, bytes.length);
    final attachment = InputFieldBloc<FileAttachment, dynamic>(initialValue: value);
    attachments.addFieldBloc(attachment);
  }

  void removeAttachment(int index) {
    attachments.removeFieldBlocAt(index);
  }

  static int compare(String a, String b) => a.toLowerCase().compareTo(b.toLowerCase());
  static int compareLabel(I18nLabel a, I18nLabel b) => a.label.toLowerCase().compareTo(b.label.toLowerCase());
  static int compareEntry(DropDownEntry a, DropDownEntry b) => a.label.toLowerCase().compareTo(b.label.toLowerCase());

  static Future<List<String>> senderNames(String pattern) async {
    return usecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(KeyValueNames.senderNames)).then(
      (value) => value
          .where(
            (element) => element.toLowerCase().contains(pattern.toLowerCase()),
          )
          .toList()
        ..sort(compare),
    );
  }

  static Future<List<DropDownEntry>> receiverNameItems() async {
    return usecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(KeyValueNames.receiverNames)).then(
      (value) => value
          .map(
            (element) => DropDownEntry.build(label: element),
          )
          .toList()
        ..sort(compareEntry),
    );
  }

  static Future<List<I18nLabel>> documentTypeItems() async {
    return usecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(KeyValueNames.documentTypes)).then(
      (value) => value
          .map(
            (element) => I18nLabel.build(label: element),
          )
          .toList()
        ..sort(compareLabel),
    );
  }

  static Future<List<I18nLabel>> areaItems() async {
    return usecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(KeyValueNames.areas)).then(
      (value) => value
          .map(
            (element) => I18nLabel.build(label: element),
          )
          .toList()
        ..sort(compareLabel),
    );
  }
}
