import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/User.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserState>(context).getUser();
    return Center(child: Text('User Page'));
  }
}
