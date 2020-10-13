import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_plugins_example/ui/widgets/appbar/custom_appbar.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterblueView extends StatefulWidget {
  @override
  _FlutterblueViewState createState() => _FlutterblueViewState();
}

class _FlutterblueViewState extends State<FlutterblueView> {
  // PermissionStatus _locationPermissionStatus = PermissionStatus.unknown;

  FlutterBlue flutterBlue = FlutterBlue.instance;

  StreamController<List<ScanResult>> _dataController = StreamController<List<ScanResult>>();

  ///获取 StreamSink 做 add 入口
  StreamSink<List<ScanResult>> get dataSink => _dataController.sink;

  ///获取 Stream 用于监听
  Stream<List<ScanResult>> get dataStream => _dataController.stream;

  ///事件订阅对象
  StreamSubscription _dataSubscription;

  Future initBlue() async {}

  Future<void> _checkPermissions() async {}

  Future<void> _checkBluetoothState() async {
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        print("蓝牙已开启");
      } else if (state == BluetoothState.off) {
        print("蓝牙未开启");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
  }

  @override
  void dispose() {
    _dataSubscription.cancel();
    _dataController.close(); // 后来警告添加
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "蓝牙测试 flutter_blue"),
      body: StreamBuilder<BluetoothState>(
        stream: flutterBlue.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          print(state);
          if (state == BluetoothState.on) {
            return StreamBuilder<List<ScanResult>>(
              stream: _dataController.stream,
              initialData: [], // 必须是List数据
              builder: (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) {
                /// 获取到数据，为所欲为的更新 UI
                var data = snapshot.data;
                print("获取到数据，为所欲为的更新 UI");
                print(data);

                _dataSubscription = flutterBlue.scanResults.listen((results) {
                  for (ScanResult item in results) {
                    print('$item');
                    print('${item.device.name} found! rssi: ${item.rssi}');
                    _dataController.sink.add([item]);
                  }
                });

                return Column(
                  children: data.map((scanResult) {
                    print(scanResult);
                    return Text(scanResult.toString());
                  }).toList(),
                );
              },
            );
          }
          return Text('Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Text("扫描"),
        onPressed: () async {
          _dataSubscription = flutterBlue.scanResults.listen((results) {
            print('扫描结果：');
            print(results);
            for (ScanResult item in results) {
              print('$item');
              print('${item.device.name} found! rssi: ${item.rssi}');
              _dataController.sink.add(results);
            }
          });
        },
      ),
    );
  }
}

// flutterBlue.connectedDevices  stopScan()
