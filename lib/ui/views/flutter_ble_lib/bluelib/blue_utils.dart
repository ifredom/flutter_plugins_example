import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import 'ble_devices.dart';
import 'blue_config.dart';
import 'device_repository.dart';

typedef DeviceTapListener = void Function();

// 可以蓝牙扫描
class BlueUtils {
  final _log = Logger('BlueUtils');
  final DeviceRepository _deviceRepository;

  final BleManager _bleManager;
  BleManager get bleManager => _bleManager;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice.skipWhile((bleDevice) => bleDevice == null);

  StreamSubscription _devicePickerSubscription;

  BehaviorSubject<BleDevice> _deviceController;
  ValueStream<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<PeripheralConnectionState> _connectionStateController =
      BehaviorSubject<PeripheralConnectionState>.seeded(PeripheralConnectionState.disconnected);
  ValueStream<PeripheralConnectionState> get connectionState => _connectionStateController.stream;

  BehaviorSubject _scanning = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject get scanning => _scanning;

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

  // 构造，使用测试单一设备，暂时不用
  BlueUtils(this._deviceRepository, this._bleManager) {
    var device = _deviceRepository.pickedDevice.value;
    _deviceController = BehaviorSubject<BleDevice>.seeded(device);

    if (device != null) {
      _connectionStateController = BehaviorSubject<PeripheralConnectionState>.seeded(
          device.isConnected ? PeripheralConnectionState.connected : PeripheralConnectionState.disconnected);
    }

    if (_visibleDevicesController.isClosed) {
      _visibleDevicesController = BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);
    }

    if (_devicePickerController.isClosed) {
      _devicePickerController = StreamController<BleDevice>();
    }

