import 'dart:math';

import 'package:flutter/material.dart';

class CircleFlowAnimation extends StatefulWidget {
  final List<Widget> children;
  const CircleFlowAnimation({Key? key, required this.children}) : super(key: key);

  @override
  State<CircleFlowAnimation> createState() => _CircleFlowAnimationState();
}

class _CircleFlowAnimationState extends State<CircleFlowAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double rad = 0.0;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this)
      ..addListener(() => setState(() => rad = _controller.value * pi * 2));
    _controller
      ..forward()
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: CircleFlowDelegate(rad),
      children: widget.children,
    );
  }
}

class CircleFlowDelegate extends FlowDelegate {
  final double rad;
  CircleFlowDelegate(this.rad);

  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    var count = context.childCount;
    double perRad = 2 * pi / count;

    for (int i = 0; i < count; i++) {
      double halfWidth = context.getChildSize(i)!.width / 2;
      double halfHeight = context.getChildSize(i)!.height / 2;

      double offsetX = (radius - halfWidth) * sin(perRad * i - rad) + radius;
      double offsetY = (radius - halfHeight) * cos(perRad * i - rad) + radius;
      context.paintChild(i, transform: Matrix4.translationValues(offsetX - halfWidth, offsetY - halfHeight, 0.0));
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return true;
  }
}
