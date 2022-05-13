import 'dart:ui';

import 'package:chitra/values/colors.dart';
import 'package:chitra/values/textstyle.dart';
import 'package:chitra/widgets/buttons.dart';
import 'package:chitra/widgets/input_container.dart';
import 'package:flutter/material.dart';

class GenerateInvoicePage extends StatelessWidget {
  const GenerateInvoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            const Text(
              "CHITRA FASHION",
              style: headingPrimary,
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
                  child: const Icon(Icons.arrow_forward),
                ),
                AppRoundButton(
                  onTap: () {},
                  height: 60,
                  child: const Icon(Icons.visibility),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            Row(
              children: [
                AppPrimaryButton(
                  onTap: () {},
                  text: "Add with id",
                ),
                AppPrimaryButton(
                  onTap: () {},
                  text: "Add without id",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
