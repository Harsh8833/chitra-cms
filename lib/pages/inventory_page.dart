import 'dart:developer';

import 'package:chitra/connection.dart';
import 'package:chitra/values/colors.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:chitra/widgets/buttons.dart';
import 'package:chitra/widgets/input_container.dart';
import 'package:chitra/widgets/table/body.dart';
import 'package:chitra/widgets/table/header.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late mongo.Db database;
  late mongo.DbCollection inventory;
  var items;
  @override
  void initState() {
    database = mongo.Db('mongodb://localhost/chitra-cms');
    Future.delayed(Duration.zero, () async {
      log("connection started");
      await database.open();
      inventory = database.collection('inventory');
      var data = await inventory.find().toList();
      log("connected");
      setState(() {
        items = data;
        log("items updated");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          controller: ScrollController(),
          children: [
            const Text(
              "Inventory",
              style: headingPrimary,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppPrimaryButton(
                  onTap: () {
                    openAddNewItemDialog();
                  },
                  text: "Add new item",
                  horizontalPadding: 10,
                ),
                AppPrimaryButton(
                  onTap: () {},
                  text: "update existing item",
                  horizontalPadding: 10,
                ),
              ],
            ),
            const Divider(),
            CustomRadioButton(
              buttonValues: const [
                'All',
                'Saree',
                'Suit',
                'Lengha',
                'Gown',
                'Kurti'
              ],
              buttonLables: const [
                'All',
                'Saree',
                'Suit',
                'Lengha',
                'Gown',
                'Kurti'
              ],
              radioButtonValue: (values) {
                print(values);
              },
              selectedColor: Appcolor.primary,
              unSelectedColor: Appcolor.white,
              selectedBorderColor: Appcolor.primary,
              unSelectedBorderColor: Appcolor.primary,
              elevation: 0,
              enableShape: true,
            ),
            const Divider(),
            inventoryTableHeaders(),
            if (items != null)
              for (var each in items) ...[
                inventoryTablebody(
                    code: each['code'],
                    name: each['name'],
                    qty: each['qty'].toString(),
                    price: each['mrp'].toString(),
                    cprice: each['cprice'],
                    type: each['type']),
              ],
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Future openAddNewItemDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 550,
            width: 500,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              color: Appcolor.gray,
            ),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Add New Item in Inventory",
                  style: headingSecondary,
                ),
              ),
              const InputContainer(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Code",
                      floatingLabelStyle:
                          const TextStyle(color: Appcolor.primary)),
                ),
              ),
              const InputContainer(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Item Name",
                      floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                ),
              ),
              const InputContainer(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Type",
                      floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                ),
              ),
              const InputContainer(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Qty",
                      floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                ),
              ),
              const InputContainer(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "CP",
                      floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                ),
              ),
              const InputContainer(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "MRP",
                      floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                ),
              ),
              AppPrimaryButton(onTap: () {}, text: "ADD", horizontalPadding: 20)
            ]),
          )));
}
