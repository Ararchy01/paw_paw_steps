import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/Dog.dart';
import '../update_dog_page/update_dog_page.dart';
import 'walk_button.dart';
import 'walk_history.dart';

class DogListItem extends StatelessWidget {
  final Dog dog;
  final DocumentReference<Dog> dogReference;
  final String userId;

  DogListItem(this.dog, this.dogReference, this.userId);

  Widget get image {
    return SizedBox(
      width: 100,
      height: 100,
      child: CircleAvatar(backgroundImage: NetworkImage(dog.imageUrl)),
    );
  }

  Widget get name {
    return Text(
      dog.name,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          WalkButton(dog: dog, dogReference: dogReference, userId: userId),
        ],
      ),
    );
  }

  Widget edit(BuildContext context) {
    if (userId != dog.ownerId) {
      return SizedBox();
    }
    return TextButton(
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const CircleBorder(),
            builder: (context) => UpdateDogPage(dog: dog)),
        child: const Text(
          'Edit',
          style: TextStyle(color: Colors.blueAccent),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              image,
              Flexible(child: details),
              Flexible(child: edit(context))
            ]),
            Flexible(child: WalkHistory(dog: dog))
          ]),
        ),
      ),
    );
  }
}
