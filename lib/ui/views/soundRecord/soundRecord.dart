import 'package:flutter/material.dart';

class SoundRecordScreen extends StatefulWidget {
  const SoundRecordScreen({Key? key}) : super(key: key);

  @override
  _SoundRecordScreenState createState() => _SoundRecordScreenState();
}

class _SoundRecordScreenState extends State<SoundRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SoundRecord录音")),
      body: Container(
        child: Text("开始录音"),
      ),
    );
  }
}
