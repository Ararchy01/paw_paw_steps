import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/home/home.dart';

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
      title: 'Walking Doggy',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const Home(),
    );
  }
}

