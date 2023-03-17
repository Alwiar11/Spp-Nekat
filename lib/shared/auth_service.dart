import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sppnekat/model/user.dart';
import 'package:sppnekat/navbar_admin.dart';
import 'package:sppnekat/navbar_user.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/dialog_loading.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  String get getUId => _firebaseAuth.currentUser!.uid;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    DialogLoading(context).showLoading();
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print(credential.user!.refreshToken);
      FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get()
          .then((user) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('role', user.get('role'));
        prefs.setString('uid', user.id);
        if (user.get('role') != 'admin') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const NavBarUser()),
              (route) => false);
          final snackBar = SnackBar(
            elevation: 0,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              color: darkBlue,
              title: 'Berhasil',
              message: 'Berhasil Masuk',
              contentType: ContentType.success,
            ),
          );

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const NavBarAdmin()),
              (route) => false);
          final snackBar = SnackBar(
            elevation: 0,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              color: darkBlue,
              title: 'Berhasil',
              message: 'Berhasil Masuk',
              contentType: ContentType.success,
            ),
          );

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      return _userFromFirebase(credential.user);
    } on FirebaseException catch (e) {
      // print(e);
      if (e.code == 'wrong-password') {
        Navigator.of(context).pop();
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
                  'Kata Sandi Salah',
                  style: TextStyle(fontFamily: 'Herme'),
                ),
              ],
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'user-not-found') {
        Navigator.of(context).pop();
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
                  'Akun Tidak Terdaftar',
                  style: TextStyle(fontFamily: 'Herme', letterSpacing: 1),
                ),
              ],
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'invalid-email') {
        Navigator.of(context).pop();
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
                  'Email Atau Kata Sandi Salah',
                  style: TextStyle(fontFamily: 'Herme'),
                ),
              ],
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'too-many-requests') {
        Navigator.of(context).pop();
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
                  'Terlalu Banyak Permintaan, Coba Lagi Nanti',
                  style: TextStyle(fontFamily: 'Herme'),
                ),
              ],
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (email.isEmpty || password.isEmpty) {
        Navigator.of(context).pop();
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
                  'Silahkan Isi Terlebih Dahulu',
                  style: TextStyle(fontFamily: 'Herme'),
                ),
              ],
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
    String name,
    String nisn,
    String level,
    String kelas,
    String role,
  ) async {
    DialogLoading(context).showLoading();
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user!.uid)
        .set({
      'name': name,
      'email': email,
      'nisn': nisn,
      'level': level,
      'class': "$level $kelas",
      'role': role == 'Siswa' ? 'student' : "operator"
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    return null;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
