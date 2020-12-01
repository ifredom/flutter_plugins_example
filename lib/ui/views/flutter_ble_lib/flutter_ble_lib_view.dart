import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:logging/logging.dart';
import 'package:flutter_plugins_example/ui/views/flutter_ble_lib/bluelib/ble_devices.dart';
import 'package:flutter_plugins_example/ui/views/flutter_ble_lib/bluelib/blue_utils.dart';
import 'package:flutter_plugins_example/ui/views/flutter_ble_lib/bluelib/device_repository.dart';
import 'package:flutter_plugins_example/ui/widgets/appbar/custom_appbar.dart';

typedef DeviceTapListener = void Function();

// 可以扫描
class FlutterBleLibView extends StatefulWidget {
  @override
  _FlutterBleLibViewState createState() => _FlutterBleLibViewState();
}

class _FlutterBleLibViewState extends State<FlutterBleLibView> {
  final _log = Logger('FlutterBleLibView');

  bool _beginScan = false;

  BlueUtils _blueUtils = BlueUtils(DeviceRepository(), BleManager());

  @override
  void initState() {
    super.initState();
    // initBlue();
  }

  @override
  void dispose() {
    _blueUtils.dispose();
    _blueUtils.destroyBlue();
    // _blueUtils.bleManager.stopPeripheralScan();
    // _scanSubscription?.cancel();
    // _devicePickerController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(title: "蓝牙测试 flutter_ble_lib"),
        body: Column(children: <Widget>[
          Center(
            child: FlatButton(
              child: Text("初始化"),
              onPressed: () async {
                _blueUtils.init();
              },
            ),
          ),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("开始扫描"),
                onPressed: () {
                  _blueUtils.startScan();
                  setState(() {
                    _beginScan = true;
                  });
                },
              ),
              _beginScan
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ),
                    )
                  : SizedBox(),
            ],
          )),
          Center(
            child: FlatButton(
              child: Text("停止扫描"),
              onPressed: () async {
                setState(() {
                  _beginScan = false;
                });
                await _blueUtils.bleManager.stopPeripheralScan();
              },
            ),
          ),
          Center(
            child: FlatButton(
              child: Text("断开连接"),
              onPressed: () async {
                await _blueUtils.bleManager.destroyClient();
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<BleDevice>>(
              initialData: _blueUtils.visibleDevices.value,
              stream: _blueUtils.visibleDevices,
              builder: (context, snapshot) => RefreshIndicator(
                onRefresh: _blueUtils.refresh,
                child: DevicesList(_blueUtils.devicePickerController, snapshot.data),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class DevicesList extends ListView {
  DevicesList(StreamController devicePickerController, List<BleDevice> devices)
      : super.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 0,
                  indent: 0,
                ),
            itemCount: devices.length,
            itemBuilder: (context, i) {
              print("Build row for $i");
              return _buildRow(context, devices[i], _createTapListener(devicePickerController, devices[i]));
            });

  static DeviceTapListener _createTapListener(StreamController devicePickerController, BleDevice bleDevice) {
    return () {
      print("clicked device: ${bleDevice.name}");
      devicePickerController.sink.add(bleDevice);
    };
  }

  static Widget _buildRow(BuildContext context, BleDevice device, DeviceTapListener deviceTapListener) {
    return ListTile(
      title: Text(device.name),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Icon(Icons.chevron_right, color: Colors.grey),
      ),
      subtitle: Column(
        children: <Widget>[
          Text(
            device.id.toString(),
            style: TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      onTap: deviceTapListener,
      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
    );
  }
}
