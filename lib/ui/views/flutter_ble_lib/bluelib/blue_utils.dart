import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import 'ble_devices.dart';
import 'blue_config.dart';
import 'device_repository.dart';

typedef DeviceTapListener = void Function();

/*
 * 蓝牙工具类
 */
class BlueUtils {
  final _log = Logger('BlueUtils');
  final DeviceRepository _deviceRepository;

  final BleManager _bleManager;
  BleManager get bleManager => _bleManager;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice.skipWhile((bleDevice) => bleDevice == null);

  Subject<List<DebugLog>> _logsController;
  Stream<List<DebugLog>> get logs => _logsController.stream;

  // StreamSubscription _devicePickerSubscription;

  BehaviorSubject<BleDevice> _deviceController;
  ValueStream<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<PeripheralConnectionState> _connectionStateController;
  ValueStream<PeripheralConnectionState> get connectionState => _connectionStateController.stream;

  bool _scanning = false;
  bool get scanning => _scanning;

  num _scanningCount = 0; // 扫描次数
  num get scanningCount => _scanningCount;

  num _limitScanningCount = 600; // 扫描次数限制，防止找不到设备时，一直扫描
  num get limitScanningCount => _limitScanningCount;

  final List<BleDevice> _bleDevices = <BleDevice>[];
  List<BleDevice> get bleDevices => _bleDevices;

  BluetoothState _bluetoothStatus = BluetoothState.UNKNOWN;
  BluetoothState get bluetoothStatus => _bluetoothStatus;

  StreamController<BleDevice> _devicePickerController = StreamController<BleDevice>();
  StreamController<BleDevice> get devicePickerController => _devicePickerController;

  Sink<BleDevice> get devicePicker => _devicePickerController.sink;

