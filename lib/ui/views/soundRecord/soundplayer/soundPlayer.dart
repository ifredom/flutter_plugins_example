import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';

class SoundPlayer {
  static final SoundPlayer _singleton = SoundPlayer._();

  factory SoundPlayer() {
    return _singleton;
  }

  SoundPlayer._();

  FlutterSoundPlayer? _flutterSoundPlayer;
  late String pathToSaveAudio;
  late Directory appDirectory;

  bool isSoundPlay = false;
  bool _isPlayerInitialised = false;

  Stream<PlaybackDisposition>? get soundDurationStream => _flutterSoundPlayer?.onProgress?.asBroadcastStream();

  Duration? _maxPlayRecordDuration = Duration.zero; // Total duration 音频总时长
  Duration? get maxPlayRecordDuration => _maxPlayRecordDuration;
  Duration _playRecordPosition = Duration.zero; // Playback progress 播放进度
  Duration get playRecordPosition => _playRecordPosition;

  Future<void> init({int subscriptionDuration = 30}) async {
    _flutterSoundPlayer = FlutterSoundPlayer();
    await _openSoundSession();
    _isPlayerInitialised = true;

    await _flutterSoundPlayer?.setSubscriptionDuration(Duration(milliseconds: subscriptionDuration)).then((value) {
      startProgressListener();
    });
  }

  void onFinished() {
    // do something
  }

  Future<void> dispose() async {
    if (isSoundPlay) {
      pause();
    }
    await _closeSoundSession();
    _isPlayerInitialised = false;
  }

  Future<FlutterSoundPlayer?> _openSoundSession() async {
    await _flutterSoundPlayer?.openAudioSession();
  }

  Future<void> _closeSoundSession() async {
    if (_isPlayerInitialised) await _flutterSoundPlayer?.closeAudioSession();
  }

  void startProgressListener() {
    soundDurationStream?.listen((e) {
      _maxPlayRecordDuration = e.duration; //Total duration 音频总时长
      _playRecordPosition = e.position; // Playback progress 播放进度
    });
  }

  Future<void> play({
    required String fromURI,
  }) async {
    await _flutterSoundPlayer?.startPlayer(
      fromURI: fromURI,
      codec: Codec.aacMP4,
      whenFinished: onFinished,
    );
    isSoundPlay = true;
  }

  Future<void> resume() async {
    await _flutterSoundPlayer?.resumePlayer();
    isSoundPlay = true;
  }

  Future<void> pause() async {
    await _flutterSoundPlayer?.pausePlayer();
    isSoundPlay = false;
  }

  Future<void> stop() async {
    await _flutterSoundPlayer?.stopPlayer();
    isSoundPlay = false;
  }

  void seek(int playTimeInMS) {
    _flutterSoundPlayer?.seekToPlayer(Duration(
      milliseconds: playTimeInMS,
    ));
  }

  Future<Map<String, Duration>> getProgressPlay() async {
    Map<String, Duration> progress = await _flutterSoundPlayer!.getProgress();
    return progress;
  }

  void localDownloadSound() async {
    String downloadDirectory = '';

    if (Platform.isAndroid) {
      downloadDirectory = '/sdcard/download/pianosound.aac';
    }

    File pathToAudio = File(pathToSaveAudio);

    try {
      await pathToAudio.rename(downloadDirectory);
    } on FileSystemException {
      await pathToAudio.copy(downloadDirectory);
      deleteSound();
    }
  }

  void deleteSound() {
    appDirectory.deleteSync(recursive: true);
  }
}
