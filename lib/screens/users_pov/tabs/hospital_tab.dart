import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/text_widget.dart';

class HospitalTab extends StatefulWidget {
  const HospitalTab({super.key});

  @override
  State<HospitalTab> createState() => _HospitalTabState();
}

class _HospitalTabState extends State<HospitalTab> {
  bool inAll = true;
  bool inNear = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.1479, 125.1321),
    zoom: 14.4746,
  );

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
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
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
                        TextWidget(
                          text: 'Polymedic General Hospital',
                          fontSize: 28,
                          color: Colors.black,
                          fontFamily: 'Bold',
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
                        TextWidget(
                          text: 'Available Services',
                          fontSize: 22,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        TextWidget(
                          text: '• Service 1',
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Medium',
                        ),
                        TextWidget(
                          text: '• Service 2',
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Medium',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          text: 'Hospital Doctors',
                          fontSize: 22,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        TextWidget(
                          text: '• Doctor 1 - Cardiologist',
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Medium',
                        ),
                        TextWidget(
                          text: '• Doctor 2 - Nutritionist',
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Medium',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          text: 'Available Emergency Beds',
                          fontSize: 22,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        TextWidget(
                          text: '• 24 rooms available',
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Medium',
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
