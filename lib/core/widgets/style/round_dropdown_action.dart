import 'package:flutter/material.dart';
import 'package:document_scanner/core/design/theme_colors.dart';

class RoundDropdownAction<T> extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  final T value;
  final DropdownButtonBuilder selectedItemBuilder;
  final List<DropdownMenuItem<T>>? items;

  final ValueChanged<T?>? onChanged;

  const RoundDropdownAction({
    super.key,
    required this.color,
    required this.onChanged,
    required this.items,
    required this.value,
    required this.selectedItemBuilder,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 46,
        child: FittedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: kElevationToShadow[4]),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: DropdownButton(
                hint: leftIcon(label, color, icon),
                value: value,
                underline: Container(),
                iconEnabledColor: themeGrey4Color,
                dropdownColor: themeGrey4Color,
                selectedItemBuilder: selectedItemBuilder,
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      );

  static Widget leftIcon(String label, Color textColor, IconData icon) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Icon(
            icon,
            color: textColor,
            size: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
