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

  TextFieldBloc<String> get supplierName => state.fieldBlocs["supplierName"] as TextFieldBloc<String>;

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
            name: "supplierName",
            validators: [notEmpty()],
            suggestions: supplierNames,
          ),
          DateTimeBloc.create(name: "documentDate", validators: [notEmpty()]),
        ]) {
    attachments.emit(attachments.state.copyWith(isValidating: false));

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

  static Future<List<String>> supplierNames(String pattern) async {
    return keyValues().supplierNames().then(
          (value) => value
              .where(
                (element) => element.toLowerCase().contains(pattern.toLowerCase()),
              )
              .toList(),
        );
  }

  static Future<List<I18nLabel>> documentTypeItems() async {
    return keyValues().documentTypeItems().then(
          (value) => value
              .map(
                (element) => I18nLabel.build(label: element),
              )
              .toList(),
        );
  }

  static Future<List<I18nLabel>> areaItems() async {
    return keyValues().areaItems().then(
          (value) => value
              .map(
                (element) => I18nLabel.build(label: element),
              )
              .toList(),
        );
  }
}
