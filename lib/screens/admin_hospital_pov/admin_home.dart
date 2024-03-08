import 'package:flutter/material.dart';
import 'package:medi_connect/widgets/button_widget.dart';

import '../../utlis/colors.dart';
import '../../widgets/text_widget.dart';
import 'hospital_home.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
        child: SingleChildScrollView(
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
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 40,
                width: 750,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Regular',
                        fontSize: 14),
                    onChanged: (value) {
                      setState(() {
                        nameSearched = value;
                      });
                    },
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(fontFamily: 'QRegular'),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        )),
                    controller: searchController,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DataTable(columns: [
                DataColumn(
                  label: TextWidget(
                    text: 'Logo',
                    fontSize: 18,
                    fontFamily: 'Bold',
                  ),
                ),
                DataColumn(
                  label: TextWidget(
                    text: 'Hospital Name',
                    fontSize: 18,
                    fontFamily: 'Bold',
                  ),
                ),
                DataColumn(
                  label: TextWidget(
                    text: 'Hospital Address',
                    fontSize: 18,
                    fontFamily: 'Bold',
                  ),
                ),
                DataColumn(
                  label: TextWidget(
                    text: 'Options',
                    fontSize: 18,
                    fontFamily: 'Bold',
                  ),
                ),
              ], rows: [
                for (int i = 0; i < 50; i++)
                  DataRow(cells: [
                    DataCell(Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 50,
                        height: 75,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                      ),
                    )),
                    DataCell(
                      TextWidget(
                        text: 'Sample',
                        fontSize: 14,
                      ),
                    ),
                    DataCell(
                      TextWidget(
                        text: 'Sample',
                        fontSize: 14,
                      ),
                    ),
                    DataCell(SizedBox(
                      width: 400,
                      child: Row(
                        children: [
                          ButtonWidget(
                            color: Colors.green,
                            radius: 100,
                            width: 150,
                            height: 40,
                            fontSize: 14,
                            label: 'View',
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const HospitalHomeScreen()));
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ButtonWidget(
                            color: Colors.red,
                            radius: 100,
                            width: 150,
                            height: 40,
                            fontSize: 14,
                            label: 'Delete',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    )),
                  ])
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
