import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/screen/class/add_class/add_class.dart';
import 'package:sppnekat/screen/class/detail_class/detail_class.dart';
import 'package:sppnekat/shared/color.dart';

import '../../shared/size.dart';

class ClassList extends StatefulWidget {
  const ClassList({super.key});

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  final List<String> level = [
    '10',
    '11',
    '12',
    '13',
  ];

  String? selectedLevel;
  String? selectedMajors;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddClass()));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                )),
          )
        ],
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        automaticallyImplyLeading: false,
        elevation: 0,
        // ignore: prefer_const_constructors
        title: Text(
          'Kelas',
          style: const TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('class')
              .where('level', isEqualTo: selectedLevel)
              .where('majors', isEqualTo: selectedMajors)
              .orderBy('name', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                width: Sizes(context).width * 1,
                height: Sizes(context).height * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Sizes(context).height * 0.25,
                    ),
                    LoadingAnimationWidget.fourRotatingDots(
                        color: lightBlue, size: 80),
                    SizedBox(
                      height: Sizes(context).height * 0.3,
                    )
                  ],
                ),
              );
            }
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            darkBlue,
                            lightBlue,
                          ],
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          dropdownDecoration:
                              const BoxDecoration(color: lightBlue),
                          iconEnabledColor: Colors.white,
                          hint: const Text(
                            'Tingkat',
                            style: TextStyle(
                              fontFamily: "Herme",
                              letterSpacing: 1,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          items: level
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'herme',
                                        letterSpacing: 1,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedLevel,
                          onChanged: (value) {
                            setState(() {
                              selectedLevel = value as String;
                            });
                          },
                          buttonHeight: 40,
                          buttonWidth: 120,
                          itemHeight: 40,
                        ),
                      ),
                    ),
                    FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('majors')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          }
                          return Container(
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  darkBlue,
                                  lightBlue,
                                ],
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                dropdownDecoration:
                                    const BoxDecoration(color: lightBlue),
                                iconEnabledColor: Colors.white,
                                hint: const Text(
                                  'Jurusan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    fontFamily: "Herme",
                                    color: Colors.white,
                                  ),
                                ),
                                items: snapshot.data!.docs
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.get('name'),
                                          child: Text(
                                            item.get('name'),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Herme",
                                                letterSpacing: 1,
                                                color: Colors.white),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedMajors,
                                onChanged: (value2) {
                                  setState(() {
                                    selectedMajors = value2 as String;
                                  });
                                },
                                buttonHeight: 40,
                                buttonWidth: 140,
                                itemHeight: 40,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedLevel = null;
                            selectedMajors = null;
                          });
                        },
                        child: Row(
                          children: const [
                            Text(
                              'Hapus Filter',
                              style: TextStyle(
                                  letterSpacing: 1,
                                  color: Colors.red,
                                  fontFamily: 'Herme'),
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Jumlah Kelas : ${snapshot.data!.docs.length}',
                  style: const TextStyle(
                      fontFamily: 'Herme', letterSpacing: 1, fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (snapshot.data!.docs.isEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Tidak Ada Kelas',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            fontSize: 24,
                            letterSpacing: 1),
                      ),
                    ],
                  )
                else
                  ...snapshot.data!.docs.map(
                    (e) {
                      return Column(
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailClass(
                                          title: e.get('level') +
                                              ' ' +
                                              e.get('name'),
                                          level: e.get('level'),
                                          majors: e.get('majors'),
                                        )));
                              },
                              child: Container(
                                width: Sizes(context).width * 0.95,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      darkBlue,
                                      lightBlue,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      trailing: IconButton(
                                        onPressed: () {
                                          CoolAlert.show(
                                            flareAsset:
                                                'assets/flare/error_check.flr',
                                            barrierDismissible: false,
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            title: 'Peringatan',
                                            text: 'Apa anda yakin hapus?',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnText: 'Hapus',
                                            confirmBtnColor: Colors.red,
                                            onConfirmBtnTap: () async {
                                              FirebaseFirestore.instance
                                                  .collection('class')
                                                  .doc(e.id)
                                                  .delete();

                                              final snackBar = SnackBar(
                                                elevation: 0,
                                                duration:
                                                    const Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: AwesomeSnackbarContent(
                                                  color: darkBlue,
                                                  title: 'Berhasil',
                                                  message:
                                                      'Berhasil Menghapus Kelas',
                                                  contentType:
                                                      ContentType.success,
                                                ),
                                              );

                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 25,
                                        child: Icon(
                                          Icons.class_,
                                          size: 35,
                                          color: darkBlue,
                                        ),
                                      ),
                                      title: Text(
                                        e.get('level') + " " + e.get('name'),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1,
                                            fontFamily: 'Herme'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
