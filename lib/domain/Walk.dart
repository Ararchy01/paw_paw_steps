import 'package:cloud_firestore/cloud_firestore.dart';

class Walk {
  final String uid;
  final String dogId;
  final String userId;
  final DateTime startAt;
  final DateTime endAt;

  Walk(
      {required this.uid,
      required this.dogId,
      required this.userId,
      required this.startAt,
      required this.endAt});

  Walk.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            dogId: json['dogId']! as String,
            userId: json['userId']! as String,
            startAt: (json['startAt'] as Timestamp).toDate(),
            endAt: (json['endAt']! as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'dogId': dogId,
      'userId': userId,
      'startAt': startAt,
      'endAt': endAt
    };
  }
}
