import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/domain/User.dart' as user_domain;
import 'package:walking_doggy/parts/padding_text_field.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  String name = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';

  @override
  Widget build(BuildContext context) {
    final user_domain.UserState _userState =
        Provider.of<user_domain.UserState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PaddingTextField(hint: 'Name', onChanged: (value) => name = value),
          PaddingTextField(hint: 'Email', onChanged: (value) => email = value),
          PaddingTextField(
              hint: 'Password',
              onChanged: (value) => password = value,
              obscureText: true),
          PaddingTextField(
              hint: 'Confirm Password',
              onChanged: (value) => passwordConfirm = value,
              obscureText: true),
          ElevatedButton(
            child: const Text('Register'),
            onPressed: () async {
              try {
                final _result = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                final user = _result.user;
                _userState.setUser(user_domain.User(user!.uid, name, []));
                Navigator.pushNamed(context, '/home');
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
          ),
          TextButton(
              child: const Text('Already user? Login',
                  style: TextStyle(color: Colors.blueAccent)),
              onPressed: () => Navigator.pushNamed(context, '/login'))
        ],
      ),
    );
  }
}
