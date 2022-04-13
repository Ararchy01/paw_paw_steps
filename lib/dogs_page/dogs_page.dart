import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/util/firestore_util.dart';
import 'package:walking_doggy/util/my_page.dart';

import '../add_dog_page/add_dog_page.dart';
import '../domain/Dog.dart';
import '../domain/User.dart';
import 'dog_list_item.dart';

final dogRef = FirestoreUtil.DOG_REF;

class DogsPage extends StatefulWidget implements MyPage {
  const DogsPage({Key? key}) : super(key: key);

  @override
  State<DogsPage> createState() => _DogsPageState();

  @override
  AppBar appBar() {
    return AppBar(
      title: Text('Dogs'),
      automaticallyImplyLeading: false,
    );
  }

  @override
  BottomNavigationBarItem bottomNavigationBarItem() {
    return BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Dogs');
  }
}

class _DogsPageState extends State<DogsPage> {
  @override
  Widget build(BuildContext context) {
    final _userId = Provider.of<UserState>(context).getUser().uid;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Dog>>(
        stream: dogRef.where('walkersIds', arrayContains: _userId).snapshots(),
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
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.size,
            itemBuilder: (context, index) {
              return DogListItem(
                  data.docs[index].data(), data.docs[index].reference, _userId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: const CircleBorder(),
              builder: (context) => const AddDogPage())),
    );
  }
}
