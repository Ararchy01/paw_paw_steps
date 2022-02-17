import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/domain/Dog.dart';

class AddDog extends StatelessWidget {
  const AddDog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _walkerController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.pets),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'name',
            ),
            controller: _nameController,
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'walker',
            ),
            controller: _walkerController,
          ),
          IconButton(
              onPressed: () {
                final Dog _newDog =
                    Dog(_nameController.text, [_walkerController.text]);
                FirebaseFirestore.instance
                    .collection('dogs')
                    .add({'name': _newDog.name, 'walkers': _newDog.walkers})
                    .then((value) => print(value))
                    .catchError((error) => print(error));
                Navigator.pop(context, _newDog);
              },
              icon: const Icon(Icons.pets))
        ],
      ),
    );
  }
}
