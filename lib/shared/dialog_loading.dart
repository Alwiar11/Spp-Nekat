import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/size.dart';

class DialogLoading {
  final BuildContext context;
  DialogLoading(this.context);

  void showLoading() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          width: Sizes(context).width * 1,
          height: Sizes(context).height * 1,
          child: LoadingAnimationWidget.fourRotatingDots(
              color: darkBlue, size: 80),
        );
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }
}
