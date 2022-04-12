import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/Dog.dart';
import '../domain/User.dart';
import '../domain/Walk.dart';
import '../util/firestore_util.dart';

final walkRef = FirestoreUtil.WALK_REF;
final userRef = FirestoreUtil.USER_REF;

class WalkHistory extends StatefulWidget {
  final Dog dog;

  const WalkHistory({Key? key, required this.dog}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WalkHistoryState();
}

class _WalkHistoryState extends State<WalkHistory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Walk>>(
        stream: walkRef
            .where('dogId', isEqualTo: widget.dog.uid)
            .orderBy('endAt', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.size,
              itemBuilder: (context, index) {
                return _Item(walk: data.docs[index].data());
              });
        });
  }
}

class _Item extends StatelessWidget {
  final Walk walk;

  const _Item({Key? key, required this.walk}) : super(key: key);

  Widget get _walkTimeText {
    String _walkInfo;
    Color _color;
    if (walk.endAt.isAtSameMomentAs(walk.startAt)) {
      _walkInfo = 'Walking now';
      _color = Colors.blue;
    } else {
      if (walk.endAt.difference(DateTime.now()).inDays == 0) {
        if (walk.endAt.day == DateTime.now().day) {
          _walkInfo = 'Today ${DateFormat('HH:mm').format(walk.endAt)}';
          _color = Colors.green;
        } else {
          _walkInfo = 'Yesterday ${DateFormat('HH:mm').format(walk.endAt)}';
          _color = Colors.deepPurple;
        }
      } else {
        _color = Colors.black;
        if (walk.endAt.year != DateTime.now().year) {
          _walkInfo = DateFormat('yyyy-MM-dd HH:mm').format(walk.endAt);
        } else {
          _walkInfo = DateFormat('MM-dd HH:mm').format(walk.endAt);
        }
      }
    }

    return Text(
      _walkInfo,
      style: TextStyle(fontWeight: FontWeight.bold, color: _color),
    );
  }

  Widget get _durationText {
    if (walk.endAt.isAtSameMomentAs(walk.startAt)) {
      return const Text('');
    }
    final _duration = walk.endAt.difference(walk.startAt);
    String _hours = '';
    String _minutes = '';
    final int _minute = _duration.inMinutes % 60;
    if (_minute == 0 || _minute == 1) {
      _minutes = '$_minute minute';
    } else {
      _minutes = '$_minute minutes';
    }
    if (_duration.inMinutes > 59) {
      if (_duration.inHours == 1) {
        _hours = '${_duration.inHours} hour ';
      } else {
        _hours = '${_duration.inHours} hours ';
      }
    }
    return Text(' for $_hours$_minutes');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white70.withAlpha(200),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [_walkTimeText, _durationText],
            ),
            _WalkersIcons(
              walkersIds: walk.walkersIds,
            )
          ]),
        ));
  }
}

class _WalkersIcons extends StatelessWidget {
  final List<String> walkersIds;

  const _WalkersIcons({Key? key, required this.walkersIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<User>>(
        stream: userRef.where('uid', whereIn: walkersIds).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.docs.map((e) {
              final user = e.data();
              return Padding(
                padding: const EdgeInsets.all(2),
                child: SizedBox(
                    height: 25,
                    child: user.imageUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl))
                        : CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(user.name.substring(0, 1)))),
              );
            }).toList(),
          );
        });
  }
}
