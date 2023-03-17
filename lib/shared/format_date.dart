import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormatDate {
  String formattedDate(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('d MMMM y, HH:mm', 'id').format(dateFromTimeStamp);
  }

  String formattedDate2(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('d/M/y', 'id').format(dateFromTimeStamp);
  }

  String formattedDate3(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('y', 'id').format(dateFromTimeStamp);
  }
}
