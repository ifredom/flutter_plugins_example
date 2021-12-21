import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  late Directory appDirectory;
  String pathToSaveAudio = "";

  FlutterSoundRecorder? _soundRecorder;
  bool _isRecorderInitialised = false;

  int recordDuration = 0; // record duration 录音时长

  Future<void> init() async {
    appDirectory = await getApplicationDocumentsDirectory();
    pathToSaveAudio = appDirectory.path + '/' + 'pianosound' + '.aac';
    try {
      bool isPermissionsReceived = await _checkPermission();
      if (isPermissionsReceived) {
        _isRecorderInitialised = true;
        _soundRecorder = FlutterSoundRecorder();

        await _openRecorderAudioSession();
        await _setAudioRecorderSubscriptionDuration(const Duration(milliseconds: 50));
        recorderStream!.listen((event) => recordDuration = event.duration.inMilliseconds);
      }
    } catch (e) {
      dispose();
    }
  }

  Future<void> dispose() async {
    if (!_isRecorderInitialised) return;
    await _closeRecorderAudioSession();
    _soundRecorder = null;
    _isRecorderInitialised = false;
  }

  void startRecording() async {
    if (!_isRecorderInitialised) return;
    await _soundRecorder
        ?.startRecorder(
          toFile: pathToSaveAudio,
        )
        .then((value) {});
  }

  Future<void> stopRecording() async {
    if (!_isRecorderInitialised) return;

    await _soundRecorder!.stopRecorder().then((value) async {
      // String url = value ?? "";
      print("fill path =>： $pathToSaveAudio $recordDuration");

      // await uploadFile(path: pathToSaveAudio, fileName: fileName, type: "voice", voiceTime: recordDuration);
    });

    await dispose();
  }

  Stream<RecordingDisposition>? get recorderStream {
    if (!_isRecorderInitialised) {
      return null;
    }
    return _soundRecorder?.onProgress;
  }

  Future<void> _openRecorderAudioSession() async {
    await _soundRecorder?.openAudioSession(
        category: SessionCategory.record, focus: AudioFocus.requestFocusAndDuckOthers);
  }

  Future<void> _closeRecorderAudioSession() async {
    await _soundRecorder?.closeAudioSession();
  }

  Future<void> _setAudioRecorderSubscriptionDuration(Duration duration) async {
    await _soundRecorder?.setSubscriptionDuration(duration);
  }

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();
    bool isGranted = permissions[Permission.storage]!.isGranted && permissions[Permission.microphone]!.isGranted;

    if (isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> uploadFile({
    required String path,
    required String type,
    required String fileName,
    required int voiceTime,
  }) async {}
}
