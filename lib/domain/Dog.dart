import 'Walk.dart';

class Dog {
  final String uid;
  final String name;
  final String imageUrl;
  final List<String> walks;
  final String walkingId;
  List<Walk> recentWalks = [];

  Dog(this.uid, this.name, this.imageUrl, this.walks, this.walkingId);

  void addRecentWalk(Walk walk) {
    recentWalks.add(walk);
  }
}