  BehaviorSubject<List<BleDevice>> _visibleDevicesController = BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);
  ValueStream<List<BleDevice>> get visibleDevices => _visibleDevicesController.stream;

  Peripheral _peripheral;
  Peripheral get peripheral => _peripheral;

  StreamSubscription<ScanResult> _scanSubscription;

  List<DebugLog> _logs = [];
  Logger log;
  Logger logError;

  // 构造，使用测试单一设备，暂时不使用
  BlueUtils(this._deviceRepository, this._bleManager) {
    var device = _deviceRepository.pickedDevice.value;
    _deviceController = BehaviorSubject<BleDevice>.seeded(device);
    print(device.toString());

    // if (device != null) {
    //   _connectionStateController = BehaviorSubject<PeripheralConnectionState>.seeded(
    //       device.isConnected ? PeripheralConnectionState.connected : PeripheralConnectionState.disconnected);
    // }
  }

  void closeDevicePicker() {
    _devicePickerController.close();
  }

  // 参考地址： https://github.com/Polidea/FlutterBleLib/blob/develop/example/lib/test_scenarios/peripheral_test_operations.dart
  Future<void> connectTo(ScanResult scanResult) async {
    _deviceController.stream.listen(print);
    _visibleDevicesController.stream.listen(print);

    _peripheral = scanResult.peripheral;
    _scanning = false;

    print('=================准备开始连接=================');
    bool isConnected = await _peripheral.isConnected();
    print("'=================当前连接状态isConnected=================: $isConnected");

    if (!isConnected) {
      await _peripheral.connect();
      isConnected = await _peripheral.isConnected();
      print('=================连接之后得状态=================： $isConnected');
    }
    // debugPrintStack(label: '连接2', maxFrames: 2);
    await _peripheral.discoverAllServicesAndCharacteristics();

    List<Service> services = await _peripheral.services();
    print("=================打印外围设备名称================= \n${_peripheral.name}");
    services.forEach((service) => print("发现服务 \n${service.uuid}"));
    Service service = services.first;
    print("=================打印第一个服务的uuid================= \n${service.uuid}");

    List<Peripheral> connectedPeripherals = await _bleManager.connectedPeripherals([service.uuid]);
    print(connectedPeripherals);

    List<Characteristic> characteristics = await service.characteristics();
    characteristics.forEach((characteristic) => print("打印特征值的uuid: ${characteristic.uuid}"));
    Characteristic characteristic = characteristics.first;
    print("=================打印第一个特征值的uuid================= \n${characteristic.uuid}");

    debugPrintStack(label: '准备读写数据', maxFrames: 3);
    print("向设备写入数据");
    await _peripheral.writeCharacteristic(
      service.uuid,
      characteristic.uuid,
      Uint8List.fromList([0x66]),
      false,
    );
    print("读取设备数据");
    await readCharacteristic(_peripheral);
  }

  Future<void> startScan() async {
    print("开始扫描 startScan\n");

    _scanning = true;

    _scanSubscription = _bleManager.startPeripheralScan().listen((scanResult) async {
      _scanningCount += 1;
      if (_scanningCount <= _limitScanningCount) {
        var bleDevice =
            BleDevice.notConnected(scanResult.peripheral.name, scanResult.peripheral.identifier, scanResult.peripheral);

        // 这里的  scanResult.peripheral.name 与 scanResult.advertisementData.localName 看设备情况使用哪一种
        if (scanResult.peripheral.name != null && !_bleDevices.contains(bleDevice)) {
          _log.info('发现新设备： ${scanResult.peripheral.name} ${scanResult.peripheral.identifier}');
          _bleDevices.add(bleDevice);
          _visibleDevicesController.add(_bleDevices.sublist(0));
        }

        // 我的的iPhone 11的设备id，固定写死:  BlueConfig.temperatureDeviceId
        if (scanResult.peripheral.identifier == BlueConfig.temperatureDeviceId) {
          print("找到目标设备： 名称：${scanResult.advertisementData.localName}  id值：${scanResult.peripheral.identifier}");

          _peripheral = scanResult.peripheral;
          await _bleManager.stopPeripheralScan();

          var findDevice = DisconnectedBleDevice(
              scanResult.peripheral.name, scanResult.peripheral.identifier, scanResult.peripheral);
          _deviceController = BehaviorSubject<BleDevice>.seeded(findDevice);

          await connectTo(scanResult);
          // await connect();
        }
      } else {
        await _bleManager.stopPeripheralScan();
        _scanningCount = 0;
      }
    });
  }

  /// 参考 https://github.com/leelai/flutter_ble/tree/e7429c445193724fbcd5836f52b7a9f05fac7ed1/lib/devices_list
  /// 初始化
  Future init() async {
    print("init进入");
    _bleDevices.clear();
    await _bleManager
        .createClient(
            restoreStateIdentifier: "example-restore-state-identifier",
            restoreStateAction: (peripherals) {
              peripherals?.forEach((peripheral) {
                _log.info("Restored peripheral: ${peripheral.name}");
              });
            })
        .catchError((e) => _log.severe("创建client实例失败"))
        .then((_) => _checkPermissions())
        .catchError((e) => _log.severe("蓝牙开启失败"))
        .then((_) => _checkLocationPermissions())
        .catchError((e) => _log.severe("定位权限未授权"))
        .then((_) => _waitForBluetoothPoweredOn());

    if (_visibleDevicesController.isClosed) {
      _visibleDevicesController = BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);
    }

    if (_devicePickerController.isClosed) {
      _devicePickerController = StreamController<BleDevice>();
    }

    // _log.info("监听 _devicePickerController.stream");
    // _devicePickerSubscription = _devicePickerController.stream.listen(_handlePickedDevice);
  }

  // 监听链接状态
  Future<void> connect() async {
    _clearLogs();
    _deviceController.stream.listen((bleDevice) async {
      var peripheral = bleDevice.peripheral;

      peripheral.observeConnectionState(emitCurrentValue: true, completeOnDisconnect: true).listen((connectionState) {
        _log.info('观察新连接状态: \n$connectionState');
        _connectionStateController.add(connectionState);
      });

      try {
        _log.info("连接至设备 ${peripheral.name}");
        await peripheral.connect();
        _log.info("Connected!");
      } on BleError catch (e) {
        _log.severe(e.toString());
      }
    });
  }

  // void _handlePickedDevice(BleDevice bleDevice) {
  //   _deviceRepository.pickDevice(bleDevice);
  // }

  Future<void> _checkPermissions() async {
    // 此方法为运行时，蓝牙权限检测（ android4.4不支持）
    if (Platform.isAndroid) {
      await _bleManager.enableRadio();
      _bluetoothStatus = await _bleManager.bluetoothState();
      print("此时的蓝牙状态");
      print(_bluetoothStatus);
      if (_bluetoothStatus != BluetoothState.POWERED_ON) {
        return Future.error(Exception("请开启蓝牙"));
      }
    }
  }

  Future<void> _checkLocationPermissions() async {
    print("检测定位权限，手机定位权限有3种情况");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();

    if (statuses[Permission.location] == PermissionStatus.granted) {
      print("已授权定位");
    }
    if (statuses[Permission.locationWhenInUse] == PermissionStatus.granted) {
      print("已授权使用时定位");
    }
    if (statuses[Permission.locationAlways] == PermissionStatus.granted) {
      print("已授权总是定位");
    }
    print("授权状态$statuses");
  }

  Future<void> _waitForBluetoothPoweredOn() async {
    Completer completer = Completer();
    StreamSubscription<BluetoothState> subscription;
    subscription = _bleManager.observeBluetoothState(emitCurrentValue: true).listen((bluetoothState) async {
      print("_waitForBluetoothPoweredOn: bluetoothState");
      print(bluetoothState);
      if (bluetoothState == BluetoothState.POWERED_ON && !completer.isCompleted) {
        await subscription.cancel();
        completer.complete();
      }
    });
    return completer.future;
  }

  Future<void> refresh() async {
    await _scanSubscription.cancel();
    await _bleManager.stopPeripheralScan();
    _bleDevices.clear();
    _visibleDevicesController.add(_bleDevices.sublist(0));
    await _checkPermissions().then((_) => startScan()).catchError((e) => _log.severe("Couldn't refresh"));
  }

  // 读取设备发送过来的数据
  Future<void> readCharacteristic(peripheral) async {
    print("读取临时配置");
    Service service = await peripheral.services().then(
        (services) => services.firstWhere((service) => service.uuid == BlueConfig.temperatureService.toLowerCase()));

    List<Characteristic> characteristics = await service.characteristics();
    Characteristic characteristic = characteristics
        .firstWhere((characteristic) => characteristic.uuid == BlueConfig.temperatureDataCharacteristic.toLowerCase());

    Uint8List readValue = await characteristic.read();
    print("读取的值");
    print(readValue);
  }

  Future<void> disconnect() async {
    _clearLogs();
    await disconnectManual();
  }

  Future<void> disconnectManual() async {
    _clearLogs();
    if (await _deviceController.stream.value.peripheral.isConnected()) {
      print("正在断开连接...");
      // await _deviceController.stream.value.peripheral.disconnectOrCancelConnection();
    }
    print("已断开!");
  }

  void _clearLogs() {
    _logs = [];
    _logsController.add(_logs);
  }

  void dispose() async {
    print("销毁页面");
    // await _devicePickerSubscription.cancel();
    await _visibleDevicesController.close();
    await _scanSubscription?.cancel();

    // await _devicePickerController.close();
    _deviceController?.value?.abandon();
    await _deviceController?.drain(); // 丢弃所有数据
    await _deviceController?.close();

    //
    await _connectionStateController?.drain();
    await _connectionStateController?.close();

    // await disconnect();
  }

  Future destroyBlue() async {
    // await _peripheral.disconnectOrCancelConnection();
    await _bleManager.destroyClient(); //remember to release native resources when you're done!
  }
}

class DebugLog {
  String time;
  String content;

  DebugLog(this.time, this.content);
}
