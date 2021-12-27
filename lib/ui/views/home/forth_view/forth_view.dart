import 'package:flutter/material.dart';
import 'package:pluginexample/core/constants/app_theme.dart';

class ForthScreen extends StatefulWidget {
  @override
  _ForthScreenState createState() => _ForthScreenState();
}

class _ForthScreenState extends State<ForthScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            color: const Color.fromRGBO(124, 124, 124, 0.8),
            child: const Center(
              child: Text("Me"),
            ),
          )),
    );
  }
}
