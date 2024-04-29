import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medi_connect/screens/users_pov/tabs/all_tab.dart';
import 'package:medi_connect/screens/users_pov/tabs/near_tab.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/text_widget.dart';

class UsersHomeScreen extends StatefulWidget {
  const UsersHomeScreen({super.key});

  @override
  State<UsersHomeScreen> createState() => _UsersHomeScreenState();
}

class _UsersHomeScreenState extends State<UsersHomeScreen> {
  bool hasloaded = false;

  double lat = 0;
  double long = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        hasloaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }

  bool inAll = true;
  bool inNear = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: hasloaded
          ? Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 50, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/sample_logo.jpg',
                        height: 50,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget(
                        text: 'MediConnect',
                        fontSize: 24,
                        color: primary,
                        fontFamily: 'Bold',
                      ),
                      const Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            inAll = true;
                            inNear = false;
                          });
                        },
                        child: TextWidget(
                          decoration: inAll ? TextDecoration.underline : null,
                          text: 'All Hospitals',
                          fontSize: 16,
                          color: inAll ? primary : Colors.grey,
                          fontFamily: 'Bold',
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            inAll = false;
                            inNear = true;
                          });
                        },
                        child: TextWidget(
                          decoration: inNear ? TextDecoration.underline : null,
                          text: 'Hospitals Near Me',
                          fontSize: 16,
                          fontFamily: 'Bold',
                          color: inNear ? primary : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  inAll
                      ? AllTab(
                          mylat: lat,
                          mylong: long,
                        )
                      : NearTab(
                          mylat: lat,
                          mylong: long,
                        ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
