import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/User.dart' as user_domain;
import '../util/firestore_util.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  final _userRef = FirestoreUtil.USER_REF;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user_domain.UserState _userState =
        Provider.of<user_domain.UserState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () async {
                try {
                  // TODO Validation
                  final name = _nameController.value.text;
                  final email = _emailController.value.text;
                  final password = _passwordController.value.text;
                  final confirmPassword = _confirmPasswordController.value.text;
                  final userCredential =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                  final user = userCredential.user;

                  if (user != null) {
                    final _user = user_domain.User(
                        uid: user.uid,
                        name: name,
                        email: email,
                        imageUrl: '',
                        dogs: []);
                    await _userRef.doc(user.uid).set(_user);
                    _userState.setUser(_user);
                    Navigator.pushNamed(context, '/after_login');
                  }
                } on FirebaseAuthException catch (e) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
            TextButton(
                child: const Text('Already user? Login',
                    style: TextStyle(color: Colors.blueAccent)),
                onPressed: () => Navigator.pushNamed(context, '/login'))
          ],
        ),
      ),
    );
  }
}
