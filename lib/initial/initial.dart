import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Initial extends StatefulWidget {
  const Initial({Key? key}) : super(key: key);

  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pow Pow Steps'),
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
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                  ),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  ElevatedButton(
                    child: const Text('Home'),
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                  )
                ]),
          ),
        ));
  }
}
