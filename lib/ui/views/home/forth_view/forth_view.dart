import 'package:flutter/material.dart';
import 'dart:math';

class ForthScreen extends StatefulWidget {
  const ForthScreen({Key? key}) : super(key: key);

  @override
  _ForthScreenState createState() => _ForthScreenState();
}

class _ForthScreenState extends State<ForthScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      color: Colors.grey.withAlpha(66),
      alignment: Alignment.center,
      child: CircleFlow(),
    );
  }
}

class FlowDemo extends StatelessWidget {
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
    print(e);
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
    print("父容器尺寸:${context.size}");
    print("孩子个数:${context.childCount}");
    for (int i = 0; i < context.childCount; i++) {
      print("第$i个孩子尺寸:${context.getChildSize(i)}");
    }

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

class CircleFlow extends StatelessWidget {
  final sides = [50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0];
  final colors = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.yellow,
    Colors.blue
  ];
  final double rad = 0.0;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: CircleFlowDelegate(rad),
      children: sides.map((e) => _buildItem(e)).toList(),
    );
  }

  Widget _buildItem(double e) {
    print(e);
    return Container(
      alignment: Alignment.center,
      width: e,
      height: e,
      color: colors[sides.indexOf(e)],
      child: Text('$e'),
    );
  }
}

// https://www.imooc.com/article/302253
class CircleFlowDelegate extends FlowDelegate {
  final double rad;
  CircleFlowDelegate(this.rad);

  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    print(radius);
    var count = context.childCount;
    var perRad = 2 * pi / count;

    var size = context.size;

    for (int i = 0; i < count; i++) {
      print(i);
      var cSizeX = context.getChildSize(i)!.width / 2;
      var cSizeY = context.getChildSize(i)!.height / 2;
      var offsetX = (radius - cSizeX) * cos(i * perRad + rad) + radius;
      var offsetY = (radius - cSizeY) * sin(i * perRad + rad) + radius;
      context.paintChild(i, transform: Matrix4.translationValues(offsetX - cSizeX, offsetY - cSizeY, 0.0));
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
