import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar customButtonTopNavBar(BuildContext context, String title, Widget button, void Function() rebuild) => AppBar(
      actions: const [SizedBox()],
      automaticallyImplyLeading: false,
      leading: leading(context, rebuild),
      title: responsiveScreenWidthPadding(
          context,
          Row(
            children: [
              buildTitle(context, title, rebuild),
              const Expanded(child: SizedBox()),
              button,
            ],
          )),
    );

AppBar subTopNavBar(BuildContext context, String title, void Function() rebuild, {bool home = false}) => AppBar(
      actions: const [SizedBox()],
      leading: leading(context, rebuild, home: home),
      automaticallyImplyLeading: false,
      title: responsiveScreenWidthPadding(context, buildTitle(context, title, rebuild)),
    );

AppBar fullTopNavBar(
  BuildContext context,
  String title,
  GlobalKey<ScaffoldState> scaffold,
  Function() rebuild, {
  List<Widget> navigation = const [],
  List<Widget> children = const [],
}) {
//   var pad = MediaQuery.of(context).size.width * 0.1;
//   if (isSmallScreen(context)) {
//     pad = 5;
//   }
  return AppBar(
    actions: const [SizedBox()],
    leading: leading(context, rebuild),
    automaticallyImplyLeading: false,
    title: responsiveScreenWidthPadding(
      context,
      Row(
        children: [
          buildTitle(context, title, rebuild),
          ...navigation,
          const Expanded(child: SizedBox()),
          ...children,
          profileIconMenu(context, scaffold)
        ],
      ),
    ),
  );
}

Widget profileIconMenu(BuildContext context, GlobalKey<ScaffoldState> scaffold) => InkWell(
      onTap: () => scaffold.currentState!.openEndDrawer(),
      child: Center(
        child: Icon(ThemeIcons.menu),
      ),
    );

Widget buildTitle(BuildContext context, String title, Function rebuild) {
  final back = context.canPop();

  return Row(children: [
    Visibility(
      visible: back,
      child: IconButton(
        icon: Icon(
          ThemeIcons.back,
        ),
        onPressed: () {
          context.pop();
          rebuild();
        },
      ),
    ),
    Text(title, style: const TextStyle(fontSize: 20)),
  ]);
}

Widget? leading(BuildContext context, Function rebuild, {bool home = false}) {
  if (home) {
    return IconButton(onPressed: () => GoRouter.of(context).go("/"), icon: Icon(ThemeIcons.home));
  }

  return null;
}
