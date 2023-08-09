import 'package:document_scanner/core/lib/logger.dart';
import 'package:sprintf/sprintf.dart';

typedef Folder<V, R> = R Function(V value);
typedef ErrorFolder<R> = R Function(Exception err, StackTrace? stackTrace);

abstract class Optional<V> {
  static Value<V> newValue<V>(V value) => Value<V>(value);
  static Error<V> newError<V>(Exception value, [StackTrace? stackTrace]) => Error<V>(value, stackTrace);

  bool get isValue;
  bool get isError;

  R fold<R>(Folder<V, R> left, ErrorFolder<R> right);
  Optional<R> convert<R>(Folder<V, R> converter);

  V eval();
}

class Value<V> implements Optional<V> {
  final V value;
  Value(this.value);

  @override
  bool get isValue => true;

  @override
  bool get isError => false;

  @override
  R fold<R>(Folder<V, R> left, ErrorFolder<R> right) => left(value);

  @override
  Optional<N> convert<N>(Folder<V, N> converter) => Optional.newValue(converter(value));

  @override
  String toString() => sprintf("[Value:{%s}]", [value]);

  @override
  V eval() => value;
}

class ErrorValue {
  final Exception _exception;
  final StackTrace? _stackTrace;

  ErrorValue(this._exception, this._stackTrace);
  ErrorValue.fromString(String exception, StackTrace? stackTrace) : this(Exception(exception), stackTrace);

  StackTrace? get stackTrace => _stackTrace;
  Exception get exception => _exception;
}

class Error<V> implements Optional<V> {
  final ErrorValue error;

  Error(
    Exception exception, [
    StackTrace? stackTrace,
  ]) : error = ErrorValue(exception, stackTrace);

  @override
  bool get isValue => false;

  @override
  bool get isError => true;

  @override
  R fold<R>(Folder<V, R> left, ErrorFolder<R> right) => right(error.exception, error.stackTrace);

  @override
  Optional<N> convert<N>(Folder<V, N> converter) => Error<N>(error.exception, error.stackTrace);

  @override
  String toString() => sprintf("[Error:{%s\n%s}]", [error.exception, error.stackTrace]);

  @override
  V eval() {
    Log.high("eval()", error: error.exception, stackTrace: error.stackTrace);
    throw error.exception;
  }

  StackTrace? get stackTrace => error.stackTrace;
  Exception get exception => error.exception;
}
