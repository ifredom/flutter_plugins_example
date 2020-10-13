import 'package:flutter/material.dart';
import 'package:flutter_plugins_example/core/constants/constants.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

import 'platform/404.dart';
import 'views/flutter_ble_lib/flutter_ble_lib_view.dart';
import 'views/flutter_blue/flutter_blue_view.dart';
import 'views/permission_handler/permission_handler_view.dart';
import 'views/screen_shot/screen_shot_view.dart';
import 'views/start_up_view/start_up_view.dart';

// 保持参数与路由的值一致
class ViewRoutes {
  static const String startUpView = '/';
  static const String flutterBlueView = 'app://flutterBlueView';
  static const String flutterBleLibView = 'app://flutterBleLibView';
  static const String screenShotView = 'app://screenShotView';
  static const String permissionHandlerView = 'app://permissionHandlerView';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return GetPageRoute(
      settings: RouteSettings(name: settings.name),
      page: () => generateView(settings),
      fullscreenDialog: _fullScreenDialogs.contains(settings.name),
    );
  }

  static Widget generateView(RouteSettings settings) {
    if (Constants.DEBUG) {
      final _log = Logger('routers');
      _log.warning("跳转路由: ${settings.name}");
    }

    switch (settings.name) {
      case flutterBleLibView:
        return FlutterBleLibView();
      case flutterBlueView:
        return FlutterblueView();
      case screenShotView:
        return ScreenShotView();
      case permissionHandlerView:
        return PermissionHandlerView();
      // case midiPage:
      //   return MidiPage();

      case startUpView:
        return StartUpView();

      default:
        return WidgetNotFound();
    }
  }

  // Add routes that should behave as fullScreenDialogs
  static final _fullScreenDialogs = [
    // Routes.route_1,
    // Routes.route_2,
  ];
}
