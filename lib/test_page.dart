import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final int increment;

  const TestPage({Key? key, required this.increment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Next Page'),
          actions: const [Icon(Icons.air), Icon(Icons.import_contacts_sharp)],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_circle_up,
                size: 100,
              ),
              Image.asset('images/reggae.png'),
              SizedBox(
                  child: ElevatedButton(
                      child: Text('$increment'),
                      onPressed: () {
                        Navigator.pop(context, 'Hello');
                      })),
            ],
          ),
        ));
  }
}
