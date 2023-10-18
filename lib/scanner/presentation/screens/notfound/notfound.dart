import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/scanner/presentation/screens/base/app_bar.dart';
import 'package:document_scanner/scanner/presentation/screens/base/screen.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends Screen {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();

  static const String route = '/404';
}

class _NotFoundScreenState extends ScreenState<NotFoundScreen> {
  @override
  String title(BuildContext context) => "Not Found";

  @override
  Widget buildScreen(BuildContext context) => Center(
        child: Column(
          children: [
            const SizedBox(height: 40.0),
            const Text(
              "Page Not Found",
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 40.0),
            ThemeIcons.logo,
          ],
        ),
      );

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => MinimalAppBar(title: title(context), home: true);
}
