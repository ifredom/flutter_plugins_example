import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pluginexample/core/constants/animations.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: const FlareActor(
        Animations.loader,
        animation: Animations.loader_name,
      ),
    );
  }
}
