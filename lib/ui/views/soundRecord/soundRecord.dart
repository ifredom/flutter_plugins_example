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
            OutlinedButton(
              child: Text("start record"),
              onPressed: () {
                _soundRecorder?.startRecording();
              },
            ),
            OutlinedButton(
              child: Text("stop record"),
              onPressed: () {
                _soundRecorder?.stopRecording();
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
              child: Text("resume/pause play"),
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
