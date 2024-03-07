import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/text_widget.dart';
import 'package:medi_connect/widgets/textfield_widget.dart';

class HospitalHomeScreen extends StatefulWidget {
  const HospitalHomeScreen({super.key});

  @override
  State<HospitalHomeScreen> createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  bool inAll = true;
  bool inNear = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.1479, 125.1321),
    zoom: 14.4746,
  );

  final name = TextEditingController();

  final description = TextEditingController();

  final doctorname = TextEditingController();

  final doctorjob = TextEditingController();
  final servicesname = TextEditingController();

  int rooms = 1;

  Marker marker = const Marker(markerId: MarkerId('1'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 50, 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 50,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/sample_logo.jpg',
                        height: 75,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      TextWidget(
                        text: 'Polymedic General Hospital',
                        fontSize: 48,
                        color: primary,
                        fontFamily: 'Bold',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 500,
                    height: 500,
                    child: GoogleMap(
                      markers: <Marker>{marker},
                      onTap: (argument) {
                        setState(() {
                          marker = Marker(
                            markerId: const MarkerId('1'),
                            position:
                                LatLng(argument.latitude, argument.longitude),
                            infoWindow: const InfoWindow(
                              title: 'Polymedic Hospital',
                            ),
                          );
                        });
                      },
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    )),
                const SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextWidget(
                              text: 'Polymedic General Hospital',
                              fontSize: 28,
                              color: Colors.black,
                              fontFamily: 'Bold',
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFieldWidget(
                                            controller: name,
                                            label: 'Name',
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFieldWidget(
                                              controller: description,
                                              label: 'Description'),
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
                                          onPressed: () {
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
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ],
                        ),
                        TextWidget(
                          text:
                              '"Eiusmod consequat officia velit sint fugiat sit laboris elit dolor cupidatat nulla cupidatat. Culpa commodo culpa ut ipsum aliquip enim sit velit anim enim nulla non proident labore. Laborum do aliquip dolore magna irure incididunt exercitation anim nulla minim. Elit do quis qui incididunt labore occaecat do occaecat occaecat anim."',
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Regular',
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              text: 'Available Services',
                              fontSize: 22,
                              color: Colors.black,
                              fontFamily: 'Bold',
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFieldWidget(
                                              controller: servicesname,
                                              label: 'Name of Service'),
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
                                          onPressed: () {
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
                              icon: const Icon(
                                Icons.add,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 75,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  TextWidget(
                                    text: '• Service ${index + 1}',
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'Medium',
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        TextWidget(
                          text: 'Hospital Doctors',
                          fontSize: 22,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        SizedBox(
                          height: 75,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  TextWidget(
                                    text:
                                        '• Doctor ${index + 1} - Cardiologist',
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'Medium',
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        TextWidget(
                          text: 'Available Emergency Rooms',
                          fontSize: 22,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        Row(
                          children: [
                            TextWidget(
                              text: '• $rooms rooms available',
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Medium',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                if (rooms > 1) {
                                  setState(() {
                                    rooms--;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.remove,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  rooms++;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
