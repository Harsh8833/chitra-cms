import 'dart:developer';
import 'package:chitra/models/invoice_model.dart';
import 'package:chitra/pdf_api.dart';
import 'package:chitra/values/colors.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:chitra/widgets/buttons.dart';
import 'package:chitra/widgets/input_container.dart';
import 'package:chitra/widgets/sidebar.dart';
import 'package:chitra/widgets/table/header.dart';
import 'package:chitra/widgets/table/invoice_items.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class GenerateInvoicePage extends StatefulWidget {
  const GenerateInvoicePage({Key? key}) : super(key: key);

  @override
  State<GenerateInvoicePage> createState() => _GenerateInvoicePageState();
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  late mongo.Db database;
  late mongo.DbCollection inventory;
  late mongo.DbCollection invoices;
  int invono = 0;
  final TextEditingController _grandTotal = TextEditingController();
  final TextEditingController _customerName = TextEditingController();
  final TextEditingController _customerPhone = TextEditingController();
  var grandTotal = 0;

  @override
  void initState() {
    database = mongo.Db('mongodb://localhost/chitra-cms');
    Future.delayed(Duration.zero, () async {
      log("connection started");
      await database.open();
      inventory = database.collection('inventory');
      invoices = database.collection('invoices');
      log("connected");
      invono = await getInvoiceNo();
      CurrentInvoice.invoiceNo = invono;
      updateGT();
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
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _grandTotal,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Grand Total",
                            hoverColor: Appcolor.primary),
                      ),
                    ),
                    AppPrimaryButton(
                        onTap: () {
                          log(CurrentInvoice.name);
                          log(CurrentInvoice.phone);
                          log(CurrentInvoice.date);
                          print(CurrentInvoice.items);
                          CurrentInvoice.calGT();
                          invoices.insertOne({
                            'invno': invono,
                            'date': CurrentInvoice.date,
                            'cname': CurrentInvoice.name,
                            'phone': CurrentInvoice.phone,
                            'gt': CurrentInvoice.gTotal,
                            'qty': CurrentInvoice.invoiceQty(),
                            'items': CurrentInvoice.items
                          });
                          setState(() {
                            CurrentInvoice.reset();
                            CurrentInvoice.items = [];
                            grandTotal = 0;
                            reload();
                          });
                        },
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
                  child: TextField(
                    controller: _customerName,
                    onChanged: (value) {
                      CurrentInvoice.name = _customerName.text;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: "Name",
                        floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                  ),
                ),
                InputContainer(
                  width: totalwidth * 0.2,
                  child: TextField(
                    controller: _customerPhone,
                    onChanged: (value) {
                      CurrentInvoice.phone = value;
                    },
                    decoration: const InputDecoration(
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
                  onTap: () {
                    updateGT();
                  },
                  height: 60,
                  icon: Icons.replay,
                ),
                AppRoundButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrintInvoice(
                                data: CurrentInvoice,
                              )),
                    );
                    ;
                  },
                  height: 60,
                  icon: Icons.print,
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
                      onTap: () {
                        openItemWithoutId();
                      },
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
                        children: [
                          const Text("Invoice No: "),
                          Text(invono.toString()),
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
            for (int i = 0; i < invoiceItem.length; i++) ...[
              InvoiceItem(
                code: invoiceItem[i]['code'],
                name: invoiceItem[i]['name'],
                type: invoiceItem[i]['type'],
                qty: '1',
                price: invoiceItem[i]['mrp'].toString(),
                total: invoiceItem[i]['mrp'].toString(),
                onRemove: () {
                  removeItemInCurrentInvoice(invoiceItem[i]);
                  invoiceItem.removeAt(i);
                  reload();
                },
                onAdd: () {
                  if (!CurrentInvoice.items.contains(invoiceItem[i])) {
                    addItemInCurrentInvoice(invoiceItem[i]);
                  }
                },
                onInc: () {
                  onQtyInc(i);
                  updateGT();
                },
                onDec: () {
                  onQtyDec(i);
                  updateGT();
                },
              ),
            ]
          ],
        ),
      ),
    );
  }

  getInvoiceNo() async {
    int no;
    no = await invoices.count();
    return no + 1;
  }

  updateGT() {
    setState(() {
      _grandTotal.text = "₹" + CurrentInvoice.calGT().toString();
    });
  }

  onQtyInc(i) {
    CurrentInvoice.items[i]['qty']++;
  }

  onQtyDec(i) {
    CurrentInvoice.items[i]['qty']--;
  }

  addItemInCurrentInvoice(item) {
    item['qty'] = 1;
    CurrentInvoice.items.add(item);
  }

  removeItemInCurrentInvoice(item) {
    CurrentInvoice.items.remove(item);
  }

  reload() {
    updateGT();
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SidebarPage(),
        transitionDuration: const Duration(seconds: 0),
      ),
      (Route<dynamic> route) => false,
    );
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

  Future openItemWithoutId() {
    final TextEditingController _name = TextEditingController();
    final TextEditingController _type = TextEditingController();
    final TextEditingController _mrp = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 350,
              width: 500,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                color: Appcolor.gray,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Add Item Without Code",
                        style: headingSecondary,
                      ),
                    ),
                    InputContainer(
                      width: 400,
                      child: TextField(
                        controller: _name,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Item Name",
                            floatingLabelStyle:
                                TextStyle(color: Appcolor.primary)),
                      ),
                    ),
                    InputContainer(
                      width: 400,
                      child: TextField(
                        controller: _type,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Type",
                            floatingLabelStyle:
                                TextStyle(color: Appcolor.primary)),
                      ),
                    ),
                    InputContainer(
                      width: 400,
                      child: TextField(
                        controller: _mrp,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "MRP",
                          floatingLabelStyle:
                              TextStyle(color: Appcolor.primary),
                        ),
                        onSubmitted: (value) {
                          invoiceItem.add({
                            'code': 'N/A',
                            'name': _name.text,
                            'mrp': _mrp.text,
                            'type': _type.text,
                            'qty': 1,
                          });

                          updateGT();
                          reload();
                          print(invoiceItem);
                        },
                      ),
                    ),
                    AppPrimaryButton(
                        onTap: () {
                          invoiceItem.add({
                            'code': 'N/A',
                            'name': _name.text,
                            'mrp': _mrp.text,
                            'type': _type.text,
                            'qty': 1,
                          });
                          reload();
                          updateGT();
                          print(invoiceItem);
                        },
                        text: "ADD",
                        horizontalPadding: 20)
                  ]),
            )));
  }
}
