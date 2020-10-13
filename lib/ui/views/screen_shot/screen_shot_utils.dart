import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

final String scrawlImagePath = '/screen_shot_scraw.png';

//  Flutter提供了一个RepaintBoundaryWidget来实现截图的功能，用RepaintBoundary包裹需要截取的部分，RenderRepaintBoundary可以将RepaintBoundary包裹的部分截取出来；然后通过boundary.toImage()方法转化为ui.Image对象，再使用image.toByteData()将image转化为byteData；最后通过File().writeAsBytes()存储为文件对象：
// 链接：https://juejin.im/post/5bf76c55e51d4540496696d0

Future<File> getScreenShotFile() async {
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = '${tempDir.path}$scrawlImagePath';
  File image = File(tempPath);
  bool isExist = await image.exists();
  return isExist ? image : null;
}

Future<bool> getPermission() async {
  if (await Permission.storage.isUndetermined || await Permission.storage.isDenied) {
    return Permission.storage.request().then((status) => status == PermissionStatus.granted ? true : false);
  } else {
    return true;
  }
}

Future saveScreenShot2SDCard(RenderRepaintBoundary boundary, {Function success, Function fail}) async {
  // 检查多种权限.
  // Map<Permission, PermissionStatus> statuses = await [
  //   Permission.storage,
  //   Permission.location,
  // ].request();

  bool storagePermissionStatus = await getPermission();
  if (storagePermissionStatus) {
    capturePng2List(boundary).then((uint8List) async {
      if (uint8List == null || uint8List.isEmpty) {
        if (fail != null) fail();
        return;
      }
      Directory tempDir = await getExternalStorageDirectory();
      _saveImage(uint8List, Directory('${tempDir.path}/flutter_ui'), '/screen_shot_scraw_${DateTime.now()}.png',
          success: success, fail: fail);
    });
  } else {
    print('请打开SD卡存储权限！');
    return;
  }
}

void saveScreenShot(RenderRepaintBoundary boundary, {Function success, Function fail}) {
  capturePng2List(boundary).then((uint8List) async {
    if (uint8List == null || uint8List.isEmpty) {
      if (fail != null) fail();
      return;
    }
    Directory tempDir = await getTemporaryDirectory();
    _saveImage(uint8List, tempDir, scrawlImagePath, success: success, fail: fail);
  });
}

void _saveImage(Uint8List uint8List, Directory dir, String fileName, {Function success, Function fail}) async {
  bool isDirExist = await Directory(dir.path).exists();
  if (!isDirExist) await Directory(dir.path).create();
  String tempPath = '${dir.path}$fileName';
  File image = File(tempPath);
  bool isExist = await image.exists();
  if (isExist) await image.delete();
  await File(tempPath).writeAsBytes(uint8List).then((_) {
    if (success != null) success();
  });
}

Future<Uint8List> capturePng2List(RenderRepaintBoundary boundary) async {
  ui.Image image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData.buffer.asUint8List();
  return pngBytes;
}
