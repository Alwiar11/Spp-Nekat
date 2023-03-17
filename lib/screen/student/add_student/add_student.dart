import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/dialog_loading.dart';

import 'package:sppnekat/shared/input_transaction.dart';
import 'package:sppnekat/shared/size.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nisnController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedMajors;
  String? selectedClass;
  String? selectedLevel;
  List<String> error = ['Tidak Ada Data'];
  bool _isShow = true;
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
          'Tambah Siswa',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: Sizes(context).width * 0.05),
          child: Column(
            children: [
              InputTransaction(
                label: "Nama Lengkap",
                controller: nameController,
                enabled: true,
                suffix: '',
              ),
              InputTransaction(
                label: "NISN",
                controller: nisnController,
                enabled: true,
                suffix: '',
              ),
              InputTransaction(
                label: "Email",
                controller: emailController,
                enabled: true,
                suffix: '',
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Kata Sandi',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Sizes(context).width * 0.9,
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: _isShow,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isShow
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                              color: const Color(0xffADADAD),
                            ),
                            onPressed: () {
                              setState(() {
                                _isShow = !_isShow;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD))),
                          hintStyle: const TextStyle(
                              fontFamily: 'Herme', fontSize: 16),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD)))),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
                onTap: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      nisnController.text.isEmpty ||
                      selectedLevel == null ||
                      selectedMajors == null ||
                      selectedClass == null) {
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
                      text: 'Apa kamu yakin menambah siswa?',
                      cancelBtnText: 'Kembali',
                      confirmBtnText: 'Simpan',
                      confirmBtnColor: lightBlue,
                      onConfirmBtnTap: () async {
                        Navigator.of(context).pop();
                        DialogLoading(context).showLoading();
                        FirebaseApp app = await Firebase.initializeApp(
                            name: 'Secondary', options: Firebase.app().options);
                        try {
                          UserCredential credential =
                              await FirebaseAuth.instanceFor(app: app)
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text
                                          .toString()
                                          .trim(),
                                      password: passwordController.text.trim());
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(credential.user!.uid)
                              .set({
                            'name': nameController.text.trim(),
                            'email': emailController.text.toString().trim(),
                            'nisn': nisnController.text.trim(),
                            'class': selectedClass.toString().trim(),
                            'role': 'student',
                            'level': selectedLevel,
                            'createAt': Timestamp.now()
                          });
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously

                          final snackBar = SnackBar(
                            elevation: 0,
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              color: darkBlue,
                              title: 'Berhasil',
                              message: 'Berhasil Menambahkan Siswa',
                              contentType: ContentType.success,
                            ),
                          );

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        } on FirebaseException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            // ignore: use_build_context_synchronously

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
                                      'Email Sudah Dipakai',
                                      style: TextStyle(
                                          fontFamily: 'Herme',
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (e.code == 'weak-password') {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            // ignore: use_build_context_synchronously

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
                                      'Kata Sandi Minimal 6 Karakter',
                                      style: TextStyle(
                                          fontFamily: 'Herme',
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                        await app.delete();
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
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
