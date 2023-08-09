import 'package:document_scanner/scanner/application.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// A page that fades in an out.
class SlideTransitionPage extends CustomTransitionPage<void> {
  static double get pos => Application.random.nextInt(3) - 1;

  /// Creates a [SlideTransitionPage].
  SlideTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
          key: key,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final x = pos;
            final y = x == 0.0 ? pos : 0.0;

            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(x, y),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: child,
        );
}
