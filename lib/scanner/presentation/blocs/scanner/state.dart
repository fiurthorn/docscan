part of "bloc.dart";

class FileAttachment extends Tuple3<String, String, int> {
  String get name => a;
  String get id => b;
  int get size => c;

  const FileAttachment(String name, String id, int size) : super(name, id, size);

  FileAttachment copyWith({required String id}) {
    return FileAttachment(name, id, size);
  }
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
          SelectFieldBloc<I18nLabel, dynamic>(name: "area", validators: [notEmptyObject()], items: areaItems()),
          SelectFieldBloc<I18nLabel, dynamic>(
              name: "documentType", validators: [notEmptyObject()], items: documentTypeItems()),
          TextFieldBloc<String>(name: "supplierName", validators: [notEmpty()], suggestions: supplierNames),
          DateTimeBloc.create(name: "documentDate", validators: [notEmpty()]),
        ]) {
    attachments.emit(attachments.state.copyWith(isValidating: false));
  }

  void uploadAttachment(String filename, Uint8List bytes, {required Function ready}) {
    final value = FileAttachment(filename, "", bytes.length);
    final attachment = InputFieldBloc<FileAttachment, dynamic>(initialValue: value);
    attachments.addFieldBloc(attachment);
    // sl<UploadAttachmentUseCase>()
    //     .call(UploadAttachmentParam(filename: filename, bytes: bytes))
    //     .then((id) => attachment.updateValue(value.copyWith(id: id.eval())))
    //     .then((_) => ready());
  }

  void removeAttachment(int index) {
    final id = attachments.state.fieldBlocs[index].value.id;
    attachments.removeFieldBlocAt(index);
    // sl<RemoveAttachmentUseCase>().call(RemoveAttachmentParam(id: id));
  }

  static Future<List<String>> supplierNames(String pattern) async {
    // TODO store in db; load from db
    return ["Axa", "Allianz", "Helsana", "Mobiliar", "Zurich", "Generali", "Helvetia", "Swisslife"];
  }

  static List<I18nLabel> documentTypeItems() {
    return [
      I18nLabel.build(label: "invoice;de:Rechnung;en:Invoice"),
      I18nLabel.build(label: "receipt;de:Quittung;en:Receipt"),
      I18nLabel.build(label: "other;de:Andere;en:Other"),
    ];
  }

  static List<I18nLabel> areaItems() {
    return [
      I18nLabel.build(label: "insurance;de:Versicherung;en:Insurance"),
    ];
  }
}
