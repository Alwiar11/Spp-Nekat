import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:sppnekat/shared/color.dart';

import 'package:sppnekat/shared/size.dart';

import '../../../shared/dialog_loading.dart';

class AddSpp extends StatefulWidget {
  const AddSpp({
    super.key,
  });

  @override
  State<AddSpp> createState() => _AddSppState();
}

class _AddSppState extends State<AddSpp> {
  final List<String> bulan = [
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
  ];
  TextEditingController sppController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  CurrencyTextInputFormatter inputFormatter =
      CurrencyTextInputFormatter(locale: 'id', symbol: '', decimalDigits: 0);
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
          'Tambah SPP',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Sizes(context).width * 0.05),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Tahun Awal',
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
                    controller: startController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffADADAD))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Color(0xffADADAD)))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Tahun Akhir',
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
                    controller: endController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffADADAD))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Color(0xffADADAD)))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Nominal',
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
                    inputFormatters: [inputFormatter],
                    style:
                        const TextStyle(fontFamily: 'Herme', letterSpacing: 1),
                    controller: sppController,
                    decoration: const InputDecoration(
                        prefix: Text('Rp.'),
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
                ),
                InkWell(
                  onTap: () {
                    if (sppController.text.isEmpty) {
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
                                'Silahkan Isi Data Terlebih Dahulu',
                                style: TextStyle(fontFamily: 'Herme'),
                              ),
                            ],
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.confirm,
                        title: 'Peringatan',
                        text: 'Apa kamu yakin perbaharui SPP?',
                        cancelBtnText: 'Batal',
                        confirmBtnText: 'Simpan',
                        confirmBtnColor: lightBlue,
                        onConfirmBtnTap: () {
                          DialogLoading(context).showLoading();
                          FirebaseFirestore.instance
                              .collection('spp')
                              .where('isActive', isEqualTo: true)
                              .get()
                              .then((value) {
                            if (value.docs.isEmpty) {
                              FirebaseFirestore.instance.collection('spp').add({
                                'nominal': inputFormatter
                                    .getUnformattedValue()
                                    .toString(),
                                'year':
                                    '${startController.text} - ${endController.text}',
                                'isActive': true,
                                'startFromDate': Timestamp.now()
                              });
                            } else {
                              for (var element in value.docs) {
                                FirebaseFirestore.instance
                                    .collection('spp')
                                    .doc(element.id)
                                    .update({
                                  'isActive': false,
                                  'endFromDate': Timestamp.now()
                                });
                                FirebaseFirestore.instance
                                    .collection('spp')
                                    .add({
                                  'nominal': inputFormatter
                                      .getUnformattedValue()
                                      .toString(),
                                  'year':
                                      '${startController.text} - ${endController.text}',
                                  'isActive': true,
                                  'startFromDate': Timestamp.now()
                                });
                              }
                            }
                          });
                          Navigator.of(context).pop();
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
                              message: 'SPP Berhasil Diperbaharui',
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
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
          ],
        ),
      ),
    );
  }
}
