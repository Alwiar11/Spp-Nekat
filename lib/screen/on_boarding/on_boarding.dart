import 'package:flutter/material.dart';
import 'package:sppnekat/screen/login/login.dart';
import 'package:sppnekat/shared/button.dart';
import 'package:sppnekat/shared/size.dart';
import '../../shared/color.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/img/onBoarding.png',
              scale: 2.5,
            ),
            Container(
              width: double.infinity,
              height: Sizes(context).height * 0.45,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Aplikasi Pembayaran SPP \nPertama SMKN 1 KATAPANG',
                          style: TextStyle(
                              fontFamily: 'Herme',
                              fontSize: 26,
                              letterSpacing: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Dapat Melihat SPP \nKapan Saja dan Dimana Saja',
                          style: TextStyle(
                              color: Color.fromARGB(255, 101, 101, 101),
                              fontFamily: 'Herme',
                              fontSize: 20,
                              letterSpacing: 1),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Login()));
                          },
                          child: const ButtonGradient(
                            title: 'Masuk',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
