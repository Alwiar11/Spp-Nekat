import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:sppnekat/API/pdf_api.dart';
import 'package:sppnekat/model/invoice.dart';

import '../model/school.dart';
import '../model/student.dart';

class PdfInvoiceApi2 {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    final image =
        (await rootBundle.load('assets/img/logo.png')).buffer.asUint8List();

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
            buildInvoiceInfo(invoice.info),
          ],
        ),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        buildTotal(invoice.info)
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
          Text("", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(""),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = <String>[
      'Nama Siswa :',
      'Tanggal Bayar :',
      'Kelas :',
      'Bulan :',
      'Tahun Ajaran :',
    ];
    final data = <String>[
      info.namePayer,
      info.date,
      info.kelas,
      info.month,
      info.year
    ];

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
            'Daftar Pembayaran',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Nama',
      'Kelas',
      'Bulan',
      'Tahun',
      'Tanggal',
      'Petugas',
      'Nominal',
      'Status',
    ];
    final data = invoice.items.map((item) {
      return [
        item.payerName,
        item.payerClass,
        item.monthBill,
        item.yearBill,
        item.date,
        item.operatorName,
        item.nominal,
        item.status,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder.all(width: 1),
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 40,
      cellStyle: const TextStyle(fontSize: 9, inherit: true, letterSpacing: 1),
      columnWidths: {
        0: const FlexColumnWidth(4),
        1: const FlexColumnWidth(3),
        2: const FlexColumnWidth(3),
        3: const FlexColumnWidth(4),
        4: const FlexColumnWidth(3.5),
        5: const FlexColumnWidth(4),
        6: const FlexColumnWidth(4),
        7: const FlexColumnWidth(3),
      },
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center,
        7: Alignment.center,
      },
    );
  }

  static Widget buildTotal(InvoiceInfo invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                buildText(
                  title: 'Total',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: invoice.total,
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
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
