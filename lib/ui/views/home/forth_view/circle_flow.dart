import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';

class CircleFlow extends StatefulWidget {
  final List<Widget> children;
  const CircleFlow({Key? key, required this.children}) : super(key: key);

  @override
  State<CircleFlow> createState() => _CircleFlowState();
}

class _CircleFlowState extends State<CircleFlow> {
  final sides = [50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0];

  final colors = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.blue
  ];

  final double rad = 0.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flow(
        delegate: CircleFlowDelegate(rad),
        children: widget.children,
      ),
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

      double offsetX = (radius - halfWidth) * sin(perRad * i) + radius;
      double offsetY = (radius - halfHeight) * cos(perRad * i) + radius;
      context.paintChild(i, transform: Matrix4.translationValues(offsetX - halfWidth, offsetY - halfHeight, 0.0));
    }
  }

  // @override
  // Size getSize(BoxConstraints constraints) {
  //   // 指定Flow的大小，简单起见我们让宽度竟可能大，但高度指定为200，
  //   // 实际开发中我们需要根据子元素所占用的具体宽高来设置Flow大小
  //   return Size(double.infinity, 200.0);
  // }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return true;
  }
}
