import 'package:document_scanner/core/lib/transition_page_fade.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> _defaultTransitionPage({
  required LocalKey key,
  required Widget child,
}) =>
    FadeTransitionPage(key: key, child: child);

GoRouterPageBuilder _pageBuilder(PageBuilder child) => (context, state) => _defaultTransitionPage(
      key: state.pageKey,
      child: child(context, state),
    );

typedef PageBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
);

class AuthMap {
  final Map<String, bool> _authMap = {};

  AuthMap add(AuthGoRoute route) {
    _authMap[route.path] = route.authRequired;
    return this;
  }

  bool authRequired(String? path) => _authMap[path] ?? true;
}

class AuthGoRoute extends GoRoute {
  final bool authRequired;

  AuthGoRoute({
    required super.path,
    required PageBuilder child,
    required this.authRequired,
    super.name,
  }) : super(pageBuilder: _pageBuilder(child));

  AuthGoRoute.authRequired({
    required super.path,
    required PageBuilder child,
    super.name,
  })  : authRequired = true,
        super(pageBuilder: _pageBuilder(child));

  AuthGoRoute.unauthorized({
    required super.path,
    required PageBuilder child,
    super.name,
  })  : authRequired = false,
        super(pageBuilder: _pageBuilder(child));
}
