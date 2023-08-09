import 'logger.dart';

T trace<T>(T t, [dynamic prefix = '']) {
  Log.less("trace $prefix: [${t.runtimeType}]: $t");
  return t;
}
