import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key}) : super(key: key);

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _showScanView = false;
  String? resultString = "";

  Widget _buildQrView(BuildContext context) {
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;

    return QRView(
      key: _qrKey,
      // You can choose between CameraFacing.front or CameraFacing.back. Defaults to CameraFacing.back
      // cameraFacing: CameraFacing.front,
      onQRViewCreated: _onQRViewCreated,
      // Choose formats you want to scan. Defaults to all formats.
      // formatsAllowed: [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((Barcode scanData) {
      resultString = scanData.code;

      print(resultString);
      _controller?.dispose();
      setState(() {
        _showScanView = false;
      });
    });
  }

  @override
  void reassemble() {
    if (_controller != null) {
      super.reassemble();
    }
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    } else if (Platform.isIOS) {
      _controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qr二维码"),
      ),
      body: Column(
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showScanView = true;
                });
              },
              child: const Text("scan"),
            ),
          ),
          Text(
            resultString ?? "",
            style: const TextStyle(color: Colors.black),
          ),
          Stack(
            children: [
              _showScanView
                  ? SizedBox(
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 5,
                            child: _buildQrView(context),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Positioned(
                left: 50,
                top: 50,
                child: GestureDetector(
                  child: Image.asset(
                    "assets/images/back.png",
                    width: 60,
                    height: 60,
                  ),
                  onTap: () {
                    setState(() {
                      _showScanView = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
