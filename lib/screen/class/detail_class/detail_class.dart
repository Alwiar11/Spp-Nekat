import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../../shared/color.dart';
import '../../../shared/size.dart';
import '../upgrade_class/upgrade_class.dart';

class DetailClass extends StatefulWidget {
  final String title;
  final String level;
  final String majors;
  const DetailClass(
      {required this.title,
      required this.majors,
      required this.level,
      super.key});

  @override
  State<DetailClass> createState() => _DetailClassState();
}

class _DetailClassState extends State<DetailClass> {
  @override
  Widget build(BuildContext context) {
    // List<String> error = ['Tidak Ada Data'];
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpgradeClass(
                            title: widget.title,
                            level: widget.level,
                            majors: widget.majors,
                          )));
                },
                icon: const Icon(
                  Icons.upgrade,
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
          'Detail Kelas',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('class', isEqualTo: widget.title)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              children: const [
                Text('Tidak Ada Data'),
              ],
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Jumlah Siswa ${widget.title} = ${snapshot.data!.docs.length}",
                    style: const TextStyle(
                        fontFamily: 'Herme',
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ...snapshot.data!.docs.map((e) {
                  return Column(
                    children: [
                      Container(
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
                                  Icons.person,
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
                                        color: Colors.white,
                                        fontFamily: 'Herme',
                                        letterSpacing: 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
