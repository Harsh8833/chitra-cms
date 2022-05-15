import 'package:chitra/connection.dart';
import 'package:chitra/pages/generate_invoice.dart';
import 'package:chitra/widgets/sidebar.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

const apiKey = 'AIzaSyDoacm3otZw9ECjCaVPOk9wPisdCnmSf3E';
const projectId = 'chitra-cms';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chitra Fashion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: SidebarPage()),
    );
  }
}
