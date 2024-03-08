import 'package:flutter/material.dart';
import 'package:medi_connect/screens/admin_hospital_pov/admin_home.dart';
import 'package:medi_connect/screens/admin_hospital_pov/hospital_home.dart';

import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:medi_connect/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  bool inadmin;

  LoginScreen({
    super.key,
    this.inadmin = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/sample_logo.jpg',
                height: 200,
              ),
              const SizedBox(
                height: 75,
              ),
              TextFieldWidget(
                borderColor: primary,
                label: 'Username',
                controller: emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                isObscure: true,
                borderColor: primary,
                label: 'Password',
                controller: passwordController,
                showEye: true,
              ),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                radius: 10,
                color: primary,
                width: 175,
                label: 'Sign In',
                onPressed: () {
                  if (widget.inadmin) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const AdminHomeScreen()));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HospitalHomeScreen()));
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
