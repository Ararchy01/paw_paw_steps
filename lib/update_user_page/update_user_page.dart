import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../domain/User.dart';
import '../util/firestore_util.dart';

final userRef = FirestoreUtil.USER_REF;

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  late User _user;
  late UserState _userState;

  File? _imageFile;
  TextEditingController? _nameController;

  Future<void> _pickImage() async {
    final _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
      });
    }
  }

  Future<void> _onChangePressed() async {
    final doc = userRef.doc();
    String _imageUrl = _user.imageUrl;
    if (_imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('users/${doc.id}')
          .putFile(_imageFile!);
      _imageUrl = await task.ref.getDownloadURL();
    }
    userRef
        .doc(_user.uid)
        .update({'imageUrl': _imageUrl, 'name': _nameController!.value.text});
    _user.name = _nameController!.value.text;
    _userState.setUser(_user);
    Navigator.pop(context);
  }

  Widget get image {
    return SizedBox(
      height: 200,
      width: 200,
      child: _imageFile != null
          ? CircleAvatar(backgroundImage: AssetImage(_imageFile!.path))
          : CircleAvatar(backgroundImage: NetworkImage(_user.imageUrl)),
    );
  }

  Widget get imageButton {
    return TextButton(
        onPressed: () async => await _pickImage(),
        child: Text('Change Image',
            style: const TextStyle(color: Colors.blueAccent)));
  }

  Widget get name {
    return SizedBox(
        width: 200,
        child: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ));
  }

  Widget get updateButton {
    return ElevatedButton(
        child: const Text('Update'),
        onPressed: () async => await _onChangePressed());
  }

  @override
  Widget build(BuildContext context) {
    _userState = Provider.of<UserState>(context);
    _user = _userState.getUser();
    _nameController = TextEditingController(text: _user.name);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [image, imageButton, name, updateButton],
      ),
    );
  }
}
