import 'package:cloud_firestore/cloud_firestore.dart';

import 'Walk.dart';

class Dog {
  final String uid;
  final String name;
  final String imageUrl;
  final String walkingId;
  final List<String> walkersIds;
  final List<DocumentReference<Walk>> walks;

  Dog(
      {required this.uid,
      required this.name,
      required this.imageUrl,
      required this.walkingId,
      required this.walkersIds,
      required this.walks});

  Dog.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            name: json['name']! as String,
            imageUrl: json['imageUrl']! as String,
            walkingId: json['walkingId']! as String,
            walkersIds: (json['walkersIds']! as List).cast<String>(),
            walks: (json['walks']! as List).cast<DocumentReference<Walk>>());

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'walkingId': walkingId,
      'walkersIds': walkersIds,
      'walks': walks
    };
  }
}
