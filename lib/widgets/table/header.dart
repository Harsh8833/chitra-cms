import 'package:chitra/values/colors.dart';
import 'package:chitra/values/dimens.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final String text;
  final double width;
  const TableHeader({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: width,
      decoration: BoxDecoration(
        color: Appcolor.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              text,
              style: tableHeader,
            )),
      ),
    );
  }
}

Row tableHeaders() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      TableHeader(width: 110, text: "Item No."),
      TableHeader(width: 280, text: "Items"),
      TableHeader(width: 140, text: "Type"),
      TableHeader(width: 140, text: "Qty"),
      TableHeader(width: 150, text: "Price"),
      TableHeader(width: 170, text: "Total"),
    ],
  );
}

Row inventoryTableHeaders() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      TableHeader(width: 120, text: "Code"),
      TableHeader(width: 320, text: "Item Name"),
      TableHeader(width: 120, text: "Type"),
      TableHeader(width: 120, text: "Qty"),
      TableHeader(width: 180, text: "cp"),
      TableHeader(width: 180, text: "Price"),
    ],
  );
}
