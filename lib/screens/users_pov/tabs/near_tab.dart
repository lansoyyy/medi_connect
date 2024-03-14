import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';

import '../../../utlis/functions.dart';
import '../../../widgets/text_widget.dart';
import '../../admin_hospital_pov/hospital_home.dart';

class NearTab extends StatefulWidget {
  double mylat;

  double mylong;

  NearTab({super.key, required this.mylat, required this.mylong});

  @override
  State<NearTab> createState() => _NearTabState();
}

class _NearTabState extends State<NearTab> {
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarth = 6371; // in kilometers
    double latDistance = degreesToRadians(lat2 - lat1);
    double lonDistance = degreesToRadians(lon2 - lon1);
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radiusOfEarth * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Hospital').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              )),
            );
          }

          final data = snapshot.requireData;
          final sortedData = List<QueryDocumentSnapshot>.from(data.docs);

          sortedData.sort((a, b) {
            final double lat1 = a['lat'];
            final double long1 = a['long'];
            final double lat2 = b['lat'];
            final double long2 = b['long'];

            final double distance1 =
                calculateDistance(widget.mylat, widget.mylong, lat1, long1);
            final double distance2 =
                calculateDistance(widget.mylat, widget.mylong, lat2, long2);

            return distance1.compareTo(distance2); // Compare in reverse order
          });
          return Expanded(
              child: GridView.builder(
            itemCount: data.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primary,
                      ),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          data.docs[index]['logo'],
                          height: 125,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          text: data.docs[index]['name'],
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        FutureBuilder<dynamic>(
                            future: getAddress(data.docs[index]['lat'],
                                data.docs[index]['long']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  'Loading...', // or any other placeholder text
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.red),
                                );
                              } else {
                                return TextWidget(
                                  text: snapshot.data ?? '',
                                  fontSize: 12,
                                  color: Colors.black,
                                );
                              }
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          text:
                              '${calculateDistance(widget.mylat, widget.mylong, data.docs[index]['lat'], data.docs[index]['long']).toStringAsFixed(2)}km away',
                          fontSize: 16,
                          color: primary,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ButtonWidget(
                          width: 200,
                          color: primary,
                          radius: 100,
                          label: 'View',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HospitalHomeScreen(
                                      inUser: true,
                                      id: data.docs[index].id,
                                    )));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ));
        });
  }
}
