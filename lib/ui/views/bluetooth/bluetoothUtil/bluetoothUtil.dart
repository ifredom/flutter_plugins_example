import 'dart:async';

import "package:flutter_blue/flutter_blue.dart";
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothUtil {
  /// 连接状态
  static BluetoothDeviceState status = BluetoothDeviceState.disconnected;

  /// 蓝牙实例对象
  FlutterBlue flutter_blue = FlutterBlue.instance;

  /// 蓝牙状态
  final BluetoothState state = BluetoothState.unknown;

  /// 蓝牙设备
  BluetoothDevice? cDevice = null;

  List findDs = []; //临时数组存放找到的设备ID

  List subscripts = [];

  static BluetoothUtil _instance = new BluetoothUtil();
  static BluetoothUtil get instance => _instance;

  Timer? scanTimer;

  /// 扫描蓝牙设备(可自动连接)
  void scanDeviceList(int timeout, {String deviceId = ""}) {
    flutter_blue.startScan(timeout: Duration(seconds: timeout));
    flutter_blue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.id.toString() == deviceId &&
            deviceId != "" &&
            BluetoothUtil.status != BluetoothDeviceState.connected) {
          print("auto connect bluetooth id:" + deviceId);
          r.device.state.listen((data) async {
            if (data == BluetoothDeviceState.connected) {
              BluetoothUtil.status = BluetoothDeviceState.connected;

              // saveID,for auto connected (保存ID，为了下次自动连接)
              SharedPreferences _preferences = await SharedPreferences.getInstance();
              _preferences.setString("BlueToothID", deviceId);

              updateConnectDevice(r.device);
            }
          });
          r.device.connect();
        }
      }
    });
  }

  /// 扫描蓝牙设备并回调
  void scanDeviceListCallback(int timeout, {Function? findDevice, Function? findFinish}) {
    flutter_blue.startScan(scanMode: ScanMode.lowPower, timeout: Duration(seconds: timeout));

    flutter_blue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print(r.device);
        print("发现设备 findDevice $findDevice ${r.device.id.toString()}");
        if (findDevice != null && r.device.name.toLowerCase().contains("piano")) {
          if (findDs.contains(r.device.id.toString()) == false) {
            findDs.add(r.device.id.toString());
            findDevice(r.device);
          }
        } else {
          print('${r.device.name} found! rssi: ${r.rssi}');
        }
      }
    });

    if (scanTimer != null) {
      scanTimer!.cancel();
    }

    scanTimer = new Timer(Duration(milliseconds: timeout), () {
      if (findFinish != null) {
        findFinish();
      }
    });
  }

  /// 停止扫描
  void stopScan() {
    flutter_blue.stopScan();
  }

  Future stopScanAsy() async {
    findDs = [];
    await flutter_blue.stopScan();
  }

  void destoryScanTimer() {
    if (scanTimer != null) {
      scanTimer!.cancel();
      scanTimer = null;
    }
  }

  /// 返回扫描结果数据流
  Stream<List<ScanResult>> getScanStream() {
    return FlutterBlue.instance.scanResults;
  }

  /// 检查蓝牙是否可用
  bool checkBlutToothAvabile() {
    if (FlutterBlue.instance.isAvailable == false) {
      return false;
    } else if (FlutterBlue.instance.isOn == false) {
      return false;
    } else {
      return true;
    }
  }

  /// 自动连接
  void autoConnectBlueTooth() async {
    if (checkBlutToothAvabile()) {
      // get Id (获取ID)
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String? lastConnectDeviceid = _preferences.getString("BlueToothID");

      if (lastConnectDeviceid != "" && lastConnectDeviceid != null) {
        scanDeviceList(4, deviceId: lastConnectDeviceid);
      } else {
        print("无缓存的蓝牙设备ID");
      }
    }
  }

  /// 更新连接设备
  void updateConnectDevice(BluetoothDevice device) {
    _instance.cDevice = device;
    _instance.cDevice!.state.listen((event) {
      switch (event) {
        case BluetoothDeviceState.disconnected:
          {
            print("blue device disconnected");
            break;
          }
        case BluetoothDeviceState.disconnecting:
          {
            print("blue device disconnecting");
            break;
          }
        case BluetoothDeviceState.connected:
          {
            print("blue device connected");
            break;
          }
        case BluetoothDeviceState.connecting:
          {
            print("blue device connecting");
            break;
          }
      }
    });
  }

  /// 监听数据
  Future<void> listeningData(BluetoothDevice device, {void Function(dynamic data)? callback}) async {
    if (checkBlutToothAvabile() == false) {
      return;
    }

    if (BluetoothUtil.status == BluetoothDeviceState.disconnected ||
        BluetoothUtil.status == BluetoothDeviceState.connecting ||
        BluetoothUtil.status == BluetoothDeviceState.disconnecting) {
      print("未链接设备或者 正在连接中，请连接设备成功后调用此方法");
      return;
    }

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      if (callback != null) {
        await readData(service, callback: callback);
      } else {
        await readData(service);
      }
    });
  }

  /// 更新设备并监听数据
  Future<void> updateDeviceAndListening(BluetoothDevice device, {void Function(dynamic data)? callback}) async {
    updateConnectDevice(device);
    if (callback != null) {
      await listeningData(device, callback: callback);
    } else {
      await listeningData(device);
    }
  }

  /// 读取数据
  Future<void> readData(BluetoothService service, {void Function(dynamic data)? callback}) async {
    var characteristics = service.characteristics;
    if (characteristics.isNotEmpty) {
      BluetoothCharacteristic readCharacteristic;
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          readCharacteristic = characteristic;
          await readCharacteristic.setNotifyValue(true);
          StreamSubscription<List<int>> ss = readCharacteristic.value.listen((response) {
            if (callback != null) {
              callback(response);
            }
          });
          subscripts.add(ss);
        }
      }
    }
  }

  closeListen() {
    subscripts.forEach((element) {
      element.cancel();
    });
  }
}
