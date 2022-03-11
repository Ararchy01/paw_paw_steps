import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  String? uid;
  String? name;
  String? email;
  String? password;
  List<String>? dogs;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setEmail(String _email) {
    this.email = _email;
    notifyListeners();
  }

  void setPassword(String _password) {
    this.password = _password;
    notifyListeners();
  }

  Future login() async {
    if (email != null && password != null) {
      // Create credential in Firebase
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      if (user != null) {
        this.uid = user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then((snapshot) {
          this.name = snapshot['name'];
          this.dogs = (snapshot['dogs'] as List<dynamic>).cast<String>();
        });
      }
    }
  }
}
