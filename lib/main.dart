import 'package:flutter/material.dart';
import 'package:medi_connect/screens/admin_hospital_pov/admin_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MediConnect',
      home: AdminHomeScreen(),
    );
  }
}
