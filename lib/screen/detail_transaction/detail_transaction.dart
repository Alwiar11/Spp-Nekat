import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/API/pdf_api.dart';
import 'package:sppnekat/API/pdf_invoice_api.dart';
import 'package:sppnekat/model/invoice.dart';
import 'package:sppnekat/model/school.dart';
import 'package:sppnekat/model/student.dart';
import 'package:sppnekat/screen/edit_transaction/edit_transaction.dart';
import 'package:sppnekat/shared/card_transaction_admin.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/dialog_loading.dart';
import 'package:sppnekat/shared/format_date.dart';
import 'package:sppnekat/shared/size.dart';

class DetailTransaction extends StatefulWidget {
  final String id;
  const DetailTransaction({required this.id, super.key});

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Detail Pembayaran',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .doc(widget.id)
              .snapshots(),
          builder: (_, data) {
            if (data.hasData) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        data.data!.get('status') == 'Lunas'
                            ? IconButton(
                                onPressed: () async {
                                  DialogLoading(_).showLoading();
                                  final invoice = Invoice(
                                    school: const School(
                                      name: "SMKN 1 KATAPANG",
                                      address:
                                          'Jalan Ceuri Jalan Terusan Kopo No.KM 13.5, Katapang, \nKec. Katapang, Kabupaten Bandung, Jawa Barat 40971',
                                    ),
                                    student: Student(
                                      name: data.data!.get('payerName'),
                                      address: data.data!.get('class'),
                                    ),
                                    info: InvoiceInfo(
                                        noTransaction: data.data!.get('no'),
                                        date: FormatDate().formattedDate(
                                            data.data!.get('dateTransaction')),
                                        kelas: '',
                                        month: '',
                                        namePayer: '',
                                        year: '',
                                        total: ''),
                                    items: [
                                      InvoiceItem(
                                        payerName: data.data!.get('payerName'),
                                        payerClass: data.data!.get('class'),
                                        operatorName:
                                            data.data!.get('operatorName'),
                                        nominal: CurrencyTextInputFormatter(
                                                locale: 'id',
                                                symbol: 'RP.',
                                                decimalDigits: 0)
                                            .format(data.data!.get('nominal')),
                                        status: data.data!.get('status'),
                                        monthBill: data.data!.get('monthBill'),
                                        yearBill: data.data!.get('yearBill'),
                                        date: FormatDate().formattedDate(
                                            data.data!.get('dateTransaction')),
                                      )
                                    ],
                                  );

                                  final pdfFile =
                                      await PdfInvoiceApi.generate(invoice);

                                  PdfApi.openFile(pdfFile);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.print))
                            : const SizedBox(),
                        IconButton(
                            splashRadius: 30,
                            onPressed: () {
                              DialogLoading(context).showLoading();
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditTransaction(
                                        id: data.data!.id,
                                      )));
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                content: Container(
                  width: Sizes(context).width * 0.9,
                  height: Sizes(context).height * 0.7,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: lightBlue),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/Checkmark.png',
                              scale: 1.5,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Sizes(context).height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.data!.get('monthBill') +
                                ' ' +
                                data.data!.get('yearBill'),
                            style: const TextStyle(
                                fontFamily: 'Herme',
                                fontSize: 20,
                                letterSpacing: 1),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Sizes(context).height * 0.02,
                      ),
                      TextInvoice(
                          title: 'Nama Lengkap',
                          desc: data.data!.get('payerName')),
                      TextInvoice(
                          title: 'Kelas', desc: data.data!.get('class')),
                      TextInvoice(
                          title: 'Nominal',
                          desc: CurrencyTextInputFormatter(
                                  locale: 'id', symbol: 'RP.', decimalDigits: 0)
                              .format(data.data!.get('nominal'))),
                      TextInvoice(
                          title: 'Sisa Bayar',
                          desc: CurrencyTextInputFormatter(
                                  locale: 'id', symbol: 'RP.', decimalDigits: 0)
                              .format(data.data!.get('sisa'))),
                      TextInvoice(
                          title: 'Tanggal Bayar',
                          desc: FormatDate().formattedDate(
                              data.data!.get('dateTransaction'))),
                      TextInvoice(
                          title: 'Status', desc: data.data!.get('status')),
                      TextInvoice(
                          title: 'Petugas',
                          desc: data.data!.get('operatorName')),
                    ],
                  ),
                ),
              );
            }
            return SizedBox(
              width: Sizes(context).width,
              height: Sizes(context).height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                      color: lightBlue, size: 80),
                  SizedBox(
                    height: Sizes(context).height * 0.05,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
