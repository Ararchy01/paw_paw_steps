import 'package:flutter/material.dart';

import '../dogs_page/dogs_page.dart';
import '../share_walk_page/share_walk_page.dart';
import '../user_page/user_page.dart';
import '../util/my_page.dart';

class AppFrameAfterLogin extends StatefulWidget {
  const AppFrameAfterLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppFrameAfterLoginState();
}

class _AppFrameAfterLoginState extends State<AppFrameAfterLogin> {
  final _dogsPage = const DogsPage();
  final _sharePage = const ShareWalkPage();
  final _userPage = const UserPage();
  final List<MyPage> _bodyOptions = [];

  @override
  void initState() {
    super.initState();
    _bodyOptions.addAll([_dogsPage, _sharePage, _userPage]);
  }

  int _selected = 0;

  void _onItemTapped(int index) => setState(() => _selected = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _bodyOptions.elementAt(_selected),
        bottomNavigationBar: BottomNavigationBar(
          items: _bodyOptions
              .map((page) => page.bottomNavigationBarItem())
              .toList(),
          currentIndex: _selected,
          selectedItemColor: Colors.amberAccent,
          onTap: _onItemTapped,
        ));
  }
}
