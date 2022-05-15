import 'dart:developer';

import 'package:chitra/connection.dart';
import 'package:chitra/models/invoice_model.dart';
import 'package:chitra/values/colors.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:chitra/widgets/buttons.dart';
import 'package:chitra/widgets/input_container.dart';
import 'package:chitra/widgets/invoice_input_container.dart';
import 'package:chitra/widgets/table/header.dart';
import 'package:chitra/widgets/table/invoice_items.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class GenerateInvoicePage extends StatefulWidget {
  const GenerateInvoicePage({Key? key}) : super(key: key);

  @override
  State<GenerateInvoicePage> createState() => _GenerateInvoicePageState();
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  late mongo.Db database;
  late mongo.DbCollection inventory;

  void initState() {
    database = mongo.Db('mongodb://localhost/chitra-cms');
    Future.delayed(Duration.zero, () async {
      log("connection started");
      await database.open();
      inventory = database.collection('inventory');
      log("connected");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final totalwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "CHITRA FASHION",
                  style: headingPrimary,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 250,
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Grand Total",
                            hoverColor: Appcolor.primary),
                      ),
                    ),
                    AppPrimaryButton(
                        onTap: () {},
                        text: "Generate Bill",
                        horizontalPadding: 50)
                  ],
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputContainer(
                  width: totalwidth * 0.11,
                  child: const TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Customer No.",
                        floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                  ),
                ),
                InputContainer(
                  width: totalwidth * 0.3,
                  child: const TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Name",
                        floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                  ),
                ),
                InputContainer(
                  width: totalwidth * 0.2,
                  child: const TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Phone No.",
                        floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                  ),
                ),
                AppRoundButton(
                  onTap: () {},
                  height: 60,
                  icon: Icons.arrow_forward,
                ),
                AppRoundButton(
                  onTap: () {},
                  height: 60,
                  icon: Icons.visibility,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppPrimaryButton(
                      onTap: () {
                        openItemWithId();
                      },
                      text: "Add with id",
                      horizontalPadding: 8,
                    ),
                    AppPrimaryButton(
                      onTap: () {},
                      text: "Add without id",
                      horizontalPadding: 8,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text("Invoice No: "),
                          Text("s1"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Date: "),
                          Text(DateTime.now().day.toString() +
                              "/" +
                              DateTime.now().month.toString() +
                              "/" +
                              DateTime.now().year.toString()),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            tableHeaders(),
            for (var each in invoiceItem) ...[
              InvoiceItem(
                code: each['code'],
                name: each['name'],
                type: each['type'],
                qty: '1',
                price: each['mrp'].toString(),
                total: each['mrp'].toString(),
              )
            ]
          ],
        ),
      ),
    );
  }

  removeInvoiceItem(item) {
    log('clicked -- ');
  }

  Future openItemWithId() {
    final TextEditingController _itemCode = TextEditingController();
    _itemCode.text = '';
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 250,
          width: 500,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            color: Appcolor.gray,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Add Item with Id",
                style: headingSecondary,
              ),
            ),
            InputContainer(
              width: 400,
              child: TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (value) async {
                  log('clicked');
                  log(_itemCode.text);
                  var item = await inventory.findOne({'code': _itemCode.text});
                  if (item != null) {
                    setState(() {
                      invoiceItem.add(item);
                    });

                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Item code Not Found!",
                      style: TextStyle(fontSize: 22),
                    )));
                  }
                },
                textCapitalization: TextCapitalization.words,
                controller: _itemCode,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Code",
                    floatingLabelStyle: TextStyle(color: Appcolor.primary)),
              ),
            ),
            AppPrimaryButton(
              onTap: () async {
                log('clicked');
                log(_itemCode.text);
                var item = await inventory.findOne({'code': _itemCode.text});
                if (item != null) {
                  setState(() {
                    invoiceItem.add(item);
                  });

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                    "Item code Not Found!",
                    style: TextStyle(fontSize: 22),
                  )));
                }
              },
              text: "ADD",
              horizontalPadding: 20,
            )
          ]),
        ),
      ),
    );
  }
}