    _devicePickerSubscription = _devicePickerController.stream.listen(_handlePickedDevice);
  }

  /// 参考 https://github.com/leelai/flutter_ble/tree/e7429c445193724fbcd5836f52b7a9f05fac7ed1/lib/devices_list
  // 初始化
  Future init() async {
    _bleDevices.clear();
    await _bleManager
        .createClient(
            restoreStateIdentifier: "example-restore-state-identifier",
            restoreStateAction: (peripherals) {
              peripherals?.forEach((peripheral) {
                _log.info("Restored peripheral: ${peripheral.name}");
              });
            })
        .catchError((e) => _log.severe("创建蓝牙client失败"));

    await _checkPermissions().catchError((e) => _log.severe("蓝牙开启失败")).then((_) => _waitForBluetoothPoweredOn());

    await _checkLocationPermissions().catchError((e) => _log.severe("定位权限未授权"));
  }

  Future<void> startScan() async {
    print("开始扫描 startScan\n");

    _scanning.add(true);

    _scanSubscription = _bleManager.startPeripheralScan().listen((scanResult) async {
      _scanningCount += 1;
      if (_scanningCount <= _limitScanningCount) {
        String deviceid = scanResult.peripheral.identifier;
        String deviceName = scanResult.advertisementData.localName;
        String devicePeripheralName = scanResult.peripheral.name;

        var bleDevice =
            BleDevice.notConnected(scanResult.peripheral.name, scanResult.peripheral.identifier, scanResult.peripheral);

        if (devicePeripheralName != null && !_bleDevices.contains(bleDevice)) {
          _log.info('发现新设备：  ${bleDevice.peripheral}');
          _bleDevices.add(bleDevice);
          _visibleDevicesController.add(_bleDevices.sublist(0));
        }

        // 找到目标设备（Midi硬件设备）就停止扫描
        // https://github.com/Polidea/FlutterBleLib/blob/develop/example/lib/test_scenarios/peripheral_test_operations.dart

        if (scanResult.peripheral.identifier == BlueConfig.temperatureDeviceId) {
          print("找到目标设备： 名称：${scanResult.advertisementData.localName}  id值：${scanResult.peripheral.identifier}");
          await _scanSubscription.cancel();
          await stopPeripheralScan();
          _peripheral = scanResult.peripheral;

          var findDevice = DisconnectedBleDevice(
              scanResult.peripheral.name, scanResult.peripheral.identifier, scanResult.peripheral);
          _deviceController = BehaviorSubject<BleDevice>.seeded(findDevice);
        }
      } else {
        stopPeripheralScan();
        _scanningCount = 0;
      }
    });
  }

  Future<void> connectTo(Peripheral peripheral) async {
    _deviceController.stream.listen(print);
    _visibleDevicesController.stream.listen(print);

    _peripheral = peripheral;

    await _peripheral.discoverAllServicesAndCharacteristics();

    // List<Service> services = await _peripheral.services();
    // Service service = services.first;
    // List<Peripheral> connectedPeripherals = await _bleManager.connectedPeripherals([service.uuid]);
    // List<Characteristic> characteristics = await service.characteristics();
    // characteristics.forEach((characteristic) => print("打印特征值的uuid: ${characteristic.uuid}"));
    // Characteristic characteristic = characteristics.first;

    print('准备写入数据');
    // await _peripheral.writeCharacteristic(
    //   service.uuid, // service
    //   characteristic.uuid, // tx characteristic
    //   Uint8List.fromList([0x66]),
    //   false,
    // );

    await readCharacteristic(_peripheral);
  }

  Future<void> readCharacteristic(peripheral) async {
    print("读取临时配置");
    List<Service> services = await peripheral.services();

    Service chosenService = services.firstWhere((elem) {
      print(elem.uuid);
      return elem.uuid == BlueConfig.temperatureService.toLowerCase();
    });
    print(chosenService);

    List<Characteristic> temperatureCharacteristics = await chosenService.characteristics();
    Characteristic chosenCharacteristic = temperatureCharacteristics.firstWhere((characteristic) {
      print(characteristic.uuid);
      return characteristic.uuid == BlueConfig.temperatureDataCharacteristic.toLowerCase();
    });

    print("这里chosenCharacteristic");
    print(chosenCharacteristic);
    print(chosenCharacteristic.service);

    // Characteristic{service: Service{peripheralId: D0:11:A8:E5:67:B3, uuid: 00001800-0000-1000-8000-00805f9b34fb},
    // _manager: Instance of 'InternalBleManager', uuid: 00002a00-0000-1000-8000-00805f9b34fb, isReadable: true,
    // isWritableWithResponse: true, isWritableWithoutResponse: false, isNotifiable: false, isIndicatable: false}
    // 新增加的
    // List<Descriptor> descriptors = await chosenCharacteristic.descriptors();
    // Descriptor chosenDescriptor = descriptors.firstWhere((elem) {
    //   print(elem);
    //   return elem.uuid == BlueConfig.clientCharacteristicConfigurationDescriptor;
    // });
    // Uint8List value = await chosenDescriptor.read();

    Uint8List readValue = await chosenCharacteristic.read();
    print("读取的值");
    // print(value);
    print(readValue);
  }

  Future<void> connect() async {
    _deviceController.stream.listen((bleDevice) async {
      var peripheral = bleDevice.peripheral;
      peripheral.observeConnectionState(emitCurrentValue: true, completeOnDisconnect: true).listen((connectionState) {
        _connectionStateController.add(connectionState);
      });

      try {
        _log.info("尝试连接至设备 ${peripheral.name}");
        bool isConnected = await peripheral.isConnected();
        if (!isConnected) {
          await peripheral.connect();
          isConnected = await peripheral.isConnected();
        }
        _scanning.add(false);
        await connectTo(peripheral);
        _log.info("Connected!");
      } on BleError catch (e) {
        _log.severe(e.toString());
      }
    });
  }

  Future<void> _handlePickedDevice(BleDevice bleDevice) async {
    _deviceRepository.pickDevice(bleDevice);
    await connect();
  }

  void closeDevicePicker() {
    _devicePickerController.close();
  }

  Future stopPeripheralScan() async {
    await _bleManager.stopPeripheralScan();
    _scanning.add(false);
  }

  Future<void> _checkPermissions() async {
    // 此方法为运行时，权限检测（ android4.4不支持）
    if (Platform.isAndroid) {
      await _bleManager.enableRadio();
      _bluetoothStatus = await _bleManager.bluetoothState();
      if (_bluetoothStatus != BluetoothState.POWERED_ON) {
        return Future.error(Exception("请开启蓝牙"));
      }
    }
  }

  Future<void> _checkLocationPermissions() async {
    Completer completer = Completer();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();

    if (statuses[Permission.location] == PermissionStatus.granted) {
      completer.complete();
    }
    if (statuses[Permission.locationWhenInUse] == PermissionStatus.granted) {
      completer.complete();
    }
    if (statuses[Permission.locationAlways] == PermissionStatus.granted) {
      completer.complete();
    }
    return completer.future;
  }

  Future<void> _waitForBluetoothPoweredOn() async {
    Completer completer = Completer();
    StreamSubscription<BluetoothState> _bluetoothStateSubscription;
    _bluetoothStateSubscription =
        _bleManager.observeBluetoothState(emitCurrentValue: true).listen((bluetoothState) async {
      if (bluetoothState == BluetoothState.POWERED_ON && !completer.isCompleted) {
        await _bluetoothStateSubscription.cancel();
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
    await startScan();
  }

  Future<void> disconnect() async {
    disconnectManual();
  }

  Future<void> disconnectManual() async {
    if (await _deviceController.stream.value.peripheral.isConnected()) {
      await _deviceController.stream.value.peripheral.disconnectOrCancelConnection();
    }
  }

  void dispose() async {
    print("销毁页面时调用dispose");
    await disconnect();

    await _scanning.close();
    await _devicePickerSubscription.cancel();
    await _scanSubscription?.cancel();
    await _visibleDevicesController.close();

    await _devicePickerController.close();

    _deviceController?.value?.abandon(); // 丢弃stream.value的数据
    await _deviceController?.drain(); // 丢弃stream上的所有数据
    await _deviceController?.close();

    await _connectionStateController?.drain();
    await _connectionStateController?.close();

    await destroyClient();
  }

  Future destroyClient() async {
    await _bleManager.destroyClient(); //remember to release native resources when you're done!
  }
}

class DebugLog {
  String time;
  String content;

  DebugLog(this.time, this.content);
}
