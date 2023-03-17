import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/screen/student/add_student/add_student.dart';
import 'package:sppnekat/screen/student/student_detail/student_detail.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/dialog_loading.dart';

import '../../../shared/size.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final List<String> level = [
    'Lulus',
    '10',
    '11',
    '12',
    '13',
  ];

  String? selectedLevel;
  String? selectedClass;
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
                      builder: (context) => const AddStudent()));
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
        title: const Text(
          'Siswa',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'student')
              .where('level', isEqualTo: selectedLevel)
              .where('class', isEqualTo: selectedClass)
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
                              selectedClass = null;
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
                            .collection('class')
                            .where('level', isEqualTo: selectedLevel)
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
                                  'Kelas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    fontFamily: "Herme",
                                    color: Colors.white,
                                  ),
                                ),
                                items: snapshot.data!.docs
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.get('level') +
                                              ' ' +
                                              item.get('name'),
                                          child: Text(
                                            item.get('level') +
                                                ' ' +
                                                item.get('name'),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Herme",
                                                letterSpacing: 1,
                                                color: Colors.white),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedClass,
                                onChanged: selectedLevel != null
                                    ? selectedLevel != 'Lulus'
                                        ? (value2) {
                                            setState(() {
                                              selectedClass = value2 as String;
                                            });
                                          }
                                        : null
                                    : null,
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
                            selectedClass = null;
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
                  'Jumlah Siswa : ${snapshot.data!.docs.length}',
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
                        'Tidak Ada Siswa',
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
                                    builder: (context) => DetailStudent(
                                          id: e.id,
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
                                            text: 'Apa kamu yakin hapus?',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnText: 'Hapus',
                                            confirmBtnColor: Colors.red,
                                            onConfirmBtnTap: () async {
                                              Navigator.of(context).pop();
                                              DialogLoading(context)
                                                  .showLoading();
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(e.id)
                                                  .delete();
                                              FirebaseFirestore.instance
                                                  .collection('transactions')
                                                  .where('payer',
                                                      isEqualTo: e.id)
                                                  .get()
                                                  .then((value) {
                                                for (var doc in value.docs) {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'transactions')
                                                      .doc(doc.id)
                                                      .delete();
                                                }
                                              });

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
                                                      'Berhasil Menghapus Siswa',
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
                                          Icons.person,
                                          size: 35,
                                          color: darkBlue,
                                        ),
                                      ),
                                      subtitle: Text(
                                        e.get('class'),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1,
                                            fontFamily: 'Herme'),
                                      ),
                                      title: Text(
                                        e.get('name'),
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
