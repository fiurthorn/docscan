import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

typedef CancelAction = void Function();

class CancelableLoadingDialog extends StatelessWidget {
  static void show(CancelAction onCancel, BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (_) => CancelableLoadingDialog(onCancel, key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  final CancelAction onCancel;

  const CancelableLoadingDialog(this.onCancel, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            // width: 80,
            // height: 80,
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton.extended(
              label: const Text("Aktion abbrechen"),
              icon: const Icon(
                Icons.close,
              ),
              onPressed: () {
                onCancel();
                hide(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressLoadingDialog extends StatefulWidget {
  final FormControl<int> control;
  final int max;

  const ProgressLoadingDialog({
    required this.control,
    this.max = 100,
    super.key,
  });

  static void show(BuildContext context, FormControl<int> control, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (_) => ProgressLoadingDialog(
          control: control,
          key: key,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  State<ProgressLoadingDialog> createState() => _ProgressLoadingDialogState();
}

class _ProgressLoadingDialogState extends State<ProgressLoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return ReactiveFormField(
        formControl: widget.control,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Card(
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(
                    value: ((widget.control.value ?? 0) > 0) ? (widget.control.value! / widget.max) : 0,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
