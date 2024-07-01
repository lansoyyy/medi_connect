import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/screens/admin_hospital_pov/admin_home.dart';
import 'package:medi_connect/screens/admin_hospital_pov/admin_tabs/map_tab.dart';
import 'package:medi_connect/screens/admin_hospital_pov/hospital_bed_page.dart';
import 'package:medi_connect/screens/admin_hospital_pov/hospital_home.dart';
import 'package:medi_connect/screens/admin_hospital_pov/hospital_services_page.dart';
import 'package:medi_connect/screens/admin_hospital_pov/login_screen.dart';
import 'package:medi_connect/screens/landing_screen.dart';
import 'package:medi_connect/widgets/text_widget.dart';
import 'package:medi_connect/widgets/textfield_widget.dart';

import '../utlis/colors.dart';

class HospitalDrawerWidget extends StatelessWidget {
  String id;

  HospitalDrawerWidget({
    super.key,
    required this.id,
  });

  final doctorname = TextEditingController();

  final doctorjob = TextEditingController();
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
                  text: 'MediConnect',
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
                    builder: (context) => HospitalHomeScreen(
                          id: id,
                          inUser: false,
                        )));
              },
              title: TextWidget(
                text: 'Dashboard',
                fontSize: 14,
                fontFamily: 'Bold',
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFieldWidget(
                              controller: doctorname, label: 'Name of Doctor'),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                              controller: doctorjob, label: 'Job of Doctor'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: TextWidget(
                            text: 'Close',
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Hospital')
                                .doc(id)
                                .update({
                              'doctors': FieldValue.arrayUnion(
                                  ['${doctorname.text} - ${doctorjob.text}']),
                            });
                            Navigator.pop(context);
                          },
                          child: TextWidget(
                            text: 'Save',
                            fontSize: 14,
                            fontFamily: 'Bold',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              title: TextWidget(
                text: 'Add Doctors',
                fontSize: 14,
                fontFamily: 'Bold',
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HospitalServicesPage(id: id)));
              },
              title: TextWidget(
                text: 'Services',
                fontSize: 14,
                fontFamily: 'Bold',
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HospitalBedPage(
                          id: id,
                        )));
              },
              title: TextWidget(
                text: 'ER Bed Availability',
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
