import 'package:flutter/material.dart';
import 'package:medi_connect/screens/admin_hospital_pov/admin_home.dart';
import 'package:medi_connect/screens/admin_hospital_pov/admin_tabs/map_tab.dart';
import 'package:medi_connect/screens/admin_hospital_pov/login_screen.dart';
import 'package:medi_connect/screens/landing_screen.dart';
import 'package:medi_connect/widgets/text_widget.dart';

import '../utlis/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 250,
      color: Colors.grey[100],
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: primary),
                      shape: BoxShape.circle,
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Image.asset(
                      'assets/images/sample_logo.jpg',
                      height: 35,
                    ),
                  ),
                ),
                TextWidget(
                  text: 'Administrator',
                  fontFamily: 'Bold',
                  fontSize: 16,
                ),
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).closeDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: primary,
                      size: 32,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const AdminHomeScreen()));
              },
              title: TextWidget(
                text: 'Hospital List',
                fontSize: 14,
                fontFamily: 'Bold',
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MapTab()));
              },
              title: TextWidget(
                text: 'Maps',
                fontSize: 14,
                fontFamily: 'Bold',
              ),
            ),
            ListTile(
              title: TextWidget(
                text: 'Logout',
                fontSize: 14,
                fontFamily: 'Bold',
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Logout Confirmation',
                            style: TextStyle(
                                fontFamily: 'QBold',
                                fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            'Are you sure you want to Logout?',
                            style: TextStyle(fontFamily: 'QRegular'),
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LandingScreen()));
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      )),
    );
  }
}
