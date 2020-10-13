import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugins_example/core/providers/provider_setup.dart';
import 'package:flutter_plugins_example/services/locator.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import '../managers/core_manager.dart';
import '../managers/restart_manager.dart';
import '../routers.dart';

class RootComponent extends StatefulWidget {
  @override
  _RootComponentState createState() => _RootComponentState();
}

class _RootComponentState extends State<RootComponent> {
  final botToastBuilder = BotToastInit(); //1.调用BotToastInit

  @override
  Widget build(BuildContext context) {
    return RestartManager(
      child: MultiProvider(
        providers: providers,
        child: CoreManager(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            // localizationsDelegates: localizationsDelegates,
            // supportedLocales: supportedLocales,
            // localeResolutionCallback: loadSupportedLocals,
            title: '插件Demo集合',
            navigatorKey: locator<NavigationService>().navigatorKey,
            navigatorObservers: [CustomNavigatorObserver.routeObserver, BotToastNavigatorObserver()],
            onGenerateRoute: (settings) => ViewRoutes.onGenerateRoute(settings),
            initialRoute: ViewRoutes.startUpView,
            builder: (context, child) {
              // child = myBuilder(context, child); //do something
              child = botToastBuilder(context, child);
              return child;
            },
          ),
        ),
      ),
    );
  }
}

/// 路由监听
// 使用: navigatorObservers: <NavigatorObserver>[CustomNavigatorObserver()],
class CustomNavigatorObserver extends NavigatorObserver {
  static CustomNavigatorObserver instance;
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>(); // 路由监听器

  static CustomNavigatorObserver getInstance() {
    if (instance == null) {
      instance = CustomNavigatorObserver();
    }
    return instance;
  }

  static observer({Routing routing}) {
    print(instance);
  }

  // https://juejin.im/post/6844903798398255111
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if ((previousRoute is TransitionRoute) && previousRoute.opaque) {
      //全屏不透明，通常是一个page
      print("监控到");
    } else {
      //全屏透明，通常是一个弹窗
    }
  }
}
