# flutter_plugins_example

示例: ble，webview, map，chart, websocket ......等第三方插件功能.

> 环境： flutter version: 2.5.0

## 功能插件列表

- flutter_blue: 蓝牙 （√）
- flutter_webview: webview
- flutter_webview_plugin: webview
- permission_handler: 权限 （√）
- screen_shot: 截图 & 二维码（√）

## 启动运行

```java
// run dev
flutter run
// build apk
flutter build apk
// 启动指定入口文件
flutter run --target lib/pages/websocket/socketpage.dart

// 检查依赖
flutter pub run dependency_validator
```

## built_valut 自动生成代码方法

[视频](https://www.youtube.com/watch?v=hNbOSSgpneI)

<!-- 执行生成代码 -->

> flutter packages pub run build_runner build --delete-conflicting-outputs

对预设模板得[要求](https://www.stacksecrets.com/flutter/how-to-use-built_value-library)
