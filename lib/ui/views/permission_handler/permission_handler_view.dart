import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugins_example/ui/widgets/appbar/custom_appbar.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerView extends StatefulWidget {
  @override
  _PermissionHandlerViewState createState() => _PermissionHandlerViewState();
}

class _PermissionHandlerViewState extends State<PermissionHandlerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "权限测试--获取权限"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Text("获取定位权限"),
        onPressed: () async {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.location,
            Permission.locationWhenInUse,
            Permission.locationAlways,
          ].request();
          print(statuses[Permission.location]);
          print(statuses[Permission.locationWhenInUse]);
          print(statuses[Permission.locationAlways]);

          if (statuses[Permission.location] == PermissionStatus.granted) {
            BotToast.showText(text: "已授权定位");
          }
          if (statuses[Permission.locationWhenInUse] == PermissionStatus.granted) {
            BotToast.showText(text: "已授权使用时定位");
          }
          if (statuses[Permission.locationAlways] == PermissionStatus.granted) {
            BotToast.showText(text: "已授权总是定位");
          }
        },
      ),
    );
  }
}

// flutterBlue.connectedDevices  stopScan()
