import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/shared/color.dart';

import 'package:sppnekat/shared/size.dart';

class DetailOperator extends StatelessWidget {
  final String id;
  const DetailOperator({required this.id, super.key});

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
          'Detail Petugas',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(id).snapshots(),
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
          return Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: lightBlue),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data!.get('name'),
                        style: const TextStyle(
                          fontFamily: 'Herme',
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        snapshot.data!.get('email'),
                        style: const TextStyle(
                          color: Colors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
