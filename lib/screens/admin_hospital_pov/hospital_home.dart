import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/services/add_appointment.dart';
import 'package:medi_connect/services/add_room.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';
import 'package:medi_connect/widgets/hospital_drawer_widget.dart';
import 'package:medi_connect/widgets/text_widget.dart';
import 'package:medi_connect/widgets/textfield_widget.dart';
import 'package:medi_connect/widgets/toast_widget.dart';

import '../../utlis/functions.dart';

class HospitalHomeScreen extends StatefulWidget {
  String id;
  bool inUser;
  double? mylat;

  double? mylong;

  bool? inAdmin;

  HospitalHomeScreen(
      {super.key,
      required this.id,
      this.inAdmin = false,
      this.inUser = false,
      this.mylat,
      this.mylong});

  @override
  State<HospitalHomeScreen> createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  bool inAll = true;
  bool inNear = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final name = TextEditingController();

  final description = TextEditingController();

  final doctorname = TextEditingController();

  final doctorjob = TextEditingController();
  final servicesname = TextEditingController();
  final roomname = TextEditingController();

  Marker marker = const Marker(markerId: MarkerId('1'));

  uploadToStorage() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child('newfile').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.id)
            .update({'logo': downloadUrl});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Hospital')
        .doc(widget.id)
        .snapshots();
    return Scaffold(
      drawer: widget.inUser || widget.inAdmin!
          ? null
          : HospitalDrawerWidget(
              id: widget.id,
            ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 50, 50),
        child: StreamBuilder<DocumentSnapshot>(
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

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.inUser || widget.inAdmin!
                            ? IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back))
                            : Builder(builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.menu,
                                  ),
                                );
                              }),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data['logo'] == ''
                                  ? GestureDetector(
                                      onTap: () {
                                        uploadToStorage();
                                      },
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        uploadToStorage();
                                      },
                                      child: CircleAvatar(
                                        minRadius: 35,
                                        maxRadius: 35,
                                        backgroundImage: NetworkImage(
                                            data['logo'].toString()),
                                      )),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: data['name'] == ''
                                        ? 'No name yet'
                                        : data['name'],
                                    fontSize: 48,
                                    color: primary,
                                    fontFamily: 'Bold',
                                  ),
                                  data['lat'] == 0
                                      ? const SizedBox()
                                      : FutureBuilder<dynamic>(
                                          future: getAddress(
                                              data['lat'], data['long']),
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
                                                    fontSize: 12,
                                                    color: Colors.red),
                                              );
                                            } else {
                                              return TextWidget(
                                                text: snapshot.data ?? '',
                                                fontSize: 12,
                                                color: Colors.black,
                                              );
                                            }
                                          }),
                                ],
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
                              polylines: widget.inUser
                                  ? {
                                      Polyline(
                                        color: Colors.red,
                                        points: [
                                          LatLng(widget.mylat!, widget.mylong!),
                                          LatLng(data['lat'], data['long']),
                                        ],
                                        polylineId: const PolylineId(
                                          '123',
                                        ),
                                      ),
                                    }
                                  : {},
                              markers: <Marker>{
                                Marker(
                                  markerId: const MarkerId('1'),
                                  position: LatLng(data['lat'], data['long']),
                                  infoWindow: InfoWindow(
                                    title: data['name'],
                                  ),
                                )
                              },
                              onTap: (argument) async {
                                if (!widget.inUser) {
                                  await FirebaseFirestore.instance
                                      .collection('Hospital')
                                      .doc(data.id)
                                      .update({
                                    'lat': argument.latitude,
                                    'long': argument.longitude
                                  });

                                  setState(() {});
                                }
                              },
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(widget.mylat ?? 8.1479,
                                    widget.mylong ?? 125.1321),
                                zoom: 14.4746,
                              ),
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
                                      text: data['name'] == ''
                                          ? 'No name yet'
                                          : data['name'],
                                      fontSize: 28,
                                      color: Colors.black,
                                      fontFamily: 'Bold',
                                    ),
                                    widget.inUser
                                        ? const SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFieldWidget(
                                                          controller: name,
                                                          label: 'Name',
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFieldWidget(
                                                            controller:
                                                                description,
                                                            label:
                                                                'Description'),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: TextWidget(
                                                          text: 'Close',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Hospital')
                                                              .doc(widget.id)
                                                              .update({
                                                            'name': name.text,
                                                            'desc': description
                                                                .text,
                                                          });
                                                          Navigator.pop(
                                                              context);
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
                                  text: data['desc'] == ''
                                      ? 'No description yet'
                                      : data['desc'],
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
                                    widget.inUser
                                        ? const SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFieldWidget(
                                                            controller:
                                                                servicesname,
                                                            label:
                                                                'Name of Service'),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: TextWidget(
                                                          text: 'Close',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Hospital')
                                                              .doc(widget.id)
                                                              .update({
                                                            'services':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              servicesname.text
                                                            ]),
                                                          });
                                                          Navigator.pop(
                                                              context);
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
                                    itemCount: data['services'].length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          TextWidget(
                                            text:
                                                '• ${data['services'][index]}',
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Medium',
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          widget.inUser
                                              ? const SizedBox()
                                              : IconButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Hospital')
                                                        .doc(widget.id)
                                                        .update({
                                                      'services': FieldValue
                                                          .arrayRemove([
                                                        data['services'][index]
                                                      ]),
                                                    });
                                                  },
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
                                Row(
                                  children: [
                                    TextWidget(
                                      text: 'Hospital Doctors',
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontFamily: 'Bold',
                                    ),
                                    widget.inUser
                                        ? const SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFieldWidget(
                                                            controller:
                                                                doctorname,
                                                            label:
                                                                'Name of Doctor'),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFieldWidget(
                                                            controller:
                                                                doctorjob,
                                                            label:
                                                                'Job of Doctor'),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: TextWidget(
                                                          text: 'Close',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Hospital')
                                                              .doc(widget.id)
                                                              .update({
                                                            'doctors': FieldValue
                                                                .arrayUnion([
                                                              '${doctorname.text} - ${doctorjob.text}'
                                                            ]),
                                                          });
                                                          Navigator.pop(
                                                              context);
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
                                    itemCount: data['doctors'].length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          TextWidget(
                                            text: '• ${data['doctors'][index]}',
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Medium',
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          widget.inUser
                                              ? const SizedBox()
                                              : IconButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Hospital')
                                                        .doc(widget.id)
                                                        .update({
                                                      'doctors': FieldValue
                                                          .arrayRemove([
                                                        data['doctors'][index]
                                                      ]),
                                                    });
                                                  },
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
                                Row(
                                  children: [
                                    TextWidget(
                                      text: 'Available Emergency Beds',
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontFamily: 'Bold',
                                    ),
                                    widget.inUser
                                        ? const SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFieldWidget(
                                                            controller:
                                                                roomname,
                                                            label:
                                                                'Name of Room'),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: TextWidget(
                                                          text: 'Close',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          addRoom(roomname.text,
                                                              widget.id);
                                                          Navigator.pop(
                                                              context);
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
                                  height: 100,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Rooms')
                                          .where('hospitalId',
                                              isEqualTo: widget.id)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          print(snapshot.error);
                                          return const Center(
                                              child: Text('Error'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Padding(
                                            padding: EdgeInsets.only(top: 50),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.black,
                                            )),
                                          );
                                        }

                                        final dataHospital =
                                            snapshot.requireData;
                                        return Column(
                                          children: [
                                            for (int i = 0;
                                                i < dataHospital.docs.length;
                                                i++)
                                              Row(
                                                children: [
                                                  TextWidget(
                                                    text:
                                                        '• ${dataHospital.docs[i]['name']}',
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontFamily: 'Medium',
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  widget.inUser
                                                      ? const SizedBox()
                                                      : IconButton(
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Rooms')
                                                                .doc(
                                                                    dataHospital
                                                                        .docs[i]
                                                                        .id)
                                                                .update({
                                                              'isAvailable':
                                                                  dataHospital.docs[
                                                                              i]
                                                                          [
                                                                          'isAvailable']
                                                                      ? false
                                                                      : true
                                                            });
                                                          },
                                                          icon: dataHospital
                                                                      .docs[i][
                                                                  'isAvailable']
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .check_box_outline_blank,
                                                                ),
                                                        ),
                                                ],
                                              ),
                                          ],
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  showAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'Booking an appointment',
            fontSize: 18,
            fontFamily: 'Bold',
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                  controller: nameController,
                  label: 'Name',
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: numberController,
                  label: 'Contact Number',
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: addressController,
                  label: 'Address',
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Date',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Bold',
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Bold',
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          dateFromPicker(context);
                        },
                        child: SizedBox(
                          width: 325,
                          height: 50,
                          child: TextFormField(
                            enabled: false,
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              color: primary,
                            ),

                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: primary,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              hintText: dateController.text,
                              border: InputBorder.none,
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              errorStyle: const TextStyle(
                                  fontFamily: 'Bold', fontSize: 12),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),

                            controller: dateController,
                            // Pass the validator to the TextFormField
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
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
                addAppointment(nameController.text, numberController.text,
                    addressController.text, widget.id, dateController.text);
                Navigator.pop(context);
                showToast('Appoint booked succesfully!');
              },
              child: TextWidget(
                text: 'Book',
                fontFamily: 'Bold',
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  final nameController = TextEditingController();
  final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final numberController = TextEditingController();
  final addressController = TextEditingController();

  void dateFromPicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primary,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        dateController.text = formattedDate;
      });
    } else {
      return null;
    }
  }
}
