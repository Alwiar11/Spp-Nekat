import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sppnekat/API/pdf_api.dart';
import 'package:sppnekat/API/pdf_invoice_api2.dart';
import 'package:sppnekat/model/invoice.dart';
import 'package:sppnekat/model/school.dart';
import 'package:sppnekat/model/student.dart';

import 'package:sppnekat/shared/card_transaction_admin.dart';
import 'package:sppnekat/shared/color.dart';
import 'package:sppnekat/shared/format_date.dart';
import 'package:sppnekat/shared/loading.dart';
import 'package:sppnekat/shared/search_service.dart';
import 'package:sppnekat/shared/size.dart';

import '../../shared/dialog_loading.dart';
import '../add_transaction/add_transaction.dart';

class TransactionAdmin extends StatefulWidget {
  const TransactionAdmin({super.key});

  @override
  State<TransactionAdmin> createState() => _TransactionAdminState();
}

class _TransactionAdminState extends State<TransactionAdmin> {
  final List<String> status = [
    'Belum Lunas',
    'Lunas',
  ];
  final List<String> bulan = [
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
  final List<String> tahun = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
  ];
  final List<String> error = [
    'Error',
  ];
  String? selectedStatus;
  String? selectedMonth;
  String? selectedYear;
  String? selectedClass;
  String? selectedUser;
  Timestamp? selectedDateStart;
  Timestamp? selectedDateEnd;
  int sum = 0;

  TextEditingController suggestionsBoxController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final SearchService _searchService = SearchService();

  List<Map<String, dynamic>> search = [];

