import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Register'),
            //ステップ２
            onPressed: () async {
              try {
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                  Navigator.pushNamed(context, '/home');
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  print('Email is already used');
                } else if (e.code == 'invalid-email') {
                  print('Invalid email format');
                } else if (e.code == 'weak-password') {
                  print('Invalid password format');
                } else if (e.code == 'operation-not-allowed') {
                  print('Operation not allowed');
                }
              }
            },
          )
        ],
      ),
    );
  }
}