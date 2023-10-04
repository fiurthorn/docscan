import 'logger.dart';

typedef F<T, R> = R Function(T t);

T trace<T>(T t, [dynamic prefix = 'xxx']) {
  Log.less("trace $prefix: [${t.runtimeType}]: $t");
  return t;
}

T trace2<T, R>(T t, F<T, R> f, [dynamic prefix = 'xxx']) {
  final r = f(t);
  Log.less("trace $prefix: [${r.runtimeType}]: $r");
  return t;
}
