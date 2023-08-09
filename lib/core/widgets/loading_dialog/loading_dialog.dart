import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({super.key});

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
        useRootNavigator: false,
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
