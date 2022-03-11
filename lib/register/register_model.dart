import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String? uid;
  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setName(String _name) {
    this.name = _name;
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

  void setConfirmPassword(String _confirmPassword) {
    this.confirmPassword = _confirmPassword;
    notifyListeners();
  }

  Future register() async {
    if (email != null && password != null) {
      // Create credential in Firebase
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      if (user != null) {
        this.uid = user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'uid': uid, 'email': email, 'name': name, 'dogs':[]});
      }
    }
  }
}
