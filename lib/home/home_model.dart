import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/domain/Dog.dart';

class HomeModel extends ChangeNotifier {
  List<Dog>? dogs;

  void fetchDogs(List<String> dogsIds) async {
    await FirebaseFirestore.instance
        .collection('dogs')
        .where('uid', whereIn: dogsIds)
        .snapshots()
        .listen((snapshot) =>
            snapshot.docs.map((document) => Dog(document['name'], '')));
  }
}
