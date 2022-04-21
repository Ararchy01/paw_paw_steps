import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/Dog.dart';
import '../util/firestore_util.dart';

final dogRef = FirestoreUtil.DOG_REF;

class UpdateDogPage extends StatefulWidget {
  final Dog dog;

  const UpdateDogPage({Key? key, required this.dog}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdateDogPageState();
}

class _UpdateDogPageState extends State<UpdateDogPage> {
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
    final doc = dogRef.doc();
    String _imageUrl = widget.dog.imageUrl;
    if (_imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('dogs/${doc.id}')
          .putFile(_imageFile!);
      _imageUrl = await task.ref.getDownloadURL();
    }
    dogRef
        .doc(widget.dog.uid)
        .update({'imageUrl': _imageUrl, 'name': _nameController!.value.text});
    Navigator.pop(context);
  }

  Widget get image {
    return SizedBox(
      height: 200,
      width: 200,
      child: _imageFile != null
          ? CircleAvatar(backgroundImage: AssetImage(_imageFile!.path))
          : CircleAvatar(backgroundImage: NetworkImage(widget.dog.imageUrl)),
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
    _nameController = TextEditingController(text: widget.dog.name);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [image, imageButton, name, updateButton],
      ),
    );
  }
}
