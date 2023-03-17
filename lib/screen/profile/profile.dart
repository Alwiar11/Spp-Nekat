import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sppnekat/screen/on_boarding/on_boarding.dart';
import 'package:sppnekat/shared/auth_service.dart';
import 'package:sppnekat/shared/button.dart';
import 'package:sppnekat/shared/color.dart';

import 'package:sppnekat/shared/list_bio.dart';
import 'package:sppnekat/shared/loading.dart';
import 'package:sppnekat/shared/size.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(authService.getUId)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            return Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes(context).width * 0.1),
                      child: Column(
                        children: [
                          snapshot.data!.get('role') == 'student'
                              ? Column(
                                  children: [
                                    ListBio(
                                      title: 'NIS',
                                      desc: snapshot.data!.get('nisn'),
                                    ),
                                    ListBio(
                                      title: 'Kelas',
                                      desc: snapshot.data!.get('class'),
                                    ),
                                  ],
                                )
                              : const ListBio(title: '', desc: '')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              CoolAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: CoolAlertType.confirm,
                                title: 'Peringatan',
                                text: 'Apa kamu yakin keluar?',
                                cancelBtnText: 'Kembali',
                                confirmBtnText: 'Keluar',
                                confirmBtnColor: lightBlue,
                                onConfirmBtnTap: () async {
                                  await authService.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const OnBoarding()),
                                      (route) => false);
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      color: darkBlue,
                                      title: 'Berhasil',
                                      message: 'Berhasil Keluar',
                                      contentType: ContentType.success,
                                    ),
                                  );

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                },
                              );
                            },
                            child: const ButtonGradient(title: 'Keluar')),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
