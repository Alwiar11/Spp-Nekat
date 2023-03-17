import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sppnekat/shared/size.dart';

import '../../../shared/color.dart';
import '../../../shared/dialog_loading.dart';

class UpgradeClass extends StatefulWidget {
  final String title;
  final String level;
  final String majors;
  const UpgradeClass(
      {required this.title,
      required this.majors,
      required this.level,
      super.key});

  @override
  State<UpgradeClass> createState() => _UpgradeClassState();
}

class _UpgradeClassState extends State<UpgradeClass> {
  String? selectedClass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            'Naik Kelas',
            style: TextStyle(
                fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
          ),
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: Sizes(context).width * 0.05),
          child: Column(children: [
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('class')
                  .where('level', isGreaterThan: widget.level)
                  .where('majors', isEqualTo: widget.majors)
                  .get(),
              builder: (context, dataClass) {
                if (dataClass.hasData) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Kelas',
                            style: TextStyle(
                                fontFamily: 'Herme',
                                letterSpacing: 1,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: const Color(0xffADADAD), width: 2)),
                        width: Sizes(context).width * 0.9,
                        height: 55,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            iconEnabledColor: Colors.black,
                            hint: const Text(
                              '',
                              style: TextStyle(
                                fontFamily: "Herme",
                                letterSpacing: 1,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            items: dataClass.data!.docs
                                .map((item) => DropdownMenuItem<String>(
                                      value: item.get('level') +
                                          " " +
                                          item.get('name'),
                                      child: Text(
                                        item.get('level') +
                                            " " +
                                            item.get('name'),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'herme',
                                          letterSpacing: 1,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedClass,
                            onChanged: (value) {
                              setState(() {
                                selectedClass = value;
                              });
                            },
                            buttonHeight: 40,
                            buttonWidth: 120,
                            itemHeight: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (selectedClass != null) {
                                List level = selectedClass!.split(' ');
                                CoolAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  title: 'Peringatan',
                                  text: 'Apa kamu yakin Naik?',
                                  cancelBtnText: 'Kembali',
                                  confirmBtnText: 'Naik',
                                  confirmBtnColor: lightBlue,
                                  onConfirmBtnTap: () async {
                                    Navigator.of(context).pop();
                                    DialogLoading(context).showLoading();
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .where('class',
                                            isEqualTo: selectedClass)
                                        .get()
                                        .then((value) async {
                                      if (value.docs.isEmpty) {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .where('class',
                                                isEqualTo: widget.title)
                                            .get()
                                            .then((value) {
                                          for (var e in value.docs) {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(e.id)
                                                .update({
                                              'class': selectedClass.toString(),
                                              'level': level[0].toString(),
                                            });
                                          }
                                        });
                                        final snackBar = SnackBar(
                                          elevation: 0,
                                          duration: const Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: AwesomeSnackbarContent(
                                            color: darkBlue,
                                            title: 'Berhasil',
                                            message: 'Berhasil Naik Kelas',
                                            contentType: ContentType.success,
                                          ),
                                        );

                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(snackBar);
                                        // ignore: use_build_context_synchronously

                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      } else {
                                        Navigator.of(context).pop();
                                        CoolAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          type: CoolAlertType.error,
                                          title: 'Peringatan',
                                          text:
                                              'Kelas yang dituju masih terisi',
                                          cancelBtnText: 'Kembali',
                                          confirmBtnText: 'Oke',
                                          confirmBtnColor: Colors.red,
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }
                                    });
                                  },
                                );
                              } else {
                                CoolAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: 'Peringatan',
                                  text: 'Silahkan Isi Kelas Terlebih Dahulu',
                                  cancelBtnText: 'Kembali',
                                  confirmBtnText: 'Oke',
                                  confirmBtnColor: Colors.red,
                                  onConfirmBtnTap: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                            child: Container(
                              width: Sizes(context).width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    darkBlue,
                                    lightBlue,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Naik',
                                    style: TextStyle(
                                        fontFamily: 'Herme',
                                        fontSize: 24,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Sizes(context).height * 0.015,
                          ),
                          InkWell(
                            onTap: () async {
                              CoolAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: CoolAlertType.confirm,
                                title: 'Peringatan',
                                text: 'Apa kamu yakin Lulus?',
                                cancelBtnText: 'Kembali',
                                confirmBtnText: 'Lulus',
                                confirmBtnColor: lightBlue,
                                onConfirmBtnTap: () async {
                                  Navigator.of(context).pop();
                                  DialogLoading(context).showLoading();
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('class', isEqualTo: widget.title)
                                      .get()
                                      .then((value) {
                                    for (var e in value.docs) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(e.id)
                                          .update({
                                        'class': 'Lulus',
                                        'level': 'Lulus',
                                      });
                                    }
                                  });
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      color: darkBlue,
                                      title: 'Berhasil',
                                      message: 'Berhasil Lulus',
                                      contentType: ContentType.success,
                                    ),
                                  );

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            child: Container(
                              width: Sizes(context).width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    darkBlue,
                                    lightBlue,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Lulus',
                                    style: TextStyle(
                                        fontFamily: 'Herme',
                                        fontSize: 24,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
                return const SizedBox();
              },
            )
          ]),
        ));
  }
}
