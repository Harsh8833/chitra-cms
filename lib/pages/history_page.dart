import 'package:chitra/values/textstyle.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ListView(
          children: const [
            Text(
              "History Page",
              style: headingPrimary,
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
