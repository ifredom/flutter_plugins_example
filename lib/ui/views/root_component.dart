import 'package:flutter/material.dart';
import 'package:pluginexample/core/app/app.router.dart';
import 'package:pluginexample/core/constants/app_theme.dart';
import 'package:pluginexample/core/localization/setup_local.dart';
import 'package:pluginexample/core/managers/lifecycle_manager.dart';
import 'package:stacked_services/stacked_services.dart';

class RootComponent extends StatefulWidget {
  const RootComponent({Key? key}) : super(key: key);
  @override
  _RootComponentState createState() => _RootComponentState();
}

class _RootComponentState extends State<RootComponent> {
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: localizationsDelegates,
        localeResolutionCallback: loadSupportedLocals,
        supportedLocales: supportedLocales,
        locale: const Locale('zh', 'CN'),
        title: 'flutterApp',
        theme: AppTheme.themData,
        navigatorKey: StackedService.navigatorKey,
        navigatorObservers: [StackedService.routeObserver],
        onGenerateRoute: StackedRouter().onGenerateRoute,
        routingCallback: routingCallback,
      ),
    );
  }

  routingCallback(Routing? routing) {
    if (routing!.current == Routes.homeView) {
      // Future.delayed(const Duration(seconds: 2), () async {
      //   Get.snackbar("Tips", "You are on homeView route");
      // });
    }
  }
}
