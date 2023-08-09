import 'package:document_scanner/core/lib/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  final bool create;
  final bool event;
  final bool change;
  final bool transition;
  final bool close;

  SimpleBlocObserver({
    this.create = false,
    this.event = false,
    this.change = false,
    this.transition = false,
    this.close = false,
  });

  @override
  void onCreate(BlocBase bloc) {
    create && Log.less('\$onCreate: [${bloc.runtimeType}]');
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    this.event && Log.less('\$onEvent: [${bloc.runtimeType}]: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    this.change && Log.less('\$onChange: [${bloc.runtimeType}]: ${change.runtimeType}');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    this.transition && Log.less('\$onTransition: [${bloc.runtimeType}]: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Log.high('\$onError: [${bloc.runtimeType}]', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    close && Log.less('\$onClose: [${bloc.runtimeType}]');
    super.onClose(bloc);
  }
}
