import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/screen/spp/add_spp/add_spp.dart';
import 'package:sppnekat/shared/color.dart';

import '../../shared/size.dart';

class SPP extends StatefulWidget {
  const SPP({super.key});

  @override
  State<SPP> createState() => _SPPState();
}

class _SPPState extends State<SPP> {
  String formattedDate(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('d MMM y').format(dateFromTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddSpp()));
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 30,
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
            'SPP',
            style: TextStyle(
                fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('spp')
                .orderBy('startFromDate', descending: true)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(
                      height: Sizes(context).height * 0.03,
                    ),
                    ...snapshot.data!.docs
                        .where((element) => element.get('isActive') == true)
                        .map((e) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.get('year'),
                                    style: const TextStyle(
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
                                        "${formattedDate(e.get('startFromDate'))} - Sekarang",
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
                    ...snapshot.data!.docs
                        .where((element) => element.get('isActive') == false)
                        .map((e) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.get('year'),
                                    style: const TextStyle(
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
                                        "${formattedDate(e.get('startFromDate'))} - ${formattedDate(e.get('endFromDate'))} ",
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
                    })
                  ],
                );
              }
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
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
