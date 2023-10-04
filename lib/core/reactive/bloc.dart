import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/reactive/form.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'state.dart';

abstract class ReactiveBloc<Param extends Equatable> extends Cubit<ReactiveState<Param>> implements ReactiveBlocForm {
  FormGroup group = FormGroup({});

  Future<void> loading();

  ReactiveBloc({required Param parameter}) : super(InitReactiveState(parameter: parameter)) {
    group.addAll(form);
  }

  @mustCallSuper
  void init() async {
    await Future<void>.delayed(const Duration());
    try {
      emit(LoadingReactiveState.newWith(other: state));
      loading().then((value) => emit(LoadedReactiveState.newWith(other: state)));
    } on Exception catch (e, s) {
      emit(LoadFailureReactiveState.newWith(other: state, failureResponse: ErrorValue(e, s)));
    }
  }

  emitSubmitting() {
    emit(SubmittingReactiveState.newWith(other: state));
  }

  emitLoading() {
    emit(LoadingReactiveState.newWith(other: state));
  }

  emitLoaded({Param? parameter}) {
    emit(LoadedReactiveState(parameter: parameter ?? state.parameter));
  }

  emitSuccess({required String successResponse, Param? parameter}) {
    emit(SuccessReactiveState(parameter: parameter ?? state.parameter, successResponse: successResponse));
  }

  emitFailure({required ErrorValue failureResponse, Param? parameter}) {
    emit(FailureReactiveState(parameter: parameter ?? state.parameter, failureResponse: failureResponse));
  }

  emitUpdate({required Param parameter}) {
    emit(UpdateReactiveState(parameter: parameter));
  }

  validate() {
    group.markAllAsTouched();
  }
}
