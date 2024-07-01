import 'dart:async';

import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/reactive/form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'bloc.freezed.dart';

@freezed
sealed class ReactiveState<StateParam> with _$ReactiveState<StateParam> {
  const factory ReactiveState.init({required StateParam parameter}) = InitReactiveState;
  //
  const factory ReactiveState.loading({required StateParam parameter}) = LoadingReactiveState;
  const factory ReactiveState.loaded({required StateParam parameter}) = LoadedReactiveState;
  const factory ReactiveState.loadFailure({
    required StateParam parameter,
    required Failure failureResponse,
  }) = LoadFailureReactiveState;
  //

  @Assert("(progress==null && max<=0) || (progress!=null && max>0)",
      "progress and max have to set both to calculate the progress")
  const factory ReactiveState.progress({
    required StateParam parameter,
    String? progressIndicator,
    FormControl<int>? progress,
    @Default(0) int max,
  }) = ProgressReactiveState;

  const factory ReactiveState.progressSuccess({
    required StateParam parameter,
    String? successResponse,
    String? progressIndicator,
  }) = ProgressSuccessReactiveState;

  const factory ReactiveState.progressFailure({
    required StateParam parameter,
    required Failure failureResponse,
    String? progressIndicator,
  }) = ProgressFailureReactiveState;
  //
  const factory ReactiveState.update({required StateParam parameter}) = UpdateReactiveState;
}

abstract class ReactiveBloc<StateParam> extends Cubit<ReactiveState<StateParam>> implements ReactiveBlocForm {
  FormGroup group = FormGroup({});

  StateParam get parameter => state.parameter;

  final _loaderCompleter = Completer<bool>();
  Future<bool> get loadedFuture => _loaderCompleter.future;

  Future<void> loading() async {}

  ReactiveBloc({required StateParam parameter}) : super(ReactiveState.init(parameter: parameter)) {
    group.addAll(form);
  }

  @mustCallSuper
  void init() async {
    await Future<void>.delayed(const Duration());
    try {
      _emitLoading();
      loading()
          .then((value) => _emitLoaded())
          .whenComplete(() => _loaderCompleter.complete(true))
          .onError<Exception>((err, stack) => _emitLoadFailureException(err, stack))
          .catchError((err, stack) => _emitLoadFailureError(err, stack));
    } on Exception catch (e, s) {
      _emitLoadFailureException(e, s);
    } catch (e, s) {
      _emitLoadFailureError(e, s);
    }
  }

  _emitLoading() => emit(ReactiveState.loading(parameter: state.parameter));
  _emitLoaded() => emit(ReactiveState.loaded(parameter: state.parameter));
  _emitLoadFailureException(Exception err, StackTrace stack) =>
      emit(ReactiveState.loadFailure(parameter: state.parameter, failureResponse: Failure(err, stack)));
  _emitLoadFailureError(dynamic err, StackTrace stack) =>
      emit(ReactiveState.loadFailure(parameter: state.parameter, failureResponse: Failure.dynamic(err, stack)));

  emitProgress({FormControl<int>? progress, int max = 0, String? progressIndicator}) {
    emit(ReactiveState.progress(
      progressIndicator: progressIndicator,
      parameter: state.parameter,
      progress: progress,
      max: max,
    ));
  }

  emitProgressSuccess({String? successResponse, StateParam? parameter, String? progressIndicator}) {
    emit(ReactiveState.progressSuccess(
      parameter: parameter ?? state.parameter,
      successResponse: successResponse,
      progressIndicator: progressIndicator,
    ));
  }

  emitProgressFailure({required Failure failureResponse, StateParam? parameter, String? progressIndicator}) {
    emit(ReactiveState.progressFailure(
      progressIndicator: progressIndicator,
      parameter: parameter ?? state.parameter,
      failureResponse: failureResponse,
    ));
  }

  emitProgressFailureException({
    required Exception failureResponse,
    StackTrace? stackTrace,
    StateParam? parameter,
    String? progressIndicator,
  }) {
    emitProgressFailure(
      progressIndicator: progressIndicator,
      parameter: parameter ?? state.parameter,
      failureResponse: Failure(failureResponse, stackTrace),
    );
  }

  emitProgressFailureError({
    required dynamic failureResponse,
    StackTrace? stackTrace,
    StateParam? parameter,
    String? progressIndicator,
  }) {
    emitProgressFailure(
      progressIndicator: progressIndicator,
      parameter: parameter ?? state.parameter,
      failureResponse: Failure.dynamic(failureResponse, stackTrace),
    );
  }

  emitUpdate({required StateParam parameter}) {
    emit(ReactiveState.update(parameter: parameter));
  }

  validate() {
    group.markAllAsTouched();
  }
}
