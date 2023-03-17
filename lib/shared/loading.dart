import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/size.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes(context).width * 1,
      height: Sizes(context).height * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: Sizes(context).height * 0.25,
          ),
          LoadingAnimationWidget.fourRotatingDots(color: lightBlue, size: 80),
          SizedBox(
            height: Sizes(context).height * 0.3,
          )
        ],
      ),
    );
  }
}
