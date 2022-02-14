import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/home.dart';

void main() async {
  print('1');
  WidgetsFlutterBinding.ensureInitialized();
  print('2');
  await Firebase.initializeApp();
  print('3');
  runApp(const Main());
  print('4');
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

