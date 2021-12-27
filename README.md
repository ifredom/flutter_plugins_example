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

## AndroidManifest.xml

```xml
  <!-- 相机权限 -->
  <uses-permission android:name="android.permission.CAMERA"></uses-permission>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"></uses-permission>
  <!-- 用于读取手机当前的状态-->
  <uses-permission android:name="android.permission.READ_PHONE_STATE"></uses-permission>
  <!-- 网络权限 -->
  <uses-permission android:name="android.permission.INTERNET"></uses-permission>
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"></uses-permission>
  <!-- 使用蓝牙设备的权限 -->
  <uses-permission android:name="android.permission.BLUETOOTH" />
  <!-- 管理蓝牙设备的权限 -->
  <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
  <!-- 这个权限用于进行网络定位-->
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission>
  <!-- 这个权限用于访问GPS定位-->
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
  <!-- 这个权限用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
  <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
  <!-- 获取网络状态，根据网络状态切换进行数据请求网络转换 -->
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission>
  <!-- 读取系统信息，包含系统版本等信息，用作统计-->
  <uses-permission android:name="com.android.launcher.permission.READ_SETTINGS"></uses-permission>
  <!-- 音频播放记录-->
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

## built_valut 自动生成代码方法

[视频](https://www.youtube.com/watch?v=hNbOSSgpneI)

<!-- 执行生成代码 -->

> flutter packages pub run build_runner build --delete-conflicting-outputs

对预设模板得[要求](https://www.stacksecrets.com/flutter/how-to-use-built_value-library)
