import 'package:sppnekat/model/school.dart';
import 'package:sppnekat/model/student.dart';

class Invoice {
  final InvoiceInfo info;
  final School school;
  final Student student;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.school,
    required this.student,
    required this.items,
  });
}

class InvoiceInfo {
  final String noTransaction;
  final String date;
  final String year;
  final String kelas;
  final String month;
  final String namePayer;
  final String total;

  const InvoiceInfo({
    required this.noTransaction,
    required this.date,
    required this.kelas,
    required this.year,
    required this.month,
    required this.namePayer,
    required this.total,
  });
}

class InvoiceItem {
  final String payerName;
  final String payerClass;
  final String operatorName;
  final String nominal;
  final String status;
  final String monthBill;
  final String yearBill;
  final String date;

  const InvoiceItem({
    required this.payerName,
    required this.payerClass,
    required this.operatorName,
    required this.nominal,
    required this.status,
    required this.monthBill,
    required this.yearBill,
    required this.date,
  });
}
