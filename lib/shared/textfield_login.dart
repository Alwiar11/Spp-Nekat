import 'package:flutter/material.dart';

import '../../shared/size.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String label;
  const TextFieldCustom({
    required this.label,
    required this.type,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          width: Sizes(context).width * 0.9,
          height: 50,
          child: TextFormField(
            keyboardType: type,
            controller: controller,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xffADADAD))),
                hintText: label,
                hintStyle: const TextStyle(fontFamily: 'Herme', fontSize: 16),
                enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: Color(0xffADADAD)))),
          ),
        ),
        SizedBox(
          height: Sizes(context).height * 0.015,
        )
      ],
    );
  }
}
