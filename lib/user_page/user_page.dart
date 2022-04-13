import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../domain/Dog.dart';
import '../domain/User.dart';
import '../util/firestore_util.dart';
import '../util/my_page.dart';

class UserPage extends StatefulWidget implements MyPage {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserPageState();

  @override
  AppBar appBar() {
    return AppBar(
      title: Text('User'),
      automaticallyImplyLeading: false,
    );
  }

  @override
  BottomNavigationBarItem bottomNavigationBarItem() {
    return BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User');
  }
}

class _UserPageState extends State<UserPage> {
  File? _newImageFile;
  final _userRef = FirestoreUtil.USER_REF;
  final _dogRef = FirestoreUtil.DOG_REF;

  Future<void> _pickImage() async {
    final _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      setState(() {
        _newImageFile = File(_pickedImage.path);
      });
    }
  }

  Widget image(String imageUrl) {
    return SizedBox(
      height: 200,
      width: 200,
      child: _newImageFile != null
          ? CircleAvatar(backgroundImage: AssetImage(_newImageFile!.path))
          : imageUrl.isNotEmpty
              ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
              : const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add_a_photo_outlined, size: 50)),
    );
  }

  Widget imageButton(String userId) {
    return TextButton(
        onPressed: () async => await _pickImage(),
        child: const Text('Set Image',
            style: TextStyle(color: Colors.blueAccent)));
  }

  Widget dogs(List<String> dogs) {
    return StreamBuilder<QuerySnapshot<Dog>>(
        stream: _dogRef.where('uid', whereIn: dogs).snapshots(),
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

  Widget save(UserState userState) {
    final _user = userState.getUser();
    return ElevatedButton(
        onPressed: () async {
          if (_newImageFile != null) {
            final task = await FirebaseStorage.instance
                .ref('dogs/{$_user.uid}')
                .putFile(_newImageFile!);
            final _imageUrl = await task.ref.getDownloadURL();
            await _userRef.doc(_user.uid).update({'imageUrl': _imageUrl});
            // TODO
            userState.setUser(User(
                uid: _user.uid,
                name: _user.name,
                email: _user.email,
                imageUrl: _imageUrl,
                dogs: _user.dogs));
          }
        },
        child: Text('Save Changes'));
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserState>(context).getUser();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image(_user.imageUrl),
          imageButton(_user.uid),
          Text(_user.name,
              style: const TextStyle(color: Colors.green, fontSize: 30)),
          dogs(_user.dogs),
          save(Provider.of<UserState>(context))
        ],
      ),
    );
  }
}
