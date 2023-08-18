import 'dart:io';

import 'package:document_scanner/l10n/app_lang.dart';

final isDesktop = isLinux || isMacOs || isWindows;
const isWeb = false;

final isMobile = isIos | isAndroid;
const isIosWeb = false;

const isChrome = false;
const isEdge = false;
const isFirefox = false;
const isOpera = false;
const isSafari = false;

final isApple = isMacOs || isIos;
final isIos = Platform.isIOS;
final isAndroid = Platform.isAndroid;
final isLinux = Platform.isLinux;
final isWindows = Platform.isWindows;
final isMacOs = Platform.isMacOS;

Future<String> findSystemLocale() => Future.value(Platform.localeName);
void loaded() => {};

String get platformDescription => AppLang.i18n.baseScreen_about_system_label_desktop(device, os);

String get device => isMobile ? "Mobile" : "Desktop";

String get os => isAndroid
    ? "Android"
    : isApple
        ? "Apple"
        : isLinux
            ? "Linux"
            : isWindows
                ? "Windows"
                : "Unknown";
