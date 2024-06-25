import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medi_connect/screens/admin_hospital_pov/hospital_home.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:medi_connect/widgets/drawer_widget.dart';
import 'package:medi_connect/widgets/hospital_drawer_widget.dart';
import 'package:medi_connect/widgets/text_widget.dart';
import 'package:medi_connect/widgets/textfield_widget.dart';

import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class HospitalServicesPage extends StatefulWidget {
  String id;

  HospitalServicesPage({super.key, required this.id});

  @override
  State<HospitalServicesPage> createState() => _HospitalServicesPageState();
}

class _HospitalServicesPageState extends State<HospitalServicesPage> {
  final servicesname = TextEditingController();
  final editServicesname = TextEditingController();

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
                        controller: servicesname, label: 'Name of Service'),
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
                          .doc(widget.id)
                          .update({
                        'services': FieldValue.arrayUnion([servicesname.text]),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextWidget(
                      text: 'Available Services',
                      fontSize: 32,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DataTable(columns: [
                  DataColumn(
                    label: TextWidget(
                      text: 'Name of Service',
                      fontSize: 18,
                      fontFamily: 'Bold',
                    ),
                  ),
                  DataColumn(
                    label: TextWidget(
                      text: 'Option',
                      fontSize: 18,
                      fontFamily: 'Bold',
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
                  for (int i = 0; i < data['services'].length; i++)
                    DataRow(cells: [
                      DataCell(
                        TextWidget(
                          text: data['services'][i],
                          fontSize: 18,
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonWidget(
                            color: Colors.green,
                            label: 'Edit',
                            onPressed: () {
                              editServicesname.text = data['services'][i];
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFieldWidget(
                                            controller: editServicesname,
                                            label: 'Edit Service Name'),
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
                                              .doc(widget.id)
                                              .update({
                                            'services': FieldValue.arrayRemove(
                                                [data['services'][i]]),
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('Hospital')
                                              .doc(widget.id)
                                              .update({
                                            'services': FieldValue.arrayUnion(
                                                [editServicesname.text]),
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
                          ),
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
                                'services': FieldValue.arrayRemove(
                                    [data['services'][i]]),
                              });
                            },
                          ),
                        ),
                      ),
                    ])
                ])
              ],
            );
          }),
    );
  }
}
