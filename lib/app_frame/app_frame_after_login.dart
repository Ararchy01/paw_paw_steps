import 'package:flutter/material.dart';
import 'package:walking_doggy/dogs_page/dogs_page.dart';
import 'package:walking_doggy/friends_page/friends_page.dart';
import 'package:walking_doggy/user_page/user_page.dart';

class AppFrameAfterLogin extends StatefulWidget {
  const AppFrameAfterLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppFrameAfterLoginState();
}

class _AppFrameAfterLoginState extends State<AppFrameAfterLogin> {
  Widget get appTitle {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.pets),
        Text('Pow Pow Steps'),
        Icon(Icons.pets),
      ],
    );
  }

  int _selected = 0;
  static const List<Widget> _bodyOptions = <Widget>[
    DogsPage(),
    FriendsPage(),
    UserPage()
  ];

  void _onItemTapped(int index) => setState(() => _selected = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: appTitle,
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: _bodyOptions.elementAt(_selected),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Dogs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.verified_user),
              label: 'User',
            ),
          ],
          currentIndex: _selected,
          selectedItemColor: Colors.amberAccent,
          onTap: _onItemTapped,
        ));
  }
}
