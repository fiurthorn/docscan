import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  static void show(BuildContext context, {Color? color, Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        barrierColor: color ?? Colors.black.withOpacity(0.5),
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(12.0),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

typedef CancelAction = void Function();

class CancelableLoadingDialog extends StatelessWidget {
  static void show(CancelAction onCancel, BuildContext context, {Color? color, Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        barrierColor: color ?? Colors.black.withOpacity(0.5),
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
        child: Container(
          // width: 80,
          // height: 80,
          padding: const EdgeInsets.all(12.0),
          child: FloatingActionButton.extended(
            elevation: 0,
            label: const Text("Aktion abbrechen"),
            icon: const Icon(Icons.close),
            onPressed: () {
              onCancel();
              hide(context);
            },
          ),
        ),
      ),
    );
  }
}

class ProgressLoadingDialog extends StatefulWidget {
  final FormControl<int>? progress;
  final int max;

  const ProgressLoadingDialog({
    required this.progress,
    this.max = 0,
    super.key,
  });

  static void show(BuildContext context, FormControl<int>? progress, int max, {Color? color, Key? key}) {
    assert(progress == null || max > 0, "progress and max have to set both calculate the progress");

    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: color ?? Colors.black.withOpacity(0.5),
      builder: (_) => ProgressLoadingDialog(
        progress: progress,
        max: max,
        key: key,
      ),
    ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));
  }

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  State<ProgressLoadingDialog> createState() => _ProgressLoadingDialogState();
}

class _ProgressLoadingDialogState extends State<ProgressLoadingDialog> {
  FormControl<int> get control => widget.progress!;

  @override
  Widget build(BuildContext context) {
    if (widget.progress == null) {
      return const LoadingDialog();
    }

    return ReactiveFormField(
        formControl: widget.progress,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  value: widget.max <= 0 ? null : (control.value! / widget.max),
                ),
              ),
            ),
          );
        });
  }
}
