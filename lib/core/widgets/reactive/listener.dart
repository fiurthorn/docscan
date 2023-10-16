import 'package:document_scanner/core/reactive/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ReactiveBlocListenerCallback<State extends ReactiveState> = void Function(BuildContext context, State state);

class ReactiveBlocListener<BLoC extends ReactiveBloc> extends BlocListener<BLoC, ReactiveState> {
  final ReactiveBlocListenerCallback<LoadingReactiveState>? onLoading;
  final ReactiveBlocListenerCallback<LoadFailureReactiveState>? onLoadFailure;
  final ReactiveBlocListenerCallback<LoadedReactiveState>? onLoaded;

  final ReactiveBlocListenerCallback<ProgressReactiveState>? onProgress;
  final ReactiveBlocListenerCallback<ProgressSuccessReactiveState>? onProgressSuccess;
  final ReactiveBlocListenerCallback<ProgressFailureReactiveState>? onProgressFailure;

  final ReactiveBlocListenerCallback<UpdateReactiveState>? onUpdateState;

  ReactiveBlocListener({
    this.onLoading,
    this.onLoaded,
    this.onLoadFailure,
    this.onProgress,
    this.onProgressSuccess,
    this.onProgressFailure,
    this.onUpdateState,
    super.child,
    super.key,
  }) : super(
          listener: (context, state) {
            //
            if (state is LoadFailureReactiveState && onLoadFailure != null) {
              onLoadFailure(context, state);
            } else if (state is LoadingReactiveState && onLoading != null) {
              onLoading(context, state);
            } else if (state is LoadedReactiveState && onLoaded != null) {
              onLoaded(context, state);
            } else if (state is ProgressReactiveState && onProgress != null) {
              onProgress(context, state);
            } else if (state is ProgressSuccessReactiveState && onProgressSuccess != null) {
              onProgressSuccess(context, state);
            } else if (state is ProgressFailureReactiveState && onProgressFailure != null) {
              onProgressFailure(context, state);
            } else if (state is UpdateReactiveState && onUpdateState != null) {
              onUpdateState(context, state);
            }
          },
        );
}
