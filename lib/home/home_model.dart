import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/domain/Dog.dart';

class HomeModel extends ChangeNotifier {
  final _userCollection = FirebaseFirestore.instance.collection('users');
  final _dogCollection = FirebaseFirestore.instance.collection('dogs');
  final _walkCollection = FirebaseFirestore.instance.collection('walks');
  List<Dog>? dogs = [];

  void fetchDogs(String userId) async {
    List<String> dogsIds = [];
    await _userCollection.doc(userId).get().then(
        (value) => dogsIds = (value['dogs'] as List<dynamic>).cast<String>());
    if (dogsIds.isNotEmpty) {
      await _dogCollection
          .where('uid', whereIn: dogsIds)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        this.dogs = snapshot.docs.map((DocumentSnapshot document) {
          final data = document.data() as Map<String, dynamic>;
          return Dog(document['uid'], data['name'], data['imageURL'],
              document['walkId']);
        }).toList();
      });
    }
    notifyListeners();
  }

  void walkDog(String dogId) async {
    final _walkDoc = await _walkCollection.doc();
    _walkDoc.set({'dogId': dogId, 'startAt': DateTime.now(), 'endAt': null});
    await _dogCollection.doc(dogId).update({'walkId': _walkDoc.id});
    notifyListeners();
  }

  void endWalk(String dogId) async {
    await _dogCollection.doc(dogId).get().then((DocumentSnapshot snapshot) {
      _walkCollection.doc(snapshot['walkId']).update({'endAt': DateTime.now()});
    });
    await _dogCollection.doc(dogId).update({'walkId': ''});
  }
}
