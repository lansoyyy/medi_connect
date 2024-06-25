import 'package:flutter/material.dart';
import 'package:medi_connect/screens/admin_hospital_pov/login_screen.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:medi_connect/widgets/text_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              opacity: 200,
              image: AssetImage(
                'assets/images/bg.jpg',
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              text: 'Select Sign in Method',
              fontSize: 18,
              color: Colors.white,
            ),
            const SizedBox(
              height: 50,
            ),
            ButtonWidget(
              width: 200,
              color: primary,
              label: 'Sign in as Admin',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginScreen(
                          inadmin: true,
                        )));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              width: 200,
              color: primary,
              label: 'Sign in as Hospital',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
