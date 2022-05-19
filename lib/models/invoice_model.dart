import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

List invoiceItem = [];

class Invoice {
  String name;
  String phone;
  int invoiceNo;
  double gTotal = 0;
  final date = DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString();
  List items;

  double calGT() {
    gTotal = 0;
    for (int i = 0; i < items.length; i++) {
      gTotal += int.parse(items[i]['mrp'].toString()) *
          int.parse(items[i]['qty'].toString());
    }
    print("GRAND TOTAL: " + gTotal.toString());
    return gTotal;
  }

  int invoiceQty() {
    var qty = 0;
    for (int i = 0; i < items.length; i++) {
      qty += int.parse(items[i]['qty'].toString());
    }
    print("QTY: " + gTotal.toString());
    return qty;
  }

  Invoice(
      {this.name = "Chitra's Customer",
      this.phone = "N/A",
      this.invoiceNo = 0,
      required this.items});
}

var CurrentInvoice = Invoice(
  items: [],
);
