import 'package:flutter/widgets.dart';

const int breakPoint = 768;

bool isSmallScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < breakPoint;
}

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= breakPoint;
}
