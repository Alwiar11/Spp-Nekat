import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sppnekat/screen/class/class_list.dart';
import 'package:sppnekat/screen/majors/majors_list.dart';
import 'package:sppnekat/screen/operator/operator_list/operator_list.dart';
import 'package:sppnekat/screen/spp/spp.dart';
import 'package:sppnekat/screen/student/student_list/student_list.dart';
import 'package:sppnekat/screen/transaction_admin/transaction_admin.dart';
import 'package:sppnekat/shared/auth_service.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/size.dart';

import '../../shared/card_menu_admin.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(authService.getUId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
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
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Sizes(context).width * 0.05),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'Halo..' + userSnapshot.data!.get('name'),
                              style: const TextStyle(
                                  fontFamily: 'Herme',
                                  fontSize: 24,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              'Selamat Datang!',
                              style: TextStyle(
                                  fontFamily: 'Herme',
                                  fontSize: 24,
                                  letterSpacing: 1),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'operator')
                          .snapshots(),
                      builder: (context, petugasData) {
                        if (!petugasData.hasData) {
                          return SizedBox(
                            width: 180,
                            height: 150,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                )),
                          );
                        }
                        return CardMenuAdmin(
                          title: 'Petugas',
                          desc: 'Petugas',
                          info: petugasData.data!.docs.length.toString(),
                          icon: Icons.person,
                          route: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const OperatorList()));
                          },
                        );
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'student')
                          .snapshots(),
                      builder: (context, siswaData) {
                        if (!siswaData.hasData) {
                          return SizedBox(
                            width: 180,
                            height: 150,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                )),
                          );
                        }
                        return CardMenuAdmin(
                          title: 'Siswa',
                          desc: 'Siswa',
                          info: siswaData.data!.docs.length.toString(),
                          icon: Icons.person,
                          route: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const StudentList()));
                          },
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('transactions')
                          .snapshots(),
                      builder: (context, transactionData) {
                        if (!transactionData.hasData) {
                          return SizedBox(
                            width: 180,
                            height: 150,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                )),
                          );
                        }
                        return CardMenuAdmin(
                          title: 'Pembayaran',
                          desc: 'Pembayaran',
                          info: transactionData.data!.docs.length.toString(),
                          icon: Icons.attach_money,
                          route: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionAdmin()));
                          },
                        );
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('spp')
                          .where('isActive', isEqualTo: true)
                          .snapshots(),
                      builder: (context, sppData) {
                        if (!sppData.hasData) {
                          return SizedBox(
                            width: 180,
                            height: 150,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                )),
                          );
                        }
                        return Column(
                          children: [
                            ...sppData.data!.docs.map((e) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                height: 170,
                                width: Sizes(context).width * 0.45,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      darkBlue,
                                      lightBlue,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'SPP',
                                          style: TextStyle(
                                              fontFamily: 'Herme',
                                              fontSize: 18,
                                              letterSpacing: 1,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 160,
                                                child: Text(
                                                  'SPP Aktif',
                                                  style: TextStyle(
                                                      fontFamily: 'Herme',
                                                      color: Colors.white,
                                                      letterSpacing: 1,
                                                      fontSize: 16,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 160,
                                                child: Text(
                                                  CurrencyTextInputFormatter(
                                                          locale: 'id',
                                                          symbol: 'Rp.',
                                                          decimalDigits: 0)
                                                      .format(e.get('nominal')),
                                                  style: const TextStyle(
                                                      fontFamily: 'Herme',
                                                      color: Colors.white,
                                                      letterSpacing: 1,
                                                      fontSize: 24,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SPP()));
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  'Detail',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 1,
                                                      fontFamily: 'Herme',
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            })
                          ],
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('class')
                          .snapshots(),
                      builder: (context, classData) {
                        if (!classData.hasData) {
                          return SizedBox(
                            width: 180,
                            height: 150,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                )),
                          );
                        }
                        return CardMenuAdmin(
                          title: 'Kelas',
                          desc: 'Kelas',
                          info: classData.data!.docs.length.toString(),
                          icon: Icons.class_,
                          route: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ClassList()));
                          },
                        );
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('majors')
                          .snapshots(),
                      builder: (context, majorsData) {
                        if (!majorsData.hasData) {
                          return SizedBox(
                            width: 180,
                            height: 150,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                )),
                          );
                        }
                        return CardMenuAdmin(
                          title: 'Jurusan',
                          desc: 'Jurusan',
                          info: majorsData.data!.docs.length.toString(),
                          icon: Icons.work,
                          route: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MajorsList()));
                          },
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
