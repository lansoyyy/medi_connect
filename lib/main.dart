import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/screens/admin_hospital_pov/admin_home.dart';
import 'package:medi_connect/screens/landing_screen.dart';
import 'package:medi_connect/screens/users_pov/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          authDomain: 'mediconnect-a4edd.firebaseapp.com',
          apiKey: "AIzaSyBR2B-YBYaEwJ0WiKVCU_0vPkw4DpmqAfs",
          appId: "1:701825559115:web:8e152e9d12b54162e2bbce",
          messagingSenderId: "701825559115",
          projectId: "mediconnect-a4edd",
          storageBucket: "mediconnect-a4edd.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MediConnect',
      home: LandingScreen(),
    );
  }
}
