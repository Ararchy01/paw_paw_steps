import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/util/firestore_util.dart';

import '../domain/Dog.dart';
import '../domain/User.dart';
import 'walk_button.dart';
import 'walk_history.dart';

final dogRef = FirestoreUtil.DOG_REF;

class DogsPage extends StatefulWidget {
  const DogsPage({Key? key}) : super(key: key);

  @override
  State<DogsPage> createState() => _DogsPageState();
}

class _DogsPageState extends State<DogsPage> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserState>(context).getUser();
    return StreamBuilder<QuerySnapshot<Dog>>(
      stream: dogRef.where('walkersIds', arrayContains: _user.uid).snapshots(),
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
            return _DogListItem(
                data.docs[index].data(), data.docs[index].reference, _user.uid);
          },
        );
      },
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
      width: 100,
      height: 100,
      child: Image.network(dog.imageUrl),
    );
  }

  Widget get name {
    return Text(
      dog.name,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          WalkButton(dog: dog, dogReference: dogReference, userId: userId),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [image, Flexible(child: details)]),
            Flexible(child: WalkHistory(dog: dog))
          ]),
        ),
      ),
      color: Colors.amberAccent,
    );
  }
}
