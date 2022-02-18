import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walking_doggy/domain/Dog.dart';

class AddDogModel {
  static Dog addNewDog(String name, List<dynamic> walkers) {
    final Dog _newDog = Dog(name, walkers, 'a');
    FirebaseFirestore.instance
        .collection('dogs')
        .add({'name': _newDog.name, 'walkers': _newDog.walkers})
        .then((value) => print(value))
        .catchError((error) => print(error));
    return _newDog;
  }
}
