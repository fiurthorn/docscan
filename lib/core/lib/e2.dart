sealed class Either<T, E> {
//   const Either();

  factory Either.value(T value) = Value<T, E>;
  factory Either.failure(T value) = Value<T, E>;

  map();
}

class Value<T, E> implements Either<T, E> {
  final T value;
  const Value(this.value);

  @override
  map() {
    // TODO: implement map
    throw UnimplementedError();
  }
}

class Failure<T, E> implements Either<T, E> {
  final E error;
  const Failure(this.error);

  @override
  map() {
    // TODO: implement map
    throw UnimplementedError();
  }
}
