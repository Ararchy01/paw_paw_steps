import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/domain/User.dart' as user_domain;
import 'package:walking_doggy/login/login_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user_domain.UserState _userState =
        Provider.of<user_domain.UserState>(context);
    return ChangeNotifierProvider(
      create: (_) => LoginModel(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Consumer<LoginModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                        onChanged: (value) => model.setEmail(value),
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
                        onChanged: (value) => model.setPassword(value),
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
                          model.startLoading();
                          try {
                            await model.login();
                            _userState.setUser(user_domain.User(model.uid!,
                                model.name!, model.email!, model.dogs!));
                            Navigator.pushNamed(context, '/home');
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
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'))
                  ],
                ),
              ),
            );
          })),
    );
  }
}
