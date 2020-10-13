import 'package:flutter/material.dart';
import 'package:flutter_plugins_example/services/locator.dart';
import 'package:flutter_plugins_example/ui/routers.dart';
import 'package:flutter_plugins_example/utils/common/color_utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'start_up_view_model.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        body: GridView.count(
          padding: const EdgeInsets.all(10),
          primary: false,
          crossAxisCount: 5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            BuildGridRowItem(title: "保存图片&生成二维码", target: ViewRoutes.screenShotView),
            BuildGridRowItem(title: "权限获取", target: ViewRoutes.permissionHandlerView),
            BuildGridRowItem(title: "蓝牙-flutterBleLib", target: ViewRoutes.flutterBleLibView),
            BuildGridRowItem(title: "蓝牙-Flutterblue", target: ViewRoutes.flutterBlueView),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPackGridRow() {
    List<Widget> widgetList = List();
    for (int i = 0; i < 10; i++) {
      widgetList
        ..add(BuildGridRowItem(
          title: "截图保存",
          target: ViewRoutes.screenShotView,
        ));
    }
    return widgetList;
  }
}

class BuildGridRowItem extends StatelessWidget {
  final String title;
  final String target;
  const BuildGridRowItem({Key key, this.title, this.target}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: HexToColor("$Colors.greenAccent"),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(color: HexToColor("#ffffff")),
          ),
        ),
      ),
      onTap: () {
        locator<NavigationService>().navigateTo(target);
      },
    );
  }
}
