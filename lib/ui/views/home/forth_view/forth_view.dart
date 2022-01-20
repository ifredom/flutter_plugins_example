import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'burst_flow_animation.dart';
import 'circle_flow.dart';
import 'circle_flow_animation.dart';
import 'sample_flow.dart';

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
    return GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
        children: <Widget>[
          Container(
            width: 300,
            height: 300,
            color: Colors.grey.withAlpha(66),
            alignment: Alignment.center,
            child: SampleFlowDemo(),
          ),
          Container(
            width: 300,
            height: 300,
            color: Colors.grey.withAlpha(66),
            alignment: Alignment.center,
            child: CircleStaticDemo(),
          ),
          Container(
            width: 300,
            height: 300,
            color: Colors.grey.withAlpha(66),
            alignment: Alignment.center,
            child: CircleDemo(),
          ),
          Container(
            width: 300,
            height: 300,
            color: Colors.grey.withAlpha(66),
            alignment: Alignment.center,
            child: BurstFlowDemo(),
          )
        ]);
  }
}

// https://www.imooc.com/article/302253

class CircleStaticDemo extends StatelessWidget {
  CircleStaticDemo({Key? key}) : super(key: key);

  final sides = [90.0, 80.0, 70.0, 60.0, 50.0, 40.0, 60.0, 50.0, 40.0, 60.0, 50.0, 40.0];

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

  @override
  Widget build(BuildContext context) {
    return CircleFlow(
      children: sides.mapIndexed((index, element) => _buildItem(index, element)).toList(),
    );
  }

  Widget _buildItem(int index, double element) {
    return Container(
      alignment: Alignment.center,
      width: element,
      height: element,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[index],
      ),
      child: Text('$element'),
    );
  }
}

class CircleDemo extends StatelessWidget {
  CircleDemo({Key? key}) : super(key: key);

  final sides = [60.0, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0];

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

  @override
  Widget build(BuildContext context) {
    return CircleFlowAnimation(
      children: sides.mapIndexed((index, element) => _buildItem(index, element)).toList(),
    );
  }

  Widget _buildItem(int index, double element) {
    return Container(
      alignment: Alignment.center,
      width: element,
      height: element,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[index],
      ),
      child: Text('$element'),
    );
  }
}

class BurstFlowDemo extends StatelessWidget {
  BurstFlowDemo({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return BurstFlowFlowAnimation(
      menu: const CircleAvatar(
        radius: 40,
        child: Text('tap'),
      ),
      children: sides.mapIndexed((index, element) => _buildItem(index, element)).toList(),
    );
  }

  Widget _buildItem(int index, double element) {
    return Container(
      alignment: Alignment.center,
      width: element,
      height: element,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[index],
      ),
      child: Text('$element'),
    );
  }
}
