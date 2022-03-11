import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/domain/Dog.dart';

class HomeModel extends ChangeNotifier {
  List<Dog>? dogs;

  void fetchDogs(List<String> dogsIds) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('dogs')
        .where('uid', whereIn: dogsIds)
        .get();
    this.dogs = snapshot.docs.map((document) {
      final data = document.data() as Map<String, dynamic>;
      return Dog(data['name'], '');
    }).toList();
    notifyListeners();
  }
}
