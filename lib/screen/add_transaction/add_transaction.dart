import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:sppnekat/shared/auth_service.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/dialog_loading.dart';
import 'package:sppnekat/shared/input_transaction.dart';
import 'package:sppnekat/shared/search_service.dart';
import 'package:sppnekat/shared/size.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController nisnController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController sisaController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final List<String> month = [
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
  ];
  final List<String> filteredMonth = [
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
  ];
  final List<String> error = [
    'Error',
  ];

  CurrencyTextInputFormatter inputFormatter =
      CurrencyTextInputFormatter(locale: 'id', symbol: '', decimalDigits: 0);
  CurrencyTextInputFormatter inputFormatter2 =
      CurrencyTextInputFormatter(locale: 'id', symbol: '', decimalDigits: 0);
  CurrencyTextInputFormatter inputFormatter3 =
      CurrencyTextInputFormatter(locale: 'id', symbol: '', decimalDigits: 0);
  CurrencyTextInputFormatter inputFormatter4 =
      CurrencyTextInputFormatter(locale: 'id', symbol: '', decimalDigits: 0);

  String? selectedMonth;
  String? selectedYear;
  String? selectedMajors;
  String? selectedClass;
  String? selectedLevel;
  String? selectedSpp;
  String? sppId;
  String? userId;
  List<String> filterMonth = [];
  Timestamp? createAt;

  final SearchService _searchService = SearchService();
  List<Map<String, dynamic>> search = [];
  Future getDocs(String param) async {
    search = (await _searchService.getuserSearch())
        .map((e) => {'name': e.get('name'), 'class': e.get('class')})
        .toList();
    List<Map<String, dynamic>> result = search
        .where((element) =>
            element.toString().toLowerCase().contains(param.toLowerCase()))
        .toList();
    return result;
  }

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
          'Tambah Pembayaran',
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Nama Lengkap',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  TypeAheadField<Map<String, dynamic>>(
                    hideOnLoading: true,
                    noItemsFoundBuilder: (context) => SizedBox(
                        width: Sizes(context).width * 0.9,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Tidak Ada Siswa',
                              style: TextStyle(
                                fontFamily: "Herme",
                                letterSpacing: 1,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )),
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        elevation: 8,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: nameController,
                      autofocus: false,
                      style: const TextStyle(
                        fontFamily: "Herme",
                        letterSpacing: 1,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xffADADAD)))),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await getDocs.call(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          suggestion['name'],
                          style: const TextStyle(
                            fontFamily: "Herme",
                            letterSpacing: 1,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          suggestion['class'],
                          style: const TextStyle(
                            fontFamily: "Herme",
                            letterSpacing: 1,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) async {
                      FirebaseFirestore.instance
                          .collection('users')
                          .where('name', isEqualTo: suggestion['name'])
                          .get()
                          .then((value) {
                        for (var element in value.docs) {
                          setState(() {
                            nameController =
                                TextEditingController(text: suggestion['name']);
                            nisnController = TextEditingController(
                                text: element.get('nisn'));
                            classController = TextEditingController(
                                text: element.get('class'));
                            createAt = element.get('createAt');
                            selectedYear = null;
                            priceController.clear();
                            userId = element.id;
                            for (var i = 0; i < filterMonth.length; i++) {
                              filteredMonth.clear();
                              filteredMonth.addAll(month);
                            }
                            nominalController.clear();
                            sisaController.clear();
                            statusController.clear();
                            selectedMonth = null;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
              InputTransaction(
                label: 'NISN',
                controller: nisnController,
                enabled: false,
                suffix: '',
              ),
              InputTransaction(
                label: 'Kelas',
                controller: classController,
                enabled: false,
                suffix: '',
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('spp')
                      // .where('startFromDate', isGreaterThanOrEqualTo: createAt)
                      .orderBy('startFromDate', descending: false)
                      .snapshots(),
                  builder: (context, yearData) {
                    if (!yearData.hasData) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'Tahun',
                                style: TextStyle(
                                    fontFamily: 'Herme',
                                    letterSpacing: 1,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: const Color(0xffADADAD), width: 2)),
                            width: Sizes(context).width * 0.9,
                            height: 55,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                iconEnabledColor: Colors.black,
                                hint: const Text('',
                                    style: TextStyle(
                                        fontFamily: 'Herme',
                                        letterSpacing: 1,
                                        fontSize: 18)),
                                items: error.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item,
                                        style: const TextStyle(
                                            fontFamily: 'Herme',
                                            letterSpacing: 1,
                                            fontSize: 18)),
                                  );
                                }).toList(),
                                value: selectedYear,
                                onChanged: nameController.text.isNotEmpty
                                    ? (value) {
                                        setState(() {
                                          selectedYear = value as String;
                                          FirebaseFirestore.instance
                                              .collection('spp')
                                              .where('yearbill',
                                                  isEqualTo: selectedYear)
                                              .get()
                                              .then((value) {
                                            for (var e in value.docs) {
                                              setState(() {
                                                priceController =
                                                    TextEditingController(
                                                        text: inputFormatter4
                                                            .format(e.get(
                                                                'nominal')));
                                              });
                                            }
                                          });
                                        });
                                      }
                                    : null,
                                buttonHeight: 40,
                                buttonWidth: 120,
                                itemHeight: 40,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Sizes(context).height * 0.015,
                          )
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Tahun',
                              style: TextStyle(
                                  fontFamily: 'Herme',
                                  letterSpacing: 1,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: const Color(0xffADADAD), width: 2)),
                          width: Sizes(context).width * 0.9,
                          height: 55,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              iconEnabledColor: Colors.black,
                              hint: const Text('',
                                  style: TextStyle(
                                      fontFamily: 'Herme',
                                      letterSpacing: 1,
                                      fontSize: 18)),
                              items: yearData.data!.docs.map((item) {
                                return DropdownMenuItem<String>(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  value: item.get('year'),
                                  child: Text(item.get('year'),
                                      style: const TextStyle(
                                          fontFamily: 'Herme',
                                          letterSpacing: 1,
                                          fontSize: 18)),
                                );
                              }).toList(),
                              value: selectedYear,
                              onChanged: nameController.text.isNotEmpty
                                  ? (value) {
                                      setState(() {
                                        selectedYear = value as String;
                                        for (var i = 0;
                                            i < filterMonth.length;
                                            i++) {
                                          filteredMonth.clear();
                                          filteredMonth.addAll(month);
                                        }
                                        FirebaseFirestore.instance
                                            .collection('transactions')
                                            .where('payer', isEqualTo: userId)
                                            .where('yearBill',
                                                isEqualTo: selectedYear)
                                            .get()
                                            .then((value) {
                                          for (var element in value.docs) {
                                            filterMonth
                                                .add(element.get('monthBill'));
                                          }
                                          for (var i = 0;
                                              i < filterMonth.length;
                                              i++) {
                                            filteredMonth
                                                .remove(filterMonth[i]);
                                          }
                                        });

                                        FirebaseFirestore.instance
                                            .collection('spp')
                                            .where('year',
                                                isEqualTo: selectedYear)
                                            .get()
                                            .then((value) {
                                          for (var e in value.docs) {
                                            setState(() {
                                              sppId = e.id;
                                              priceController =
                                                  TextEditingController(
                                                      text: inputFormatter4
                                                          .format(e
                                                              .get('nominal')));
                                            });
                                          }
                                        });
                                        filterMonth.clear();
                                        nominalController.clear();
                                        sisaController.clear();
                                        statusController.clear();
                                        selectedMonth = null;
                                      });
                                    }
                                  : null,
                              buttonHeight: 40,
                              buttonWidth: 120,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Sizes(context).height * 0.015,
                        )
                      ],
                    );
                  }),
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
                      inputFormatters: [inputFormatter4],
                      style: const TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1),
                      controller: priceController,
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
                        'Bulan',
                        style: TextStyle(
                            fontFamily: 'Herme',
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: const Color(0xffADADAD), width: 2)),
                    width: Sizes(context).width * 0.9,
                    height: 55,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        iconEnabledColor: Colors.black,
                        hint: const Text(
                          '',
                          style: TextStyle(
                            fontFamily: "Herme",
                            letterSpacing: 1,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        items: filteredMonth.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: const TextStyle(
                                    fontFamily: 'Herme',
                                    letterSpacing: 1,
                                    fontSize: 18)),
                          );
                        }).toList(),
                        value: selectedMonth,
                        onChanged: selectedYear != null
                            ? (value) {
                                setState(() {
                                  selectedMonth = value as String;
                                });
                              }
                            : null,
                        buttonHeight: 40,
                        buttonWidth: 120,
                        itemHeight: 40,
                      ),
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
                      onFieldSubmitted: (value) {
                        FirebaseFirestore.instance
                            .collection('spp')
                            .where('year', isEqualTo: selectedYear)
                            .get()
                            .then((value) {
                          for (var e in value.docs) {
                            int sisa = int.parse(e.get('nominal')) -
                                int.parse(inputFormatter3
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
                      inputFormatters: [inputFormatter3],
                      style: const TextStyle(
                          fontFamily: 'Herme', letterSpacing: 1, fontSize: 18),
                      controller: nominalController,
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
                  if (nisnController.text.isNotEmpty ||
                      selectedMonth != null ||
                      selectedYear != null ||
                      nominalController.text.isNotEmpty ||
                      statusController.text.isNotEmpty) {
                    int nominal = int.parse(
                        inputFormatter3.getUnformattedValue().toString());
                    int harga = int.parse(
                        inputFormatter4.getUnformattedValue().toString());
                    if (nominal > harga) {
                      statusController.clear();
                      nominalController.clear();
                      sisaController.clear();
                      CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.error,
                        title: 'Peringatan',
                        text: 'Nominal Lebih Dari Harga',
                        cancelBtnText: 'Kembali',
                        confirmBtnText: 'Oke',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.confirm,
                        title: 'Peringatan',
                        text: 'Apa anda yakin menambahkan pembayaran?',
                        cancelBtnText: 'Kembali',
                        confirmBtnText: 'Simpan',
                        confirmBtnColor: lightBlue,
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                          DialogLoading(context).showLoading();
                          FirebaseFirestore.instance
                              .collection('transactions')
                              .where('nisn', isEqualTo: nisnController.text)
                              .where('status', isEqualTo: "Belum Lunas")
                              .get()
                              .then((value) {
                            if (value.docs.isEmpty) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(authService.getUId)
                                  .get()
                                  .then((inputer) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .where('nisn',
                                        isEqualTo: nisnController.text)
                                    .get()
                                    .then((payer) {
                                  for (var e in payer.docs) {
                                    FirebaseFirestore.instance
                                        .collection('transactions')
                                        .add({
                                      'no':
                                          'Ktp/$selectedYear/$selectedMonth/${Random().nextInt(10000)}',
                                      'payerName': e.get('name'),
                                      'payer': e.id,
                                      'class': classController.text,
                                      'nisn': nisnController.text,
                                      'operator': inputer.id,
                                      'operatorName': inputer.get('name'),
                                      'dateTransaction': Timestamp.now(),
                                      'monthBill': selectedMonth,
                                      'yearBill': selectedYear,
                                      'nominal': inputFormatter3
                                          .getUnformattedValue()
                                          .toString(),
                                      'sisa': inputFormatter2
                                          .getUnformattedValue()
                                          .toString(),
                                      'status': statusController.text.toString()
                                    });
                                  }
                                });
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

                              final snackBar = SnackBar(
                                elevation: 0,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  color: darkBlue,
                                  title: 'Berhasil',
                                  message: 'Pembayaran Berhasil Ditambahkan',
                                  contentType: ContentType.success,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            } else {
                              Navigator.of(context).pop();
                              CoolAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: CoolAlertType.error,
                                title: 'Peringatan',
                                text:
                                    'Silahkan Bayar Tunggakan Bulan Sebelumnya!',
                                cancelBtnText: 'Kembali',
                                confirmBtnText: 'Oke',
                                confirmBtnColor: Colors.red,
                                onConfirmBtnTap: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          });
                        },
                      );
                    }
                  } else {
                    DialogLoading(context).showLoading();
                    final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                        content: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Icon(
                                Icons.info,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Isi Terlebih Dahulu',
                              style: TextStyle(
                                fontFamily: 'Herme',
                                letterSpacing: 1,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }
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
