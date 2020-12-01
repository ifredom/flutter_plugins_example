# blue_ble_lib插件

## 必备蓝牙常识

* 手机电脑等常用设备蓝牙需要互相手动操作进行连接，使用 blue_ble_lib 插件
* 对于厂商的蓝牙模块设备，比如信号发射，温度检测，过车检测等蓝牙模块，使用 flutter_blue 插件

## 无法扫描到结果

无法扫描出设备 ，通常是没有进行定位权限的授权 。也就是 **_checkLocationPermissions**方法，没有成功调用.此时要么重新尝试调用授权方法，要么重新安装

## [设备两个名字的区别](https://developer.apple.com/forums/thread/72343)

> 设备有两个名字 scanResult.peripheral.name 和 scanResult.advertisementData.localName 通常是一样得.
> 信号强度: rssi

String deviceName = scanResult.advertisementData.localName;
String devicePeripheralName = scanResult.peripheral.name;

## [找到目标设备就停止扫描](https://github.com/Polidea/FlutterBleLib/blob/develop/example/lib/test_scenarios/peripheral_test_operations.dart)