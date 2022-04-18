import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Widget get image {
    return SizedBox(
      height: 200,
      width: 200,
      child: _newImageFile != null
          ? CircleAvatar(backgroundImage: AssetImage(_newImageFile!.path))
          : _user.imageUrl.isNotEmpty
              ? CircleAvatar(backgroundImage: NetworkImage(_user.imageUrl))
              : const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add_a_photo_outlined, size: 50)),
    );
  }

  Widget get imageButton {
    return TextButton(
        onPressed: () async => await _pickImage(),
        child: const Text('Set Image',
            style: TextStyle(color: Colors.blueAccent)));
  }

  Widget get userName {
    final _controller = TextEditingController(text: _user.name);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          width: 150,
          child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.green, fontSize: 30)),
        ),
        IconButton(
            onPressed: () async {
              await _userRef
                  .doc(_user.uid)
                  .update({'name': _controller.value.text});
              _user.name = _controller.value.text;
              _userState.setUser(_user);
            },
            icon: Icon(Icons.change_circle))
      ],
    );
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

  Widget get save {
    return ElevatedButton(
        onPressed: () async {
          if (_newImageFile != null) {
            final task = await FirebaseStorage.instance
                .ref('users/{$_user.uid}')
                .putFile(_newImageFile!);
            final _imageUrl = await task.ref.getDownloadURL();
            await _userRef.doc(_user.uid).update({'imageUrl': _imageUrl});
            _user.imageUrl = _imageUrl;
            _userState.setUser(_user);
          }
        },
        child: Text('Save Changes'));
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
          children: [image, imageButton, userName, dogs, save],
        ),
      ),
    );
  }
}
