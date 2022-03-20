import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/Dog.dart';
import '../domain/User.dart';
import '../domain/Walk.dart';
import 'home_model.dart';

final dogRef = FirebaseFirestore.instance.collection('dogs').withConverter(
    fromFirestore: (snapshots, _) => Dog.fromJson(snapshots.data()!),
    toFirestore: (dog, _) => dog.toJson());

final walkRef = FirebaseFirestore.instance.collection('walks').withConverter(
    fromFirestore: (snapshots, _) => Walk.fromJson(snapshots.data()!),
    toFirestore: (walk, _) => walk.toJson());

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget get appTitle {
    return Row(
      children: const [
        Icon(Icons.pets),
        Text('Pow Pow Steps'),
        Icon(Icons.pets),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserState>(context).getUser();
    return Scaffold(
      appBar: AppBar(title: appTitle),
      body: StreamBuilder<QuerySnapshot<Dog>>(
        stream:
            dogRef.where('walkersIds', arrayContains: _user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData;
          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return _DogListItem(data.docs[index].data(),
                  data.docs[index].reference, _user.uid);
            },
          );
        },
      ),
    );
  }
}

class _SingleView extends StatelessWidget {
  final Dog dog;
  final HomeModel model;
  final String userId;

  const _SingleView(this.dog, this.model, this.userId);

  Widget get image {
    return SizedBox(
      width: 200,
      child: Image.network(dog.imageUrl),
    );
  }

  Widget get name {
    return Text(dog.name,
        style: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green));
  }

  //
  // Widget get startWalk {
  //   return ElevatedButton(
  //       onPressed: () async => model.walkDog(dog.uid, userId),
  //       child: const Text('Start Walk!'),
  //       style: ElevatedButton.styleFrom(primary: Colors.yellow));
  // }
  //
  // Widget get endWalk {
  //   return ElevatedButton(
  //       onPressed: () async => model.endWalk(dog.uid),
  //       child: const Text('End Walk'),
  //       style: ElevatedButton.styleFrom(primary: Colors.redAccent));
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image,
        name,
        // dog.walkingId.isEmpty ? startWalk : endWalk,
        Column(
          children: dog.recentWalks
              .map((walk) => Text(walk.endAt.toLocal().toString()))
              .toList(),
        )
      ],
    );
  }
}

class _DogListItem extends StatelessWidget {
  final Dog dog;
  final DocumentReference<Dog> dogReference;
  final String userId;

  const _DogListItem(this.dog, this.dogReference, this.userId);

  Widget get image {
    return SizedBox(
      width: 150,
      height: 150,
      child: Image.network(dog.imageUrl),
    );
  }

  Widget get name {
    return Text(
      dog.name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get lastWalked {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text('Last Walked: 12:20 March 18, 2022'), //TODO
    );
  }

  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          lastWalked,
          WalkButton(dog: dog, dogReference: dogReference, userId: userId),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image,
          Flexible(child: details),
        ],
      ),
    );
  }
}

class WalkButton extends StatefulWidget {
  final Dog dog;
  final DocumentReference<Dog> dogReference;
  final String userId;

  const WalkButton(
      {Key? key,
      required this.dog,
      required this.dogReference,
      required this.userId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WalkButtonState();
}

class _WalkButtonState extends State<WalkButton> {
  Future<void> _onEndWalkPressed() async {
    final _walkDoc = await walkRef.doc(widget.dog.walkingId);
    final batch = FirebaseFirestore.instance.batch();
    batch.update(_walkDoc, {'endAt': DateTime.now()});
    batch.update(widget.dogReference, {'walkingId': ''});
    batch.commit();
  }

  Future<void> _onWalkPressed() async {
    final _walkDoc = await walkRef.doc();
    final batch = FirebaseFirestore.instance.batch();
    batch.set(
        _walkDoc,
        Walk(
            uid: _walkDoc.id,
            dogId: widget.dog.uid,
            userId: widget.userId,
            startAt: DateTime.now(),
            endAt: DateTime.fromMillisecondsSinceEpoch(0)));
    batch.update(widget.dogReference, {
      'walkingId': _walkDoc.id,
      'walks': FieldValue.arrayUnion([_walkDoc])
    });
    batch.commit();
  }

  Future<DocumentSnapshot<Walk>> _getWalk() async {
    return widget.dog.walkingId.isEmpty
        ? await walkRef.doc().get()
        : await walkRef.doc(widget.dog.walkingId).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getWalk(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text(
              'Error',
              style: TextStyle(color: Colors.red),
            );
          }

          if (!snapshot.hasData) {
            return const Text(
              'No Data',
              style: TextStyle(color: Colors.red),
            );
          }

          if (widget.dog.walkingId.isEmpty) {
            return ElevatedButton(
                onPressed: _onWalkPressed,
                child: const Text('Start Walk',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent));
          }
          return ElevatedButton(
              onPressed: _onEndWalkPressed,
              child:
                  const Text('End Walk', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(primary: Colors.redAccent));
          ;
        });
  }
}
