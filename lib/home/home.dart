import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../add_dog/add_dog.dart';
import '../domain/Dog.dart';
import '../domain/User.dart';
import 'home_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _userState = Provider.of<UserState>(context);
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()..fetchDogs(_userState.getUser().uid),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Icon(Icons.pets),
              Text('Pow Pow Steps'),
              Icon(Icons.pets),
            ],
          ),
        ),
        body: Center(
          child: Consumer<HomeModel>(builder: (context, model, child) {
            final List<Dog>? dogs = model.dogs;
            if (dogs == null) {
              return const CircularProgressIndicator();
            }
            if (dogs.length == 1) {
              return _SingleView(dogs.first, model, _userState.getUser().uid);
            } else {
              return _MultipleView(dogs, model, _userState.getUser().uid);
            }
          }),
        ),
        floatingActionButton:
            Consumer<HomeModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDog(),
                    fullscreenDialog: true),
              );
              if (added != null && added) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Added a dog!'),
                ));
              }
              model.fetchDogs(_userState.getUser().uid);
            },
            child: const Icon(Icons.add),
          );
        }),
        //TODO
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
            BottomNavigationBarItem(
                icon: Icon(Icons.app_registration), label: 'Register')
          ],
        ),
      ),
    );
  }
}

class _SingleView extends StatelessWidget {
  final Dog dog;
  final HomeModel model;
  final String userId;

  const _SingleView(this.dog, this.model, this.userId);

  Widget get image {
    return SizedBox(
      width: 200,
      child: Image.network(dog.imageUrl),
    );
  }

  Widget get name {
    return Text(dog.name,
        style: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green));
  }

  Widget get startWalk {
    return ElevatedButton(
        onPressed: () async => model.walkDog(dog.uid, userId),
        child: const Text('Start Walk!'),
        style: ElevatedButton.styleFrom(primary: Colors.yellow));
  }

  Widget get endWalk {
    return ElevatedButton(
        onPressed: () async => model.endWalk(dog.uid),
        child: const Text('End Walk'),
        style: ElevatedButton.styleFrom(primary: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image,
        name,
        dog.walkingId.isEmpty ? startWalk : endWalk,
        Column(
          children: dog.recentWalks
              .map((walk) => Text(walk.endAt.toLocal().toString()))
              .toList(),
        )
      ],
    );
  }
}

class _MultipleView extends StatelessWidget {
  final List<Dog> dogs;
  final HomeModel model;
  final String userId;

  const _MultipleView(this.dogs, this.model, this.userId);

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(10.0),
        children: dogs.map((dog) => _DogListItem(dog, model, userId)).toList());
  }
}

class _DogListItem extends StatelessWidget {
  final Dog dog;
  final HomeModel model;
  final String userId;

  const _DogListItem(this.dog, this.model, this.userId);

  Widget get image {
    return SizedBox(
      width: 150,
      height: 150,
      child: Image.network(dog.imageUrl),
    );
  }

  Widget get name {
    return Text(
      dog.name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get lastWalked {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text('Last Walked: 12:20 March 18, 2022'), //TODO
    );
  }

  Widget get startWalk {
    return ElevatedButton(
        onPressed: () async => model.walkDog(dog.uid, userId),
        child: const Text('Start Walk!'),
        style: ElevatedButton.styleFrom(primary: Colors.yellow));
  }

  Widget get endWalk {
    return ElevatedButton(
        onPressed: () async => model.endWalk(dog.uid),
        child: const Text('End Walk'),
        style: ElevatedButton.styleFrom(primary: Colors.redAccent));
  }

  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          lastWalked,
          dog.walkingId.isEmpty ? startWalk : endWalk,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image,
          Flexible(child: details),
        ],
      ),
    );
  }
}
