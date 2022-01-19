// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:pluginexample/ui/views/audio/justaudio.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../../ui/views/bluetooth/bluetooth.dart';
import '../../ui/views/home/home_view/home.dart';
import '../../ui/views/login/login_view.dart';
import '../../ui/views/qrcode/qrcode.dart';
import '../../ui/views/register/register_view.dart';
import '../../ui/views/screenshot/screenshot.dart';
import '../../ui/views/soundRecord/soundRecord.dart';
import '../../ui/views/start_up/start_up_view.dart';
import '../../ui/views/update/update_view.dart';
import '../../ui/views/webview/webview.dart';

class Routes {
  static const String startUpView = '/';
  static const String homeView = '/home-view';
  static const String updateView = '/update-view';
  static const String loginView = '/login-view';
  static const String registerView = '/register-view';
  static const String soundRecordScreen = '/sound-record-screen';
  static const String bluetoothScreen = '/bluetooth-screen';
  static const String screenshotScreen = '/screenshot-screen';
  static const String qrCodeScreen = '/qr-code-screen';
  static const String webviewScreen = '/webview-screen';
  static const String justAudioScreen = '/just-audio-screen';
  static const all = <String>{
    startUpView,
    homeView,
    updateView,
    loginView,
    registerView,
    soundRecordScreen,
    bluetoothScreen,
    screenshotScreen,
    qrCodeScreen,
    webviewScreen,
    justAudioScreen,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.updateView, page: UpdateView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.registerView, page: RegisterView),
    RouteDef(Routes.soundRecordScreen, page: SoundRecordScreen),
    RouteDef(Routes.bluetoothScreen, page: BluetoothScreen),
    RouteDef(Routes.screenshotScreen, page: ScreenshotScreen),
    RouteDef(Routes.qrCodeScreen, page: QrCodeScreen),
    RouteDef(Routes.webviewScreen, page: WebviewScreen),
    RouteDef(Routes.justAudioScreen, page: JustAudioScreen),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartUpView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    UpdateView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => UpdateView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginView(),
        settings: data,
      );
    },
    RegisterView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const RegisterView(),
        settings: data,
      );
    },
    SoundRecordScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SoundRecordScreen(),
        settings: data,
      );
    },
    BluetoothScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const BluetoothScreen(),
        settings: data,
      );
    },
    ScreenshotScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ScreenshotScreen(),
        settings: data,
      );
    },
    QrCodeScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const QrCodeScreen(),
        settings: data,
      );
    },
    WebviewScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const WebviewScreen(),
        settings: data,
      );
    },
    JustAudioScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const JustAudioScreen(),
        settings: data,
      );
    },
  };
}
