import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/Dog.dart';
import '../domain/Walk.dart';

class FirestoreUtil {
  FirestoreUtil._() {
    throw UnsupportedError('This class is not supposed to be instantiated');
  }

  static final DOG_REF = FirebaseFirestore.instance
      .collection('dogs')
      .withConverter(
          fromFirestore: (snapshots, _) => Dog.fromJson(snapshots.data()!),
          toFirestore: (dog, _) => dog.toJson());

  static final WALK_REF = FirebaseFirestore.instance
      .collection('walks')
      .withConverter(
          fromFirestore: (snapshots, _) => Walk.fromJson(snapshots.data()!),
          toFirestore: (walk, _) => walk.toJson());
}
