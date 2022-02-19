import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walking_doggy/domain/Dog.dart';

class AddDogModel {

  static Future addNewDog(String name, List<dynamic> walkers) async {
    final _ip = ImagePicker();
    final _pickedImage = await _ip.pickImage(source: ImageSource.gallery);
    final File? _imageFile = File(_pickedImage!.path);

    final Dog _newDog = Dog(name, walkers, 'a');
    await FirebaseFirestore.instance
        .collection('dogs')
        .add({'name': _newDog.name, 'walkers': _newDog.walkers})
        .then((value) => print(value))
        .catchError((error) => print(error));
  }

}
