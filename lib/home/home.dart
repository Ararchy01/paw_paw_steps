import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/add_dog/add_dog.dart';
import 'package:walking_doggy/domain/Dog.dart';

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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                crossAxisSpacing: 20,
                mainAxisSpacing: 250,
                scrollDirection: Axis.vertical,
                children: dogs
                    .map((dog) => Column(
                          children: [
                            Image.network(
                                'https://rosevalleywhiteshepherds.net/wp-content/uploads/2020/09/Bolt-Grand-Prairie-1024x1024.jpg',
                            height: 50),
                            Text(dog.name,
                                style: TextStyle(color: Colors.blueAccent)),
                            Text(dog.walkers.join('\n')),
                            FloatingActionButton(
                                onPressed: _upload,
                                child: Icon(Icons.upload_file_outlined))
                          ],
                        ))
                    .toList());
          }),
        ),
        floatingActionButton: FloatingActionButton(
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
      ),
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
