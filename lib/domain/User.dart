import 'package:flutter/cupertino.dart';

class User {
  String uid;
  String name;
  String email;
  List<String> dogs;

  User(this.uid, this.name, this.email, this.dogs);
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
