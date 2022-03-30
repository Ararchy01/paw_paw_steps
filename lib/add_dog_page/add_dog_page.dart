import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/domain/Dog.dart';
import 'package:walking_doggy/util/firestore_util.dart';

import '../domain/User.dart';

final userRef = FirestoreUtil.USER_REF;
final dogRef = FirestoreUtil.DOG_REF;

class AddDogPage extends StatefulWidget {
  const AddDogPage({Key? key}) : super(key: key);

  @override
  State<AddDogPage> createState() => _AddDogPageState();
}

class _AddDogPageState extends State<AddDogPage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userState = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dog'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 0,
                child: _imageFile != null
                    ? Image.file(_imageFile!)
                    : const Icon(Icons.add_a_photo_outlined)),
            TextButton(
                onPressed: () async {
                  await _pickImage();
                },
                child: const Text('Set Image',
                    style: TextStyle(color: Colors.blueAccent))),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                final doc = dogRef.doc();
                String? imageURL;
                if (_imageFile != null) {
                  final task = await FirebaseStorage.instance
                      .ref('dogs/${doc.id}')
                      .putFile(_imageFile!);
                  imageURL = await task.ref.getDownloadURL();
                }
                final batch = await FirebaseFirestore.instance.batch();
                batch.set(
                    doc,
                    Dog(
                        uid: doc.id,
                        name: 'AAA',
                        imageUrl: imageURL!,
                        walkingId: '',
                        walkersIds: [_userState.getUser().uid],
                        walks: []));
                batch.update(userRef.doc(_userState.getUser().uid), {
                  'dogs': FieldValue.arrayUnion([doc.id])
                });
                await batch.commit();
                Navigator.pushNamed(context, '/after_login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
