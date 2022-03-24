import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/add_dog/add_dog_model.dart';

import '../domain/User.dart';
import '../parts/padding_text_field.dart';

class AddDog extends StatefulWidget {
  const AddDog({Key? key}) : super(key: key);

  @override
  State<AddDog> createState() => _AddDogState();
}

class _AddDogState extends State<AddDog> {
  @override
  Widget build(BuildContext context) {
    final _userState = Provider.of<UserState>(context);
    return ChangeNotifierProvider(
      create: (_) => AddDogModel()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Dog'),
        ),
        body: Consumer<AddDogModel>(builder: (context, model, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 0,
                  child: model.imageFile != null
                      ? Image.file(model.imageFile!)
                      : model.noImageURL != null
                          ? Image.network(model.noImageURL!)
                          : CircularProgressIndicator()),
              ElevatedButton(
                  onPressed: () async => model.pickImage(),
                  child: Text('Image')),
              PaddingTextField(
                  hint: 'Name', onChanged: (value) => model.name = value),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () async {
                  model.startLoading();
                  try {
                    await model.addDog(_userState.getUser().uid);
                    Navigator.pushNamed(context, '/dogs_page');
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
            ],
          );
        }),
      ),
    );
  }
}
