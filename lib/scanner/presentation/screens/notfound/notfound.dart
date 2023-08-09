import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends BaseScreen {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();

  static const String route = '/404';
}

class _NotFoundScreenState extends BaseScreenState<NotFoundScreen> {
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
  PreferredSizeWidget? buildAppBar(BuildContext context) => subTopNavBar(context, title(context), update, home: true);
}
