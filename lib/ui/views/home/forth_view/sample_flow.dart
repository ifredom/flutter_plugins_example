import 'package:flutter/material.dart';

class SampleFlowDemo extends StatelessWidget {
  final sides = [60.0, 50.0, 40.0, 30.0];
  final colors = [Colors.red, Colors.yellow, Colors.blue, Colors.green];

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowDemoDelegate(),
      children: sides.map((e) => _buildItem(e)).toList(),
    );
  }

  Widget _buildItem(double e) {
    return Container(
      alignment: Alignment.center,
      width: e,
      height: e,
      color: colors[sides.indexOf(e)],
      child: Text('$e'),
    );
  }
}

class FlowDemoDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    var size = context.size;

    for (int i = 0; i < context.childCount; i++) {
      var tr = context.getChildSize(i);
      if (i == 1) {
        context.paintChild(i, transform: Matrix4.translationValues(size.width - tr!.width, 0, 0.0));
      } else if (i == 2) {
        context.paintChild(i,
            transform: Matrix4.translationValues(size.width - tr!.width, size.height - tr.height, 0.0));
      } else if (i == 3) {
        context.paintChild(i, transform: Matrix4.translationValues(0, size.height - tr!.height, 0.0));
      } else {
        context.paintChild(i);
      }
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
