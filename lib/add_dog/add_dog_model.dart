import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AddDogModel extends ChangeNotifier {
  String? name;
  File? imageFile;
  bool isLoading = false;
  String? noImageURL;

  final _dogsCollection = FirebaseFirestore.instance.collection('dogs');
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _picker = ImagePicker();

  void init() async {
    noImageURL = await FirebaseStorage.instance
        .ref('general/no_image.jpg')
        .getDownloadURL();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
  }

  Future addDog(String userId) async {
    final doc = _dogsCollection.doc();
    String? imageURL;
    if (imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('dogs/${doc.id}')
          .putFile(imageFile!);
      imageURL = await task.ref.getDownloadURL();
    } else {
      imageURL = noImageURL;
    }
    await doc
        .set({'uid': doc.id, 'name': name, 'imageURL': imageURL, 'walkId': ''});
    await _usersCollection.doc(userId).update({
      'dogs': FieldValue.arrayUnion([doc.id])
    });
  }

  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
