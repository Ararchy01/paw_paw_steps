import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/home/home.dart';
import 'package:walking_doggy/login/login.dart';
import 'package:walking_doggy/register/register.dart';

import 'initial/initial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pow Pow Steps',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        initialRoute: '/initial',
        routes: {
          '/initial': (context) => const Initial(),
          '/register': (context) => const Register(),
          '/login': (context) => const Login(),
          '/home': (context) => const Home(),
        });
  }
}
