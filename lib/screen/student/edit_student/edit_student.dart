import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/input_transaction.dart';
import '../../../shared/dialog_loading.dart';
import '../../../shared/size.dart';

class EditStudent extends StatefulWidget {
  final String id;
  const EditStudent({
    required this.id,
    super.key,
  });

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {});
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .get()
        .then((doc) {
      nisnController = TextEditingController(text: doc.get('nisn'));
      nameController = TextEditingController(text: doc.get('name'));
      classController = TextEditingController(text: doc.get('class'));
      emailController = TextEditingController(text: doc.get('email'));
    });
    setState(() {});
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController nisnController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? selectedMajors;
  String? selectedClass;
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
          'Edit Siswa',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: Sizes(context).width * 0.05),
        child: Column(
          children: [
            InputTransaction(
              label: "Nama Lengkap",
              controller: nameController,
              enabled: false,
              suffix: '',
            ),
            InputTransaction(
              label: "NISN",
              controller: nisnController,
              enabled: false,
              suffix: '',
            ),
            InputTransaction(
              label: "Email",
              controller: emailController,
              enabled: false,
              suffix: '',
            ),
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
                                        selectedClass = null;
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
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('class')
                    .where('majors', isEqualTo: selectedMajors)
                    .where('level', isEqualTo: selectedLevel)
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
                                            ' ' +
                                            item.get('name'),
                                        child: Text(
                                          item.get('level') +
                                              ' ' +
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
                              onChanged: selectedMajors != null
                                  ? (value) {
                                      setState(() {
                                        selectedClass = value as String;
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
                            value: selectedClass,
                            onChanged: selectedMajors != null
                                ? (value) {
                                    setState(() {
                                      selectedClass = value as String;
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
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                if (classController.text.isEmpty ||
                    selectedClass == null ||
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
                  CoolAlert.show(
                    barrierDismissible: false,
                    context: context,
                    type: CoolAlertType.confirm,
                    title: 'Peringatan',
                    text: 'Apa kamu yakin ubah?',
                    cancelBtnText: 'Kembali',
                    confirmBtnText: 'Ubah',
                    confirmBtnColor: lightBlue,
                    onConfirmBtnTap: () async {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.id)
                          .update({
                        'class': selectedClass.toString(),
                        'level': selectedLevel.toString(),
                      });

                      final snackBar = SnackBar(
                        elevation: 0,
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          color: darkBlue,
                          title: 'Berhasil',
                          message: 'Berhasil Memperbaharui Siswa',
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
      )),
    );
  }
}
