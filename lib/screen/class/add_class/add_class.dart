import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import '../../../shared/color.dart';
import '../../../shared/dialog_loading.dart';

import '../../../shared/size.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  TextEditingController classController = TextEditingController();
  String? selectedMajors;
  String? selectedLevel;
  List<String> error = ['Tidak Ada Data'];
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
          'Tambah Kelas',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Sizes(context).width * 0.05),
        child: Column(
          children: [
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('level')
                    .orderBy('name', descending: false)
                    .get(),
                builder: (context, dataLevel) {
                  if (dataLevel.hasData) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Tingkat',
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
                              items: dataLevel.data!.docs
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.get('name'),
                                        child: Text(
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
                              value: selectedLevel,
                              onChanged: (value) {
                                setState(() {
                                  selectedLevel = value as String;
                                  selectedMajors = null;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 120,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Sizes(context).height * 0.015,
                        )
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Tingkat',
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
                            items: error
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          color: Colors.black,
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
                      SizedBox(
                        height: Sizes(context).height * 0.015,
                      )
                    ],
                  );
                }),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('majors')
                    .where('level', arrayContains: selectedLevel)
                    .get(),
                builder: (context, datamajors) {
                  if (datamajors.hasData) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Jurusan',
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
                              items: datamajors.data!.docs
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.get('name'),
                                        child: Text(
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
                              value: selectedMajors,
                              onChanged: selectedLevel != null
                                  ? (value) {
                                      setState(() {
                                        selectedMajors = value as String;
                                      });
                                    }
                                  : null,
                              buttonHeight: 40,
                              buttonWidth: 120,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Sizes(context).height * 0.015,
                        )
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Jurusan',
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
                            items: error
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'herme',
                                          letterSpacing: 1,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedMajors,
                            onChanged: selectedLevel != null
                                ? (value) {
                                    setState(() {
                                      selectedMajors = value as String;
                                    });
                                  }
                                : null,
                            buttonHeight: 40,
                            buttonWidth: 120,
                            itemHeight: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Sizes(context).height * 0.015,
                      )
                    ],
                  );
                }),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Kelas',
                      style: TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1, fontSize: 18),
                    ),
                  ],
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: Sizes(context).width * 0.9,
                  height: 50,
                  child: TextFormField(
                    style:
                        const TextStyle(fontFamily: 'Herme', letterSpacing: 1),
                    controller: classController,
                    decoration: const InputDecoration(
                        hintText: 'Contoh : RPL 2',
                        enabled: true,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffADADAD))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Color(0xffADADAD)))),
                  ),
                ),
                SizedBox(
                  height: Sizes(context).height * 0.015,
                )
              ],
            ),
            InkWell(
              onTap: () async {
                DialogLoading(context).showLoading();
                if (classController.text.isEmpty ||
                    selectedLevel == null ||
                    selectedMajors == null) {
                  DialogLoading(context).showLoading();
                  final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Icon(
                              Icons.info,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Isi Terlebih Dahulu',
                            style: TextStyle(
                              fontFamily: 'Herme',
                              letterSpacing: 1,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                } else {
                  FirebaseFirestore.instance
                      .collection('class')
                      .where('name', isEqualTo: classController.text)
                      .where('level', isEqualTo: selectedLevel)
                      .where('majors', isEqualTo: selectedMajors)
                      .get()
                      .then((value) {
                    if (value.docs.isNotEmpty) {
                      Navigator.of(context).pop();
                      CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.error,
                        title: 'Peringatan',
                        text: 'Kelas Sudah Tersedia!',
                        cancelBtnText: 'Kembali',
                        confirmBtnText: 'Oke',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.confirm,
                        title: 'Peringatan',
                        text: 'Apa anda yakin menambah jurusan?',
                        cancelBtnText: 'Kembali',
                        confirmBtnText: 'Simpan',
                        confirmBtnColor: lightBlue,
                        onConfirmBtnTap: () async {
                          DialogLoading(context).showLoading();

                          FirebaseFirestore.instance.collection('class').add({
                            'name': classController.text.trim(),
                            'level': selectedLevel,
                            'majors': selectedMajors,
                          });

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          final snackBar = SnackBar(
                            elevation: 0,
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              color: darkBlue,
                              title: 'Berhasil',
                              message: 'Berhasil Menambah Jurusan',
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  });
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
                      'Simpan',
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
        ),
      ),
    );
  }
}
