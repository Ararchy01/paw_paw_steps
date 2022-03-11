import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/domain/User.dart' as user_domain;
import 'package:walking_doggy/parts/padding_text_field.dart';
import 'package:walking_doggy/register/register_model.dart';

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
    return ChangeNotifierProvider(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Consumer<RegisterModel>(builder: (context, model, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaddingTextField(
                  hint: 'Name', onChanged: (value) => model.setName(value)),
              PaddingTextField(
                  hint: 'Email', onChanged: (value) => model.setEmail(value)),
              PaddingTextField(
                  hint: 'Password',
                  onChanged: (value) => model.setPassword(value),
                  obscureText: true),
              PaddingTextField(
                  hint: 'Confirm Password',
                  onChanged: (value) => model.setConfirmPassword(value),
                  obscureText: true),
              ElevatedButton(
                child: const Text('Register'),
                onPressed: () async {
                  model.startLoading();
                  try {
                    await model.register();
                    _userState.setUser(user_domain.User(
                        model.uid!, model.name!, model.email!, []));
                    Navigator.pushNamed(context, '/home');
                  } on FirebaseAuthException catch (e) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } finally {
                    model.endLoading();
                  }
                },
              ),
              TextButton(
                  child: const Text('Already user? Login',
                      style: TextStyle(color: Colors.blueAccent)),
                  onPressed: () => Navigator.pushNamed(context, '/login'))
            ],
          );
        }),
      ),
    );
  }
}
