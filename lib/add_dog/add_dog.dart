import 'package:flutter/material.dart';
import 'package:walking_doggy/add_dog/add_dog_model.dart';
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
          ElevatedButton(
            onPressed: () {
              final Dog _newDog = AddDogModel.addNewDog(
                  _nameController.text, [_walkerController.text]);
              Navigator.pop(context, _newDog);
            },
            child: const Text('Add Dog'),
          )
        ],
      ),
    );
  }
}
