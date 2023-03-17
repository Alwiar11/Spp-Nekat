import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/size.dart';

class OldSpp extends StatelessWidget {
  const OldSpp({super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate(Timestamp timeStamp) {
      var dateFromTimeStamp =
          DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
      return DateFormat('d MMM y').format(dateFromTimeStamp);
    }

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
          'Riwayat SPP',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('spp')
                .where('isActive', isEqualTo: false)
                .orderBy('endFromDate', descending: true)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  width: Sizes(context).width * 1,
                  height: Sizes(context).height * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                          color: lightBlue, size: 80),
                      SizedBox(
                        height: Sizes(context).height * 0.2,
                      )
                    ],
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Column(
                  children: const [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: Text(
                      'Tidak Ada Data SPP',
                      style: TextStyle(
                          fontFamily: 'Herme',
                          letterSpacing: 1,
                          fontSize: 24,
                          color: Colors.black),
                    ))
                  ],
                );
              }
              return Column(
                children: [
                  ...snapshot.data!.docs.map((e) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(15),
                        width: Sizes(context).width * 0.9,
                        height: Sizes(context).height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'SPP Tidak Aktif',
                                  style: TextStyle(
                                      fontFamily: 'Herme',
                                      letterSpacing: 1,
                                      fontSize: 28,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      CurrencyTextInputFormatter(
                                              locale: 'id',
                                              symbol: 'Rp.',
                                              decimalDigits: 0)
                                          .format(e.get('nominal')),
                                      style: const TextStyle(
                                          fontFamily: 'Herme',
                                          letterSpacing: 1,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${formattedDate(e.get('startFromDate'))} - ${formattedDate(e.get('endFromDate'))}",
                                      style: const TextStyle(
                                          fontFamily: 'Herme',
                                          letterSpacing: 1,
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 195, 195, 195)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
      ),
    );
  }
}
