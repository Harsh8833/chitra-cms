import 'package:chitra/values/colors.dart';
import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  final Widget child;
  const InputContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Appcolor.light,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Appcolor.primary),
      ),
      child: child,
    );
  }
}
