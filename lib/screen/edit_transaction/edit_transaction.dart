import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/dialog_loading.dart';
import '../../shared/auth_service.dart';
import '../../shared/input_transaction.dart';
import '../../shared/size.dart';

class EditTransaction extends StatefulWidget {
  final String id;
  const EditTransaction({required this.id, super.key});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  String? role;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    setState(() {});
    await FirebaseFirestore.instance
        .collection("transactions")
        .doc(widget.id)
        .get()
        .then((doc) {
      nisnController = TextEditingController(text: doc.get('nisn'));
      nameController = TextEditingController(text: doc.get('payerName'));
      classController = TextEditingController(text: doc.get('class'));
      yearController = TextEditingController(text: doc.get('yearBill'));
      monthController = TextEditingController(text: doc.get('monthBill'));
      statusController = TextEditingController(text: doc.get('status'));
      nominalController = TextEditingController(
          text: inputFormatter.format(doc.get('nominal')));
      sisaController =
          TextEditingController(text: inputFormatter2.format(doc.get('sisa')));
      FirebaseFirestore.instance
          .collection('spp')
          .where('year', isEqualTo: doc.get('yearBill'))
          .get()
          .then((value) {
        for (var e in value.docs) {
          setState(() {
            priceController = TextEditingController(
                text: CurrencyTextInputFormatter(
                        locale: 'id', symbol: 'Rp.', decimalDigits: 0)
                    .format(e.get('nominal')));
          });
        }
      });
    });

    setState(() {});
  }

  TextEditingController nisnController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController sisaController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final List<String> month = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  final List<String> year = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
  ];
  final List<String> status = [
    'Lunas',
    'Belum Lunas',
  ];
  CurrencyTextInputFormatter inputFormatter =
      CurrencyTextInputFormatter(locale: 'id', symbol: '', decimalDigits: 0);
  CurrencyTextInputFormatter inputFormatter2 =
      CurrencyTextInputFormatter(locale: 'id', symbol: '', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
          'Edit Pembayaran',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes(context).width * 0.05,
          ),
          child: Column(
            children: [
              SizedBox(
                height: Sizes(context).height * 0.02,
              ),
              InputTransaction(
                label: 'Nama Lengkap',
                controller: nameController,
                enabled: false,
                suffix: '',
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'NISN',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: Sizes(context).width * 0.9,
                    height: 50,
                    child: TextFormField(
                      enabled: false,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .where('nisn', isEqualTo: nisnController.text)
                              .get()
                              .then((data) {
                            data.docs.map((element) {
                              setState(() {
                                nameController = TextEditingController(
                                    text: element.get('name'));
                                classController = TextEditingController(
                                    text: element.get('class'));
                              });
                            });
                          });
                          // ignore: empty_catches
                        } on FirebaseException {}
                      },
                      style: const TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1),
                      controller: nisnController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD)))),
                    ),
                  ),
                  SizedBox(
                    height: Sizes(context).height * 0.015,
                  )
                ],
              ),
              InputTransaction(
                label: 'Kelas',
                controller: classController,
                enabled: false,
                suffix: '',
              ),
              InputTransaction(
                label: 'Tahun',
                controller: yearController,
                enabled: false,
                suffix: '',
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Nominal',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: Sizes(context).width * 0.9,
                    height: 50,
                    child: TextFormField(
                      enabled: false,
                      style: const TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1),
                      controller: priceController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD)))),
                    ),
                  ),
                  SizedBox(
                    height: Sizes(context).height * 0.015,
                  )
                ],
              ),
              InputTransaction(
                label: 'Bulan',
                controller: monthController,
                enabled: false,
                suffix: '',
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Jumlah Bayar',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: Sizes(context).width * 0.9,
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [inputFormatter],
                      style: const TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1),
                      controller: nominalController,
                      onFieldSubmitted: (value) {
                        FirebaseFirestore.instance
                            .collection('spp')
                            .where('year', isEqualTo: yearController.text)
                            .get()
                            .then((value) {
                          for (var e in value.docs) {
                            int sisa = int.parse(e.get('nominal')) -
                                int.parse(inputFormatter
                                    .getUnformattedValue()
                                    .toString());
                            setState(() {
                              sisaController = TextEditingController(
                                  text:
                                      inputFormatter2.format(sisa.toString()));
                              sisa == 0
                                  ? statusController =
                                      TextEditingController(text: 'Lunas')
                                  : statusController = TextEditingController(
                                      text: 'Belum Lunas');
                            });
                          }
                        });
                      },
                      decoration: const InputDecoration(
                          prefix: Text('Rp.'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD)))),
                    ),
                  ),
                  SizedBox(
                    height: Sizes(context).height * 0.015,
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Sisa Bayar',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: Sizes(context).width * 0.9,
                    height: 50,
                    child: TextFormField(
                      enabled: false,
                      inputFormatters: [inputFormatter2],
                      style: const TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1),
                      controller: sisaController,
                      decoration: const InputDecoration(
                          prefix: Text('Rp.'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD)))),
                    ),
                  ),
                  SizedBox(
                    height: Sizes(context).height * 0.015,
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Status',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: Sizes(context).width * 0.9,
                    height: 50,
                    child: TextFormField(
                      enabled: false,
                      inputFormatters: [inputFormatter2],
                      style: const TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1),
                      controller: statusController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD)))),
                    ),
                  ),
                  SizedBox(
                    height: Sizes(context).height * 0.015,
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  CoolAlert.show(
                    barrierDismissible: false,
                    context: context,
                    type: CoolAlertType.confirm,
                    title: 'Peringatan',
                    text: 'Apa kamu yakin ubah?',
                    cancelBtnText: 'Kembali',
                    confirmBtnText: 'Simpan',
                    onConfirmBtnTap: () async {
                      Navigator.of(context).pop();
                      DialogLoading(context).showLoading();
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(authService.getUId)
                          .get()
                          .then((inputer) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .where('nisn', isEqualTo: nisnController.text)
                            .get()
                            .then((payer) async {
                          for (var e in payer.docs) {
                            FirebaseFirestore.instance
                                .collection('transactions')
                                .doc(widget.id)
                                .update({
                              'payerName': e.get('name'),
                              'payer': e.id,
                              'class': classController.text,
                              'nisn': nisnController.text,
                              'operator': inputer.id,
                              'operatorName': inputer.get('name'),
                              'dateTransaction': Timestamp.now(),
                              'monthBill': monthController.text,
                              'yearBill': yearController.text,
                              'sisa': inputFormatter2
                                  .getUnformattedValue()
                                  .toString(),
                              'nominal': inputFormatter
                                  .getUnformattedValue()
                                  .toString(),
                              'status': statusController.text.toString()
                            });
                          }
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });

                      final snackBar = SnackBar(
                        elevation: 0,
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          color: darkBlue,
                          title: 'Berhasil',
                          message: 'Berhasil Ubah Pembayaran',
                          contentType: ContentType.success,
                        ),
                      );

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                  );
                },
                child: Container(
                  width: Sizes(context).width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        darkBlue,
                        lightBlue,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Simpan',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            fontSize: 24,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Sizes(context).height * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }
}
