import 'package:flutter/material.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/size.dart';

class CardMenuAdmin extends StatelessWidget {
  final void Function()? route;
  final String title;
  final String desc;
  final String info;
  final IconData icon;
  const CardMenuAdmin({
    required this.title,
    required this.info,
    required this.desc,
    required this.icon,
    required this.route,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 170,
      width: Sizes(context).width * 0.45,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkBlue,
            lightBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Herme',
                    fontSize: 16,
                    letterSpacing: 1,
                    color: Colors.white),
              )
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Text(
                        info,
                        style: const TextStyle(
                            fontFamily: 'Herme',
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 36,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: Text(
                        desc,
                        style: const TextStyle(
                            fontFamily: 'Herme',
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: route,
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Detail',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            fontFamily: 'Herme',
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
