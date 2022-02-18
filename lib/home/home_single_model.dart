import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:walking_doggy/domain/Dog.dart';

class HomeSingleModel extends ChangeNotifier {
  final _dogCollection = FirebaseFirestore.instance.collection('dogs');
  List<Dog>? dogs;

  void fetchDogs() async {
    final QuerySnapshot snapshot = await _dogCollection.get();
    final List<Dog> dogs = snapshot.docs.map((DocumentSnapshot document) {
      final Map<String, dynamic> data =
          document.data()! as Map<String, dynamic>;
      final String name = data['name'];
      final List<dynamic> walkers = data['walkers'];
      return Dog(name, walkers,'');
    }).toList();

    this.dogs = dogs;
    notifyListeners();
  }
}
