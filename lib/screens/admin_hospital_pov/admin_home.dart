import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medi_connect/services/add_hospital.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:medi_connect/widgets/drawer_widget.dart';
import 'package:medi_connect/widgets/toast_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../utlis/colors.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'hospital_home.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  final username = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final location = TextEditingController();
  final admin = TextEditingController();
  final number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
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
                  Container(
                    height: 40,
                    width: 600,
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
                    width: 20,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFieldWidget(
                                      borderColor: primary,
                                      label: 'Hospital Username',
                                      controller: username,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFieldWidget(
                                      isObscure: true,
                                      borderColor: primary,
                                      label: 'Hospital Password',
                                      controller: password,
                                      showEye: true,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFieldWidget(
                                      borderColor: primary,
                                      label: 'Hospital Name',
                                      controller: name,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFieldWidget(
                                      borderColor: primary,
                                      label: 'Hospital Admin',
                                      controller: admin,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFieldWidget(
                                      borderColor: primary,
                                      label: 'Hospital Location',
                                      controller: location,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFieldWidget(
                                      borderColor: primary,
                                      label: 'Contact Number',
                                      controller: number,
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    ButtonWidget(
                                      radius: 10,
                                      color: primary,
                                      width: 175,
                                      label: 'Create',
                                      onPressed: () {
                                        register(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Hospital')
                      .where('name',
                          isGreaterThanOrEqualTo:
                              toBeginningOfSentenceCase(nameSearched))
                      .where('name',
                          isLessThan:
                              '${toBeginningOfSentenceCase(nameSearched)}z')
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

                    final data = snapshot.requireData;
                    return DataTable(columns: [
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
                          text: 'Options',
                          fontSize: 18,
                          fontFamily: 'Bold',
                        ),
                      ),
                    ], rows: [
                      for (int i = 0; i < data.docs.length; i++)
                        DataRow(cells: [
                          DataCell(Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 50,
                              height: 75,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(data.docs[i]['logo']),
                                      fit: BoxFit.cover),
                                  color: Colors.grey,
                                  shape: BoxShape.circle),
                            ),
                          )),
                          DataCell(
                            TextWidget(
                              text: data.docs[i]['name'] == ''
                                  ? '"Not available"'
                                  : data.docs[i]['name'],
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HospitalHomeScreen(
                                                  inAdmin: true,
                                                  id: data.docs[i].id,
                                                )));
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
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Delete Confirmation',
                                                style: TextStyle(
                                                    fontFamily: 'QBold',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this hospital?',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular'),
                                              ),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                    'Close',
                                                    style: TextStyle(
                                                        fontFamily: 'QRegular',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Hospital')
                                                        .doc(data.docs[i].id)
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                        fontFamily: 'QRegular',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                ),
                              ],
                            ),
                          )),
                        ])
                    ]);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  register(context) async {
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: '${username.text}@connect.com', password: password.text);

      addHospital('${username.text}@connect.com', name.text, '', [], [], 0,
          user.user!.uid, '', admin.text, number.text, location.text);

      showToast('Account created succesfully!');
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showToast('The email address is not valid.');
      } else {
        showToast(e.toString());
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
