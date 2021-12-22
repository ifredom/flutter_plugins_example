import 'package:flutter/material.dart';

import 'soundplayer/soundPlayer.dart';
import 'soundplayer/soundRecorder.dart';

class SoundRecordScreen extends StatefulWidget {
  const SoundRecordScreen({Key? key}) : super(key: key);

  @override
  _SoundRecordScreenState createState() => _SoundRecordScreenState();
}

class _SoundRecordScreenState extends State<SoundRecordScreen> {
  SoundRecorder? _soundRecorder;
  SoundRecorder? get soundRecorder => _soundRecorder;

  SoundPlayer? _soundPlayer;
  SoundPlayer? get soundPlayer => _soundPlayer;

  bool isRecording = false;

  bool isPlaying = false;

  initSoundRecord() async {
    if (_soundRecorder == null) {
      _soundRecorder = SoundRecorder();
      await _soundRecorder?.init();
    }
  }

  initSoundPlayer() async {
    if (_soundPlayer == null) {
      _soundPlayer = SoundPlayer();
      await _soundPlayer?.init();
    }
  }

  @override
  void initState() {
    initSoundRecord();
    initSoundPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _soundRecorder?.dispose();

    _soundPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SoundRecord录音")),
      body: Container(
        child: Column(
          children: [
            OutlinedButton.icon(
              icon: Icon(isRecording ? Icons.fiber_smart_record_outlined : Icons.fiber_manual_record_outlined),
              label: Text("start"),
              onPressed: () {
                _soundRecorder?.startRecording();

                setState(() {
                  isRecording = true;
                });
              },
            ),
            OutlinedButton(
              child: Text("stop record"),
              onPressed: () {
                _soundRecorder?.stopRecording();
                setState(() {
                  isRecording = false;
                });
              },
            ),
            Text("saveTo: ${_soundRecorder?.pathToSaveAudio}"),
            Divider(height: 2),
            OutlinedButton(
              child: Text("start play"),
              onPressed: () {
                print(_soundRecorder?.pathToSaveAudio);
                if (_soundRecorder?.pathToSaveAudio != "") {
                  _soundPlayer?.play(fromURI: _soundRecorder!.pathToSaveAudio);

                  setState(() {
                    isPlaying = true;
                  });
                }
              },
            ),
            OutlinedButton(
              child: Text(isPlaying ? "pause" : "resume"),
              onPressed: () {
                isPlaying = !isPlaying;
                if (isPlaying) {
                  _soundPlayer?.resume();
                } else {
                  _soundPlayer?.pause();
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
