class Dog {
  final String uid;
  final String name;
  final String imageUrl;
  final String walkingId;
  final List<String> walkersIds;
  final String ownerId;

  Dog(
      {required this.uid,
      required this.name,
      required this.imageUrl,
      required this.walkingId,
      required this.walkersIds,
      required this.ownerId});

  Dog.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            name: json['name']! as String,
            imageUrl: json['imageUrl']! as String,
            walkingId: json['walkingId']! as String,
            walkersIds: (json['walkersIds']! as List).cast<String>(),
            ownerId: json['ownerId'] as String);

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'walkingId': walkingId,
      'walkersIds': walkersIds,
      'ownerId': ownerId
    };
  }
}
