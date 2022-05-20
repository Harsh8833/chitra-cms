import 'dart:typed_data';
import 'package:chitra/models/invoice_model.dart';
import 'package:chitra/pages/generate_invoice.dart';
import 'package:chitra/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 200),
          initialPageFormat: PdfPageFormat.a5,
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final Uint8List fontData1 =
        (await rootBundle.load('font/Poppins-Bold.ttf')).buffer.asUint8List();
    final poppinsBold = pw.Font.ttf(fontData1.buffer.asByteData());

    final Uint8List fontData =
        (await rootBundle.load('font/Poppins-Regular.ttf'))
            .buffer
            .asUint8List();
    final poppinsLight = pw.Font.ttf(fontData.buffer.asByteData());

    final title1 = pw.MemoryImage(
      (await rootBundle.load('assets/images/title.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Container(
              width: double.infinity,
              child: pw.Column(
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Invoice No: ' + data.invoiceNo.toString(),
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 10)),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text('Phone- 7004647426',
                                  style: pw.TextStyle(
                                      font: poppinsLight, fontSize: 10)),
                              pw.Text('8102462045',
                                  style: pw.TextStyle(
                                      font: poppinsLight, fontSize: 10)),
                            ])
                      ]),
                  pw.Container(
                    width: 200,
                    height: 400,
                    child: pw.Image(title1, dpi: 1200),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("• Lehenga",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Suit",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Saree",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Gown",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Crop Top",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Kurti",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Plazzo",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Blouse",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Dupatta",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Jeans",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                        pw.Text("• Skirt",
                            style:
                                pw.TextStyle(font: poppinsLight, fontSize: 6)),
                      ]),
                  pw.Divider(),
                  pw.Row(children: [
                    pw.Text('Customer\'s Name: ',
                        style: pw.TextStyle(font: poppinsLight, fontSize: 10)),
                    pw.Text(data.name,
                        style: pw.TextStyle(font: poppinsLight, fontSize: 10)),
                  ]),
                  pw.Row(children: [
                    pw.Text('Customer\'s Phone: ',
                        style: pw.TextStyle(font: poppinsLight, fontSize: 10)),
                    pw.Text(data.phone,
                        style: pw.TextStyle(font: poppinsLight, fontSize: 10)),
                  ]),
                  pw.Divider(),
                  pw.SizedBox(
                    width: 50,
                    child: pw.FittedBox(
                      child: pw.Text("INVOICE",
                          style: pw.TextStyle(font: poppinsBold, fontSize: 10)),
                    ),
                  ),
                  pdfTableHeader(),
                  for (var each in data.items) ...[
                    pdfTableBody(each, poppinsLight),
                  ],
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('GRAND TOTAL',
                            style: pw.TextStyle(
                                font: poppinsBold,
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(inrFormat.format(data.gTotal),
                              style: pw.TextStyle(
                                  font: poppinsBold,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                        )
                      ]),
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Terms & Conditions",
                                  style: pw.TextStyle(
                                      font: poppinsBold, fontSize: 8)),
                              pw.Text("• NO Return No Exchange.",
                                  style: pw.TextStyle(
                                      font: poppinsLight, fontSize: 8)),
                              pw.Text("• E&OE",
                                  style: pw.TextStyle(
                                      font: poppinsLight, fontSize: 8)),
                            ])
                      ]),
                  pw.Divider(),
                  pw.Text('Thank you Visit us again',
                      style: pw.TextStyle(font: poppinsLight, fontSize: 8))
                ],
              ));
        },
      ),
    );

    return pdf.save();
  }

  pdfTableHeader() {
    return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 5),
        padding: const pw.EdgeInsets.symmetric(vertical: 5),
        decoration:
            pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
        child: pw.Row(
          children: [
            pw.SizedBox(
                child: pw.Text('#Code',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 9)),
                width: 40),
            pw.SizedBox(
                child: pw.Text('Name',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 9)),
                width: 100),
            pw.SizedBox(
                child: pw.Text('Qty',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 9)),
                width: 30),
            pw.SizedBox(
                child: pw.Text('Price',
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 9)),
                width: 55),
            pw.SizedBox(
                child: pw.Text('Total',
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 9)),
                width: 55)
          ],
        ));
  }

  pdfTableBody(item, font) {
    final inrFont = PdfGoogleFonts.hindLight();
    return pw.Row(
      children: [
        pw.SizedBox(
            child: pw.Text(item['code'],
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 9)),
            width: 40),
        pw.SizedBox(width: 4),
        pw.SizedBox(
            child: pw.Text(item['name'],
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(fontSize: 9)),
            width: 100),
        pw.SizedBox(
            child: pw.Text(item['qty'].toString(),
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 9)),
            width: 30),
        pw.SizedBox(
            child: pw.Text(
              inrFormat.format(item['mrp']),
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(font: font, fontSize: 9),
            ),
            width: 55),
        pw.SizedBox(width: 4),
        pw.SizedBox(
            child: pw.Text(
                inrFormat.format(
                  item['mrp'] * item['qty'],
                ),
                style: pw.TextStyle(font: font, fontSize: 9),
                textAlign: pw.TextAlign.right),
            width: 55)
      ],
    );
  }
}
