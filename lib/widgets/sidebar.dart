import 'package:chitra/pages/customers_page.dart';
import 'package:chitra/pages/history_page.dart';
import 'package:chitra/pages/inventory_page.dart';
import 'package:chitra/pages/generate_invoice.dart';
import 'package:chitra/values/colors.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({Key? key}) : super(key: key);

  @override
  _SidebarPageState createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  late List<CollapsibleItem> _items;
  late Widget _body;
  final AssetImage _avatarImg = const AssetImage('assets/images/mb.png');

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _body = const GenerateInvoicePage();
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Generate Invoice',
        icon: Icons.add,
        onPressed: () => setState(() => _body = const GenerateInvoicePage()),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Inventory',
        icon: Icons.inventory_2,
        onPressed: () => setState(() => _body = const InventoryPage()),
      ),
      CollapsibleItem(
        text: 'History',
        icon: Icons.history,
        onPressed: () => setState(() => _body = const HistoryPage()),
      ),
      CollapsibleItem(
        text: 'Customers',
        icon: Icons.people,
        onPressed: () => setState(() => _body = const CustomerPage()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: CollapsibleSidebar(
          avatarImg: _avatarImg,
          isCollapsed: true,
          items: _items,
          title: 'Chitra Fashion',
          body: _body,
          topPadding: 150,
          backgroundColor: Appcolor.primary,
          selectedIconColor: Appcolor.dark,
          selectedIconBox: Appcolor.secondary,
          selectedTextColor: Appcolor.black,
          unselectedIconColor: Appcolor.light,
          textStyle: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          titleStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          toggleTitleStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          sidebarBoxShadow: [
            BoxShadow(
              color: Appcolor.primary.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0.01,
              offset: const Offset(3, 3),
            ),
          ],
        ),
      ),
    );
  }
}
