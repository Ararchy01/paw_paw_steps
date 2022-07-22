import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_dog_page/add_dog_page.dart';
import 'app_frame/app_frame_after_login.dart';
import 'domain/User.dart';
import 'initial_page/initial_page.dart';
import 'login_page/login_page.dart';
import 'login_check/login_check.dart';
import 'register_page/register_page.dart';

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
          title: 'Paw Paw Steps',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
          ),
          initialRoute: '/login_check',
          routes: {
            '/login_check': (context) => const LoginCheck(),
            '/initial_page': (context) => const InitialPage(),
            '/register_page': (context) => const RegisterPage(),
            '/login_page': (context) => const LoginPage(),
            '/add_dog_page': (context) => const AddDogPage(),
            '/after_login': (context) => const AppFrameAfterLogin()
          }),
    );
  }
}
