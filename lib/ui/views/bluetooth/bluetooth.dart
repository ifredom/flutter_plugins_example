import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'bluetoothUtil/bluetoothUtil.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({Key? key}) : super(key: key);

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothUtil blueMag = BluetoothUtil.instance;

  List<BluetoothDevice> scanDevices = [];
  String? selectDevice;

  startScan() {
    blueMag.scanDeviceListCallback(10, findDevice: (BluetoothDevice result) {
      scanDevices.add(result);

      BluetoothUtil.status = BluetoothDeviceState.connected;
    }, findFinish: () {
      BluetoothUtil.status = BluetoothDeviceState.disconnected;
    });
  }

  @override
  void dispose() {
    blueMag.destoryScanTimer();
    blueMag.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth蓝牙"),
      ),
      body: Column(
        children: [
          OutlinedButton(
            child: Text("scan"),
            onPressed: () {
              startScan();
            },
          ),
          buildDeviceListWidget(),
        ],
      ),
    );
  }

  /// 设备列表内容
  Widget buildDeviceListWidget() {
    return Container(
      height: 400,
      width: 400,
      child: ListView.builder(
        itemCount: scanDevices.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          if (scanDevices.length > 0) {
            return Row(
              children: [Text(scanDevices[index].toString())],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
