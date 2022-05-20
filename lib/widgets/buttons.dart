import 'package:chitra/values/colors.dart';
import 'package:chitra/values/dimens.dart';
import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final onTap;
  final text;
  final double horizontalPadding;
  const AppPrimaryButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: onTap,
        height: 50,
        color: Appcolor.button,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadius)),
      ),
    );
  }
}

class AppRoundButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final double height;
  const AppRoundButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      shape: const CircleBorder(),
      height: height,
      color: Appcolor.button,
      child: Icon(
        icon,
        color: Appcolor.white,
      ),
    );
  }
}
