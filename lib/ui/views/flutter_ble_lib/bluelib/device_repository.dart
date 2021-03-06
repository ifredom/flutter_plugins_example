import 'package:rxdart/rxdart.dart';

import 'ble_devices.dart';

class MissingPickedDeviceException implements Exception {}

/*
 * 蓝牙设备统一管理
 */
class DeviceRepository {
  static BleDevice _bleDevice;
  BehaviorSubject<BleDevice> _deviceController;

  static final DeviceRepository _deviceRepository = DeviceRepository._internal();

  factory DeviceRepository() {
    return _deviceRepository;
  }

  DeviceRepository._internal() {
    _deviceController = BehaviorSubject<BleDevice>.seeded(_bleDevice);
  }

  void pickDevice(BleDevice bleDevice) {
    _bleDevice = bleDevice;
    _deviceController.add(_bleDevice);
  }

  // shareValueSeeded: 将当前Stream转换为ValueStream可以多次收听的新Stream ，并提供一个初始值。第一次收听时，它将自动开始发射项目，当没有收听者时，它将关闭。
  ValueStream<BleDevice> get pickedDevice => _deviceController.stream.shareValueSeeded(_bleDevice);

  bool get hasPickedDevice => _bleDevice != null;
}
