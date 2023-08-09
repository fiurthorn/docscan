import 'package:equatable/equatable.dart';
import 'package:sprintf/sprintf.dart';

class Tuple<A> extends Equatable {
  final A a;

  const Tuple(this.a);

  @override
  List<Object?> get props => [a];

  @override
  String toString() => sprintf("[a:'%s']", [a]);
}

class Tuple2<A, B> extends Equatable {
  final A a;
  final B b;

  const Tuple2(this.a, this.b);

  @override
  List<Object?> get props => [a, b];

  @override
  String toString() => sprintf("[a:'%s',b:'%s']", [a, b]);
}

class Tuple3<A, B, C> extends Equatable {
  final A a;
  final B b;
  final C c;

  const Tuple3(this.a, this.b, this.c);

  @override
  List<Object?> get props => [a, b, c];

  @override
  String toString() => sprintf("[a:'%s',b:'%s',c:'%s']", [a, b, c]);
}

class Tuple4<A, B, C, D> extends Equatable {
  final A a;
  final B b;
  final C c;
  final D d;

  @override
  List<Object?> get props => [a, b, c, d];

  const Tuple4(this.a, this.b, this.c, this.d);
}

class Tuple5<A, B, C, D, E> extends Equatable {
  final A a;
  final B b;
  final C c;
  final D d;
  final E e;

  const Tuple5(this.a, this.b, this.c, this.d, this.e);

  @override
  List<Object?> get props => [a, b, c, d, e];

  @override
  String toString() => sprintf("[a:'%s',b:'%s',c:'%s',d:'%s',e:'%s']", [a, b, c, d, e]);
}

class Tuple6<A, B, C, D, E, F> extends Equatable {
  final A a;
  final B b;
  final C c;
  final D d;
  final E e;
  final F f;

  const Tuple6(this.a, this.b, this.c, this.d, this.e, this.f);

  @override
  List<Object?> get props => [a, b, c, d, e, f];

  @override
  String toString() => sprintf("[a:'%s',b:'%s',c:'%s',d:'%s',e:'%s',f:'%s']", [a, b, c, d, e, f]);
}

class Tuple7<A, B, C, D, E, F, G> extends Equatable {
  final A a;
  final B b;
  final C c;
  final D d;
  final E e;
  final F f;
  final G g;

  const Tuple7(this.a, this.b, this.c, this.d, this.e, this.f, this.g);

  @override
  List<Object?> get props => [a, b, c, d, e, f, g];

  @override
  String toString() => sprintf("[a:'%s',b:'%s',c:'%s',d:'%s',e:'%s',f:'%s',g:'%s']", [a, b, c, d, e, f, g]);
}

class Tuple8<A, B, C, D, E, F, G, H> extends Equatable {
  final A a;
  final B b;
  final C c;
  final D d;
  final E e;
  final F f;
  final G g;
  final H h;

  const Tuple8(this.a, this.b, this.c, this.d, this.e, this.f, this.g, this.h);

  @override
  List<Object?> get props => [a, b, c, d, e, f, g, h];

  @override
  String toString() => sprintf("[a:'%s',b:'%s',c:'%s',d:'%s',e:'%s',f:'%s',g:'%s',h:'%s']", [a, b, c, d, e, f, g, h]);
}

class Tuple9<A, B, C, D, E, F, G, H, I> extends Equatable {
  final A a;
  final B b;
  final C c;
  final D d;
  final E e;
  final F f;
  final G g;
  final H h;
  final I i;

  const Tuple9(this.a, this.b, this.c, this.d, this.e, this.f, this.g, this.h, this.i);

  @override
  List<Object?> get props => [a, b, c, d, e, f, g, h, i];

  @override
  String toString() =>
      sprintf("[a:'%s',b:'%s',c:'%s',d:'%s',e:'%s',f:'%s',g:'%s',h:'%s',i:'%s']", [a, b, c, d, e, f, g, h, i]);
}

class Tuple10<A, B, C, D, E, F, G, H, I, J> extends Equatable {
  final A a;
  final B b;
  final C c;
  final D d;
  final E e;
  final F f;
  final G g;
  final H h;
  final I i;
  final J j;

  const Tuple10(this.a, this.b, this.c, this.d, this.e, this.f, this.g, this.h, this.i, this.j);

  @override
  List<Object?> get props => [a, b, c, d, e, f, g, h, i, j];

  @override
  String toString() =>
      sprintf("[a:'%s',b:'%s',c:'%s',d:'%s',e:'%s',f:'%s',g:'%s',h:'%s',i:'%s',j:%s]", [a, b, c, d, e, f, g, h, i, j]);
}
