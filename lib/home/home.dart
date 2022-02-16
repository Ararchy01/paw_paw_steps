import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/domain/Dog.dart';
import 'package:walking_doggy/home/home_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _dogsStream =
      FirebaseFirestore.instance.collection('dogs').snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()..fetchDogs(),
      child: Scaffold(
          appBar: AppBar(
            title: const Icon(Icons.pets),
          ),
          body: Center(
              child: Consumer<HomeModel>(builder: (context, model, child) {
            final List<Dog>? dogs = model.dogs;
            if (dogs == null) {
              return const CircularProgressIndicator();
            }
            final List<Widget> widgets = dogs
                .map((dog) => ListTile(
                    title: Text(dog.name),
                    subtitle: Text(dog.walkers.join(','))))
                .toList();
            return ListView(children: widgets);
          }))),
    );
  }
}

class _SingleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}

class _MultipleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2);
  }
}
