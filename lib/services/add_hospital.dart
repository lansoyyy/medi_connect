import 'package:cloud_firestore/cloud_firestore.dart';

Future addHospital(email, name, desc, services, doctors, int rooms, id, logo,
    admin, number, location) async {
  final docUser = FirebaseFirestore.instance.collection('Hospital').doc(id);

  final json = {
    'admin': admin,
    'number': number,
    'location': location,
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
    'lat': 0,
    'long': 0,
  };

  await docUser.set(json);
}
