import 'package:document_scanner/core/lib/whatsnew/items.dart';
import 'package:flutter/material.dart';

class WhatsNewList extends StatelessWidget {
  final List<ListItem> items;

  const WhatsNewList({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        double padding = 0;
        if (index > 0) {
          padding = 25;
        } else if (item is MessageItem) {
          padding = 8;
        }

        return Padding(
          padding: EdgeInsets.only(top: padding),
          child: item.build(context),
        );
      },
    );
  }
}
