import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/home/home.dart';
import 'package:walking_doggy/login/login.dart';
import 'package:walking_doggy/register/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/register',
    routes: {
      '/register' : (context) => const Register(),
      '/login': (context) => const Login(),
      '/home' : (context) => const Home(),
    }
  ));
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walking Doggy',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const Home(),
    );
  }
}

