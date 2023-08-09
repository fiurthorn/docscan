import 'dart:async';

import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/states/validators.dart';
import 'package:document_scanner/core/widgets/bloc_builder/dropdown.dart';
import 'package:document_scanner/core/widgets/blocs/datetime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

part 'state.dart';

class ScannerBloc extends FormBloc<String, ErrorValue> {
  void uploadAttachment(String filename, Uint8List bytes, {required Function ready}) =>
      main.uploadAttachment(filename, bytes, ready: ready);

  void removeAttachment(int index) => main.removeAttachment(index);

  int attachmentCount() => main.attachments.value.length;
  List<AttachmentState> get attachments => main.attachments.value;

  AttachState get main => (state.groupFieldBlocOf("main")! as AttachState);

  ScannerBloc() {
    addFieldBlocs(fieldBlocs: [
      AttachState(),
    ]);
  }

  Future<bool> validate() {
    return main.validate();
  }

  @override
  FutureOr<void> onSubmitting() {
    // TODO store filecontent in download folder
    // TODO store supplier in db
    emitSuccess();
  }
}
