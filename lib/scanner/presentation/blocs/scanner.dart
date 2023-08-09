import 'dart:async';

import 'package:document_scanner/core/lib/optional.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ScannerBloc extends FormBloc<String, ErrorValue> {
  @override
  FutureOr<void> onSubmitting() {
    throw UnimplementedError();
  }
}
