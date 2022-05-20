import 'dart:developer';
import 'package:chitra/models/invoice_model.dart';
import 'package:chitra/pdf_api.dart';
import 'package:chitra/values/colors.dart';
import 'package:chitra/values/dimens.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:chitra/widgets/buttons.dart';
import 'package:chitra/widgets/input_container.dart';
import 'package:chitra/widgets/sidebar.dart';
import 'package:chitra/widgets/table/header.dart';
import 'package:chitra/widgets/table/invoice_items.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

final inrFormat = NumberFormat.currency(
    name: "INR", locale: 'en_IN', decimalDigits: 2, symbol: '₹');

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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                        style: const TextStyle(
                            color: Appcolor.button,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                        controller: _grandTotal,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Appcolor.primary, width: 2),
                                borderRadius: BorderRadius.circular(
                                    AppDimens.borderRadius)),
                            labelText: 'Grand Total',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimens.borderRadius))),
                      ),
                    ),
                    AppPrimaryButton(
                        onTap: () async {
                          log("Generate Invoice Started");
                          log(CurrentInvoice.name);
                          log(CurrentInvoice.phone);
                          log(CurrentInvoice.date);
                          print(CurrentInvoice.items);
                          print(CurrentInvoice.calGT());
                          invoices.insertOne({
                            'invno': invono,
                            'date': CurrentInvoice.date,
                            'cname': CurrentInvoice.name,
                            'phone': CurrentInvoice.phone,
                            'gt': _grandTotal.text,
                            'qty': CurrentInvoice.invoiceQty(),
                            'items': CurrentInvoice.items
                          });
                          var i = await getInvoiceNo();
                          // log('Generated');
                          setState(() {
                            invono = i;
                            CurrentInvoice.items = [];
                            invoiceItem = [];
                            _grandTotal.text = "";
                            _customerName.text = "";
                            _customerPhone.text = "";
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
                // InputContainer(
                //   width: totalwidth * 0.11,
                //   child: const TextField(
                //     decoration: InputDecoration(
                //         border: InputBorder.none,
                //         labelText: "Customer No.",
                //         floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                //   ),
                // ),
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
      _grandTotal.text = inrFormat.format(CurrentInvoice.calGT());
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
                  var item = await inventory.findOne({'code': _itemCode.text});
                  if (item != null) {
                    setState(() {
                      invoiceItem.add(item);
                    });

                    Navigator.of(context).pop();
                    reload();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Item code Not Found!",
                      style: TextStyle(fontSize: 22),
                    )));
                  }
                },
                controller: _itemCode,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Code",
                    floatingLabelStyle: TextStyle(color: Appcolor.primary)),
              ),
            ),
            AppPrimaryButton(
              onTap: () async {
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
    final TextEditingController _mrp = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 450,
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
                    CustomRadioButton(
                      enableButtonWrap: true,
                      buttonValues: const [
                        'Lehenga',
                        'Suit',
                        'Saree',
                        'Gown',
                        'Crop Top',
                        'Kurti',
                        'Plazzo',
                        'Blouse',
                        'Dupatta',
                        'Jeans',
                        'Skirt',
                        'Others'
                      ],
                      buttonLables: const [
                        'Lehenga',
                        'Suit',
                        'Saree',
                        'Gown',
                        'Crop Top',
                        'Kurti',
                        'Plazzo',
                        'Blouse',
                        'Dupatta',
                        'Jeans',
                        'Skirt',
                        'Others'
                      ],
                      radioButtonValue: (values) {
                        _name.text = values.toString();
                      },
                      selectedColor: Appcolor.primary,
                      unSelectedColor: Appcolor.white,
                      selectedBorderColor: Appcolor.primary,
                      unSelectedBorderColor: Appcolor.primary,
                      elevation: 0,
                      enableShape: true,
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
                            'mrp': int.parse(_mrp.text),
                            'type': 'N/A',
                            'qty': 1,
                          });
                          reload();
                          print(invoiceItem);
                        },
                      ),
                    ),
                    AppPrimaryButton(
                        onTap: () {
                          if (_mrp.text.isEmpty || _name.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Text(
                              "Please enter Item Name and MRP",
                              style: TextStyle(fontSize: 22),
                            )));
                          } else {
                            try {
                              invoiceItem.add({
                                'code': 'N/A',
                                'name': _name.text,
                                'mrp': int.parse(_mrp.text),
                                'type': 'N/A',
                                'qty': 1,
                              });
                              reload();
                              print(invoiceItem);
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                "Invalid Input",
                                style: TextStyle(fontSize: 22),
                              )));
                            }
                          }
                        },
                        text: "ADD",
                        horizontalPadding: 20)
                  ]),
            )));
  }
}
