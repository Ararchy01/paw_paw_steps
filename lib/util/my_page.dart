import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/domain/User.dart';

abstract class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  BottomNavigationBarItem bottomNavigationBarItem();
  @override
  State<StatefulWidget> createState();
}
