import 'logger.dart';

T trace<T>(T t, [dynamic prefix = 'trace']) {
  Log.less("trace $prefix: [${t.runtimeType}]: $t");
  return t;
}

typedef F<T, R> = R Function(T t);

T trace2<T, R>(T t, F<T, R> f, [dynamic prefix = 'trace']) {
  final r = f(t);
  Log.less("trace $prefix: [${r.runtimeType}]: $r");
  return t;
}
