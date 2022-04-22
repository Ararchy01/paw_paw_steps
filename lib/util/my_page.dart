import 'package:flutter/material.dart';

abstract class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  BottomNavigationBarItem bottomNavigationBarItem();

  @override
  State<StatefulWidget> createState();
}
