import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/util/my_page.dart';

import '../domain/Dog.dart';
import '../domain/User.dart';
import '../util/firestore_util.dart';

class FriendsPage extends StatefulWidget implements MyPage {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendsPageState();

  @override
  AppBar appBar() {
    return AppBar(
      title: Text('Share Walk'),
      automaticallyImplyLeading: false,
    );
  }

  @override
  BottomNavigationBarItem bottomNavigationBarItem() {
    return BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Share');
  }
}

class _FriendsPageState extends State<FriendsPage> {
  final _userRef = FirestoreUtil.USER_REF;
  final _dogRef = FirestoreUtil.DOG_REF;
  final _emailController = TextEditingController();

  User? _friendUser;
  DocumentReference<User>? _friendRef;

  Widget get emailTextBox {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: _emailController,
        decoration: const InputDecoration(labelText: 'Email'),
      ),
    );
  }

  Future<void> _onSearchPressed() async {
    final _friend = await _userRef
        .where('email', isEqualTo: _emailController.value.text)
        .get();
    if (_friend.docs.first.exists) {
      setState(() {
        _friendRef = _friend.docs.first.reference;
        _friendUser = _friend.docs.first.data();
      });
    }
  }

  Widget get searchButton {
    return ElevatedButton(
        onPressed: () => _onSearchPressed(), child: const Icon(Icons.search));
  }

  Widget get image {
    return SizedBox(
      height: 100,
      width: 100,
      child: _friendUser != null
          ? _friendUser!.imageUrl.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(_friendUser!.imageUrl))
              : const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.image, size: 50))
          : SizedBox(),
    );
  }

  Widget dogs(User user) {
    return StreamBuilder<QuerySnapshot<Dog>>(
        stream: _dogRef
            .where('uid', whereIn: user.dogs)
            .where('ownerId', isEqualTo: user.uid)
            .snapshots(),
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

          if (data.size == 0) {
            return const Center(
                child: Text(
              'No dog to share walks',
              style: TextStyle(color: Colors.redAccent),
            ));
          }

          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.size,
              itemBuilder: (context, index) {
                return _DogList(
                    dog: data.docs[index].data(),
                    dogRef: data.docs[index].reference,
                    friend: _friendUser != null ? _friendUser! : null,
                    friendRef: _friendRef != null ? _friendRef! : null);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserState>(context).getUser();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          emailTextBox,
          searchButton,
          dogs(_user),
        ],
      ),
    );
  }
}

class _DogList extends StatelessWidget {
  final Dog dog;
  final DocumentReference<Dog> dogRef;
  final User? friend;
  final DocumentReference<User>? friendRef;

  const _DogList(
      {Key? key,
      required this.dog,
      required this.dogRef,
      required this.friend,
      required this.friendRef})
      : super(key: key);

  Future<void> _onShareWalkPressed() async {
    final batch = FirebaseFirestore.instance.batch();
    batch.update(friendRef!, {
      'dogs': FieldValue.arrayUnion([dog.uid])
    });
    batch.update(dogRef, {
      'walkersIds': FieldValue.arrayUnion([friend!.uid])
    });
    await batch.commit();
    dog.walkersIds.add(friend!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final bool isFriendSelected = friend != null;
    final bool isDogShared =
        friend != null ? friend!.dogs.contains(dog.uid) : false;
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(dog.imageUrl)),
          Text(dog.name),
          ElevatedButton(
            onPressed: isFriendSelected && !isDogShared
                ? () => _onShareWalkPressed()
                : null,
            child: isFriendSelected
                ? isDogShared
                    ? Text('Already Shared')
                    : Text('Share Walk')
                : Icon(Icons.not_interested),
          )
        ],
      ),
    );
  }
}
