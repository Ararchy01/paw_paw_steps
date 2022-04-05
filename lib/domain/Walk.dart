import 'package:cloud_firestore/cloud_firestore.dart';

class Walk {
  final String uid;
  final String dogId;
  final List<String> walkersIds;
  final DateTime startAt;
  final DateTime endAt;

  Walk(
      {required this.uid,
      required this.dogId,
      required this.walkersIds,
      required this.startAt,
      required this.endAt});

  Walk.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            dogId: json['dogId']! as String,
            walkersIds: (json['walkersIds']! as List<dynamic>).cast<String>(),
            startAt: (json['startAt'] as Timestamp).toDate(),
            endAt: (json['endAt']! as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'dogId': dogId,
      'walkersIds': walkersIds,
      'startAt': startAt,
      'endAt': endAt
    };
  }
}
