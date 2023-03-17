import 'package:flutter/material.dart';

class ListBio extends StatelessWidget {
  final String title;
  final String desc;
  const ListBio({
    required this.title,
    required this.desc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Herme',
                    fontSize: 12,
                    letterSpacing: 1,
                    color: Colors.grey),
              ),
              Text(
                desc,
                style: const TextStyle(
                    fontFamily: 'Herme', fontSize: 18, letterSpacing: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
