import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(12.0),
          child: const CircularProgressIndicator(),
        ),
      );
}
