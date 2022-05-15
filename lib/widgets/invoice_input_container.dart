import 'package:chitra/values/colors.dart';
import 'package:flutter/material.dart';

class InvoiceInputFeild extends StatelessWidget {
  final double width;
  final TextEditingController? controller;
  const InvoiceInputFeild({Key? key, required this.width, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      height: 35,
      width: width,
      decoration: BoxDecoration(
        color: Appcolor.gray,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
