import 'dart:async';

import 'package:just_audio/just_audio.dart';

class JustAudioUtil {
  int _tick = 0;
  int _nowStep = -1;
  bool _isRunning = false;
  int soundType = 7;
  int beat = 4;
  int bpm = 120;
  Timer? timer;
  late AudioPlayer audioPlayer;

  JustAudioUtil() {
    audioPlayer = AudioPlayer();
  }

  Future<void> playAudio() async {
    int nextStep = _nowStep + 1;
    soundType = soundType;

    // 每3拍切换一下声音
    if (nextStep % beat == 0) {
      audioPlayer.setAsset('assets/audio/metronome/metronome$soundType-1.wav');
      audioPlayer.play();
    } else {
      audioPlayer.setAsset('assets/audio/metronome/metronome$soundType-2.wav');
      audioPlayer.play();
    }
  }

  void runTimer() {
    timer = Timer(Duration(milliseconds: (60 / bpm.toInt() * 1000).toInt()), () {
      _tick++;
      _isRunning = true;
      playAudio().then((value) => _setNowStep());
      runTimer();
    });
  }

  void _setNowStep() {
    _nowStep++;
  }

  void toggleIsRunning() {
    if (_isRunning) {
      timer?.cancel();
    } else {
      runTimer();
    }
    if (_isRunning) {
      timer?.cancel();
      _isRunning = !_isRunning;
    }
  }

  void startBeatRunning() {
    if (!_isRunning) {
      runTimer();
    }
  }

  void stopBeatRunning() {
    timer?.cancel();
    _isRunning = false;
  }

  dispose() async {
    stopBeatRunning();
    await audioPlayer.dispose();
  }

  playMusic() {
    audioPlayer.setAsset('assets/audio/viper.mp3');
    audioPlayer.play();
  }

  stopPlayMusic() {
    audioPlayer.stop();
  }

  void loopMultSource() async {
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        // Start loading next item just before reaching it.
        useLazyPreparation: true, // default
        // Customise the shuffle algorithm.
        shuffleOrder: DefaultShuffleOrder(), // default
        // Specify the items in the playlist.
        children: [
          AudioSource.uri(Uri.parse('asset:///assets/audio/metronome/metronome1-1.wav')),
          AudioSource.uri(Uri.parse('asset:///assets/audio/metronome/metronome2-1.wav')),
          AudioSource.uri(Uri.parse('asset:///assets/audio/metronome/metronome3-1.wav')),
        ],
      ),
      // Playback will be prepared to start from track1.mp3
      initialIndex: 0, // default
      // Playback will be prepared to start from position zero.
      initialPosition: Duration.zero, // default
    );
    audioPlayer.play();
  }
}
