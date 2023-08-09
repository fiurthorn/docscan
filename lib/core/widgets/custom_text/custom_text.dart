import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const CustomText(this.text, {super.key, this.size, this.color, this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 16,
          color: color ?? Theme.of(context).textTheme.bodyLarge!.color!,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}
