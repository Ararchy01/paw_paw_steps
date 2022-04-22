import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/User.dart' as user_domain;
import '../util/firestore_util.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _userRef = FirestoreUtil.USER_REF;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user_domain.UserState _userState =
        Provider.of<user_domain.UserState>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                    controller: _emailController,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Empty input';
                      }
                      if (!EmailValidator.validate(text)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    )),
                TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Empty input';
                      }
                      if (text.length < 6) {
                        return 'Password too short';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    )),
                ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    if (_formKey.currentState == null) {
                      // TODO
                      print('Formkey currentState is null');
                    } else if (!_formKey.currentState!.validate()) {
                      // TODO
                      print(_formKey.currentState);
                    } else {
                      try {
                        final userCredential =
                            await _auth.signInWithEmailAndPassword(
                                email: _emailController.value.text,
                                password: _passwordController.value.text);
                        final user = userCredential.user;

                        if (user != null) {
                          final _user = await _userRef.doc(user.uid).get();
                          _userState.setUser(_user.data()!);
                          Navigator.pushNamed(context, '/after_login');
                        }
                      } on FirebaseAuthException catch (e) {
                        // TODO
                        print(e);
                      }
                    }
                  },
                ),
                TextButton(
                    child: const Text('First time? Register',
                        style: TextStyle(color: Colors.blueAccent)),
                    onPressed: () => Navigator.pushNamed(context, '/register'))
              ],
            ),
          ),
        ));
  }
}
