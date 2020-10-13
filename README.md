# flutter_plugins_example

演示: ble，webview, map，chart, websocket ......等第三方插件功能.

copy file & use ！

环境：
flutter version: 1.22.1
android sdk: 28

## 功能插件列表

- flutter_blue: 蓝牙 （√）
- flutter_ble_lib: 蓝牙
- flutter_webview: webview
- flutter_webview_plugin: webview
- permission_handler: 权限 （√）
- screen_shot: 截图 & 二维码（√）

## 启动运行

```java
// 开发，运行
flutter run
// 打包apk
flutter build apk
// 启动指定入口文件
flutter run --target lib/pages/websocket/socketpage.dart
```

## android 环境修改

android compileSdkVersion: 28

app/build.gradle 中的 compileSdkVersion 以及 minSdkVersion

```java
android {
    compileSdkVersion 28

    defaultConfig {
      minSdkVersion 28
    }
}
...
```

---

AndroidManifest.xml

```java
<application android:usesCleartextTraffic="true"
 ...>
```

### 开发常用的快捷键

Ctrl + Space 给出代码提示
Alt + Shift + O 移除没用的 imports
Ctrl + . 快速包裹小部件。例如`Wrap with Container`，点击任意 widget，例如`Scaffold`,按下 `ctrl+.`
Ctrl + . 快速将`StatelessWidget`转变为`StatefulWidget`。点击`StatelessWidget`,按下 `ctrl+.`
右键 + 点击 提取本地变量（Extract Local Variable
右键 + 点击 提取为类（Extract Widget）

## built_valut 自动生成代码方法

[视频](https://www.youtube.com/watch?v=hNbOSSgpneI)

<!-- 执行生成代码 -->

> flutter packages pub run build_runner build --delete-conflicting-outputs

对预设模板得[要求](https://www.stacksecrets.com/flutter/how-to-use-built_value-library)

同时加入 serializers.dart 文件中

```dash

import 'package:built_value/built_value.dart';

part 'testmode.g.dart';

abstract class Testmode implements Built<Testmode, TestmodeBuilder> {
  @nullable
  String get id;

  @nullable
  String get token;

  String get name;

  Testmode._();
  factory Testmode([updates(TestmodeBuilder b)]) = _$Testmode;
}
```
