import 'dart:math';

import 'package:flutter/material.dart';

class BurstFlowFlowAnimation extends StatefulWidget {
  final List<Widget> children;
  final Widget menu;
  const BurstFlowFlowAnimation({Key? key, required this.children, required this.menu}) : super(key: key);

  @override
  State<BurstFlowFlowAnimation> createState() => _BurstFlowFlowAnimationState();
}

class _BurstFlowFlowAnimationState extends State<BurstFlowFlowAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double _rad = 0.0;

  bool _closed = true;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() => setState(() => _rad = (_closed ? (_controller.value) : 1 - _controller.value)))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _closed = !_closed;
        }
      });

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
      delegate: CircleFlowDelegate(_rad),
      children: [
        ...widget.children,
        InkWell(
          onTap: () {
            _controller.reset();
            _controller.forward();
          },
          child: widget.menu,
        )
      ],
    );
  }
}

class CircleFlowDelegate extends FlowDelegate {
  final double rad;
  CircleFlowDelegate(this.rad);

  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    var count = context.childCount - 1;
    var perRad = 2 * pi / count;
    for (int i = 0; i < count; i++) {
      var cSizeX = context.getChildSize(i)!.width / 2;
      var cSizeY = context.getChildSize(i)!.height / 2;
      var offsetX = rad * (radius - cSizeX) * cos(i * perRad) + radius;
      var offsetY = rad * (radius - cSizeY) * sin(i * perRad) + radius;
      context.paintChild(i, transform: Matrix4.translationValues(offsetX - cSizeX, offsetY - cSizeY, 0.0));
    }
    context.paintChild(context.childCount - 1,
        transform: Matrix4.translationValues(radius - context.getChildSize(context.childCount - 1)!.width / 2,
            radius - context.getChildSize(context.childCount - 1)!.height / 2, 0.0));
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return true;
  }
}