  Future getDocs(String param) async {
    search = (await _searchService.getuserSearch()).map(
        // (e) => e.get('name').toString() + " " + e.get('class').toString(),
        (e) => {'name': e.get('name'), 'class': e.get('class')}).toList();
    List<Map<String, dynamic>> result = search
        .where((element) =>
            element.toString().toLowerCase().contains(param.toLowerCase()))
        .toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddTransaction()));
        },
        child: const Icon(
          Icons.add,
          color: darkBlue,
        ),
      ),
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
          'Pembayaran',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .where(
                'payerName',
                isEqualTo: selectedUser,
              )
              .where('dateTransaction',
                  isGreaterThanOrEqualTo: selectedDateStart)
              .where('dateTransaction', isLessThanOrEqualTo: selectedDateEnd)
              .where(
                'status',
                isEqualTo: selectedStatus,
              )
              .where(
                'monthBill',
                isEqualTo: selectedMonth,
              )
              .where(
                'yearBill',
                isEqualTo: selectedYear,
              )
              .where(
                'class',
                isEqualTo: selectedClass,
              )
              .orderBy('dateTransaction', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes(context).width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      width: Sizes(context).width * 0.9,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: TypeAheadField<Map<String, dynamic>>(
                        hideOnLoading: true,
                        noItemsFoundBuilder: (context) => SizedBox(
                            width: Sizes(context).width * 0.9,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Tidak Ada Data',
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
                            controller: suggestionsBoxController,
                            autofocus: false,
                            style: const TextStyle(
                              fontFamily: "Herme",
                              letterSpacing: 1,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                                hintText: 'Cari Siswa....',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none)),
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
                        onSuggestionSelected: (suggestion) {
                          setState(() {
                            suggestionsBoxController =
                                TextEditingController(text: suggestion['name']);
                            selectedUser = suggestion['name'];
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: Sizes(context).width * 0.9,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            darkBlue,
                            lightBlue,
                          ],
                        ),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: "Herme",
                          letterSpacing: 1,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        controller: dateController,
                        readOnly: true,
                        onTap: () {
                          showDateRangePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 20),
                            lastDate: DateTime(DateTime.now().year + 20),
                            initialDateRange: DateTimeRange(
                                start: DateTime.now(), end: DateTime.now()),
                          ).then((value) async {
                            setState(() {
                              DateTime endDate = DateTime(
                                value!.end.year,
                                value.end.month,
                                value.end.day + 1,
                                value.end.hour,
                                value.end.minute,
                                value.end.second,
                                value.end.millisecond,
                                value.end.microsecond,
                              );

                              selectedDateStart =
                                  Timestamp.fromDate(value.start);
                              selectedDateEnd = Timestamp.fromDate(endDate);

                              dateController = TextEditingController(
                                  text:
                                      '${FormatDate().formattedDate2(Timestamp.fromDate(value.start))} - ${FormatDate().formattedDate2(Timestamp.fromDate(value.end))}');
                            });
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Pilih Tanggal',
                          hintStyle: TextStyle(
                            fontFamily: "Herme",
                            letterSpacing: 1,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                darkBlue,
                                lightBlue,
                              ],
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              dropdownDecoration:
                                  const BoxDecoration(color: lightBlue),
                              iconEnabledColor: Colors.white,
                              hint: const Text(
                                'Status',
                                style: TextStyle(
                                  fontFamily: "Herme",
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              items: status
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'herme',
                                            letterSpacing: 1,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedStatus,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 120,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                        FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('spp')
                                .orderBy('year', descending: false)
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        darkBlue,
                                        lightBlue,
                                      ],
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      dropdownDecoration:
                                          const BoxDecoration(color: lightBlue),
                                      iconEnabledColor: Colors.white,
                                      hint: const Text(
                                        'Tahun',
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          fontFamily: "Herme",
                                          color: Colors.white,
                                        ),
                                      ),
                                      items: error
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Herme",
                                                      letterSpacing: 1,
                                                      color: Colors.white),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedYear,
                                      onChanged: (value2) {
                                        setState(() {
                                          selectedYear = value2 as String;
                                        });
                                      },
                                      buttonHeight: 40,
                                      buttonWidth: 120,
                                      itemHeight: 40,
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                margin: const EdgeInsets.only(right: 20),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      darkBlue,
                                      lightBlue,
                                    ],
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    dropdownDecoration:
                                        const BoxDecoration(color: lightBlue),
                                    iconEnabledColor: Colors.white,
                                    hint: const Text(
                                      'Tahun',
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontFamily: "Herme",
                                        color: Colors.white,
                                      ),
                                    ),
                                    items: snapshot.data!.docs
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item.get('year'),
                                              child: Text(
                                                item.get('year'),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Herme",
                                                    letterSpacing: 1,
                                                    color: Colors.white),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedYear,
                                    onChanged: (value2) {
                                      setState(() {
                                        selectedYear = value2 as String;
                                      });
                                    },
                                    buttonHeight: 40,
                                    buttonWidth: 120,
                                    itemHeight: 40,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                darkBlue,
                                lightBlue,
                              ],
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              dropdownDecoration:
                                  const BoxDecoration(color: lightBlue),
                              iconEnabledColor: Colors.white,
                              hint: const Text(
                                'Bulan',
                                style: TextStyle(
                                  fontFamily: "Herme",
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              items: bulan
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'herme',
                                            letterSpacing: 1,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedMonth,
                              onChanged: (value) {
                                setState(() {
                                  selectedMonth = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 120,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('class')
                                .orderBy('level', descending: false)
                                .get(),
                            builder: (context, classData) {
                              if (!classData.hasData) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        darkBlue,
                                        lightBlue,
                                      ],
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      dropdownDecoration:
                                          const BoxDecoration(color: lightBlue),
                                      iconEnabledColor: Colors.white,
                                      hint: const Text(
                                        'Kelas',
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          fontFamily: "Herme",
                                          color: Colors.white,
                                        ),
                                      ),
                                      items: error
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Herme",
                                                      letterSpacing: 1,
                                                      color: Colors.white),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedMonth,
                                      onChanged: (value2) {
                                        setState(() {
                                          selectedMonth = value2 as String;
                                        });
                                      },
                                      buttonHeight: 40,
                                      buttonWidth: 120,
                                      itemHeight: 40,
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                margin: const EdgeInsets.only(right: 20),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      darkBlue,
                                      lightBlue,
                                    ],
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    dropdownDecoration:
                                        const BoxDecoration(color: lightBlue),
                                    iconEnabledColor: Colors.white,
                                    hint: const Text(
                                      'Kelas',
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontFamily: "Herme",
                                        color: Colors.white,
                                      ),
                                    ),
                                    items: classData.data!.docs
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item.get('level') +
                                                  ' ' +
                                                  item.get('name'),
                                              child: Text(
                                                item.get('level') +
                                                    ' ' +
                                                    item.get('name'),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Herme",
                                                    letterSpacing: 1,
                                                    color: Colors.white),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedClass,
                                    onChanged: (value2) {
                                      setState(() {
                                        selectedClass = value2 as String;
                                      });
                                    },
                                    buttonHeight: 40,
                                    buttonWidth: 120,
                                    itemHeight: 40,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        snapshot.data!.docs.isNotEmpty
                            ? Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: InkWell(
                                  onTap: () async {
                                    DialogLoading(context).showLoading();

                                    setState(() {
                                      for (var element in snapshot.data!.docs) {
                                        sum = sum +
                                            int.parse(element.get('nominal'));
                                      }
                                    });
                                    final invoice = Invoice(
                                      school: const School(
                                        name: "SMKN 1 KATAPANG",
                                        address:
                                            'Jalan Ceuri Jalan Terusan Kopo No.KM 13.5, Katapang, \nKec. Katapang, Kabupaten Bandung, Jawa Barat 40971',
                                      ),
                                      student: const Student(
                                        name: 'snapshot.data!.get(' ')',
                                        address: 'snapshot.data!.get(' ')',
                                      ),
                                      info: InvoiceInfo(
                                        noTransaction: '',
                                        date: dateController.text.isEmpty
                                            ? '${FormatDate().formattedDate2(snapshot.data!.docs.last.get('dateTransaction'))}  -  ${FormatDate().formattedDate2(snapshot.data!.docs.first.get('dateTransaction'))}'
                                            : dateController.text,
                                        kelas: selectedClass != null
                                            ? selectedClass.toString()
                                            : '-',
                                        month: selectedMonth != null
                                            ? selectedMonth.toString()
                                            : '-',
                                        namePayer: selectedUser != null
                                            ? selectedUser.toString()
                                            : '-',
                                        year: selectedYear != null
                                            ? selectedYear.toString()
                                            : '-',
                                        total: CurrencyTextInputFormatter(
                                                locale: 'id',
                                                decimalDigits: 0,
                                                symbol: 'Rp.')
                                            .format(sum.toString()),
                                      ),
                                      items: [
                                        ...snapshot.data!.docs.map((e) {
                                          return InvoiceItem(
                                            payerName: e.get('payerName'),
                                            payerClass: e.get('class'),
                                            operatorName: e.get('operatorName'),
                                            nominal: CurrencyTextInputFormatter(
                                                    locale: 'id',
                                                    symbol: 'Rp.',
                                                    decimalDigits: 0)
                                                .format(e.get('nominal')),
                                            status: e.get('status'),
                                            monthBill: e.get('monthBill'),
                                            yearBill: e.get('yearBill'),
                                            date: FormatDate().formattedDate2(
                                                e.get('dateTransaction')),
                                          );
                                        })
                                      ],
                                    );
                                    setState(() {
                                      sum = 0;
                                    });

                                    final pdfFile =
                                        await PdfInvoiceApi2.generate(invoice);

                                    PdfApi.openFile(pdfFile);
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.print,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        'Cetak',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Herme",
                                            letterSpacing: 1,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedUser = null;
                                selectedStatus = null;
                                selectedMonth = null;
                                selectedYear = null;
                                selectedClass = null;
                                suggestionsBoxController.text = '';
                                selectedDateStart = null;
                                selectedDateEnd = null;
                                dateController.clear();
                              });
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'Hapus Filter',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Herme",
                                      letterSpacing: 1,
                                      color: Colors.red),
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (snapshot.data!.docs.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Tidak Ada Pembayaran',
                            style: TextStyle(
                                fontFamily: 'Herme',
                                fontSize: 24,
                                letterSpacing: 1),
                          ),
                        ],
                      )
                    else
                      ...snapshot.data!.docs.map(
                        (e) {
                          return Center(
                            child: Column(
                              children: [
                                CardTransactionAdmin(
                                  payerName: e.get('payerName'),
                                  payerClass: e.get('class'),
                                  monthBill: e.get('monthBill'),
                                  yearBill: e.get('yearBill'),
                                  dateTransaction: FormatDate()
                                      .formattedDate(e.get('dateTransaction')),
                                  status: e.get('status'),
                                  id: e.id,
                                  nominal: e.get('nominal'),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
