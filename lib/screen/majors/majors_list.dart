import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/screen/majors/add_majors/add_majors.dart';
import 'package:sppnekat/shared/color.dart';

import '../../shared/size.dart';
import 'detail_majors.dart/detail_majors.dart';

class MajorsList extends StatelessWidget {
  const MajorsList({super.key});

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
                      builder: (context) => const AddMajors()));
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
          'Jurusan',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('majors')
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
                Text(
                  'Jumlah Jurusan : ${snapshot.data!.docs.length}',
                  style: const TextStyle(
                      fontFamily: 'Herme', letterSpacing: 1, fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                ...snapshot.data!.docs.map(
                  (e) {
                    return Column(
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailMajors(
                                        title: e.get('name'),
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
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      child: Icon(
                                        Icons.work,
                                        size: 35,
                                        color: darkBlue,
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.get('name'),
                                          style: const TextStyle(
                                              fontFamily: 'Herme',
                                              letterSpacing: 1,
                                              color: Colors.white),
                                        ),
                                        IconButton(
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
                                                FirebaseFirestore.instance
                                                    .collection('majors')
                                                    .doc(e.id)
                                                    .delete();

                                                final snackBar = SnackBar(
                                                  elevation: 0,
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    color: darkBlue,
                                                    title: 'Berhasil',
                                                    message:
                                                        'Berhasil Menghapus Jurusan',
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
                                        )
                                      ],
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
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
