import 'package:flutter/cupertino.dart';

class User {
  String uid;
  String name;
  String email;
  List<String> dogs;

  User(
      {required this.uid,
      required this.name,
      required this.email,
      required this.dogs});

  User.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid'] as String,
            name: json['name'] as String,
            email: json['email'] as String,
            dogs: (json['dogs'] as List<dynamic>).cast<String>());

  Map<String, Object?> toJson() {
    return {'uid': uid, 'name': name, 'email': email, 'dogs': dogs};
  }
}

class UserState extends ChangeNotifier {
  User? _user;

  User getUser() {
    return _user!;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
