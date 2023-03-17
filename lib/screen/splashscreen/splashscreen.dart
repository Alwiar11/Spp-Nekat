import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sppnekat/checker.dart';
import 'package:sppnekat/shared/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() async {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthChecker())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkBlue,
            lightBlue,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/logo.png',
                      scale: 3,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'SMKN 1 KATAPANG',
                      style: TextStyle(
                          fontSize: 30,
                          letterSpacing: 1,
                          fontFamily: 'Herme',
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
