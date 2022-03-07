import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/add_dog/add_dog.dart';
import 'package:walking_doggy/domain/Dog.dart';
import 'package:walking_doggy/domain/User.dart';
import 'package:walking_doggy/login/login.dart';

import 'home_stream_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _upload() async {
    print('1');
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    File? file = File(pickerFile!.path); //TODO

    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref().putFile(file);
      print(storage.ref());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userState = Provider.of<UserState>(context);
    return ChangeNotifierProvider<HomeStreamModel>(
      create: (_) => HomeStreamModel()..fetchDogs(),
      child: Scaffold(
          appBar: AppBar(
            title: const Icon(Icons.pets),
          ),
          body: Center(
            child: Consumer<HomeStreamModel>(builder: (context, model, child) {
              final List<Dog>? dogs = model.dogs;
              if (dogs == null) {
                return const CircularProgressIndicator();
              }
              return GridView.count(
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: dogs
                      .map((dog) => Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  'https://rosevalleywhiteshepherds.net/wp-content/uploads/2020/09/Bolt-Grand-Prairie-1024x1024.jpg',
                                ),
                              ),
                              Text(dog.name,
                                  style: TextStyle(color: Colors.blueAccent)),
                              //Text(dog.walkers.join('\n')),
                              ElevatedButton(
                                  onPressed: _upload,
                                  child: Icon(Icons.upload_file_outlined))
                            ],
                          ))
                      .toList());
            }),
          ),
          //TODO
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.logout), label: 'Logout'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.app_registration), label: 'Register')
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDog(),
                          fullscreenDialog: true));
                },
                tooltip: 'Add Dog',
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Login(),
                          fullscreenDialog: true));
                },
                tooltip: 'SignIn',
                child: const Icon(Icons.login),
              ),
            ],
          )),
    );
  }
}

class _SingleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}

class _MultipleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2);
  }
}
