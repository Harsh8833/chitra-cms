import 'package:chitra/values/colors.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryTableBody extends StatelessWidget {
  final String text;
  final double width;
  const InventoryTableBody({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(5),
      width: width,
      decoration: BoxDecoration(
        color: Appcolor.gray,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              text,
              style: tableBody,
            )),
      ),
    );
  }
}

Row inventoryTablebody(
    {required code,
    required name,
    required type,
    required qty,
    required cprice,
    required price}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InventoryTableBody(width: 120, text: code),
      InventoryTableBody(width: 320, text: name),
      InventoryTableBody(width: 120, text: type),
      InventoryTableBody(width: 120, text: qty),
      InventoryTableBody(width: 180, text: cprice),
      InventoryTableBody(width: 180, text: price),
    ],
  );
}
