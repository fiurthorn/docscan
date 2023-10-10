part of 'bloc.dart';

abstract class ReactiveState<StateParam extends Equatable> extends Equatable {
  final String? successResponse;
  final ErrorValue? failureResponse;
  final StateParam parameter;

  const ReactiveState({
    required this.parameter,
    this.successResponse,
    this.failureResponse,
  });

  @override
  List<Object?> get props => [
        successResponse,
        failureResponse,
        parameter,
      ];
}

class InitReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const InitReactiveState({
    required super.parameter,
  }) : super(
          successResponse: null,
          failureResponse: null,
        );
}

class LoadingReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  final FormControl<int>? progress;

  const LoadingReactiveState({
    required super.parameter,
    this.progress,
  }) : super(
          successResponse: null,
          failureResponse: null,
        );

  LoadingReactiveState.newWith({
    required ReactiveState<StateParam> other,
    FormControl<int>? progress,
  }) : this(
          parameter: other.parameter,
          progress: progress,
        );
}

class LoadedReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const LoadedReactiveState({
    required super.parameter,
  }) : super(
          successResponse: null,
          failureResponse: null,
        );

  LoadedReactiveState.newWith({
    required ReactiveState<StateParam> other,
  }) : this(
          parameter: other.parameter,
        );
}

class LoadFailureReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const LoadFailureReactiveState({
    required super.failureResponse,
    required super.parameter,
  }) : super(
          successResponse: null,
        );

  LoadFailureReactiveState.newWith({
    required ErrorValue? failureResponse,
    required ReactiveState<StateParam> other,
  }) : this(
          failureResponse: failureResponse,
          parameter: other.parameter,
        );
}

class ProgressReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  final FormControl<int>? progress;
  final int max;

  const ProgressReactiveState({
    required super.parameter,
    this.progress,
    this.max = 0,
  })  : assert(progress == null || max > 0, "progress and max have to set both calculate the progress"),
        super(
          successResponse: null,
          failureResponse: null,
        );

  ProgressReactiveState.newWith({
    required ReactiveState<StateParam> other,
    FormControl<int>? progress,
    int max = -1,
  }) : this(
          parameter: other.parameter,
          progress: progress,
          max: max,
        );
}

class ProgressCloseReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const ProgressCloseReactiveState({
    required super.parameter,
    required super.successResponse,
  }) : super(
          failureResponse: null,
        );

  ProgressCloseReactiveState.newWith({
    required ReactiveState<StateParam> other,
    required String? successResponse,
  }) : this(
          successResponse: successResponse,
          parameter: other.parameter,
        );
}

class ProgressFailureReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const ProgressFailureReactiveState({
    required super.failureResponse,
    required super.parameter,
  }) : super(
          successResponse: null,
        );

  ProgressFailureReactiveState.newWith({
    required ErrorValue? failureResponse,
    required ReactiveState<StateParam> other,
  }) : this(
          failureResponse: failureResponse,
          parameter: other.parameter,
        );
}

class UpdateReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const UpdateReactiveState({
    required super.parameter,
  }) : super(
          successResponse: null,
          failureResponse: null,
        );
}

class SubmittingReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const SubmittingReactiveState({
    required super.parameter,
  }) : super(
          successResponse: null,
          failureResponse: null,
        );

  SubmittingReactiveState.newWith({
    required ReactiveState<StateParam> other,
  }) : this(
          parameter: other.parameter,
        );
}

class SuccessReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const SuccessReactiveState({
    required super.successResponse,
    required super.parameter,
  }) : super(
          failureResponse: null,
        );

  SuccessReactiveState.newWith({
    required String? successResponse,
    required ReactiveState<StateParam> other,
  }) : this(
          successResponse: successResponse,
          parameter: other.parameter,
        );
}

class FailureReactiveState<StateParam extends Equatable> extends ReactiveState<StateParam> {
  const FailureReactiveState({
    required super.failureResponse,
    required super.parameter,
  }) : super(
          successResponse: null,
        );

  FailureReactiveState.newWith({
    required ErrorValue? failureResponse,
    required ReactiveState<StateParam> other,
  }) : this(
          failureResponse: failureResponse,
          parameter: other.parameter,
        );
}
