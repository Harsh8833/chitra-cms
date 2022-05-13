import 'package:chitra/values/colors.dart';
import 'package:chitra/values/dimens.dart';
import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  final Widget child;
  final double width;
  const InputContainer({Key? key, required this.child, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Appcolor.white,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        border: Border.all(color: Appcolor.primary),
      ),
      child: child,
    );
  }
}
