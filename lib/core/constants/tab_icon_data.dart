import 'package:flutter/material.dart';

class TabIconData {
  TabIconData(
      {this.imagePath = '',
      this.index = 0,
      this.selectedImagePath = '',
      this.isSelected = false,
      this.animationController});

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/images/dengta.png',
      selectedImagePath: 'assets/images/dengta_s.png',
      index: 0,
      isSelected: true,
      // animationController: animationController,
    ),
    TabIconData(
      imagePath: 'assets/images/tianwenwangyuanjing.png',
      selectedImagePath: 'assets/images/tianwenwangyuanjing_s.png',
      index: 1,
      isSelected: false,
      // animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/images/yu.png',
      selectedImagePath: 'assets/images/yu_s.png',
      index: 2,
      isSelected: false,
      // animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/images/penjing.png',
      selectedImagePath: 'assets/images/penjing_s.png',
      index: 3,
      isSelected: false,
      // animationController: null,
    ),
  ];
}
