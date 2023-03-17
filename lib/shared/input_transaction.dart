import 'package:flutter/material.dart';

import '../../shared/size.dart';

class InputTransaction extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;
  final bool enabled;
  const InputTransaction({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.suffix,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontFamily: 'Herme', letterSpacing: 1, fontSize: 18),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          width: Sizes(context).width * 0.9,
          height: 50,
          child: TextFormField(
            style: const TextStyle(fontFamily: 'Herme', letterSpacing: 1),
            controller: controller,
            decoration: InputDecoration(
                suffix: Text(suffix),
                enabled: enabled,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xffADADAD))),
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
