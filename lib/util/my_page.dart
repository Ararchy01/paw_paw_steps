import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/domain/User.dart';

abstract class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  AppBar appBar(BuildContext context);
  BottomNavigationBarItem bottomNavigationBarItem();
  @override
  State<StatefulWidget> createState();

  IconButton logoutButton(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Provider.of<UserState>(context, listen: false).signOut();
          Navigator.pushNamed(context, '/initial');
        },
    tooltip: 'Log Out',
    );
  }
}
