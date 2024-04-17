import 'package:cloud_firestore/cloud_firestore.dart';

Future addRoom(name, hospitalId) async {
  final docUser = FirebaseFirestore.instance.collection('Rooms').doc();

  final json = {
    'name': name,
    'hospitalId': hospitalId,
    'isAvailable': true,
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
