import 'package:document_scanner/core/lib/logger.dart';

typedef Folder<Value, Result> = Result Function(Value value);

sealed class Either<Type> {
  const factory Either.value(Type value) = Value<Type>;
  const factory Either.exception(Exception exception, [StackTrace? stackTrace]) = Failure<Type>;
  factory Either.failure(dynamic failure, [StackTrace? stackTrace]) =>
      Either.exception(Exception("$failure"), StackTrace.current);

  Either<R> map<R>(Folder<Type, R> converter);
  Type eval();
}

class Value<Type> implements Either<Type> {
  final Type value;
  const Value(this.value);

  @override
  Either<N> map<N>(Folder<Type, N> converter) => Either.value(converter(value));

  @override
  String toString() => "[Value:{$value}]";

  @override
  Type eval() => value;
}

class Failure<Type> implements Either<Type> {
  final Exception _exception;
  final StackTrace? _stackTrace;

  StackTrace? get stackTrace => _stackTrace;
  Exception get exception => _exception;

  const Failure(this._exception, [this._stackTrace]);

  factory Failure.dynamic(dynamic failure, [StackTrace? stackTrace]) =>
      Failure(Exception("$failure"), StackTrace.current);

  @override
  Either<N> map<N>(Folder<Type, N> converter) => Failure<N>(exception, stackTrace);

  @override
  String toString() => "[Failure:{$exception\n$stackTrace}]";

  @override
  Type eval() {
    Log.high("eval()", error: exception, stackTrace: stackTrace);
    throw exception;
  }
}
