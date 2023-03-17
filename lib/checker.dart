import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sppnekat/navbar_admin.dart';
import 'package:sppnekat/navbar_user.dart';
import 'package:sppnekat/screen/on_boarding/on_boarding.dart';

import 'package:sppnekat/shared/auth_service.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    authChecker();
  }

  authChecker() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthService().getUId)
            .get()
            .then((value) {
          if (value.get('role') == 'admin') {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const NavBarAdmin()),
                (route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const NavBarUser()),
                (route) => false);
          }
        });
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const OnBoarding(),
            ),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
