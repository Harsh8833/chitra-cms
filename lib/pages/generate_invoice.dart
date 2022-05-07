import 'dart:ui';

import 'package:chitra/values/colors.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:chitra/widgets/input_container.dart';
import 'package:flutter/material.dart';

class GenerateInvoicePage extends StatelessWidget {
  const GenerateInvoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ListView(
          children: [
            const Text(
              "CHITRA FASHION",
              style: headingPrimary,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                InputContainer(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Name",
                        floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                  ),
                ),
                InputContainer(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Phone No.",
                        floatingLabelStyle: TextStyle(color: Appcolor.primary)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
