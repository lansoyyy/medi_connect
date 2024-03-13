import 'package:cloud_firestore/cloud_firestore.dart';

Future addHospital(
    email, name, desc, services, doctors, int rooms, id, logo) async {
  final docUser = FirebaseFirestore.instance.collection('Hospital').doc(id);

  final json = {
    'email': email,
    'name': name,
    'desc': desc,
    'services': services,
    'doctors': doctors,
    'rooms': rooms,
    'id': id,
    'logo': logo,
    'status': 'Active',
    'dateTime': DateTime.now(),
    'type': 'Hospital',
    'lat': 8.1479,
    'long': 125.1321,
  };

  await docUser.set(json);
}
