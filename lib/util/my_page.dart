import 'package:flutter/material.dart';

abstract class MyPage extends Widget{
  const MyPage({Key? key}) : super(key: key);

  AppBar appBar();
  BottomNavigationBarItem bottomNavigationBarItem();
}