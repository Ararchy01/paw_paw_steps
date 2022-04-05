import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../domain/Dog.dart';
import '../domain/User.dart';
import '../util/firestore_util.dart';

final userRef = FirestoreUtil.USER_REF;
final dogRef = FirestoreUtil.DOG_REF;

class AddDogPage extends StatefulWidget {
  const AddDogPage({Key? key}) : super(key: key);

  @override
  State<AddDogPage> createState() => _AddDogPageState();
}

class _AddDogPageState extends State<AddDogPage> {
  File? _imageFile;
  String _imageButtonText = 'Add Image';
  final _nameController = TextEditingController();

  Future<void> _pickImage() async {
    final _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
        _imageButtonText = 'Change Image';
      });
    }
  }

  Future<void> _onAddPressed(String userId) async {
    final doc = dogRef.doc();
    String? imageURL;
    if (_imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('dogs/${doc.id}')
          .putFile(_imageFile!);
      imageURL = await task.ref.getDownloadURL();
    }
    final _newDog = Dog(
        uid: doc.id,
        name: _nameController.value.text,
        imageUrl: imageURL!,
        walkingId: '',
        walkersIds: [userId]);
    final batch = await FirebaseFirestore.instance.batch();
    batch.set(doc, _newDog);
    batch.update(userRef.doc(userId), {
      'dogs': FieldValue.arrayUnion([doc.id])
    });
    await batch.commit();
    Navigator.pop(context);
  }

  Widget get image {
    return SizedBox(
      height: 200,
      width: 200,
      child: _imageFile != null
          ? CircleAvatar(backgroundImage: AssetImage(_imageFile!.path))
          : const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.add_a_photo_outlined, size: 50)),
    );
  }

  Widget get imageButton {
    return TextButton(
        onPressed: () async {
          await _pickImage();
        },
        child: Text(_imageButtonText,
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

  Widget addButton(String userId) {
    return ElevatedButton(
        child: const Text('Add'),
        onPressed: () async => await _onAddPressed(userId));
  }

  @override
  Widget build(BuildContext context) {
    final _userState = Provider.of<UserState>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          imageButton,
          name,
          addButton(_userState.getUser().uid)
        ],
      ),
    );
  }
}
