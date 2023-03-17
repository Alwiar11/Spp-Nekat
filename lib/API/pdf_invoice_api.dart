import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:sppnekat/API/pdf_api.dart';
import 'package:sppnekat/model/invoice.dart';
import 'package:sppnekat/model/school.dart';
import 'package:sppnekat/model/student.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    final image =
        (await rootBundle.load('assets/img/logo.png')).buffer.asUint8List();
    final lunas =
        (await rootBundle.load('assets/img/lunas.png')).buffer.asUint8List();

    pdf.addPage(MultiPage(
      build: (context) => [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Image(MemoryImage(image), width: 80),
          buildHeader(invoice),
        ]),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCustomerAddress(invoice.student),
            buildInvoiceInfo(invoice.info),
          ],
        ),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Image(MemoryImage(lunas), width: 100),
        ])
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.school),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  static Widget buildCustomerAddress(Student student) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nama : ${student.name}",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Kelas : ${student.address}"),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = <String>[
      'No Pembayaran:',
      'Tanggal Pembayaran:',
    ];
    final data = <String>[info.noTransaction, info.date];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 250);
      }),
    );
  }

  static Widget buildSupplierAddress(School school) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(school.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(school.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bukti Pembayaran',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Nama',
      'Kelas',
      'Bulan',
      'Tahun',
      'Petugas',
      'Nominal',
    ];
    final data = invoice.items.map((item) {
      return [
        item.payerName,
        item.payerClass,
        item.monthBill,
        item.yearBill,
        item.operatorName,
        item.nominal,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      columnWidths: {
        0: const FlexColumnWidth(5),
        1: const FlexColumnWidth(4),
        2: const FlexColumnWidth(3),
        3: const FlexColumnWidth(3),
        4: const FlexColumnWidth(4),
        5: const FlexColumnWidth(4),
      },
      cellHeight: 40,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
      },
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: '', value: ''),
          SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
