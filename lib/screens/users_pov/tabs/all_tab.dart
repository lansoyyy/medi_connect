import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../../utlis/functions.dart';
import '../../../widgets/text_widget.dart';
import '../../admin_hospital_pov/hospital_home.dart';

class AllTab extends StatefulWidget {
  const AllTab({super.key});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  final searchController = TextEditingController();
  String nameSearched = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 500,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'Regular', fontSize: 14),
                  onChanged: (value) {
                    setState(() {
                      nameSearched = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintText: 'Search Hospital',
                      hintStyle: TextStyle(fontFamily: 'QRegular'),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                  controller: searchController,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Hospital')
                .where('name',
                    isGreaterThanOrEqualTo:
                        toBeginningOfSentenceCase(nameSearched))
                .where('name',
                    isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return SizedBox(
                  height: 450,
                  child: GridView.builder(
                    itemCount: data.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                              fontSize: 12,
                                              color: Colors.black),
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
                                  height: 25,
                                ),
                                ButtonWidget(
                                  width: 200,
                                  color: primary,
                                  radius: 100,
                                  label: 'View',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HospitalHomeScreen(
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
            }),
      ],
    );
  }
}
