import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sppnekat/API/pdf_api.dart';
import 'package:sppnekat/API/pdf_invoice_api.dart';
import 'package:sppnekat/model/invoice.dart';
import 'package:sppnekat/model/school.dart';
import 'package:sppnekat/model/student.dart';
import 'package:sppnekat/screen/detail_transaction/detail_transaction.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/size.dart';
import '../screen/edit_transaction/edit_transaction.dart';
import 'dialog_loading.dart';
import 'format_date.dart';

class CardTransactionAdmin extends StatelessWidget {
  final String payerName;
  final String payerClass;
  final String monthBill;
  final String yearBill;
  final String dateTransaction;
  final String status;
  final String id;
  final String nominal;
  const CardTransactionAdmin({
    required this.payerName,
    required this.payerClass,
    required this.monthBill,
    required this.yearBill,
    required this.dateTransaction,
    required this.status,
    required this.id,
    required this.nominal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      width: Sizes(context).width * 0.9,
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [
          darkBlue,
          lightBlue,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                payerName,
                style: const TextStyle(
                    fontFamily: 'Herme',
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 16),
              ),
              InkWell(
                onTap: () {
                  CoolAlert.show(
                    flareAsset: 'assets/flare/error_check.flr',
                    confirmBtnColor: Colors.red,
                    barrierDismissible: true,
                    context: context,
                    type: CoolAlertType.confirm,
                    title: 'Peringatan',
                    text: 'Apa kamu yakin hapus?',
                    cancelBtnText: 'Kembali',
                    confirmBtnText: 'Hapus',
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                      FirebaseFirestore.instance
                          .collection('transactions')
                          .doc(id)
                          .delete();

                      final snackBar = SnackBar(
                        elevation: 0,
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          color: darkBlue,
                          title: 'Berhasil',
                          message: 'Pembayaran Berhasil Dihapus',
                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    onCancelBtnTap: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                payerClass,
                style: const TextStyle(
                    fontFamily: 'Herme',
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                '$monthBill  $yearBill',
                style: const TextStyle(
                    fontFamily: 'Herme',
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                dateTransaction,
                style: const TextStyle(
                    fontFamily: 'Herme',
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                status,
                style: const TextStyle(
                    fontFamily: 'Herme',
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                CurrencyTextInputFormatter(
                        locale: 'id', symbol: 'Rp.', decimalDigits: 0)
                    .format(nominal),
                style: const TextStyle(
                    fontFamily: 'Herme',
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 14),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailTransaction(
                                  id: id,
                                )));
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Detail',
                              style: TextStyle(
                                  fontFamily: 'Herme',
                                  color: Colors.black,
                                  letterSpacing: 1,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Object?> showInvoice(BuildContext context, String id) {
    return showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .doc(id)
              .snapshots(),
          builder: (_, data) {
            if (data.hasData) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        splashRadius: 30,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close)),
                    Row(
                      children: [
                        data.data!.get('status') == 'Lunas'
                            ? IconButton(
                                onPressed: () async {
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
        );
      },
      animationType: DialogTransitionType.slideFromRight,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }
}

class TextInvoice extends StatelessWidget {
  final String title;
  final String desc;
  const TextInvoice({
    required this.title,
    required this.desc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Herme',
                    fontSize: 12,
                    letterSpacing: 1,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                desc,
                style: const TextStyle(
                    fontFamily: 'Herme', fontSize: 16, letterSpacing: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
