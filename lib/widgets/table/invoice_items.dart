import 'dart:developer';

import 'package:chitra/models/invoice_model.dart';
import 'package:chitra/values/colors.dart';
import 'package:chitra/widgets/buttons.dart';
import 'package:chitra/widgets/invoice_input_container.dart';
import "package:flutter/material.dart";

class InvoiceItem extends StatefulWidget {
  final String code;
  final String name;
  final String type;
  final String qty;
  final String price;
  final String total;
  final item;
  const InvoiceItem(
      {Key? key,
      required this.code,
      required this.name,
      required this.type,
      required this.qty,
      required this.price,
      required this.total,
      this.item})
      : super(key: key);

  @override
  State<InvoiceItem> createState() => _InvoiceItemState();
}

class _InvoiceItemState extends State<InvoiceItem> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  @override
  void initState() {
    _codeController.text = widget.code;
    _nameController.text = widget.name;
    _typeController.text = widget.type;
    _qtyController.text = widget.qty;
    _priceController.text = widget.price;
    _totalController.text = widget.total;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InvoiceInputFeild(
          width: 110,
          controller: _codeController,
        ),
        InvoiceInputFeild(
          width: 280,
          controller: _nameController,
          textAlign: TextAlign.left,
        ),
        InvoiceInputFeild(
          width: 140,
          controller: _typeController,
        ),
        SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                padding: const EdgeInsets.all(0),
                minWidth: 35,
                onPressed: () {
                  setState(() {
                    var intQty = int.parse(_qtyController.text);
                    intQty--;
                    print(intQty);
                    _qtyController.text = intQty.toString();
                  });
                },
                shape: const CircleBorder(),
                color: Appcolor.button,
                child: const Icon(
                  Icons.remove,
                  size: 22,
                  color: Appcolor.white,
                ),
              ),
              InvoiceInputFeild(
                width: 60,
                controller: _qtyController,
              ),
              MaterialButton(
                padding: const EdgeInsets.all(0),
                minWidth: 35,
                onPressed: () {
                  setState(() {
                    var intQty = int.parse(_qtyController.text);
                    intQty++;
                    print(intQty);
                    _qtyController.text = intQty.toString();
                  });
                },
                shape: const CircleBorder(),
                height: 40,
                color: Appcolor.button,
                child: const Icon(
                  Icons.add,
                  size: 22,
                  color: Appcolor.white,
                ),
              ),
            ],
          ),
        ),
        InvoiceInputFeild(
          width: 150,
          controller: _priceController,
        ),
        InvoiceInputFeild(
          width: 170,
          controller: _totalController,
        ),
        SizedBox(
          width: 50,
          child: IconButton(
            hoverColor: Colors.redAccent,
            splashRadius: 12,
            onPressed: () {
              setState(() {
                log('Before');
                print(invoiceItem);
                invoiceItem.removeAt(0);
                log('After');
                print(invoiceItem);
              });
            },
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
