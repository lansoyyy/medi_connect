import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medi_connect/screens/admin_hospital_pov/hospital_home.dart';
import 'package:medi_connect/services/add_room.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:medi_connect/widgets/drawer_widget.dart';
import 'package:medi_connect/widgets/hospital_drawer_widget.dart';
import 'package:medi_connect/widgets/text_widget.dart';
import 'package:medi_connect/widgets/textfield_widget.dart';

import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class HospitalBedPage extends StatefulWidget {
  String id;

  HospitalBedPage({super.key, required this.id});

  @override
  State<HospitalBedPage> createState() => _HospitalBedPageState();
}

class _HospitalBedPageState extends State<HospitalBedPage> {
  final roomname = TextEditingController();
  final servicesname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Hospital')
        .doc(widget.id)
        .snapshots();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldWidget(
                        controller: roomname, label: 'Name of Room'),
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
                      addRoom(roomname.text, widget.id);
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
      ),
      drawer: HospitalDrawerWidget(
        id: widget.id,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            dynamic data = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Builder(builder: (context) {
                        return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 100,
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
                              text: 'Medi Connect',
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
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Available Emergency Beds',
                      fontSize: 32,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Rooms')
                        .where('hospitalId', isEqualTo: widget.id)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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

                      final dataHospital = snapshot.requireData;
                      return DataTable(columns: [
                        DataColumn(
                          label: TextWidget(
                            text: 'Name of Room',
                            fontSize: 18,
                            fontFamily: 'Bold',
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              TextWidget(
                                text: 'Available',
                                fontSize: 12,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextWidget(
                                text: 'Occupied',
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: TextWidget(
                            text: 'Option',
                            fontSize: 18,
                            fontFamily: 'Bold',
                          ),
                        ),
                      ], rows: [
                        for (int i = 0; i < dataHospital.docs.length; i++)
                          DataRow(cells: [
                            DataCell(
                              TextWidget(
                                text: dataHospital.docs[i]['name'],
                                fontSize: 18,
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Rooms')
                                          .doc(dataHospital.docs[i].id)
                                          .update({
                                        'isAvailable': dataHospital.docs[i]
                                                ['isAvailable']
                                            ? false
                                            : true
                                      });
                                    },
                                    icon: dataHospital.docs[i]['isAvailable']
                                        ? const Icon(
                                            Icons.check_box,
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                          ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Rooms')
                                          .doc(dataHospital.docs[i].id)
                                          .update({
                                        'isAvailable': dataHospital.docs[i]
                                                ['isAvailable']
                                            ? false
                                            : true
                                      });
                                    },
                                    icon: !dataHospital.docs[i]['isAvailable']
                                        ? const Icon(
                                            Icons.check_box,
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ButtonWidget(
                                  color: Colors.red,
                                  label: 'Delete',
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('Hospital')
                                        .doc(widget.id)
                                        .update({
                                      'rooms': FieldValue.arrayRemove(
                                          [dataHospital.docs[i]['name']]),
                                    });
                                  },
                                ),
                              ),
                            ),
                          ])
                      ]);
                    })
                // SizedBox(
                //   height: 300,
                //   child: StreamBuilder<QuerySnapshot>(
                //       stream: FirebaseFirestore.instance
                //           .collection('Rooms')
                //           .where('hospitalId', isEqualTo: widget.id)
                //           .snapshots(),
                //       builder: (BuildContext context,
                //           AsyncSnapshot<QuerySnapshot> snapshot) {
                //         if (snapshot.hasError) {
                //           print(snapshot.error);
                //           return const Center(child: Text('Error'));
                //         }
                //         if (snapshot.connectionState ==
                //             ConnectionState.waiting) {
                //           return const Padding(
                //             padding: EdgeInsets.only(top: 50),
                //             child: Center(
                //                 child: CircularProgressIndicator(
                //               color: Colors.black,
                //             )),
                //           );
                //         }

                //         final dataHospital = snapshot.requireData;
                //         return Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             for (int i = 0; i < dataHospital.docs.length; i++)
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   TextWidget(
                //                     text: '• ${dataHospital.docs[i]['name']}',
                //                     fontSize: 16,
                //                     color: Colors.grey,
                //                     fontFamily: 'Medium',
                //                   ),
                //                   const SizedBox(
                //                     width: 10,
                //                   ),

                //                 ],
                //               ),
                //           ],
                //         );
                //       }),
                // ),
              ],
            );
          }),
    );
  }
}
