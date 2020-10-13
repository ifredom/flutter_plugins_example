# issues

flutter- 开发问题集锦

## blue 蓝牙

- 蓝牙需要在 AndroidManifest.xml中设置权限（android 6.0之后需要提前开启定位权限）
- 蓝牙只能发现部分蓝牙设备，面配对的硬件可以搜索，例外：小米手机搜索不到


```bash
<!-- 管理蓝牙设备的权限 -->
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<!-- 使用蓝牙设备的权限 -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<!-- 这个权限用于进行网络定位-->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission>
<!-- 这个权限用于访问GPS定位-->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
```
