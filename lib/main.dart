import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/User.dart';
import 'home/home.dart';
import 'initial/initial.dart';
import 'login/login.dart';
import 'register/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserState(),
      child: MaterialApp(
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
          }),
    );
  }
}
