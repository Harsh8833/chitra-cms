import 'package:chitra/widgets/invoice_input_container.dart';
import "package:flutter/material.dart";

class InvoiceItem extends StatelessWidget {
  final String code;
  final String name;
  final String type;
  final String qty;
  final String price;
  final String total;
  const InvoiceItem({
    Key? key,
    required this.code,
    required this.name,
    required this.type,
    required this.price,
    required this.qty,
    required this.total,
  }) : super(key: key);

  final TextEditingController _codeController;
  final TextEditingController _nameController;
  final TextEditingController _typeController;
  final TextEditingController _qtyController;
  final TextEditingController _codeController;
  final TextEditingController _codeController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        InvoiceInputFeild(
          width: 110,
        ),
        InvoiceInputFeild(
          width: 280,
        ),
        InvoiceInputFeild(
          width: 140,
        ),
        InvoiceInputFeild(
          width: 140,
        ),
        InvoiceInputFeild(
          width: 150,
        ),
        InvoiceInputFeild(
          width: 170,
        ),
      ],
    );
  }
}
