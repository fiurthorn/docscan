const isDesktop = false;
const isWeb = false;

const isMobile = false;
const isIosWeb = false;

const isChrome = false;
const isEdge = false;
const isFirefox = false;
const isOpera = false;
const isSafari = false;

const isApple = false;
const isIos = false;
const isAndroid = false;
const isLinux = false;
const isWindows = false;
const isMacOs = false;

Future<String> appDocumentsDir() => throw UnsupportedError('appDocumentsDir is not supported on this platform');
Future<String> findSystemLocale() => Future.value("en");
void loaded() => {};

String get platformDescription => throw UnsupportedError('platformDescription is not supported on this platform');
String get device => throw UnsupportedError('device is not supported on this platform');
String get os => throw UnsupportedError('os is not supported on this platform');
