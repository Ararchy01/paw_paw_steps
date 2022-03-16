import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/add_dog/add_dog.dart';
import 'package:walking_doggy/domain/Dog.dart';
import 'package:walking_doggy/domain/User.dart';
import 'package:walking_doggy/home/home_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _upload() async {
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
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()..fetchDogs(_userState.getUser().uid),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Icon(Icons.pets),
              Text('Pow Pow Steps'),
              Icon(Icons.pets),
            ],
          ),
        ),
        body: Center(
          child: Consumer<HomeModel>(builder: (context, model, child) {
            final List<Dog>? dogs = model.dogs;
            if (dogs == null) {
              return const CircularProgressIndicator();
            }
            if (dogs.length == 1) {
              return _SingleView(dogs.first, model);
            } else {
              return _MultipleView(dogs, model);
            }
          }),
        ),
        floatingActionButton:
            Consumer<HomeModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDog(),
                    fullscreenDialog: true),
              );
              if (added != null && added) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Added a dog!'),
                ));
              }
              model.fetchDogs(_userState.getUser().uid);
            },
            child: const Icon(Icons.add),
          );
        }),
        //TODO
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
            BottomNavigationBarItem(
                icon: Icon(Icons.app_registration), label: 'Register')
          ],
        ),
      ),
    );
  }
}

class _SingleView extends StatelessWidget {
  final Dog dog;
  final HomeModel model;

  const _SingleView(this.dog, this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dog.name,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          Expanded(child: Image.network(dog.imageUrl), flex: 0),
          ElevatedButton(
            onPressed: () async => dog.walkId.isEmpty
                ? model.walkDog(dog.uid)
                : model.endWalk(dog.uid),
            child: Text(dog.walkId.isEmpty ? 'Start Walk!' : 'End Walk'),
            style: ElevatedButton.styleFrom(
                primary: dog.walkId.isEmpty ? Colors.yellow : Colors.redAccent),
          )
        ],
      ),
    );
  }
}

class _MultipleView extends StatelessWidget {
  final List<Dog> dogs;
  final HomeModel model;

  const _MultipleView(this.dogs, this.model);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        children: dogs
            .map((dog) => Column(
                  children: [
                    Expanded(
                      child: Image.network(dog.imageUrl),
                    ),
                    Text(dog.name,
                        style: const TextStyle(color: Colors.blueAccent)),
                    ElevatedButton(
                      onPressed: () async => dog.walkId.isEmpty
                          ? model.walkDog(dog.uid)
                          : model.endWalk(dog.uid),
                      child:
                          Text(dog.walkId.isEmpty ? 'Start Walk!' : 'End Walk'),
                      style: ElevatedButton.styleFrom(
                          primary: dog.walkId.isEmpty
                              ? Colors.yellow
                              : Colors.redAccent),
                    )
                  ],
                ))
            .toList());
  }
}
