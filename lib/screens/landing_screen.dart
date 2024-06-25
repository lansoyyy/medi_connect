import 'package:flutter/material.dart';
import 'package:medi_connect/screens/admin_hospital_pov/main_screen.dart';
import 'package:medi_connect/screens/users_pov/home_screen.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:medi_connect/widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

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
              text: 'Welcome To',
              fontSize: 18,
              color: Colors.white,
            ),
            TextWidget(
              text: 'MediConnect Bukidnon',
              fontSize: 75,
              color: Colors.white,
              fontFamily: 'Bold',
            ),
            TextWidget(
              text:
                  '"Helping you find the nearest available hospitals near you"',
              fontSize: 14,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 50,
            ),
            ButtonWidget(
              width: 200,
              color: primary,
              label: 'Find Hospitals',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UsersHomeScreen()));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              width: 200,
              color: primary,
              label: 'Sign In',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MainScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
