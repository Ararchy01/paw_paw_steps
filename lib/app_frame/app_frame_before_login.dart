import 'package:flutter/material.dart';

class AppFrameBeforeLogin extends StatefulWidget {
  final Widget body;

  const AppFrameBeforeLogin({Key? key, required this.body}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppFrameBeforeLoginState();
}

class _AppFrameBeforeLoginState extends State<AppFrameBeforeLogin> {
  Widget get appTitle {
    return Row(
      children: const [
        Icon(Icons.pets),
        Text('Pow Pow Steps'),
        Icon(Icons.pets),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: appTitle), body: widget.body);
  }
}
