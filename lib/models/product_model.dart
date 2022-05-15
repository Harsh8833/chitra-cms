import 'dart:io' show Platform;

class ProductModel {
  late String code;
  late String name;
  late String cPrice;
  late String mrp;
  late int qty;

  ProductModel(
    this.code,
    this.name,
    this.cPrice,
    this.mrp,
    this.qty,
  );
}
