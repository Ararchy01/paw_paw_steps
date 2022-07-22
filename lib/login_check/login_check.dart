import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/User.dart';
import '../util/firestore_util.dart';

class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  void checkUser() async {
    final currentUser = await FirebaseAuth.instance.currentUser;
    final userState = Provider.of<UserState>(context, listen: false);
    if (currentUser == null) {
      Navigator.pushReplacementNamed(context, "/initial_page");
    } else {
      final _user = await FirestoreUtil.USER_REF.doc(currentUser.uid).get();
      if (_user.exists) {
        userState.setUser(_user.data()!);
        Navigator.pushReplacementNamed(context, "/after_login");
      } else {
        Navigator.pushReplacementNamed(context, "/initial_page");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
