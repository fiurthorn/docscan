// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:intl/intl_browser.dart' as intl;
import 'package:sprintf/sprintf.dart';

const isDesktop = false;
const isWeb = kIsWeb;

final isMobile = isIos || isAndroid;
final isIosWeb = isWeb && isIos;

final isChrome = navigatorIsChrome() && !navigatorIsEdge();
final isEdge = navigatorIsEdge();
final isFirefox = navigatorIsFirefox();
final isOpera = navigatorIsOpera();
final isSafari = navigatorIsSafari();

final isApple = isIos || isMacOs;
final isIos = defaultTargetPlatform == TargetPlatform.iOS;
final isAndroid = defaultTargetPlatform == TargetPlatform.android;
final isLinux = defaultTargetPlatform == TargetPlatform.linux;
final isWindows = defaultTargetPlatform == TargetPlatform.windows;
final isMacOs = defaultTargetPlatform == TargetPlatform.macOS;

Future<String?> appDocumentsDir() => Future.sync(() => null);
Future<String> findSystemLocale() async => await intl.findSystemLocale();
void loaded() => js.context.callMethod('hideSpinner');

String get platformDescription => AppLang.i18n.baseScreen_about_system_label_browser(_browser, device, _os);

String get device => isMobile ? "Mobile" : "Desktop";

String get os => sprintf("%s/%s", [_os, _browser]);

String get _os => isAndroid
    ? "Android"
    : isApple
        ? "Apple"
        : isLinux
            ? "Linux"
            : isWindows
                ? "Windows"
                : "Unknown";

String get _browser => isChrome
    ? "Chrome"
    : isEdge
        ? "Edge"
        : isFirefox
            ? "Firefox"
            : isOpera
                ? "Opera"
                : isSafari
                    ? "Safari"
                    : "Web";

// see [Browser_detection_using_the_user_agent](https://developer.mozilla.org/en-US/docs/Web/HTTP/Browser_detection_using_the_user_agent)

bool navigatorIsSafari() {
  final navigator = html.window.navigator;
  final String vendor = navigator.vendor;
  final String appVersion = navigator.appVersion;
  return vendor.contains('Apple') && appVersion.contains('Version');
}

bool navigatorIsChrome() {
  final navigator = html.window.navigator;
  final String vendor = navigator.vendor;
  final String userAgent = navigator.userAgent;
  return vendor.contains('Google') && userAgent.contains('Chrome');
}

bool navigatorIsEdge() {
  final navigator = html.window.navigator;
  final String userAgent = navigator.userAgent;
  return userAgent.contains('Edg');
}

bool navigatorIsOpera() {
  final navigator = html.window.navigator;
  final String userAgent = navigator.userAgent;
  return userAgent.contains('OPR');
}

bool navigatorIsFirefox() {
  final navigator = html.window.navigator;
  final String userAgent = navigator.userAgent;
  return userAgent.contains('Firefox');
}
