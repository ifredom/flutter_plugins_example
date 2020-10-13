import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugins_example/ui/widgets/appbar/custom_appbar.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'screen_shot_utils.dart';

// 截图&保存图片 功能
class ScreenShotView extends StatefulWidget {
  @override
  _ScreenShotViewState createState() => _ScreenShotViewState();
}

class _ScreenShotViewState extends State<ScreenShotView> {
  final GlobalKey _repaintKey = GlobalKey();
  void _saveScreenShot() {
    RenderRepaintBoundary boundary = _repaintKey.currentContext.findRenderObject();
    saveScreenShot(boundary, success: () {
      saveScreenShot2SDCard(boundary, success: () {
        print('二维码图片已保存到本地!');
        BotToast.showText(text: "二维码图片已保存到本地");
      }, fail: () {
        print('图片保存失败');
      });
    }, fail: () {
      print('图片保存失败!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "保存二维码图片"),
      body: Center(
        child: RepaintBoundary(
          key: _repaintKey,
          child: QrImage(
            data: " write to Qr data",
            version: QrVersions.auto,
            size: 144,
            gapless: false,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("保存"),
        onPressed: () {
          _saveScreenShot();
        },
      ),
    );
  }
}
