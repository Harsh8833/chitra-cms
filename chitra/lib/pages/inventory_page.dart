import 'package:chitra/values/textstyle.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ListView(
          children: const [
            Text(
              "Inventory Page",
              style: headingPrimary,
            )
          ],
        ),
      ),
    );
  }
}
