import 'package:flutter/material.dart';

import 'justaudioutil.dart';

class JustAudioScreen extends StatefulWidget {
  const JustAudioScreen({Key? key}) : super(key: key);

  @override
  _JustAudioScreenState createState() => _JustAudioScreenState();
}

class _JustAudioScreenState extends State<JustAudioScreen> {
  JustAudioUtil player = JustAudioUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("justAudio"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                player.playMusic();
              },
              child: const Text("play music"),
            ),
            ElevatedButton(
              onPressed: () {
                player.stopPlayMusic();
              },
              child: const Text("stop music"),
            ),
            ElevatedButton(
              onPressed: () {
                player.runTimer();
              },
              child: const Text("Metronome start"),
            ),
            ElevatedButton(
              onPressed: () {
                player.stopBeatRunning();
              },
              child: const Text("Metronome stop"),
            ),
            ElevatedButton(
              onPressed: () {
                player.loopMultSource();
              },
              child: const Text("loopMultSource"),
            )
          ],
        ),
      ),
    );
  }
}
