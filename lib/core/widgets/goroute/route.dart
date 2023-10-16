import 'package:document_scanner/core/lib/transition_page_fade.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

part 'route.freezed.dart';

CustomTransitionPage<void> _defaultTransitionPage({
  required LocalKey key,
  required Widget child,
  required String name,
}) =>
    FadeTransitionPage(key: key, child: child, name: name);

GoRouterPageBuilder _pageBuilder(PageBuilder child, String name) => (context, state) => _defaultTransitionPage(
      key: state.pageKey,
      child: child(context, state),
      name: name,
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
    required String name,
  }) : super(pageBuilder: _pageBuilder(child, name), name: name);

  AuthGoRoute.authRequired({
    required super.path,
    required PageBuilder child,
    required String name,
  })  : authRequired = true,
        super(pageBuilder: _pageBuilder(child, name), name: name);

  AuthGoRoute.unauthorized({
    required super.path,
    required PageBuilder child,
    required String name,
  })  : authRequired = false,
        super(pageBuilder: _pageBuilder(child, name), name: name);
}

abstract mixin class GoRouteAware {
  /// Called when the current route has been pushed.
  void didPush(String? name, String? previousName) {}

  /// Called when the current route has been popped off.
  void didPop(String? name, String? previousName) {}
}

class GoRouterObserver extends NavigatorObserver {
  final Set<GoRouteAware> _listeners = {};

  void subscribe(GoRouteAware routeAware) {
    _listeners.add(routeAware);
  }

  void unsubscribe(GoRouteAware routeAware) {
    _listeners.remove(routeAware);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final listener in _listeners) {
      listener.didPush(
        _name(route.settings),
        _name(previousRoute?.settings),
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final listener in _listeners) {
      listener.didPop(
        _name(route.settings),
        _name(previousRoute?.settings),
      );
    }
  }

  String? _name(RouteSettings? page) {
    return page?.name;
  }
}

@freezed
class RouterConfiguration with _$RouterConfiguration {
  factory RouterConfiguration(GoRouter goRouter, GlobalKey<NavigatorState> navigatorKey) = _RouterConfiguration;
}
