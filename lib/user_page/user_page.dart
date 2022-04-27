import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paw_paw_steps/update_user_page/update_user_page.dart';
import 'package:provider/provider.dart';

import '../domain/Dog.dart';
import '../domain/User.dart' as my_user;
import '../util/firestore_util.dart';
import '../util/my_page.dart';

class UserPage extends MyPage {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserPageState();

  @override
  BottomNavigationBarItem bottomNavigationBarItem() {
    return BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User');
  }
}

class _UserPageState extends State<UserPage> {
  late my_user.User _user;
  late my_user.UserState _userState;
  final _dogRef = FirestoreUtil.DOG_REF;

  Widget get image {
    return SizedBox(
      height: 200,
      width: 200,
      child: _user.imageUrl.isNotEmpty
          ? CircleAvatar(backgroundImage: NetworkImage(_user.imageUrl))
          : const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.add_a_photo_outlined, size: 50)),
    );
  }

  Widget get userName {
    return Text(_user.name,
        style: const TextStyle(color: Colors.green, fontSize: 30));
  }

  Widget get dogs {
    return StreamBuilder<QuerySnapshot<Dog>>(
        stream: _dogRef.where('uid', whereIn: _user.dogs).snapshots(),
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

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.docs
                .map((e) => CircleAvatar(
                    backgroundImage: NetworkImage(e.data().imageUrl)))
                .toList(),
          );
        });
  }

  Widget get update {
    return ElevatedButton(
        child: const Text('Update'),
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const CircleBorder(),
            builder: (context) => UpdateUserPage()));
  }

  @override
  Widget build(BuildContext context) {
    _userState = Provider.of<my_user.UserState>(context);
    _user = _userState.getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Provider.of<my_user.UserState>(context, listen: false).signOut();
              Navigator.pushNamed(context, '/initial');
            },
            tooltip: 'Log Out',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [image, userName, dogs, update],
        ),
      ),
    );
  }
}
