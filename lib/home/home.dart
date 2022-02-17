import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_doggy/add_dog/add_dog.dart';
import 'package:walking_doggy/domain/Dog.dart';

import 'home_stream_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeStreamModel>(
      create: (_) => HomeStreamModel()..fetchDogs(),
      child: Scaffold(
        appBar: AppBar(
          title: const Icon(Icons.pets),
        ),
        body: Center(
          child: Consumer<HomeStreamModel>(builder: (context, model, child) {
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
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final Dog addDog = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDog(),
                    fullscreenDialog: true));
          },
          tooltip: 'Add Dog',
          child: const Icon(Icons.add),
        ),
        
      ),
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
