import 'package:document_scanner/core/widgets/blocs/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class DateTimeSuffixButton extends StatelessWidget {
  final DateTime? firstDateTime;
  final Duration? lastDateDuration;
  final void Function(DateTime?) onSubmit;
  final DateTime? Function() initialDateTime;

  const DateTimeSuffixButton({
    required this.onSubmit,
    required this.initialDateTime,
    this.firstDateTime,
    this.lastDateDuration,
    super.key,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.date_range),
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: initialDateTime() ?? DateTime.now(),
            firstDate: firstDateTime ?? DateTime.now(),
            lastDate: firstDateTime ?? DateTime.now().add(lastDateDuration ?? const Duration(days: 3653)),
          ).then(onSubmit);
        },
      );
}

class DateTimeBlocBuilder extends TextFieldBlocBuilder {
  DateTimeBlocBuilder({
    super.key,
    bool requestFocus = false,
    bool isEnabled = true,
    String? label,
    String? hint,
    DateTime? firstDateTime,
    Duration? lastDateDuration,
    required DateTimeBloc<dynamic> bloc,
  }) : super(
          textFieldBloc: bloc,
          autofocus: requestFocus,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[-/0-9.]"))],
          isEnabled: isEnabled,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            suffixIcon: Focus(
              descendantsAreFocusable: false,
              descendantsAreTraversable: false,
              canRequestFocus: false,
              child: DateTimeSuffixButton(
                initialDateTime: () => bloc.dateTime,
                firstDateTime: firstDateTime,
                lastDateDuration: lastDateDuration,
                onSubmit: bloc.updateDateTimeValue,
              ),
            ),
          ),
        );
}
