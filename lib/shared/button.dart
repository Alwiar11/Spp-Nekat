import 'package:flutter/material.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/size.dart';

class ButtonGradient extends StatelessWidget {
  final String title;
  const ButtonGradient({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes(context).width * 0.9,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [
          lightBlue,
          darkBlue,
        ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontSize: 24,
                fontFamily: 'Herme'),
          )
        ],
      ),
    );
  }
}
