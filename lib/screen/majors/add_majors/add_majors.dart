import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import 'package:sppnekat/shared/dialog_loading.dart';

import '../../../shared/color.dart';
import '../../../shared/size.dart';

class AddMajors extends StatefulWidget {
  const AddMajors({super.key});

  @override
  State<AddMajors> createState() => _AddMajorsState();
}

class _AddMajorsState extends State<AddMajors> {
  List<String> level = [
    '10',
    '11',
    '12',
    '13',
  ];
  List<String> selectedLevel = [];
  bool select = false;
  TextEditingController classController = TextEditingController();
  String? selectedMajors;

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
          'Tambah Jurusan',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Sizes(context).width * 0.05),
        child: Column(
          children: [
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  selectedLevel = x;
                });
              },
              options: level,
              selectedValues: selectedLevel,
              whenEmpty: 'Pilih Tingkat',
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20,
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
                        hintText: 'Contoh : RPL',
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
                  height: Sizes(context).height * 0.05,
                )
              ],
            ),
            InkWell(
              onTap: () async {
                DialogLoading(context).showLoading();
                if (select || classController.text.isEmpty) {
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
                      .collection('majors')
                      .where('name', isEqualTo: classController.text)
                      .get()
                      .then((value) {
                    if (value.docs.isNotEmpty) {
                      Navigator.of(context).pop();
                      CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.error,
                        title: 'Peringatan',
                        text: 'Jurusan Sudah Tersedia!',
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
                          FirebaseFirestore.instance.collection('majors').add({
                            'level': FieldValue.arrayUnion(
                              selectedLevel,
                            ),
                            'name': classController.text.trim(),
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
