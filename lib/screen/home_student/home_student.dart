import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sppnekat/shared/card_transaction_student.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/format_date.dart';
import 'package:sppnekat/shared/loading.dart';
import 'package:sppnekat/shared/size.dart';

import '../../shared/auth_service.dart';

class HomeStudent extends StatefulWidget {
  const HomeStudent({super.key});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  final List<String> status = [
    'Belum Lunas',
    'Lunas',
  ];
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
  String? selectedStatus;
  String? selectedMonth;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .where('payer', isEqualTo: authService.getUId)
              .where(
                'status',
                isEqualTo: selectedStatus,
              )
              .where(
                'monthBill',
                isEqualTo: selectedMonth,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes(context).width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(authService.getUId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const Loading();
                        }
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: Sizes(context).width * 0.8,
                                  child: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    'Halo.. ' + userSnapshot.data!.get('name'),
                                    style: const TextStyle(
                                        overflow: TextOverflow.fade,
                                        fontFamily: 'Herme',
                                        fontSize: 24,
                                        letterSpacing: 1),
                                  ),
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
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                                'Status',
                                style: TextStyle(
                                  fontFamily: "Herme",
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              items: status
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
                              value: selectedStatus,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 120,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                        Container(
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
                                'Bulan',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  fontFamily: "Herme",
                                  color: Colors.white,
                                ),
                              ),
                              items: bulan
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Herme",
                                              letterSpacing: 1,
                                              color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedMonth,
                              onChanged: (value2) {
                                setState(() {
                                  selectedMonth = value2 as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 120,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedStatus = null;
                                selectedMonth = null;
                              });
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'Hapus Filter',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Herme",
                                      letterSpacing: 1,
                                      color: Colors.red),
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (snapshot.data!.docs.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Belum Ada Pembayaran',
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
                          return Center(
                            child: Column(
                              children: [
                                CardTransactionStudent(
                                  payerName: e.get('payerName'),
                                  payerClass: e.get('class'),
                                  monthBill: e.get('monthBill'),
                                  yearBill: e.get('yearBill'),
                                  dateTransaction: FormatDate()
                                      .formattedDate(e.get('dateTransaction')),
                                  status: e.get('status'),
                                  id: e.id,
                                  nominal: e.get('nominal'),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
