import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pow Pow Steps'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: IntrinsicWidth(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pow Pow Steps',
                    style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.w900,
                        fontSize: 40),
                  ),
                  ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () => Navigator.pushNamed(context, '/register_page'),
                  ),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () => Navigator.pushNamed(context, '/login_page'),
                  ),
                ]),
          ),
        ));
  }
}
