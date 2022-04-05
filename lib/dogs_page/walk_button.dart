import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/Dog.dart';
import '../domain/Walk.dart';
import '../util/firestore_util.dart';

final walkRef = FirestoreUtil.WALK_REF;

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
    await batch.commit();
  }

  Future<void> _onStartWalkPressed() async {
    final _walkDoc = await walkRef.doc();
    final batch = FirebaseFirestore.instance.batch();
    batch.set(
        _walkDoc,
        Walk(
            uid: _walkDoc.id,
            dogId: widget.dog.uid,
            walkersIds: [widget.userId],
            startAt: DateTime.now(),
            endAt: DateTime.fromMillisecondsSinceEpoch(0)));
    batch.update(widget.dogReference, {'walkingId': _walkDoc.id});
    await batch.commit();
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
                onPressed: _onStartWalkPressed,
                child: const Text('Start Walk',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: Colors.green));
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
