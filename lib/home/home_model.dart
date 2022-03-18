import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walking_doggy/domain/Dog.dart';

import '../domain/Walk.dart';

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
          return Dog(data['uid'], data['name'], data['imageURL'],
              (data['walks'] as List<dynamic>).cast<String>());
        }).toList();
      });
      dogs!.forEach((dog) async {
        await _walkCollection
            .where('dogId', isEqualTo: dog.uid)
            .orderBy('endAt')
            .limit(10)
            .get()
            .then((snapshot) => snapshot.docs.forEach((doc) {
                  dog.addRecentWalk(Walk(doc['uid'], doc['dogId'],
                      doc['userId'], doc['startAt'], doc['endAt']));
                }));
      });
    }
    notifyListeners();
  }

  void walkDog(String dogId, String userId) async {
    final _walkDoc = await _walkCollection.doc();
    _walkDoc.set({
      'uid': _walkDoc.id,
      'dogId': dogId,
      'userId': userId,
      'startAt': DateTime.now(),
      'endAt': null
    });
    await _dogCollection.doc(dogId).update({
      'walks': FieldValue.arrayUnion([_walkDoc.id]),
      'walkingId': _walkDoc.id
    });
    notifyListeners();
  }

  void endWalk(String dogId) async {
    await _dogCollection.doc(dogId).get().then((DocumentSnapshot snapshot) {
      _walkCollection.doc(snapshot['walkingId']).update({'endAt': DateTime.now()});
    });
    await _dogCollection.doc(dogId).update({'walkingId': ''});
  }
}
