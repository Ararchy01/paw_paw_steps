import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/add_dog/add_dog.dart';
import 'package:walking_doggy/app_frame/app_frame_after_login.dart';

import 'domain/User.dart';
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
            '/add_dog': (context) => const AddDog(),
            '/after_login': (context) => const AppFrameAfterLogin()
          }),
    );
  }
}
