import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/domain/Dog.dart';

class HomeModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _dogsStream =
      FirebaseFirestore.instance.collection('dogs').snapshots();

  List<Dog>? dogs;

  void fetchDogs() {
    _dogsStream.listen((QuerySnapshot snapshot) {
      final List<Dog> dogs = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String name = data['name'];
        final List<dynamic> walkers = data['walkers'];
        return Dog(name, walkers);
      }).toList();
      this.dogs = dogs;
      notifyListeners();
    });
  }
}
