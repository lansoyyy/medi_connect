import 'package:cloud_firestore/cloud_firestore.dart';

Future addAppointment(name, number, address, hospitalId, date) async {
  final docUser = FirebaseFirestore.instance.collection('Appointment').doc();

  final json = {
    'name': name,
    'number': number,
    'address': address,
    'hospitalId': hospitalId,
    'date': date,
    'status': 'Pending',
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
