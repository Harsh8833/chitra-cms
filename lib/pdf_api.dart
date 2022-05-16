// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:chitra/models/invoice_model.dart';
import 'package:chitra/values/colors.dart';
import 'package:chitra/widgets/table/header.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintInvoice extends StatelessWidget {
  final Invoice data;
  const PrintInvoice({
    Key? key,
    required this.data,
    this.title = 'Print Invoice',
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolor.primary,
          title: Text(title),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format, title),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Invoice No: ' + data.invoiceNo.toString()),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('Phone- 7004647426'),
                          pw.Text('8102462045'),
                        ])
                  ]),
              pw.SizedBox(
                width: 100,
                child: pw.FittedBox(
                  child:
                      pw.Text("JAI JAGDAMBE", style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text("CHITRA FASHION",
                      style: pw.TextStyle(font: font)),
                ),
              ),
              pw.Divider(),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Invoice No: ' + data.invoiceNo.toString()),
                    pw.Text('Date: ' + data.date),
                  ]),
              pw.Row(children: [
                pw.Text('Customer Name: '),
                pw.Text(data.name),
              ]),
              pw.Row(children: [
                pw.Text('Customer Phone: '),
                pw.Text(data.phone),
              ]),
              pw.Divider(),
              pw.SizedBox(
                width: 50,
                child: pw.FittedBox(
                  child: pw.Text("INVOICE"),
                ),
              ),
              pw.Divider(),
              pdfTableHeader(),
              pw.Divider(),
              for (var each in data.items) ...[
                pdfTableBody(each),
              ],
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text('GRAND TOTAL',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(
                  width: 100,
                  child: pw.Text(data.gTotal.toString(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center),
                )
              ]),
              pw.Divider()
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pdfTableHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.SizedBox(child: pw.Text('Code'), width: 40),
        pw.SizedBox(child: pw.Text('Name'), width: 140),
        pw.SizedBox(child: pw.Text('Qty'), width: 50),
        pw.SizedBox(child: pw.Text('Price'), width: 50),
        pw.SizedBox(child: pw.Text('Total'), width: 50)
      ],
    );
  }

  pdfTableBody(item) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.SizedBox(child: pw.Text(item['code']), width: 40),
        pw.SizedBox(child: pw.Text(item['name']), width: 140),
        pw.SizedBox(child: pw.Text(item['qty'].toString()), width: 50),
        pw.SizedBox(child: pw.Text(item['mrp'].toString()), width: 50),
        pw.SizedBox(
            child: pw.Text((item['mrp'] * item['qty']).toString()), width: 50)
      ],
    );
  }
}
