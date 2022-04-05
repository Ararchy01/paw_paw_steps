import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/Dog.dart';
import '../domain/Walk.dart';
import '../util/firestore_util.dart';

final walkRef = FirestoreUtil.WALK_REF;

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
              itemCount: data.size,
              itemBuilder: (context, index) {
                final walk = data.docs[index].data();
                final duration = walk.endAt.difference(walk.startAt).inMinutes;

                String _walkInfo = '';
                if (walk.endAt.difference(DateTime.now()).inDays == 0) {
                  if (walk.endAt.day == DateTime.now().day) {
                    _walkInfo =
                        'Today ${DateFormat('HH:mm').format(walk.endAt)}';
                  } else {
                    _walkInfo =
                        'Yesterday ${DateFormat('HH:mm').format(walk.endAt)}';
                  }
                } else {
                  _walkInfo = DateFormat('yyyy-MM-dd HH:mm').format(walk.endAt);
                }

                return Card(
                    color: Colors.white70.withAlpha(200),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Row(children: [
                        Text(
                          _walkInfo,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Text(' for $duration minutes')
                      ]),
                    ));
              });
        });
  }
}
