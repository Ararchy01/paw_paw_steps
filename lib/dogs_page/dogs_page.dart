import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/util/firestore_util.dart';

import '../add_dog_page/add_dog_page.dart';
import '../domain/Dog.dart';
import '../domain/User.dart';
import 'dog_list_item.dart';

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
    return Scaffold(
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
              return DogListItem(data.docs[index].data(),
                  data.docs[index].reference, _user.uid);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return AddDogPage();
              })),
    );
  }
}
